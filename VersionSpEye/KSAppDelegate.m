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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"username",
                                 @"", @"apikey",
                                 nil];
    [defaults registerDefaults:appDefaults];
    
    NSString *username = [defaults valueForKey:@"username"];
    [[self usernameField] setStringValue:username];
    [[self apikeyField] setStringValue:[defaults valueForKey:@"apikey"]];
    
    [self readAndSetPasswordForUsername:username];
}

- (void)readAndSetPasswordForUsername:(NSString*)username {
    NSString *password = [self passwordForGenericServiceForUser:username];
    [[self passwordField] setStringValue:password];
}

- (IBAction)performMakeKeyAndOrderFront:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [_preferencesWindow makeKeyAndOrderFront:sender];
}

- (NSString*)passwordForGenericServiceForUser:(NSString*)username {
    NSString *service = @"VersionSpEye";
    OSStatus status;
    
    char *passwordBuffer;
    UInt32 passwordLength;
    
    status = SecKeychainFindGenericPassword(NULL, (uint32_t)service.length, service.UTF8String, (uint32_t)username.length, username.UTF8String, &passwordLength, (void **)&passwordBuffer, NULL);
    if (status == CSSM_OK) {
        return [[NSString alloc] initWithUTF8String:passwordBuffer];
    } else {
        return @"";
    }
}

- (void)addPasswordForGenericServiceForUser:(NSString*)username password:(NSString*)password replaceExisting:(BOOL)replace {
    NSString *service = @"VersionSpEye";
    OSStatus status;
    
    status = SecKeychainAddGenericPassword(NULL, (uint32_t)service.length, service.UTF8String, (uint32_t)username.length, username.UTF8String, (uint32_t)password.length, password.UTF8String, NULL);
    if (status == errSecDuplicateItem && replace == YES) {
        SecKeychainItemRef existingItem;
        UInt32 existingPasswordLength;
        char *existingPasswordBuffer;
        
        status = SecKeychainFindGenericPassword(NULL, (uint32_t)service.length, service.UTF8String, (uint32_t)username.length, username.UTF8String, &existingPasswordLength, (void**)&existingPasswordBuffer, &existingItem);
        if (![password isEqualToString:[NSString stringWithUTF8String:existingPasswordBuffer]]) {
            status = SecKeychainItemModifyContent(existingItem, NULL, (uint32_t)password.length, password.UTF8String);
        }
        SecKeychainItemFreeContent(NULL, existingPasswordBuffer);
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    NSTextField *field = [notification object];
    NSString *identifier = [field identifier];
    
    if (identifier) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[field stringValue] forKey:identifier];
        [defaults synchronize];
        
        if (field == _usernameField) {
            [self readAndSetPasswordForUsername:[field stringValue]];
        }
    }
    else if (field == _passwordField) {
        NSString *username = [[self usernameField] stringValue];
        if (username.length > 0) {
            [self addPasswordForGenericServiceForUser:username password:[field stringValue] replaceExisting:YES];
        }
    }
}

@end
