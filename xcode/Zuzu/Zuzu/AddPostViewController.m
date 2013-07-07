//
//  AddPostViewController.m
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import "AddPostViewController.h"
#import "Post.h"
#import "ZuzuAPIClient.h"

@interface AddPostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *postTextField;
@property (assign, nonatomic, readwrite) CLLocationDegrees latitude;
@property (assign, nonatomic, readwrite) CLLocationDegrees longitude;

@end

@implementation AddPostViewController

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize postTextField = _postTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self saveButton];
  //  self.navigationItem.leftBarButtonItem = [self onCancel];
    
}

- (CLLocation *)location {
    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
}

-(UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePostAtLocation:block:)];
}

-(UIBarButtonItem *)onCancel {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
}

-(void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
