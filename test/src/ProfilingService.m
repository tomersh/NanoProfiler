//
//  ProfilingService.m
//  test
//
//  Created by Tomer Shiri on 1/10/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "ProfilingService.h"

@implementation ProfilingService

static NSMutableDictionary* timers;

-(id)init {
    return nil;
}

+(void)initialize {
    timers = [[NSMutableDictionary alloc] init];
}

+(void) startTimer:(NSString*)named {
    [ProfilingService startTimer:named verbose:YES];
}

+(void) startTimer:(NSString*)named verbose:(BOOL)verbose {
    [timers setObject:[NSDate date] forKey:named];
    if (verbose) {
        NSLog(@"*** Timer %@ started. ***",named);
    }
}

+(double) stopTimer:(NSString*)named {
    return [ProfilingService stopTimer:named verbose:YES];
}

+(double) stopTimer:(NSString*)named verbose:(BOOL)verbose {
    NSDate* startTime = [timers valueForKey:named];
    if (startTime == nil) {
        NSLog(@"*** No such timer %@ ***", named);
        return 0;
    }
    double timePassed = [startTime timeIntervalSinceNow] * -1000.0;
    if (verbose) {
        NSLog(@"*** Timer %@ stopped. runtime: %f milliseconds ***", named, timePassed);
    }
    return timePassed;
}

@end
