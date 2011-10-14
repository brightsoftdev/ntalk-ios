//
//  LoginViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 04/09/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize tableView = _tableView, loadCell = _loadCell;
@synthesize emailValue, passwordValue;
static NSString *loginUrl = @"/users/sign_in.json";

- (void)dealloc {
    [_tableView release];
//    [_loadCell release];
    [emailValue release];
    [passwordValue release];
    [super dealloc];
}

//TODO WTF figure out this
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (int i = 0; i < 2; i++) {
        TextEditCell *cell = (TextEditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.textField isFirstResponder]) {
            [cell.textField resignFirstResponder];
            break;
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TextEditCell";
    TextEditCell *cell = (TextEditCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TextEditCell" owner:self options:nil];
        cell = self.loadCell;
        self.loadCell = nil;
    }
    
    //TODO refactorizar esto en el inicializador de TextEditCell
    if (indexPath.row == 0) {
        cell.textField.placeholder = @"Email";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.returnKeyType = UIReturnKeyNext;
    } else if (indexPath.row == 1) {
        cell.textField.placeholder = @"Contraseña";
        cell.textField.returnKeyType = UIReturnKeyGo;
        cell.textField.secureTextEntry = YES;
    }
    
    cell.textField.tag = indexPath.row;
    cell.textField.delegate = self;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.textField.enablesReturnKeyAutomatically = YES;
    
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        emailValue = textField.text;
    } else if (textField.tag == 1) {
        passwordValue = textField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    if (textField.tag == 0) {
        TextEditCell *cell = (TextEditCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textField becomeFirstResponder];
        
        emailValue = textField.text;
    } else if (textField.tag == 1) {
        passwordValue = textField.text;
        [self grabTokenInBackgroundWithEmail:emailValue andPassword:passwordValue];        
    }
    
    return NO;
}

#pragma mark - POST
-(void)grabTokenInBackgroundWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [SVProgressHUD showInView:self.view];
    
    ASIFormDataRequest *request = [self formRequestWithURL:loginUrl];
    [request setPostValue:email forKey:@"user[email]"];
    [request setPostValue:password forKey:@"user[password]"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

-(void) requestFinished:(ASIHTTPRequest *) request 
{
    [SVProgressHUD dismissWithSuccess:@"Gracias"];
    if ([request responseStatusCode] == 201) {
        NSDictionary *response = [[request responseString] objectFromJSONString];
        [self clearFinishedRequests];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didGetAuthToken" object:nil userInfo:response];
    }
}

-(void) requestFailed:(ASIHTTPRequest *) request
{
    [SVProgressHUD dismissWithError:[[request error] localizedDescription]];
}

@end
