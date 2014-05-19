//
//  SDMUSBTermConsoleViewController.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDMUSBTermPluginProtocol.h"

@interface SDMUSBTermConsoleViewController : NSViewController

@property (nonatomic, strong) id<SDMUSBTermPluginProtocol> pluginInstance;

@property (nonatomic, readonly) dispatch_queue_t deviceReadOperation;
@property (nonatomic, readonly) dispatch_queue_t deviceWriteOperation;

@property (nonatomic, readonly) BOOL shouldReadFromDevice;

@property (nonatomic, strong) IBOutlet NSTextView *consoleText;
@property (nonatomic, weak) IBOutlet NSTextField *consoleInput;

- (void)setupPlugin;

- (IBAction)sendInput:(id)sender;

@end
