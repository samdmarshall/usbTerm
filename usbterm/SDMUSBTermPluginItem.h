//
//  SDMUSBTermPluginItem.h
//  usbterm
//
//  Created by Sam Marshall on 5/18/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMTableViewItemProtocol.h"

@interface SDMUSBTermPluginItem : NSObject <SDMTableViewItemProtocol>

@property (nonatomic, strong) NSBundle *pluginBundle;
@property (nonatomic, strong) NSString *pluginName;
@property (nonatomic, strong) NSString *pluginDescription;

- (instancetype)initWithBundle:(NSBundle *)bundle;
- (id)fetchObjectForIdentifier:(NSString *)identifier;

@end
