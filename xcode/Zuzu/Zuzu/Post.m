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
@property (assign, nonatomic, readwrite) CLLocationDegrees latitude;
@property (assign, nonatomic, readwrite) CLLocationDegrees longitude;
@end

@implementation Post
@synthesize content = _content;
@synthesize timestamp = _timestamp;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@dynamic location;

-(id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.content = [attributes valueForKeyPath:@"content"];
    self.timestamp = NSDateFromISO8601String([attributes valueForKeyPath:@"createdAt"]);
    
    self.latitude = [[attributes valueForKeyPath:@"lat"] doubleValue];
    self.longitude = [[attributes valueForKeyPath:@"lng"] doubleValue];
    
    return self;
}

- (CLLocation *)location {
    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
}
+ (void)savePostAtLocation:(CLLocation *)location
                     block:(void (^)(Post *post, NSError *error))block
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"lat"];
    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"lng"];
    
    NSMutableURLRequest *mutableURLRequest = [[ZuzuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"/posts" parameters:mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }];
    AFHTTPRequestOperation *operation = [[ZuzuAPIClient sharedClient] HTTPRequestOperationWithRequest:mutableURLRequest success:^(AFHTTPRequestOperation *operation, id JSON) {
        Post *post = [[Post alloc] initWithAttributes:[JSON valueForKeyPath:@"post"]];
        
        if (block) {
            block(post, nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    [[ZuzuAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
}

#pragma mark - MKAnnotation

- (NSString *)content {
    return NSStringFromCoordinate(self.coordinate);
}
- (NSString *)subtitle {
    return NSStringFromDate(self.timestamp);
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
