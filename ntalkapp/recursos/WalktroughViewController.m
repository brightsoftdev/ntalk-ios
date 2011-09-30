//
//  WalktroughViewController.m
//  ScrollViewTest
//
//  Created by Jeduan Cornejo Legorreta on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WalktroughViewController.h"

@implementation WalktroughViewController
@synthesize scrollView = _scrollView, pageControl = _pageControl;
static NSUInteger kNumberOfPages = 4;

-(void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    _viewControllers = nil;
    [_viewControllers release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewControllers = [[NSMutableArray alloc] initWithCapacity:kNumberOfPages];
    for (int i = 0; i < kNumberOfPages; i++) {
        [_viewControllers addObject:[NSNull null]];
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * kNumberOfPages, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.numberOfPages = kNumberOfPages;
    _pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
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

#pragma mark - UIScrollViewDelegate 

-(void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    UIViewController* controller = [_viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        if (0 == page || 1 == page || 2 == page) {            
            controller = [[WalkthroughScreen alloc] initWithPageNumber:page];
        } else if (3 == page) {
            controller = [[LoginViewController alloc] init];
        }
        [_viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
        
    }
    
    if (nil == controller.view.superview) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [_scrollView addSubview:controller.view];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth /2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

-(void)changePage:(id)sender 
{
    int page = _pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

@end
