//
//  SDMUSBTermPluginTableDatasource.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMUSBTermPluginTableDatasource.h"
#import "SDMUSBTermPluginItem.h"
#import "NSFileManager+DirectoryLocations.h"

@interface SDMUSBTermPluginTableDatasource ()

@property (nonatomic, strong) NSArray *knownPlugins;

@end

@implementation SDMUSBTermPluginTableDatasource

- (id)init {
	self = [super init];
	if (self) {
		_knownPlugins = @[];
		[self reloadPlugins];
	}
	return self;
}

- (void)dealloc {
	_knownPlugins = nil;
}

- (void)reloadPlugins {
	NSString *applicationSupportPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"/Plugins/"];
	NSMutableArray *reloadedPlugins = [NSMutableArray new];
	
	NSArray *pluginDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:applicationSupportPath error:nil];
	for (NSString *itemName in pluginDirectoryContents) {
		NSString *fullItemPath = [applicationSupportPath stringByAppendingPathComponent:itemName];
		NSBundle *pluginBundle = [[NSBundle alloc] initWithPath:fullItemPath];
		if (pluginBundle != nil) {
			SDMUSBTermPluginItem *plugin = [[SDMUSBTermPluginItem alloc] initWithBundle:pluginBundle];
			[reloadedPlugins addObject:plugin];
		}
	}
	
	_knownPlugins = nil;
	_knownPlugins = [reloadedPlugins copy];
	reloadedPlugins = nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [_knownPlugins count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	SDMUSBTermPluginItem *pluginItem = [_knownPlugins objectAtIndex:rowIndex];
	return [pluginItem fetchObjectForIdentifier:[aTableColumn identifier]];
}

- (NSBundle *)pluginBundleFromIndex:(NSInteger)index {
	return [[_knownPlugins objectAtIndex:index] pluginBundle];
}

@end
