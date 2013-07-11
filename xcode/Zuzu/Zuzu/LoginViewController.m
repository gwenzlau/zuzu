//
//  LoginViewController.m
//  Zuzu
//
//  Created by Grant Wenzlau on 7/10/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "LoginViewController.h"
#import "ZuzuAPIClient.h"
#import "IndexViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize getAccessTokenButton;

- (IBAction)logUserIn:(id)sender {
    IndexViewController *viewController = [[IndexViewController alloc] initWithNibName:nil bundle:nil];
    
    if ([userSignatureField.text isEqualToString:@""] && [[ZuzuAPIClient sharedClient] isAuthenticated]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        NSLog(@"== Exchanging username and password for OAuth credentials");
        [[ZuzuAPIClient sharedClient] authenticateUsingOAuthWithUsername:userSignatureField.text password:userPasswordField.text success:^(AFOAuthCredential *credential) {
            NSLog(@"  == Successfully received OAuth credentials %@", credential);
            [self.navigationController pushViewController:viewController animated:YES];
        } failure:^(NSError *error) {
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Marko", nil);
    
    //if presence true all them to submit
    [userSignatureField addTarget:self action:@selector(checkPasswordUsernamePresence:) forControlEvents:UIControlEventEditingChanged];
    [userPasswordField addTarget:self action:@selector(checkPasswordUsernamePresence:) forControlEvents:UIControlEventEditingChanged];
    
    //make login clickable if previously authenticated
    if ( [[ZuzuAPIClient sharedClient] isAuthenticated]) {
        [getAccessTokenButton setEnabled:YES];
        [getAccessTokenButton setHighlighted:YES];
    }
}

//presence true
- (void)checkPasswordUsernamePresence:(id)sender {
    if (![userSignatureField.text isEqualToString:@""] && ![userPasswordField.text isEqualToString:@""]) {
        [getAccessTokenButton setEnabled:YES];
        [getAccessTokenButton setHighlighted:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
