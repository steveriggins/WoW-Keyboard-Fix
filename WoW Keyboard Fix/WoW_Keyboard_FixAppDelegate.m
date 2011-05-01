//
//  WoW_Keyboard_FixAppDelegate.m
//  WoW Keyboard Fix
//
//  Created by Steven W Riggins on 4/30/11.
//
//  Keyboard code from http://dotdotcomorg.net/Mac/

#import "WoW_Keyboard_FixAppDelegate.h"

static NSTextField *gStatusField = nil;

@implementation WoW_Keyboard_FixAppDelegate

@synthesize window;
@synthesize statusField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    gStatusField = self.statusField;
    [self installTap];
}

// alterkeys.c
// http://osxbook.com
// modified by Chance Miller to support multikeyboard use
//
// Complile using the following command line:
//	 gcc -Wall -o alterkeys alterkeys.c -framework ApplicationServices
//
// You need superuser privileges to create the event tap, unless accessibility
// is enabled. To do so, select the "Enable access for assistive devices"
// checkbox in the Universal Access system preference pane.

#include <ApplicationServices/ApplicationServices.h>

//Global Variables to keey track of modifier keys pressed
static bool ctr = false;
static bool sft = false;
static bool cmd = false;
static bool opt = false;


// This callback will be invoked every time there is a keystroke.
//
CGEventRef
myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
				  CGEventRef event, void *refcon)
{
	// Paranoid sanity check.
	if ((type != kCGEventKeyDown) && (type != kCGEventKeyUp) && (type != kCGEventFlagsChanged))
		return event;
    
	// The incoming keycode.
	CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
	//Control
	if(keycode == (CGKeyCode)59||keycode == (CGKeyCode)62){
		if(ctr){
			ctr = false;
            [gStatusField setStringValue:@"Control up!"];
		}
		else{
            [gStatusField setStringValue:@"Control down!"];
			ctr = true;
		}
	}
	if(ctr){
		CGEventSetFlags(event,NX_CONTROLMASK|CGEventGetFlags(event));
	}
	//Shift
	if(keycode == (CGKeyCode)60||keycode == (CGKeyCode)56){
		if(sft){
			sft = false;
		}
		else{
			sft = true;
		}
	}
	if(sft){
		CGEventSetFlags(event,NX_SHIFTMASK|CGEventGetFlags(event));
	}
	//Command
	if(keycode == (CGKeyCode)55||keycode == (CGKeyCode)54){
		if(cmd){
			cmd = false;
		}
		else{
			cmd = true;
		}
	}
	if(cmd){
		CGEventSetFlags(event,NX_COMMANDMASK|CGEventGetFlags(event));
	}
	//Option
	if(keycode == (CGKeyCode)58||keycode == (CGKeyCode)61){
		if(opt){
			opt = false;
		}
		else{
			opt = true;
		}
	}
	if(opt){
		CGEventSetFlags(event,NX_ALTERNATEMASK|CGEventGetFlags(event));
	}
	CGEventSetIntegerValueField(
                                event, kCGKeyboardEventKeycode, (int64_t)keycode);
    
	// We must return the event for it to be useful.
	return event;
}

-(void)installTap {
	CFMachPortRef	  eventTap;
	CGEventMask		eventMask;
	CFRunLoopSourceRef runLoopSource;
    
	// Create an event tap. We are interested in key presses.
	eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp) | (1 << kCGEventFlagsChanged));
	eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0,
								eventMask, myCGEventCallback, NULL);
	if (!eventTap) {
		fprintf(stderr, "failed to create event tap\n");
		exit(1);
	}
    
	// Create a run loop source.
	runLoopSource = CFMachPortCreateRunLoopSource(
                                                  kCFAllocatorDefault, eventTap, 0);
    
	// Add to the current run loop.
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource,
					   kCFRunLoopCommonModes);
    
	// Enable the event tap.
	CGEventTapEnable(eventTap, true);
    
	// Set it all running.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFRunLoopRun();
    });

    
	// In a real program, one would have arranged for cleaning up.
}
@end
