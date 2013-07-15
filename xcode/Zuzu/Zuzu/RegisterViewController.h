//
//  RegisterViewController.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/12/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface RegisterViewController : UIViewController {
    
    IBOutlet UITextField *userSignatureField;
    IBOutlet UITextField *userEmailField;
    IBOutlet UITextField *userPasswordField;
    IBOutlet UITextField *userPasswordConfirmField;
}
- (IBAction)register:(id)sender;

@end
