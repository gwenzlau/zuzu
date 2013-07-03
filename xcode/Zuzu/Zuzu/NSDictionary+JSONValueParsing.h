//
//  NSDictionary+JSONValueParsing.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONValueParsing)

//- (int)intForKey:(id)key;
- (NSString *)stringForKey:(id)key;
// is below right?
- (NSDate *)dateForKey:(id)key;

@end
