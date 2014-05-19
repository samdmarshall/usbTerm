//
//  SDMUSBTermDeviceViewController.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDMUSBTermPluginProtocol.h"

@interface SDMUSBTermDeviceViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSTableView *deviceTable;
@property (nonatomic, weak) IBOutlet NSButton *connectButton;
@property (nonatomic, weak) IBOutlet NSButton *cancelButton;

- (IBAction)doConnect:(id)sender;
- (IBAction)doCancel:(id)sender;

- (void)scanForDevicesForPlugin:(id<SDMUSBTermPluginProtocol>)plugin;

@end
