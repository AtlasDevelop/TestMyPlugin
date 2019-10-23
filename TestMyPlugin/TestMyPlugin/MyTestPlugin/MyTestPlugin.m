//
//  MyTestPlugin.m
//  CallTermBundleTests
//
//  Created by Weidong Cao on 2019/10/22.
//  Copyright © 2019 Weidong Cao. All rights reserved.
//

#import "MyTestPlugin.h"

@implementation FSPlugin
-(CTPluginCommand *)execute:(NSString *)command parameters:(NSDictionary *)param{
    CTPluginCommand *ctpcmd=[[CTPluginCommand alloc] init];
    ctpcmd.command=command;
    ctpcmd.parameters=param;
    return [self.CT_PluginWrapper executeCommand:ctpcmd error:nil];
    
}
@end

@implementation MyTestPlugin

-(FSPlugin *)loadPlugin:(NSString *)bundlePath name:(NSString *)name parameters:(NSDictionary *)param err:(NSError **)err{
    //NSError *err;
    id log= CTLogGetDelegate();
    CTPluginSettings *settings=[[CTPluginSettings alloc] init];
    settings.identifier=@"";
    settings.loggingID=@"DEBUG";
    settings.pluginName=name;
    settings.workingDirectory=@"/vault";
    settings.bundlePath=bundlePath;
    NSString *logPath=[NSString stringWithFormat:@"/vault/%@.log",name];
    settings.logPaths=@[logPath];
    
    CTPluginWrapper *wrapper=[[CTPluginWrapper alloc] initWithSettings:settings
                                                              delegate:nil
                                                                   log:log
                                                                 error:err];
    CTLog(CTLOG_LEVEL_INFO, @"wrapper init error:%@",*err);
    
    BOOL status=[wrapper setup:param error:err];
    CTLog(CTLOG_LEVEL_INFO, @"setup status:%hhd error:%@",status,*err);
    
    if (NO == status) {
        return nil;
    }
    
    FSPlugin *plugin=[[FSPlugin alloc] init];
    plugin.CT_PluginWrapper = wrapper;
    plugin.CT_Unit = nil;
    
    return plugin;
    
}
@end
