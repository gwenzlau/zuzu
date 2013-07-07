//
//  Post.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/MapKit.h>


@interface Post : NSObject <MKAnnotation> {
    @private
    NSString *_content;
    NSDate *_timestamp;
    
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
}

@property (nonatomic, strong) NSString *content;
@property (strong, nonatomic, readonly) NSDate *timestamp;
@property (strong, nonatomic, readonly) CLLocation *location;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)postsNearLocation:(CLLocation *)location
                    block:(void (^)(NSArray *posts, NSError *error))block;
+ (void)savePostAtLocation:(CLLocation *)location
                     block:(void (^)(Post *post, NSError *error))block;
@end
