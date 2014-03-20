//
//  KSAppDelegate.h
//  VersionSpEye
//
//  Created by Karsten Silkenbäumer on 06.03.14.
//  Copyright (c) 2014 Karsten Silkenbäumer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KSVersionEyeAPI.h"

@interface KSAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu* statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageDisabled;
    KSVersionEyeAPI *versionEyeAPI;
}

@property (unsafe_unretained) IBOutlet NSWindow *preferencesWindow;
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *apikeyField;

@end
