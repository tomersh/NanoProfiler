//
//  ProfilingService.m
//
//  Created by Tomer Shiri on 1/10/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "ProfilingService.h"

@interface TimerData : NSObject {
    double _totalRuntime;
    int _runtimeCount;
}

@property (nonatomic, assign) double totalRuntime;
@property (nonatomic, assign) int runtimeCount;
@end

@implementation TimerData
@synthesize totalRuntime = _totalRuntime, runtimeCount = _runtimeCount;
@end

@implementation ProfilingService

static NSMutableDictionary* _timers;
static NSMutableDictionary* _avarageRuntimeData;

+(void)initialize {
    _timers = [[NSMutableDictionary alloc] init];
    _avarageRuntimeData = [[NSMutableDictionary alloc] init];
}

-(id)init {
    return nil;
}

+(NSString*) _getThradSafeTimerName:(NSString*) timerName {
    return [timerName stringByAppendingString:[[NSThread currentThread] name]];
}

+(void) _startTimerForTimerNamed:(NSString*) timerName {
    @synchronized(_timers) {
        [_timers setValue:[NSDate date] forKey:[ProfilingService _getThradSafeTimerName:timerName]];
    }
}

+(NSDate*) _stopTimerNamed:(NSString*) timerName {
    @synchronized(_timers) {
        NSDate* date = [_timers valueForKey:[ProfilingService _getThradSafeTimerName:timerName]];
        [_timers removeObjectForKey:timerName];
        return date;
    }
}


+(TimerData*) _getRuntimeDataForTimerNamed:(NSString*) timerName {
    @synchronized(_avarageRuntimeData) {
        return [_avarageRuntimeData valueForKey:timerName];
    }
}

+(void) _setRuntimeDataForTimerNamed:(TimerData*) timerData named:(NSString*) timerName {
    @synchronized(_avarageRuntimeData) {
        [_avarageRuntimeData setValue:timerData forKey:timerName];
    }
}

+(void) startTimer:(NSString*)named {
    [ProfilingService startTimer:named verbose:YES];
}

+(void) startTimer:(NSString*)named verbose:(BOOL)verbose {
    [ProfilingService _startTimerForTimerNamed:named];
    if (verbose) {
        NSLog(@"*** Timer %@ started. ***", named);
    }
}

+(double) stopTimer:(NSString*)named {
    return [ProfilingService stopTimer:named verbose:YES];
}

+(double) stopTimer:(NSString*)named verbose:(BOOL)verbose {
    NSDate* endTime = [NSDate date];
    NSDate* startTime = [ProfilingService _stopTimerNamed:named];
    if (!startTime) {
        if (verbose) {
            NSLog(@"No such timer %@", named);
        }
        return -1;
    }
    double timePassed = [startTime timeIntervalSinceDate:endTime] * -1000.0;
    
    TimerData* timerData = [ProfilingService _getRuntimeDataForTimerNamed:named];
    
    if (!timerData) {
        timerData = [[[TimerData alloc] init] autorelease];
    }
    
    timerData.runtimeCount += 1;
    timerData.totalRuntime += timePassed;
    
    [ProfilingService _setRuntimeDataForTimerNamed:timerData named:named];
    
    double avarageRuntime = timerData.totalRuntime / timerData.runtimeCount;

    if (verbose) {
        NSLog(@"*** Timer %@ stopped. runtime: %f ms. Avarage runtime %f ms. Total runtime: %f ms ***", named, timePassed, avarageRuntime, timerData.totalRuntime);
    }
    return timePassed;
}

@end
