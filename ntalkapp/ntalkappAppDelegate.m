//
//  ntalkappAppDelegate.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ntalkappAppDelegate.h"
#import "WalktroughViewController.h"

@implementation ntalkappAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    id token = [[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"];
    if (token == nil) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetAuthenticationToken:) name:@"didGetAuthToken" object:nil];
        WalktroughViewController* wvc = [[WalktroughViewController alloc] init];
        [self.window.rootViewController presentModalViewController:wvc animated:YES];
        
        [wvc release];
    } else {
        //TODO necesitamos algo? Aqui se supone que ya hay un token valido
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)didGetAuthenticationToken: (NSNotification*) n {
    //TODO enviar info via asihttprequest    
    NSLog(@"userinfo %@ %@", [n.userInfo objectForKey:@"email"], [n.userInfo objectForKey:@"password"]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didGetAuthToken" object:nil];
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
