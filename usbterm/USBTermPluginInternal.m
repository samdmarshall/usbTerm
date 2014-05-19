//
//  USBTermPluginInternal.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "USBTermPluginInternal.h"

@implementation USBTermPluginInternal

- (id)init {
	self = [super init];
	if (self) {
		_device = 0;
	}
	return self;
}

- (void)attachToDevice:(io_service_t)device {
	_device = device;
}

+ (CFDictionaryRef)deviceMatchingInformation {
	return CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
}

- (void)connectToDevice {
}

- (IOReturn)readData:(NSData *)data {
	return kIOReturnError;
}

- (IOReturn)writeData:(NSData * )data {
	data = nil;
	return kIOReturnError;
}

@end
