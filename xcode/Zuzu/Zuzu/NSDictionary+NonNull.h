//
//  NSDictionary+NonNull.h
//  Zuzu
//
//  Created by Mattt Thompson on 2013/07/15.
//  Copyright (c) 2013年 Grant Wenzlau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NonNull)

- (id)nonNullValueForKeyPath:(NSString *)keypath;

@end
