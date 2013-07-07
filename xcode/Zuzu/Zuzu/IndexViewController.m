//
//  IndexViewController.m
//  Zuzu
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.

#import "IndexViewController.h"
#import "Post.h"
#import "AFJSONRequestOperation.h"

static CLLocationDistance const kMapRegionSpanDistance = 5000;

@interface IndexViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic, readwrite) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *posts;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation IndexViewController
@synthesize posts = _posts;
@synthesize tableView = _tableView;
@synthesize locationManager = _locationManager;
@synthesize activityIndicatorView = _activityIndicatorView;

- (void)loadView {
    [super loadView];

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped = YES;
}

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

- (void)locationManager: (CLLocationManager *)manager
didUpdateLocations:(CLLocation *)newLocation
     fromLocation:(CLLocation *)oldLocation
{
    [self.activityIndicatorView startAnimating];
    [Post postsNearLocation:newLocation block:^(NSArray *posts, NSError *error) {
     [self.activityIndicatorView stopAnimating];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nearby Posts Failed", nil) message:[error localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        } else {
            [self.tableView insertRowsAtIndexPaths:posts withRowAnimation:YES];
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
