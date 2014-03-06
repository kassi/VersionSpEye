//
//  KSAppDelegate.h
//  VersionSpEye
//
//  Created by Karsten Silkenbäumer on 06.03.14.
//  Copyright (c) 2014 Karsten Silkenbäumer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KSAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu* statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighlighted;
}

@property (assign) IBOutlet NSWindow *window;

@end
