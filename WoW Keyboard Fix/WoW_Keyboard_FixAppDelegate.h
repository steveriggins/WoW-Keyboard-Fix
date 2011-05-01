//
//  WoW_Keyboard_FixAppDelegate.h
//  WoW Keyboard Fix
//
//  Created by Steven W Riggins on 4/30/11.
//  Copyright 2011 Geeks R Us. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WoW_Keyboard_FixAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
