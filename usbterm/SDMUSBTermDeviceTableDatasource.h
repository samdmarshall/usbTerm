//
//  SDMUSBTermDeviceTableDatasource.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMUSBTermPluginProtocol.h"

@interface SDMUSBTermDeviceTableDatasource : NSObject <NSTableViewDataSource>

- (void)reloadDevices;
- (void)updatePlugin:(id<SDMUSBTermPluginProtocol>)plugin;
- (id<SDMUSBTermPluginProtocol>)attachToDeviceAtIndex:(NSInteger)index;

@end
