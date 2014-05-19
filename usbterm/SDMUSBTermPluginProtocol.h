//
//  SDMUSBTermPluginProtocol.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

@protocol SDMUSBTermPluginProtocol <NSObject>

- (void)attachToDevice:(io_service_t)device;

+ (CFDictionaryRef)copyDeviceMatchingInformation;

- (void)connectToDevice;

- (IOReturn)readData:(NSData **)data;

- (IOReturn)writeData:(NSData *)data;

@end
