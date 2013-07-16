//
//  Post.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Post : NSObject

@property (nonatomic, strong) NSString *content;
@property (strong, nonatomic, readonly) NSDate *timestamp;
@property (strong) CLLocation *location;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (void)postsNearLocation:(CLLocation *)location
                    block:(void (^)(NSArray *posts, NSError *error))block;
+ (void)savePostAtLocation:(CLLocation *)location
               withContent:(NSString *)content
                     block:(void (^)(Post *post, NSError *error))block;
@end
