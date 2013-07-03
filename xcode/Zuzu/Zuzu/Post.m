//
//  Post.m
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "Post.h"
#import "AddPostViewController.h"
#import "ZuzuAPIClient.h"
#import "Notifications.h"
#import "AFNetworking.h"
#import "ISO8601DateFormatter.h"
#import "NSDictionary+JSONValueParsing.h"
#import "BlocksKit.h"

static NSDate * NSDateFromISO8601String(NSString *string) {
    static ISO8601DateFormatter *_iso8601DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iso8601DateFormatter = [[ISO8601DateFormatter alloc] init];
    });
    
    if (!string) {
        return nil;
    }
    
    return [_iso8601DateFormatter dateFromString:string];
}

//static NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate) {
//    return [ NSString stringWithFormat:@"(%f, %f)", coordinate.latitude, coordinate.longitude];
//}

static NSString * NSStringFromDate(NSDate *date) {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDoesRelativeDateFormatting:YES];
    });
    
    return [_dateFormatter stringFromDate:date];
}

//@interface Post ()
//@property (strong, nonatomic, readwrite) NSDate *timestamp;
////@property (strong, nonatomic, readwrite) NSString *content;
//@end

@implementation Post
@synthesize content, createdAt;
//@dynamic content;
//@dynamic createdAt;

-(id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.content = [attributes valueForKeyPath:@"content"];
    self.createdAt = [attributes valueForKeyPath:@"createdAt"];

    return self;
}
+ (void)fetchPosts:(void (^)(NSArray *posts, NSError *error))completionBlock {
    [[ZuzuAPIClient sharedClient] getPath:@"/posts.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            NSArray *posts = [Post postsWithJSON:responseObject];
            completionBlock(posts, nil);
        } else {
            NSLog(@"Received an HTTP %d: %@", operation.response.statusCode, responseObject);
            completionBlock(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
}

+(NSArray *)postsWithJSON:(NSArray *)postsJson {
    return [postsJson map:^id(id itemJson) {
        return [Post postFromJSON:itemJson];
    }];
}

+(Post *)postFromJSON:(NSDictionary *)dictionary {
    Post *post = [[Post alloc] init];
 //   [post updateFromJSON:dictionary];
    
    return post;
}

//- (void)updateFromJSON:(NSDictionary *)dictionary {
//    self.content = [dictionary stringForKey:@"content"];
//    self.createdAt = [dictionary dateForKey:@"createdAt"];
//}

- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
    [self saveWithProgress:nil completion:completionBlock];
}

-(void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    if (!self.content) self.content = @"";
    
    NSDictionary *params = @{
                             @"post[content]" : self.content,
                            @"post[createdAt]" : self.createdAt
                             };
    
    NSURLRequest *postRequest = [[ZuzuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                                                        path:@"/posts"
                                                                                  parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:self.content name:@"content"];
    }];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            NSDictionary *updatedPost = [responseObject objectForKey:@"post"];
    //        [self updateFromJSON:updatedPost];
            [self notifyCreated];
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO,error);
    }];
    [[ZuzuAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
};

- (void)notifyCreated {
    [[NSNotificationCenter defaultCenter] postNotificationName:PostCreatedNotification
                                                        object:self];
}
@end
