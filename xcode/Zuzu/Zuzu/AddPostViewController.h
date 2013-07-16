//
//  AddPostViewController.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "Post.h"
//#import "IndexViewController.h"

@interface AddPostViewController : UITableViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic, readonly) CLLocation *location;
//+ (void)savePostAtLocation:(CLLocation *)location
//                     block:(void (^)(Post *post, NSError *error))block;


@end
