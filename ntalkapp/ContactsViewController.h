//
//  ContactsViewController.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 02/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "AsyncCell.h"

@interface ContactsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

- (IBAction)didTouchAddContactButton:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *contacts;
@end
