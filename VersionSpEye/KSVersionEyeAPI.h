//
//  KSVersionEyeAPI.h
//  VersionSpEye
//
//  Created by Karsten Silkenbäumer on 19.03.14.
//  Copyright (c) 2014 Karsten Silkenbäumer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSVersionEyeAPI : NSObject

@property (nonatomic, retain) NSString *apiKey;

#pragma mark Creating a Singleton Object

+ (id)sharedAPI;

#pragma mark -

- (BOOL)ping;

@end
