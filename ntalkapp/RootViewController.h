//
//  RootViewController.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SVProgressHUD.h"

@interface RootViewController : BaseViewController {
    double lat;
    double lng;
}


- (void) showPreferences;
- (IBAction)didTouchPanicButton:(id)sender;

@end
