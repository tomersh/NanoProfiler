//
//  NanoProfiler.h
//  test
//
//  Created by Tomer Shiri on 1/10/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AddProfiler(target, selector) [NanoProfiler addProfiler:(target) andSelector:(selector)];

@interface NanoProfiler : NSObject

+(void) addProfiler:(Class) target andSelector:(SEL) selector;

@end
