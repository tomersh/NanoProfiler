//
//  NanoProfiler.m
//  test
//
//  Created by Tomer Shiri on 1/10/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "NanoProfiler.h"
#import "ProfilingService.h"
#import <objc/runtime.h>

@implementation NanoProfiler

static NSMutableDictionary* _wrappedFunctions;

+(id) init {
    return nil;
}

+(void)initialize {
    _wrappedFunctions = [[NSMutableDictionary alloc] init];
}

+(BOOL) isInstance:(id) object {
    return class_isMetaClass(object_getClass(object));
}

+(BOOL) wasWrapped:(Class) clazz andSelector:(SEL) selector {
    NSNumber* pointer = [_wrappedFunctions objectForKey:[NanoProfiler getStoredKeyForClass:clazz andSelector:selector]];
    return pointer ? YES : NO;
}

+(BOOL) addProfiler:(id) object andSelector:(SEL) selector {
    
    Class originalClass = [NanoProfiler isInstance:object] ? [object class] : object;
    
    if ([NanoProfiler wasWrapped:originalClass andSelector:selector]) return NO;
    
    Method originalMethod;
    
    if ([NanoProfiler isInstance:object]) {
        originalMethod = class_getInstanceMethod(originalClass, selector);
    }
    else {
        originalMethod = class_getClassMethod(originalClass, selector);
    }
    
    void* originaImplementation = (void *)method_getImplementation(originalMethod);
    int* pointerToFunction = (void*)&originaImplementation;
    int pointerAddress = *pointerToFunction;
    
    [_wrappedFunctions setValue:[NSNumber numberWithInt:pointerAddress] forKey:[NanoProfiler getStoredKeyForClass:originalClass        andSelector:selector]];
    
    if(!class_addMethod(originalClass, selector, (IMP)OverrideInit, method_getTypeEncoding(originalMethod)))
        method_setImplementation(originalMethod, (IMP)OverrideInit);
    
    return YES;
}

+(NSString*) getStoredKeyForClass:(Class) clazz andSelector:(SEL) selector {
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass(clazz), NSStringFromSelector(selector)];
}

static id OverrideInit(id self, SEL _cmd, ...)
{
    va_list args;
    va_start(args, _cmd);
    
    NSString* timerKey = [NanoProfiler getStoredKeyForClass:[self class] andSelector:_cmd];
    
    NSNumber* implementationPointer = [_wrappedFunctions objectForKey:timerKey];
    int pointerAddress = [implementationPointer intValue];
    if (!implementationPointer) return nil;
    id (*implementation)(id, SEL, ...) = (void *)*&pointerAddress;
    
    [ProfilingService startTimer:timerKey];
    
    id returnValue = implementation(self, _cmd, args);
    
    [ProfilingService stopTimer:timerKey];
    
    return returnValue;
}

@end
