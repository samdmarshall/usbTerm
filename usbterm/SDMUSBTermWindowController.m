//
//  SDMUSBTermWindowController.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermWindowController.h"
#import "SDMUSBTermConsoleViewController.h"
#import "SDMUSBTermPluginViewController.h"
#import "SDMUSBTermDeviceViewController.h"

@interface SDMUSBTermWindowController ()

@property (nonatomic, strong) SDMUSBTermConsoleViewController *consoleViewController;
@property (nonatomic, strong) SDMUSBTermDeviceViewController *deviceViewController;
@property (nonatomic, strong) SDMUSBTermPluginViewController *pluginViewController;

@end

@implementation SDMUSBTermWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapToPluginList:) name:@"com.samdmarshall.usbTerm.ShowPluginList" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapToDeviceList:) name:@"com.samdmarshall.usbTerm.ShowDeviceList" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapToConsoleView:) name:@"com.samdmarshall.usbTerm.ShowConsoleView" object:nil];
		
		_pluginViewController = [[SDMUSBTermPluginViewController alloc] initWithNibName:@"SDMUSBTermPluginViewController" bundle:nil];
		_consoleViewController = [[SDMUSBTermConsoleViewController alloc] initWithNibName:@"SDMUSBTermConsoleViewController" bundle:nil];
		_deviceViewController = [[SDMUSBTermDeviceViewController alloc] initWithNibName:@"SDMUSBTermDeviceViewController" bundle:nil];
    }
    return self;
}

- (void)dealloc {
	_consoleViewController = nil;
	_pluginViewController = nil;
	_deviceViewController = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.samdmarshall.usbTerm.ShowPluginList" object:nil];
}

- (void)removeCurrentViewController {
	NSArray *views = [_targetView subviews];
	[views makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)swapToPluginList:(NSNotification *)notification {
	[self removeCurrentViewController];
	[_targetView addSubview:[_pluginViewController view]];
}

- (void)swapToDeviceList:(NSNotification *)notification {
	[self removeCurrentViewController];
	[_targetView addSubview:[_deviceViewController view]];
	[_deviceViewController scanForDevicesForPlugin:[notification object]];
}

- (void)swapToConsoleView:(NSNotification *)notification {
	[self removeCurrentViewController];
	[_consoleViewController setPluginInstance:[notification object]];
	[_targetView addSubview:[_consoleViewController view]];
	[_consoleViewController setupPlugin];
}

@end
