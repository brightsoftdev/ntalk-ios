//
//  LoginViewController.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 04/09/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "TextEditCell.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet TextEditCell *loadCell;
@property (nonatomic, retain) NSString* emailValue;
@property (nonatomic, retain) NSString* passwordValue;

- (NSDictionary*) grabTokenInBackgroundWithEmail:(NSString *)email andPassword:(NSString*)password;

@end

