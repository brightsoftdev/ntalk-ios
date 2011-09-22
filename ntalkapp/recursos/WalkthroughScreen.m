//
//  WalkthroughScreen.m
//  ScrollViewTest
//
//  Created by Jeduan Cornejo Legorreta on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WalkthroughScreen.h"

@implementation WalkthroughScreen

-(id)initWithPageNumber:(int)page 
{
    NSString* nib = [NSString stringWithFormat:@"WalkthroughScreen%d", page+1];
    self = [super initWithNibName:nib bundle:nil];
    if (self) {
        pageNumber = page;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
