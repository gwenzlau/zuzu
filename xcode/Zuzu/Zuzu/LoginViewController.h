//
//  LoginViewController.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/10/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface LoginViewController : UIViewController {
    NSString *access_token;
    
    //buttons
    IBOutlet UIButton *getAccessTokenButton;
    
    //textFields
    IBOutlet UITextField *userSignatureField;
    IBOutlet UITextField *userPasswordField;
}
- (IBAction)logUserIn:(id)sender;

//button outlets
@property(retain) IBOutlet UIButton *getAccessTokenButton;


@end
