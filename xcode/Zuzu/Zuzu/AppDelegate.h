//
//  AppDelegate.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NewRelicAgent/NewRelicAgent.h>

@class LoginViewController;

//@interface AppDelegate : UIResponder <UIApplicationDelegate>
//
//@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) LoginViewController *viewController;
//
//@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@end

