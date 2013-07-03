//
//  Post.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSObject

+ (void)fetchPosts:(void (^)(NSArray *posts, NSError *error))completionBlock;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdAt;

- (id)initWithAttributes:(NSDictionary *)attributes;

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;

@end
