//
//  SDMUSBTermPluginTableDatasource.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDMUSBTermPluginTableDatasource : NSObject <NSTableViewDataSource>

- (void)reloadPlugins;
- (NSBundle *)pluginBundleFromIndex:(NSInteger)index;

@end
