//
//  ntalkappAppDelegate.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ntalkappAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(void) didGetAuthenticationToken:(NSNotification*) n;

@end
