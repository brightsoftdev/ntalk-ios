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
#import "PreferencesViewController.h"

@interface RootViewController : BaseViewController <CLLocationManagerDelegate> {
    double lat;
    double lng;
}

@property (nonatomic, retain) IBOutlet UIButton *panicButton;
@property (nonatomic, retain) CLLocationManager *locman;

- (void) showPreferences;
- (IBAction)didTouchPanicButton:(id)sender;

@end
