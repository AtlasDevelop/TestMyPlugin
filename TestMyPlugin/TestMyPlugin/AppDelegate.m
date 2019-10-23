//
//  AppDelegate.m
//  TestMyPlugin
//
//  Created by Weidong Cao on 2019/10/23.
//  Copyright © 2019 Weidong Cao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    NSString *_logString;
    FSPlugin *testPlugin;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _logString=@"";
    testPlugin=nil;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(IBAction)loadBtnAction:(id)sender{
    _logString=@"";
    testPlugin=nil;
    NSString *bundle_path=[bundlePathTF stringValue];
    if (![bundle_path hasSuffix:@".bundle"]) {
        [self showAlertViewWarning:@"Bundle path wrong,please check!"];
        return;
    }
    [self logUpdate:[NSString stringWithFormat:@"Bundle:%@",bundle_path]];
    NSString *plugin_name=[pluginNameTF stringValue];
    if ([plugin_name length]<1) {
        [self showAlertViewWarning:@"Plugin name wrong,please check!"];
        return;
    }
    [self logUpdate:[NSString stringWithFormat:@"Plugin name:%@",plugin_name]];
    NSString *paramStr=[paramLoadTF stringValue];
    NSDictionary *paramDic=[self dictionaryWithJsonString:paramStr];
    if (nil == paramDic) {
        [self showAlertViewWarning:@"Params of setup plugin parse wrong,please check!"];
        return;
    }
    [self logUpdate:[NSString stringWithFormat:@"Setup params:%@",paramDic]];
    MyTestPlugin *mtp=[[MyTestPlugin alloc] init];
    NSError *err=nil;
    
    @try {
        testPlugin = [mtp loadPlugin:bundle_path name:plugin_name parameters:paramDic err:&err];
        [self logUpdate:[NSString stringWithFormat:@"Load err:%@",[err description]]];
    } @catch (NSException *exception) {
        [self logUpdate:[NSString stringWithFormat:@"Exception:%@",[exception description]]];
        [self showAlertViewWarning:[NSString stringWithFormat:@"Exception:%@",[exception description]]];
    } @finally {
        
    }
    
    if (nil == testPlugin) {
        [self showAlertViewWarning:@"Load plugin error,please check!"];
        return;
    }
    [self logUpdate:[NSString stringWithFormat:@"Load plugin:%@ successful.",[testPlugin description]]];
    //[self testFunc];
}
-(IBAction)testBtnAction:(id)sender{
    if (nil == testPlugin) {
        [self showAlertViewWarning:@"Please load plugin correctly first!"];
        return;
    }
    NSString *cmd=[commandTF stringValue];
    if ([cmd length]<1) {
        [self showAlertViewWarning:@"Command wrong,please check!"];
        return;
    }
    NSString *paramStr=[paramCmdTF stringValue];
    NSDictionary *paramDic=[self dictionaryWithJsonString:paramStr];
    if (nil == paramDic) {
        [self showAlertViewWarning:@"Params of command parse wrong,please check!"];
        return;
    }
    
    @try {
        CTPluginCommand *ctpcmd=[testPlugin execute:cmd parameters:paramDic];
        NSLog(@"result:%@",[ctpcmd.output description]);
        [self logUpdate:@"============output============="];
        [self logUpdate:[ctpcmd.output description]];
    } @catch (NSException *exception) {
        [self logUpdate:[NSString stringWithFormat:@"Exception:%@",[exception description]]];
        [self showAlertViewWarning:[NSString stringWithFormat:@"Exception:%@",[exception description]]];
    } @finally {
        
    }
    
}
-(IBAction)clearBtnAction:(id)sender{
    _logString=@"";
    [self logUpdate:@"Clear log OK"];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(void)logUpdate:(NSString *)log{
    @synchronized (self){
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"[yyyy/MM/dd HH:mm:ss.SSS]"];
        NSString *dateText=[NSString string];
        dateText=[dateFormat stringFromDate:[NSDate date]];
        //dateText=[dateText stringByAppendingString:@"\n"];
        //_logString = [_logString stringByAppendingString:@"\r\n==============================\r\n"];
        _logString = [_logString stringByAppendingString:dateText];
        _logString = [_logString stringByAppendingString:log];
        _logString = [_logString stringByAppendingString:@"\r\n"];
        [self performSelectorOnMainThread:@selector(printLogThread) withObject:nil waitUntilDone:YES];
        //if([self._logString length] >10000) self._logString=@"";
        NSLog(@"%@",log);
    }
    
}
-(void)printLogThread{
    [logView setString:_logString];
    [logView scrollRangeToVisible:NSMakeRange([[logView textStorage] length],0)];
    [logView setNeedsDisplay: YES];
}
- (void)showAlertViewWarning:(NSString *)strWarning
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:strWarning];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert runModal];
}
-(void)windowShouldClose:(id)sender{
    NSLog(@"window will close...");
    [NSApp terminate:self];
}

@end
