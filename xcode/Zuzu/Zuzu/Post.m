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
#import "AFNetworking.h"
#import "ISO8601DateFormatter.h"

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

static NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    return [ NSString stringWithFormat:@"(%f, %f)", coordinate.latitude, coordinate.longitude];
}

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

@interface Post ()
@property (strong, nonatomic, readwrite) NSDate *timestamp;
//@property (assign, nonatomic, readwrite) CLLocationDegrees latitude;
//@property (assign, nonatomic, readwrite) CLLocationDegrees longitude;
@end

@implementation Post
@synthesize content = _content;
@synthesize timestamp = _timestamp;
@dynamic location;

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.content = [dictionary valueForKeyPath:@"content"];
    self.timestamp = NSDateFromISO8601String([dictionary valueForKeyPath:@"createdAt"]);
    self.location = [[CLLocation alloc] initWithLatitude:[[dictionary valueForKey:@"lat"] doubleValue] longitude:[[dictionary valueForKey:@"lng"] doubleValue]];
    
    return self;
}

//- (CLLocation *)location {
//    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
//}
+ (void)savePostAtLocation:(CLLocation *)location
                     withContent:(NSString *)content
                     block:(void (^)(Post *, NSError *))block
{
    NSDictionary *parameters = @{ @"post": @{
                                          @"lat": @(location.coordinate.latitude),
                                          @"lng": @(location.coordinate.longitude),
                                          @"content": content
                                          }
                                  };
    [[ZuzuAPIClient sharedClient] postPath:@"/posts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Post *post = [[Post alloc] initWithDictionary:responseObject];
        if (block) {
            block(post, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
//    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
//    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"lat"];
//    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"lng"];
//    
//    NSMutableURLRequest *mutableURLRequest = [[ZuzuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"/posts" parameters:mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    }];
//    AFHTTPRequestOperation *operation = [[ZuzuAPIClient sharedClient] HTTPRequestOperationWithRequest:mutableURLRequest success:^(AFHTTPRequestOperation *operation, id JSON) {
//        Post *post = [[Post alloc] initWithAttributes:[JSON valueForKeyPath:@"post"]];
//        
//        if (block) {
//            block(post, nil);
//        }
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];
//    [[ZuzuAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
//}


+ (void)postsNearLocation:(CLLocation *)location
                    block:(void (^)(NSArray *posts, NSError *error))block {
    NSDictionary *parameters = @{
                                 @"lat": @(location.coordinate.latitude),
                                 @"lng": @(location.coordinate.longitude)
                                 };
    
    [[ZuzuAPIClient sharedClient] getPath:@"/posts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutablePosts = [NSMutableArray array];
        for (NSDictionary *dictionary in [responseObject valueForKey:@"posts"]) {
            Post *post = [[Post alloc] initWithDictionary:dictionary];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block(mutablePosts, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (block) {
            block(nil, error);
        }
    }];
//    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
//    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"lat"];
//    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"lng"];
//    
//    [[ZuzuAPIClient sharedClient] getPath:@"/posts" parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id JSON) {
//        NSMutableArray *mutablePosts = [NSMutableArray array];
//        for (NSDictionary *attributes in [JSON valueForKey:@"posts"]) {
//            Post *post = [[Post alloc] initWithAttributes:attributes];
//            [mutablePosts addObject:post];
//        }
//        
//        if (block ) {
//            block([NSArray arrayWithArray:mutablePosts], nil);
//        }
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];
}



@end
