//
//  MyTestPlugin.h
//  CallTermBundleTests
//
//  Created by Weidong Cao on 2019/10/22.
//  Copyright © 2019 Weidong Cao. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <FFCommunication/FFCommunication.h>
#import <CoreTestFoundation/CoreTestFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FSPlugin : NSObject

@property (nonatomic,strong) CTPluginWrapper *CT_PluginWrapper;
@property (nonatomic,strong) CTUnit *__nullable CT_Unit;

-(CTPluginCommand *)execute:(NSString *)command parameters:(NSDictionary *)param;

@end

@interface MyTestPlugin : NSObject
-(FSPlugin *)loadPlugin:(NSString *)bundlePath name:(NSString *)name parameters:(NSDictionary *)param err:(NSError **)err;

@end



NS_ASSUME_NONNULL_END
