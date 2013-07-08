//
//  IndexViewController.h
//  Zuzu
//
//  Created by Grant Wenzlau on 7/2/13.
//  Copyright (c) 2013 marko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SSPullToRefresh.h"

@interface IndexViewController : UITableViewController <UITableViewDelegate, CLLocationManagerDelegate, SSPullToRefreshViewDelegate> {
@private
    CLLocationManager *_locationManager;
    UIActivityIndicatorView *_activityIndicatorView;
}
@property NSManagedObjectContext *managedObjectContext;

@end
