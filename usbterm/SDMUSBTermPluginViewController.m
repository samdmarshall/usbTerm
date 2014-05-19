//
//  SDMUSBTermPluginViewController.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermPluginViewController.h"
#import "SDMUSBTermPluginTableDatasource.h"
#import "SDMUSBTermPluginProtocol.h"

@interface SDMUSBTermPluginViewController ()

@property (nonatomic, strong) SDMUSBTermPluginTableDatasource *pluginTableDatasource;

@end

@implementation SDMUSBTermPluginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_pluginTableDatasource = [[SDMUSBTermPluginTableDatasource alloc] init];
    }
    return self;
}

- (void)dealloc {
	_pluginTableDatasource = nil;
}

- (void)awakeFromNib {
	[[self pluginTable] setDataSource:_pluginTableDatasource];
	[[self pluginTable] reloadData];
}


- (IBAction)doLoadPlugin:(id)sender {
	// push sheet to select and copy to app support
	[_pluginTableDatasource reloadPlugins];
}

- (IBAction)doStartConsole:(id)sender {
	NSInteger selectedPlugin = [_pluginTable selectedRow];
	NSBundle *bundleToLoad = [_pluginTableDatasource pluginBundleFromIndex:selectedPlugin];
	Class loadClass;
	id<SDMUSBTermPluginProtocol> pluginClassInstance;
	if ((loadClass = [bundleToLoad principalClass])) {
		pluginClassInstance = [[loadClass alloc] init];
		if (pluginClassInstance != nil) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"com.samdmarshall.usbTerm.ShowDeviceList" object:pluginClassInstance userInfo:nil];
		}
	}
}

@end
