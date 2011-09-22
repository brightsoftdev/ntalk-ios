//
//  WalktroughViewController.h
//  ScrollViewTest
//
//  Created by Jeduan Cornejo Legorreta on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkthroughScreen.h"
#import "LoginViewController.h"

@interface WalktroughViewController : UIViewController <UIScrollViewDelegate> {
    BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet NSMutableArray *viewControllers;

- (void) loadScrollViewWithPage:(int)page;
- (IBAction)changePage:(id)sender;
@end
