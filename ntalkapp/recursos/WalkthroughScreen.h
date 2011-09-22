//
//  WalkthroughScreen.h
//  ScrollViewTest
//
//  Created by Jeduan Cornejo Legorreta on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkthroughScreen : UIViewController {
    int pageNumber;
}

-(id)initWithPageNumber:(int)page;

@end
