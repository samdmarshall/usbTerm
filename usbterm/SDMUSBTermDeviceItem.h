//
//  SDMUSBTermDeviceItem.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMTableViewItemProtocol.h"

@interface SDMUSBTermDeviceItem : NSObject <SDMTableViewItemProtocol>

@property (nonatomic, readonly) io_service_t deviceHandle;
@property (nonatomic, readonly) NSString *deviceName;
@property (nonatomic, readonly) uint32_t deviceLocation;

- (instancetype)initWithDevice:(io_service_t)device location:(uint32_t)locationId;

- (id)fetchObjectForIdentifier:(NSString *)identifier;

@end
