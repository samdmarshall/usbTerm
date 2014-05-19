//
//  USBTermPluginIBoot.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "USBTermPluginIBoot.h"

@implementation USBTermPluginIBoot

- (id)init {
	self = [super init];
	if (self) {
		_device = 0;
	}
	return self;
}

- (void)attachToDevice:(io_service_t)device {
	if (_device) {
		IOObjectRelease(_device);
	}
	_device = device;
}

CFMutableDictionaryRef addValue(CFMutableDictionaryRef dict, CFStringRef key, uint32_t value) {
    CFNumberRef num_value = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &value);
    CFDictionarySetValue(dict, key, num_value);
	CFRelease(num_value);
    return dict;
}

+ (CFDictionaryRef)copyDeviceMatchingInformation {
	CFMutableDictionaryRef matching = IOServiceMatching(kIOUSBDeviceClassName);
	matching = addValue(matching, CFSTR(kUSBDeviceClass), 0);
	matching = addValue(matching, CFSTR(kUSBDeviceSubClass), 0);
	matching = addValue(matching, CFSTR(kUSBDeviceProtocol), 0);
	matching = addValue(matching, CFSTR(kUSBVendorID), kAppleVendorID);
	matching = addValue(matching, CFSTR(kUSBProductID), 0x1281);
	return matching;
}

- (void)connectToDevice {
	if ([self device] != 0) {
		IOCFPlugInInterface **plugin_interface = NULL;
		IOUSBConfigurationDescriptorPtr config;
		SInt32 score = 0;
		kern_return_t device_result = kIOReturnError, kr = IOCreatePlugInInterfaceForService([self device], kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID, &plugin_interface, &score);
		if (kr == 0) {
			(*plugin_interface)->QueryInterface(plugin_interface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID), (LPVOID)&_usb_device);
			(*plugin_interface)->Release(plugin_interface);
			device_result = (*_usb_device)->USBDeviceOpen(_usb_device);
			if (device_result == kIOReturnSuccess) {
				device_result = (*_usb_device)->GetConfigurationDescriptorPtr(_usb_device, 0, &config);
				if (kr != kIOReturnSuccess) {
					printf(":: Could not set active configuration (error: %x)\n", kr);
				}
				(*_usb_device)->SetConfiguration(_usb_device, config->bConfigurationValue);
			}
			else if (kr == kIOReturnExclusiveAccess) {
				printf(":: Exclusive access mode, device may be limited...\n");
			}
			else {
				printf(":: Could not open device (error: %x)\n", kr);
			}
		}
		if (device_result == kIOReturnSuccess) {
			SInt32 score = 0;
			IOUSBFindInterfaceRequest interface_request;
			interface_request.bInterfaceClass = kIOUSBFindInterfaceDontCare;
			interface_request.bInterfaceSubClass = kIOUSBFindInterfaceDontCare;
			interface_request.bInterfaceProtocol = kIOUSBFindInterfaceDontCare;
			interface_request.bAlternateSetting = kIOUSBFindInterfaceDontCare;
			io_iterator_t interface_iterator;
			(*_usb_device)->CreateInterfaceIterator(_usb_device, &interface_request, &interface_iterator);
			IOIteratorNext(interface_iterator);
			io_service_t usb_ref = IOIteratorNext(interface_iterator);
			IOObjectRelease(interface_iterator);
			IOCFPlugInInterface **plugin_interface_io = NULL;
			device_result = IOCreatePlugInInterfaceForService(usb_ref, kIOUSBInterfaceUserClientTypeID, kIOCFPlugInInterfaceID, &plugin_interface_io, &score);
			IOObjectRelease(usb_ref);
			if (device_result == kIOReturnSuccess) {
				(*plugin_interface_io)->QueryInterface(plugin_interface_io, CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID300), (LPVOID)&_usb_interface);
				(*plugin_interface_io)->Release(plugin_interface_io);
				device_result = (*_usb_interface)->USBInterfaceOpen(_usb_interface);
				if (device_result != kIOReturnSuccess) {
					printf(":: Could not open interface (error: %x)\n", device_result);
				}
				device_result = (*_usb_interface)->SetAlternateInterface(_usb_interface, 1);
				if (device_result != kIOReturnSuccess) {
					printf(":: Could not set alt-interface (error: %x)\n", device_result);
				}
				uint8_t direction, number, transfer_type, interval;
				uint8_t endpoints = 0;
				device_result = (*_usb_interface)->GetNumEndpoints(_usb_interface, &endpoints);
				if (device_result == kIOReturnSuccess) {
					for (uint8_t index = 1; index < endpoints+1; index++) {
						uint16_t packet_size = 0;
						device_result = (*_usb_interface)->GetPipeProperties(_usb_interface, index, &direction, &number, &transfer_type, &packet_size, &interval);
						if (device_result == kIOReturnSuccess) {
							switch (direction) {
								case kUSBOut: {
									_write_packet_size = packet_size;
									_write_pipe_index = number;
									break;
								}
								case kUSBIn: {
									_read_packet_size = packet_size;
									_read_pipe_index = number;
									break;
								}
								default: {
									break;
								}
							}
						}
					}
				}
			}
			else {
				printf(":: Could not connect on the serial interface, try putting it into recovery...\n");
			}
		}
	}
}

#define kReadBuffer 1024

- (IOReturn)readData:(NSData **)data {
	uint32_t length = kReadBuffer;
	char *data_read = calloc(length, sizeof(char));
	IOReturn ret = kIOReturnSuccess;
	uint32_t offset = 0;
	while (offset < length) {
		uint32_t read = (length - offset);
		read = (read > _read_packet_size ? _read_packet_size : read);
		ret = (*_usb_interface)->ReadPipeTO(_usb_interface, _read_pipe_index, &(data_read[offset]), &read, 1000, 1000);
		IOReturn status = (*_usb_interface)->GetPipeStatus(_usb_interface, _read_pipe_index);
		if(ret == kIOUSBTransactionTimeout && status == kIOUSBPipeStalled) {
			(*_usb_interface)->ClearPipeStallBothEnds(_usb_interface, _read_pipe_index);
			ret = (*_usb_interface)->GetPipeStatus(_usb_interface, _read_pipe_index);
		}
		else {
			offset += read;
		}
	}
	*data = [NSData dataWithBytes:data_read length:length];
	free(data_read);
	return ret;
}

- (IOReturn)writeData:(NSData * )data {
	uint32_t length = (uint32_t)[data length];
	char * data_write = calloc(length+1, sizeof(char));
	memcpy(data_write, (char * )[data bytes], sizeof(char[length]));
	IOReturn ret = kIOReturnSuccess;
	
	IOUSBDevRequest req;
	req.bmRequestType = 0x40;
	req.bRequest = 0x0;
	req.wValue = 0x0;
	req.wIndex = 0x0;
	req.wLength = length+1;
	req.pData = data_write;
	
	ret = (*_usb_device)->DeviceRequest(_usb_device, &req);
	if (ret == kIOUSBTransactionTimeout || ret == kIOUSBPipeStalled) {
		(*_usb_interface)->ClearPipeStallBothEnds(_usb_interface, _write_pipe_index);
		ret = (*_usb_interface)->GetPipeStatus(_usb_interface, _write_pipe_index);
	}
	else if (ret != kIOReturnSuccess && ret != kIOReturnNotResponding) {
		printf(":: error sending command.\n");
	}
	data = nil;
	return ret;
}

@end
