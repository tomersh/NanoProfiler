//
//  ProfilingService.h
//  test
//
//  Created by Tomer Shiri on 1/10/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AddProfiler(target, selector) [NanoProfiler addProfiler:(target) andSelector:(selector)];

@interface ProfilingService : NSObject

+(void) startTimer:(NSString*)named;
+(void) startTimer:(NSString*)named verbose:(BOOL)verbose;

+(double) stopTimer:(NSString*)named;
+(double) stopTimer:(NSString*)named verbose:(BOOL)verbose;

@end
