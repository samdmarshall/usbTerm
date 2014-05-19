//
//  SDMUSBTermPluginViewController.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDMUSBTermPluginViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSTableView *pluginTable;
@property (nonatomic, weak) IBOutlet NSButton *startConsole;
@property (nonatomic, weak) IBOutlet NSButton *loadPlugin;

- (IBAction)doStartConsole:(id)sender;
- (IBAction)doLoadPlugin:(id)sender;

@end
