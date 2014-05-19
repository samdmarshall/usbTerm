//
//  SDMAppDelegate.m
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import "SDMAppDelegate.h"
#import "SDMUSBTermWindowController.h"
#import "NSFileManager+DirectoryLocations.h"

@interface SDMAppDelegate ()

@property (nonatomic, readonly) SDMUSBTermWindowController *windowController;

@end

@implementation SDMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	NSString *applicationSupportPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"/Plugins/"];
	BOOL isCreated = YES;
	BOOL pluginsDirExists;
	BOOL appSupportExists = [[NSFileManager defaultManager] fileExistsAtPath:applicationSupportPath	isDirectory:&pluginsDirExists];
	if (appSupportExists == NO || (appSupportExists == YES && pluginsDirExists == NO)) {
		isCreated = [[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportPath withIntermediateDirectories:YES attributes:@{} error:nil];
	}
	
	if (isCreated == YES) {
		NSString *builtinPluginsPath = [[NSBundle mainBundle] builtInPlugInsPath];
		NSArray *builtinPlugins = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:builtinPluginsPath error:nil];
		for (NSString *builtinItem in builtinPlugins) {
			NSString *fullBuiltinPath = [builtinPluginsPath stringByAppendingPathComponent:builtinItem];
			NSString *appSupportPath = [applicationSupportPath stringByAppendingPathComponent:builtinItem];
			BOOL didCopy = [[NSFileManager defaultManager] copyItemAtPath:fullBuiltinPath toPath:appSupportPath error:nil];
			if (didCopy == YES) {
				// successful copy
			}
		}
	}

	
	_windowController = [[SDMUSBTermWindowController alloc] initWithWindowNibName:@"SDMUSBTermWindowController"];
	[_windowController showWindow:self];
}

@end
