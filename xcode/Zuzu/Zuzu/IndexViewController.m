//
//  IndexViewController.m
//  Zuzu
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.

#import "IndexViewController.h"
#import "Post.h"
#import "AFJSONRequestOperation.h"
#import "SSPullToRefresh.h"

static CLLocationDistance const kMapRegionSpanDistance = 5000;

@interface IndexViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic, readwrite) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *posts;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@end

@implementation IndexViewController
@synthesize posts = _posts;
@synthesize tableView = _tableView;
@synthesize locationManager = _locationManager;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize pullToRefreshView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Marko", nil);
    self.navigationItem.rightBarButtonItem = [self addPostButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto:)];
    
    NSURL *url = [NSURL URLWithString:@"sleepy-mountain-9630.herokuapp.com/posts.json"];
    [AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"posts"]) {
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [self.tableView insertRowsAtIndexPaths:post withRowAnimation:YES];
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    [self.locationManager startUpdatingLocation];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    //[self refresh];
    
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
-(void)refresh {
    [self.pullToRefreshView startLoading];
    [self locationManager];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(popTime, backgroundQueue, ^(void){
            [_posts removeAllObjects];
            for (int i = 0; i < 25; i++) {
                [self insertNewPost:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pullToRefreshView finishLoading];
                [self.tableView reloadData];
        });
    });
}

- (void)insertNewPost:(id)sender {
    if (!_posts) {
        _posts = [[NSMutableArray alloc] init];
    }
    [_posts insertObject:[NSDictionary dictionary] atIndex:0];
}


- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

- (void)locationManager: (CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.activityIndicatorView startAnimating];
    [Post postsNearLocation:newLocation block:^(NSArray *posts, NSError *error) {
        [self.activityIndicatorView stopAnimating];
        if (posts) {
            NSLog(@"Recieved %d posts", posts.count);
            self.posts = [NSMutableArray arrayWithArray:posts];
            [self.tableView reloadData];
            [self.tableView setNeedsLayout];
            [self.tableView insertRowsAtIndexPaths:posts withRowAnimation:YES];
            
        } else {
          [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nearby Posts Failed", nil)
                                      message:[error localizedFailureReason]
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                            otherButtonTitles:nil, nil] show];
        }
    }];

    
}

- (void)addPost:(id)sender {
    UIStoryboard *addPostStoryBoard = [UIStoryboard storyboardWithName:@"AddPostStoryboard"
                                                                bundle:nil];
    id vc = [addPostStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postCreated:(NSNotification *)notification {
    [self.posts insertObject:notification.object atIndex:0];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Pull to refresh

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return YES;
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {
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
