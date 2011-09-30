//
//  RootViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
static NSString *panicUrl = @"http://ntalk.dev/api/v1/panics.json?auth_token=%@";

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Preferencias" style:UIBarButtonItemStylePlain target:self action:@selector(showPreferences)];
    self.navigationItem.leftBarButtonItem = b;
    [b release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(void)showPreferences
{
    NSLog(@"show preferences");
}

- (void)didTouchPanicButton:(id)sender
{
    [SVProgressHUD showInView:self.view];
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"];
    NSString *url = [NSString stringWithFormat:panicUrl, token];
    
    ASIFormDataRequest *request = [self formRequestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
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
