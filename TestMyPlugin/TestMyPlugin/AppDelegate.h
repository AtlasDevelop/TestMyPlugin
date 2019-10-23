//
//  AppDelegate.h
//  TestMyPlugin
//
//  Created by Weidong Cao on 2019/10/23.
//  Copyright © 2019 Weidong Cao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyTestPlugin.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTextField *bundlePathTF;
    IBOutlet NSTextField *pluginNameTF;
    IBOutlet NSTextField *paramLoadTF;
    IBOutlet NSButton *loadBtn;
    
    IBOutlet NSTextField *commandTF;
    IBOutlet NSTextField *paramCmdTF;
    IBOutlet NSButton *testBtn;
    
    IBOutlet NSTextView *logView;
    
    IBOutlet NSButton *clearBtn;
}

-(IBAction)loadBtnAction:(id)sender;
-(IBAction)testBtnAction:(id)sender;
-(IBAction)clearBtnAction:(id)sender;

@end

