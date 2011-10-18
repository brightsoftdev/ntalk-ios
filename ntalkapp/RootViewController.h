//
//  RootViewController.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ntalkappAppDelegate.h"
#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "CoreLocationSimulator.h"
#import "SlideToCancelViewController.h"

@interface RootViewController : BaseViewController <CLLocationManagerDelegate, SlideToAlertDelegate> {
    double lat;
    double lng;
    SlideToCancelViewController* slideToCancel;
}

@property (nonatomic, retain) CLLocationManager *locman;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

- (void)alerted;

@end
