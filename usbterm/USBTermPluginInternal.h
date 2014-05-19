//
//  USBTermPluginInternal.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMUSBTermPluginProtocol.h"

#ifdef BUNDLE_CODE
#define USBTermPluginInternal USBTermPluginInternal_BUNDLE
#else
#define USBTermPluginInternal USBTermPluginInternal_APP
#endif

@interface USBTermPluginInternal : NSObject <SDMUSBTermPluginProtocol>

@property (nonatomic, readonly) io_service_t device;

- (void)attachToDevice:(io_service_t)device;

+ (CFDictionaryRef)deviceMatchingInformation;
- (void)connectToDevice;
- (IOReturn)readData:(NSData *)data;
- (IOReturn)writeData:(NSData *)data;

@end
