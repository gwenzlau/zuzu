//
//  RegisterViewController.m
//  Zuzu
//
//  Created by Grant Wenzlau on 7/12/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZuzuAPIClient.h"
#import "IndexViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Sign Up", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                                   self.signature.text,
                                                                                   self.email.text,
                                                                                   self.password.text,
                                                                                   self.confirmPassword.text,
                                                                                   nil]
                                                       forKeys:[NSArray arrayWithObjects:
                                                                @"signature",
                                                                @"email",
                                                                @"password",
                                                                @"password_confirmation",
                                                                nil]];
    [[AFHTTPClient sharedClient] post:@"/users.json" params:params delegate:self];
}
@end
