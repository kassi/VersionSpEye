//
//  KSAppDelegate.m
//  VersionSpEye
//
//  Created by Karsten Silkenbäumer on 06.03.14.
//  Copyright (c) 2014 Karsten Silkenbäumer. All rights reserved.
//

#import "KSAppDelegate.h"

@implementation KSAppDelegate

- (void)awakeFromNib {
    statusImage = [NSImage imageNamed:@"versioneye-16"];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:statusImage];
    [statusItem setMenu: statusMenu];
    [statusItem setToolTip:NSLocalizedString(@"No updates available", @"ToolTip of StatusBar Item")];
}

- (IBAction)showPreferences:(id)sender {
    [_preferencesWindow makeKeyAndOrderFront:sender];
}

@end
