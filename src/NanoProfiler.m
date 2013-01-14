//
//  NanoProfiler.m
//  test
//
//  Created by Tomer Shiri on 1/10/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "NanoProfiler.h"
#import "ProfilingService.h"
#import "TheWrapper.h"

@implementation NanoProfiler

+(id) init {
    return nil;
}

+(NSString*) getTimerNameForClass:(Class) clazz andSelector:(SEL) selector {
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass(clazz), NSStringFromSelector(selector)];
}

+(void) addProfiler:(Class) target andSelector:(SEL) selector {
    [TheWrapper addWrappertoClass:target andSelector:selector withPreRunBlock:^(va_list args)
    {
        [ProfilingService startTimer:[NanoProfiler getTimerNameForClass:target andSelector:selector]];
    }
    andPostRunBlock:^id(id functionReturnValue, va_list args)
    {
        [ProfilingService stopTimer:[NanoProfiler getTimerNameForClass:target andSelector:selector]];
        return functionReturnValue;
    }];
}

@end
