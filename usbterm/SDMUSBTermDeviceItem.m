//
//  SDMUSBTermDeviceItem.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermDeviceItem.h"

@implementation SDMUSBTermDeviceItem

- (instancetype)initWithDevice:(io_service_t)device location:(uint32_t)locationId {
	self = [super init];
	if (self) {
		_deviceName = @"Device";
		IOObjectRetain(device);
		_deviceHandle = device;
		_deviceLocation = locationId;
	}
	return self;
}

- (id)fetchObjectForIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"DeviceName"]) {
		return _deviceName;
	}
	else if ([identifier isEqualToString:@"DeviceLocation"]) {
		return [NSString stringWithFormat:@"0x%08x",_deviceLocation];
	}
	else {
		return @"Invalid Identifier";
	}
}

@end
