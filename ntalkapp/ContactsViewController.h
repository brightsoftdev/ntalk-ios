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
#import "ContactDetailsViewController.h"
#import "KVPasscodeViewController.h"

@interface ContactsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, KVPasscodeViewControllerDelegate>

- (IBAction)didTouchAddContactButton:(id)sender;
- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode;
- (void)didCancelPasscodeEntry:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *contacts;
@end
