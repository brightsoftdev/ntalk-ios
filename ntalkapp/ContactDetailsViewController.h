//
//  ContactDetailsViewController.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 05/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "BaseViewController.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"

@interface ContactDetailsViewController : BaseViewController {
    BOOL isNewContact;
}

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) NSDictionary *contact;

-(id)initWithContact:(NSDictionary *)contact;
-(IBAction)didTouchSaveButton:(id)sender;
-(IBAction)didTouchDeleteButton:(id)sender;

-(IBAction)didChangeTextFieldValue:(id)sender;

-(void) requestFinished:(ASIHTTPRequest *) request;
-(void) requestFailed:(ASIHTTPRequest *) request;

@end
