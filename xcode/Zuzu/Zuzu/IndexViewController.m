//
//  IndexViewController.m
//  Zuzu
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.

#import "IndexViewController.h"
#import "Post.h"
#import "AFJSONRequestOperation.h"

static CLLocationDistance const kMapRegionSpanDistance = 5000;

@interface IndexViewController () <CLLocationManagerDelegate>
@property (strong) CLLocationManager *locationManager;
@property (strong) NSMutableArray *posts;
//@property (strong, nonatomic, readwrite) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation IndexViewController
//@synthesize posts = _posts;
//@synthesize tableView = _tableView;
//@synthesize locationManager = _locationManager;
//@synthesize activityIndicatorView = _activityIndicatorView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Marko", nil);
    self.navigationItem.rightBarButtonItem = [self addPostButton];
    self.navigationItem.leftBarButtonItem = [self addPhotoButton];
    
//    NSURL *url = [NSURL URLWithString:@"sleepy-mountain-9630.herokuapp.com/posts.json"];
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        for (NSDictionary *dictionary in [JSON valueForKeyPath:@"posts"]) {
//            Post *post = [[Post alloc] initWithDictionary:dictionary];
//            [self.tableView insertRowsAtIndexPaths:post withRowAnimation:YES];
//        }
//    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"Error: %@", error);
//    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [self.locationManager startUpdatingLocation];
    
}
- (void)viewDidUnload {[super viewDidUnload];}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)addPostButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                         target:self
                                                         action:@selector(addPost:)];
}
- (UIBarButtonItem *)addPhotoButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                         target:self
                                                         action:@selector(addPhoto:)];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    if (location) {
        [Post savePostAtLocation:location withContent:@"Hello!" block:^(Post *post, NSError *error) {
            NSLog(@"Block: %@", post);
        }];
        
        [Post postsNearLocation:location
                          block:^(NSArray *posts, NSError *error) {
            self.posts = posts;
            [self.tableView reloadData];
            NSLog(@"Recieved %d posts", posts.count);
        }];
        
        [manager stopUpdatingLocation];
    } else {
//         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nearby Posts Failed", nil)
//                    message:[error localizedFailureReason]
//                    delegate:nil
//                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                    otherButtonTitles:nil, nil] show];
        NSLog(@"Couldn't Find Location, Nearby posts failed.");
    }
}

//- (void)locationManager: (CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    [self.activityIndicatorView startAnimating];
//    [Post postsNearLocation:newLocation block:^(NSArray *posts, NSError *error) {
//        [self.activityIndicatorView stopAnimating];
//        if (posts) {
//            NSLog(@"Recieved %d posts", posts.count);
//            self.posts = [NSMutableArray arrayWithArray:posts];
//            [self.tableView reloadData];
//            [self.tableView setNeedsLayout];
//            [self.tableView insertRowsAtIndexPaths:posts withRowAnimation:YES];
//            
//        } else {
//          [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nearby Posts Failed", nil)
//                                      message:[error localizedFailureReason]
//                                     delegate:nil
//                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                            otherButtonTitles:nil, nil] show];
//        }
//    }];
//
//    
//}

- (void)addPost:(id)sender {
    UIStoryboard *addPostStoryBoard = [UIStoryboard storyboardWithName:@"AddPostStoryboard"
                                                                bundle:nil];
    id vc = [addPostStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addPhoto:(id)sender {
    UIStoryboard *addPhotoStoryBoard = [UIStoryboard storyboardWithName:@"AddPhotoStoryboard"
                                                                bundle:nil];
    id vc = [addPhotoStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

//
//- (void)postCreated:(NSNotification *)notification {
//    [self.posts insertObject:notification.object atIndex:0];
//}

//-(void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - Pull to refresh

//- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
//    return YES;
//}
//
//- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.posts objectAtIndex:indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = post.content;
}


#pragma mark - TableViewDelegate

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:indexPath.row];
    return MAX([post.content sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(280.0f, CGFLOAT_MAX)].height, tableView.rowHeight);
}


@end
