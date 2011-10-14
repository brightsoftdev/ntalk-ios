//
//  RootViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize locman;
static NSString *panicUrl = @"/api/v1/panics.json";

- (void)dealloc
{ 
    [locman release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!slideToCancel) {
		// Create the slider
		slideToCancel = [[SlideToCancelViewController alloc] init];
		slideToCancel.delegate = self;
		
		// Position the slider off the bottom of the view, so we can slide it up
		CGRect sliderFrame = slideToCancel.view.frame;
		sliderFrame.origin.y = 100.0f;
		slideToCancel.view.frame = sliderFrame;
		
		// Add slider to the view
		[self.view addSubview:slideToCancel.view];
	}
    
    [SVProgressHUD showInView:self.view status:@"localizando"];
    slideToCancel.enabled = NO;
    
    BOOL ok = [CLLocationManager locationServicesEnabled];
    if (!ok) {
        [SVProgressHUD dismissWithError:@"Oh, well"];
        slideToCancel.enabled = YES;
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
    slideToCancel.enabled = YES;
    DebugLog(@"location: %d, %d", lat, lng);
}

#pragma mark - Panic HTTP

- (void)alerted;
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
