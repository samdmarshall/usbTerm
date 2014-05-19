//
//  SDMUSBTermConsoleViewController.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermConsoleViewController.h"

@interface SDMUSBTermConsoleViewController ()

@end

@implementation SDMUSBTermConsoleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		_deviceReadOperation = dispatch_queue_create("com.samdmarshall.usbTerm.DeviceRead", NULL);
		_deviceWriteOperation = dispatch_queue_create("com.samdmarshall.usbTerm.DeviceWrite", NULL);
		_shouldReadFromDevice = YES;
    }
    return self;
}

- (void)dealloc {
	_deviceReadOperation = nil;
	_deviceWriteOperation = nil;
	_pluginInstance = nil;
}

- (void)setupPlugin {
	if (_pluginInstance != nil) {
		[_pluginInstance connectToDevice];
		dispatch_async(_deviceReadOperation, ^{
			IOReturn result = kIOReturnSuccess;
			while (_shouldReadFromDevice) {
				NSData *console_data = nil;
				result = [_pluginInstance readData:&console_data];
				if (result == kIOReturnSuccess) {
					NSString *readString = [[NSString alloc] initWithData:console_data encoding:NSUTF8StringEncoding];
					dispatch_async(dispatch_get_main_queue(), ^{
						NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:readString];
						[[_consoleText textStorage] appendAttributedString:attributedString];
						[_consoleText scrollRangeToVisible:NSMakeRange([[_consoleText string] length], 0)];
					});
				}
			}
		});
	}
}

- (IBAction)sendInput:(id)sender {
	__block NSString *input = [[_consoleInput stringValue] copy];
	[_consoleInput setStringValue:@""];
	dispatch_async(_deviceWriteOperation, ^{
		IOReturn result = kIOReturnSuccess;
		NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
		result = [_pluginInstance writeData:inputData];
		if (result != kIOReturnSuccess) {
			[self stopConnectedDevice];
		}
	});
}

- (void)stopConnectedDevice {
	_shouldReadFromDevice = NO;
	dispatch_async(dispatch_get_main_queue(), ^{
		[_pluginInstance attachToDevice:0];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"com.samdmarshall.usbTerm.ShowDeviceList" object:_pluginInstance];
	});
	_pluginInstance = nil;
}

@end
