//
//  ProgressView.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (id)presentInWindow:(UIWindow *)window;

- (void)dismiss;
- (void)setProgress:(CGFloat)progress;

@end
