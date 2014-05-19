//
//  SDMUSBTermDeviceViewController.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermDeviceViewController.h"
#import "SDMUSBTermDeviceTableDatasource.h"

@interface SDMUSBTermDeviceViewController ()

@property (nonatomic, strong) id<SDMUSBTermPluginProtocol> usbPlugin;
@property (nonatomic, strong) SDMUSBTermDeviceTableDatasource *deviceTableDatasource;
@property (nonatomic, strong) NSTimer *updateDisplay;

@end

@implementation SDMUSBTermDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		_deviceTableDatasource = [[SDMUSBTermDeviceTableDatasource alloc] init];
		_updateDisplay = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanForNewDevices) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc {
	[_updateDisplay invalidate];
	_updateDisplay = nil;
	_deviceTableDatasource = nil;
	_usbPlugin = nil;
}

- (void)awakeFromNib {
	[[self deviceTable] setDataSource:_deviceTableDatasource];
}

- (IBAction)doConnect:(id)sender {
	NSInteger selectedDevice = [_deviceTable selectedRow];
	_usbPlugin = [_deviceTableDatasource attachToDeviceAtIndex:selectedDevice];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.samdmarshall.usbTerm.ShowConsoleView" object:_usbPlugin];
}

- (IBAction)doCancel:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.samdmarshall.usbTerm.ShowPluginList" object:nil];
}

- (void)scanForDevicesForPlugin:(id<SDMUSBTermPluginProtocol>)plugin {
	_usbPlugin = plugin;
	[_deviceTableDatasource updatePlugin:_usbPlugin];
	[self scanForNewDevices];
}

- (void)scanForNewDevices {
	[_deviceTableDatasource reloadDevices];
	[_deviceTable reloadData];
}

@end
