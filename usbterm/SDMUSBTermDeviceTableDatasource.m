//
//  SDMUSBTermDeviceTableDatasource.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermDeviceTableDatasource.h"
#import "SDMUSBTermDeviceItem.h"
#import "SDMUSBTermPluginProtocol.h"
#include <IOKit/IOKitLib.h>
#include <IOKit/usb/IOUSBLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <mach/mach_port.h>

@interface SDMUSBTermDeviceTableDatasource ()

@property (nonatomic, strong) id<SDMUSBTermPluginProtocol> deviceType;
@property (nonatomic, strong) NSArray *foundDevices;

@end

@implementation SDMUSBTermDeviceTableDatasource

- (id)init {
	self = [super init];
	if (self) {
		_foundDevices = @[];
	}
	return self;
}

- (void)dealloc {
	_foundDevices = nil;
}

- (void)reloadDevices {
	NSMutableArray *reloadedDevices = [NSMutableArray new];
	
	if (_deviceType != nil) {
		io_service_t usb_device = 0x0;
		io_iterator_t iterator = 0x0;
		mach_port_t master_port = 0x0;
		kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &master_port);
		CFDictionaryRef search = [[_deviceType class] copyDeviceMatchingInformation];
		if (kr == kIOReturnSuccess && master_port && search != NULL) {
			kr = IOServiceGetMatchingServices(kIOMasterPortDefault, search, &iterator);
			if (kr == kIOReturnSuccess) {
				while ((usb_device = IOIteratorNext(iterator))) {
					uint32_t loc_id = 0;
					CFTypeRef location_id = IORegistryEntrySearchCFProperty(usb_device, kIOServicePlane, CFSTR(kUSBDevicePropertyLocationID), kCFAllocatorDefault, kIORegistryIterateRecursively);
					if (location_id) {
						CFNumberGetValue(location_id, kCFNumberSInt32Type, &loc_id);
						CFRelease(location_id);
					}
					SDMUSBTermDeviceItem *deviceItem = [[SDMUSBTermDeviceItem alloc] initWithDevice:usb_device location:loc_id];
					[reloadedDevices addObject:deviceItem];
					IOObjectRelease(usb_device);
				}
			}
		}
		else {
			printf(":: Error - Couldn't create a master I/O Kit port(%08x)\n", kr);
		}
		mach_port_deallocate(mach_task_self(), master_port);
		search = NULL;
	}
	
	_foundDevices = nil;
	_foundDevices = [reloadedDevices copy];
	reloadedDevices = nil;
}

- (void)updatePlugin:(id<SDMUSBTermPluginProtocol>)plugin {
	_deviceType = plugin;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [_foundDevices count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	SDMUSBTermDeviceItem *deviceItem = [_foundDevices objectAtIndex:rowIndex];
	return [deviceItem fetchObjectForIdentifier:[aTableColumn identifier]];
}

- (id<SDMUSBTermPluginProtocol>)attachToDeviceAtIndex:(NSInteger)index {
	SDMUSBTermDeviceItem *deviceItem = [_foundDevices objectAtIndex:index];
	[_deviceType attachToDevice:[deviceItem deviceHandle]];
	return _deviceType;
}

@end
