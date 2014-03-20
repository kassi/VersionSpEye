//
//  KSVersionEyeAPI.m
//  VersionSpEye
//
//  Created by Karsten Silkenbäumer on 19.03.14.
//  Copyright (c) 2014 Karsten Silkenbäumer. All rights reserved.
//

#import "KSVersionEyeAPI.h"

@implementation KSVersionEyeAPI
@synthesize apiKey           = _apiKey;
@synthesize errorDescription = _errorDescription;

NSString *apiBaseURL = @"https://www.versioneye.com/api";

#pragma mark Creating a singleton object

+ (id)sharedAPI {
    static KSVersionEyeAPI *sharedAPI;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedAPI = [[KSVersionEyeAPI alloc] init];
    });
    return sharedAPI;
}

#pragma mark -

- (BOOL)ping {
    if (!self.apiKey)
        return NO;
    
    NSURL *url = [[NSURL alloc] initWithString:[apiBaseURL stringByAppendingFormat:@"%@%@", @"/v2/services/ping?api_key=", self.apiKey]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *response;
    NSError *error;
    [request setHTTPMethod:@"GET"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (error) {
        self.errorDescription = [error localizedDescription];
    } else {
        self.errorDescription = nil;
    }
    
    if (data && [response statusCode] < 400) {
        return YES;
    }
    return NO;
}

@end
