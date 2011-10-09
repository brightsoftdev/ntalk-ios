//
//  RootViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize panicButton, locman;
static NSString *panicUrl = @"http://ntalk.dev/api/v1/panics.json?auth_token=%@";

- (void)dealloc
{ 
    [panicButton release];
    [locman release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showInView:self.view status:@"localizando"];
    [panicButton setEnabled:NO];
    
    BOOL ok = [CLLocationManager locationServicesEnabled];
    if (!ok) {
        [SVProgressHUD dismissWithError:@"Oh, well"];
        [panicButton setEnabled:YES];
    }
    
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    self.locman = lm;
    [lm release];
    self.locman.delegate = self;
    [self.locman startUpdatingLocation];
}

#pragma mark - CoreLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    [SVProgressHUD dismissWithSuccess:@"Localizado"];
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    DebugLog(@"location: %d, %d", lat, lng);
}

#pragma mark - Panic HTTP

- (void)didTouchPanicButton:(id)sender
{
    [SVProgressHUD showInView:self.view];

    ASIFormDataRequest *request = [self formRequestWithURL:panicUrl tokenIncluded:YES];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    if (lat != 0.0) {
        NSNumber *nslat = [[NSNumber alloc] initWithDouble:lat];
        [request addPostValue:nslat forKey:@"panic[lat]"];
        [nslat release];
    }
    if (lng != 0.0) {
        NSNumber *nslng = [[NSNumber alloc] initWithDouble:lng];
        [request addPostValue:nslng forKey:@"panic[lng]"];
        [nslng release];
    }
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

-(void) requestFinished:(ASIHTTPRequest *) request 
{
    [SVProgressHUD dismissWithSuccess:@"Enviado"];
    [self clearFinishedRequests];
}

-(void) requestFailed:(ASIHTTPRequest *) request
{
    [SVProgressHUD dismissWithError:[[request error] localizedDescription]];
    //TODO phone hack
}
@end
