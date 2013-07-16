//
//  NSDictionary+NonNull.m
//  Zuzu
//
//  Created by Mattt Thompson on 2013/07/15.
//  Copyright (c) 2013年 Grant Wenzlau. All rights reserved.
//

#import "NSDictionary+NonNull.h"

@implementation NSDictionary (NonNull)

- (id)nonNullValueForKeyPath:(NSString *)keypath {
    id value = [self valueForKeyPath:keypath];
    if (value && ![value isEqual:[NSNull null]]) {
        return value;
    }

    return nil;
}

@end
