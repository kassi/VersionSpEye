//
//  KSAppDelegate.m
//  VersionSpEye
//
//  Created by Karsten Silkenbäumer on 06.03.14.
//  Copyright (c) 2014 Karsten Silkenbäumer. All rights reserved.
//

#import "KSAppDelegate.h"
#import "KSVersionEyeAPI.h"

@implementation KSAppDelegate

- (void)awakeFromNib {
    statusImage = [NSImage imageNamed:@"versioneye-16"];
    statusImageDisabled = [NSImage imageNamed:@"versioneye-16-alt"];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [statusItem setImage:statusImageDisabled];
    [statusItem setMenu: statusMenu];
    [statusItem setToolTip:NSLocalizedString(@"No updates available", @"ToolTip of StatusBar Item")];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"username",
                                 @"", @"apikey",
                                 nil];
    [defaults registerDefaults:appDefaults];
    
    NSString *username = [defaults valueForKey:@"username"];
    [[self usernameField] setStringValue:username];
    NSString *apikey = [defaults valueForKey:@"apikey"];
    [[self apikeyField] setStringValue:apikey];
    
    KSVersionEyeAPI *api = [KSVersionEyeAPI sharedAPI];
    [api setApiKey:apikey];
    
    [self readAndSetPasswordForUsername:username];
    
    [self setStatusItemImage];
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

- (void)setStatusItemImage {
    if ([[KSVersionEyeAPI sharedAPI] ping]) {
        [statusItem setImage:statusImage];
    } else {
        [statusItem setImage:statusImageDisabled];
    }
}

#pragma NSMenu delegate methods

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    NSMenuItem *errorMenuItem = [statusMenu itemWithTag:1];
    NSString *errorDescription = [[KSVersionEyeAPI sharedAPI] errorDescription];
    
    NSUInteger flags = ([NSEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
    
    BOOL shouldHideErrorMenuItem = !(flags == NSAlternateKeyMask && errorDescription);
    
    [errorMenuItem setTitle:errorDescription];
    [errorMenuItem setHidden:shouldHideErrorMenuItem];
}

@end
