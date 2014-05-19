//
//  USBTermPluginIBoot.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMUSBTermPluginProtocol.h"
#include <IOKit/IOKitLib.h>
#include <IOKit/usb/IOUSBLib.h>
#include <IOKit/IOCFPlugIn.h>

@interface USBTermPluginIBoot : NSObject <SDMUSBTermPluginProtocol>

@property (nonatomic, readonly) IOUSBInterfaceInterface300** usb_interface;
@property (nonatomic, readonly) IOUSBDeviceInterface300** usb_device;

@property (nonatomic, readonly) uint16_t read_packet_size;
@property (nonatomic, readonly) uint16_t write_packet_size;
@property (nonatomic, readonly) uint8_t read_pipe_index;
@property (nonatomic, readonly) uint8_t write_pipe_index;

@property (nonatomic, readonly) io_service_t device;

- (void)attachToDevice:(io_service_t)device;

+ (CFDictionaryRef)copyDeviceMatchingInformation;
- (void)connectToDevice;
- (IOReturn)readData:(NSData **)data;
- (IOReturn)writeData:(NSData *)data;

@end
