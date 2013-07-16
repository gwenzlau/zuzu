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
#import "AFJSONRequestOperation.h"


@interface AddPostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *postTextField;
@property (strong, nonatomic, readwrite) NSDate *timestamp;
@property (assign, nonatomic, readwrite) CLLocationDegrees latitude;
@property (assign, nonatomic, readwrite) CLLocationDegrees longitude;

@end

@implementation AddPostViewController

@synthesize timestamp = _timestamp;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize postTextField = _postTextField;
@dynamic location;


static NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    return [ NSString stringWithFormat:@"(%f, %f)", coordinate.latitude, coordinate.longitude];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self saveButton];
  //  self.navigationItem.leftBarButtonItem = [self onCancel];
    
}

//-(id)initWithDictionary:(NSDictionary *)dictionary {
//    self = [super init];
//    if (!self) {
//        return nil;
//    }
//    self.latitude = [[dictionary valueForKeyPath:@"lat"] doubleValue];
//    self.longitude = [[dictionary valueForKeyPath:@"lng"] doubleValue];
//    
//    return self;
//}

//- (CLLocation *)location {
//    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
//}

-(UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePostAtLocation:withContent:block:)];
}

- (void)savePostAtLocation:(CLLocation *)location
               withContent:(NSString *)content
                     block:(void (^)(Post *, NSError *))block
{
    NSDictionary *parameters = @{ @"post": @{
                                          @"lat": @(location.coordinate.latitude),
                                          @"lng": @(location.coordinate.longitude),
                                          @"content": content
                                          }
                                  };
    NSMutableURLRequest *mutableURLRequest = [[ZuzuAPIClient sharedClient] requestWithMethod:@"POST" path:@"/posts" parameters:parameters];
    AFHTTPRequestOperation *operation = [[ZuzuAPIClient sharedClient] HTTPRequestOperationWithRequest:mutableURLRequest
                                                                            success:^(AFHTTPRequestOperation *operation, id JSON) {
        Post *post = [[Post alloc] initWithDictionary:[JSON valueForKeyPath:@"post"]];
        if (block) {
            block(post, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

//- (void)onSave: (id)sender  {
//    Post *post = [[Post alloc] init];
//    post.content = self.postTextField.text;
//    [self.view endEditing:YES];
//    
//    
////        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
////        [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"lat"];
////        [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"lng"];
////       change params back to mutableParams when you figure out above... 
//        NSMutableURLRequest *mutableURLRequest = [[ZuzuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"/posts" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        }];
//        AFHTTPRequestOperation *operation = [[ZuzuAPIClient sharedClient] HTTPRequestOperationWithRequest:mutableURLRequest success:^(AFHTTPRequestOperation *operation, id JSON) {
//            Post *post = [[Post alloc] initWithDictionary:[JSON valueForKeyPath:@"post[post]"]];
//            if (post) {
//                [self.navigationController popViewControllerAnimated:YES];
//                NSLog(@"Success!");
//            }
//        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if  
//                (nil, error) {
//                    NSLog(@"Error: %@", error);
//                }
//        }];
//        [[ZuzuAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
//    }



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
