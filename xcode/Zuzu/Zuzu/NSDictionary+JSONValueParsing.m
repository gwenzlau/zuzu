//
//  NSDictionary+JSONValueParsing.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "NSDictionary+JSONValueParsing.h"

@implementation NSDictionary (JSONValueParsing)

//- (int)intForKey:(id)key {
//    return [[self objectForKey:key] intValue];
//}

- (NSString *)stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

- (NSDate *)dateForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

@end
