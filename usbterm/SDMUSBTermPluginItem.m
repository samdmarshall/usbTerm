//
//  SDMUSBTermPluginItem.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermPluginItem.h"

@implementation SDMUSBTermPluginItem

- (instancetype)initWithBundle:(NSBundle *)bundle {
	self = [super init];
	if (self) {
		_pluginBundle = bundle;
		NSDictionary *infoDictionary = [_pluginBundle infoDictionary];
		_pluginName = [infoDictionary objectForKey:@"CFBundleExecutable"];
	}
	return self;
}

- (void)dealloc {
	_pluginBundle = nil;
	_pluginName = nil;
	_pluginDescription = nil;
}

- (id)fetchObjectForIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"PluginName"]) {
		return _pluginName;
	}
	else if ([identifier isEqualToString:@"PluginDescription"]) {
		return _pluginDescription;
	}
	else {
		return @"Invalid Identifier";
	}
}

@end
