//
//  WoW_Keyboard_FixAppDelegate.h
//  WoW Keyboard Fix
//
//  Created by Steven W Riggins on 4/30/11.
//

#import <Cocoa/Cocoa.h>

@interface WoW_Keyboard_FixAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSTextField *statusField;
    NSTextView *infoTextView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *statusField;
@property (assign) IBOutlet NSTextView *infoTextView;

-(void)installTap;

@end
