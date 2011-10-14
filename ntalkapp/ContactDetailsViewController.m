//
//  ContactDetailsViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 05/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "ContactDetailsViewController.h"

@implementation ContactDetailsViewController

@synthesize nameTextField, emailTextField, deleteButton;
@synthesize contact;

static NSString *contactUrl  = @"/api/v1/contacts/%@.json";
static NSString *contactsUrl = @"/api/v1/contacts.json";

- (void)dealloc {
    [contact release];
    [nameTextField release];
    [emailTextField release];
    [deleteButton release];
    [super dealloc];
}

- (id)initWithContact:(NSDictionary *)_contact {
    if (self = [super init]) {
        self.contact = _contact;
        if ([self.contact valueForKey:@"id"] == nil) {
            isNewContact = YES;
        }
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [contact valueForKey:@"name"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didTouchSaveButton:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    nameTextField.text = [contact valueForKey:@"name"];
    emailTextField.text = [contact valueForKey:@"email"];
    DebugLog(@"id %@", [contact objectForKey:@"id"]);
    
    if (isNewContact) {
        deleteButton.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - Actions

- (void)didTouchDeleteButton:(id)sender {
    NSString *url = [NSString stringWithFormat:contactUrl, [contact valueForKey:@"id"]];
    ASIHTTPRequest *request = [self requestWithURL:url tokenIncluded:YES];
    [request setRequestMethod:@"DELETE"];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

- (void)didTouchSaveButton:(id)sender {
    ASIFormDataRequest *request;
    NSString *url;
    if (isNewContact) {
        url = contactsUrl;
    } else {
        url = [NSString stringWithFormat:contactUrl, [contact valueForKey:@"id"]];
        DebugLog(@"id %@", [contact objectForKey:@"id"]);
    }
    request = [self formRequestWithURL:url tokenIncluded:YES];
    request.requestMethod = (isNewContact) ? @"POST" : @"PUT";

    [request setPostValue:nameTextField.text forKey:@"contact[name]"];
    [request setPostValue:emailTextField.text forKey:@"contact[email]"];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    
    DebugLog(@"enviando request a %@ metodo %@", request.url, request.requestMethod);
    [request startAsynchronous];
}

-(void)didChangeTextFieldValue:(id)sender 
{
    if (! isNewContact) return;
    if (![sender isKindOfClass:[UITextField class]]) return;
    
    if (! [emailTextField.text isEqualToString:@""]  && 
        ! [nameTextField.text isEqualToString:@""] && 
        self.navigationItem.rightBarButtonItem.enabled == NO) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } else if (([emailTextField.text isEqualToString:@""] || 
                [nameTextField.text  isEqualToString:@""]) &&
               self.navigationItem.rightBarButtonItem.enabled == YES) {
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void) requestFinished:(ASIHTTPRequest *) request
{
    [self clearFinishedRequests];

    if (isNewContact && request.responseStatusCode == 422) {
//        NSDictionary *error = [[request responseString] objectFromJSONString];
        [SVProgressHUD dismissWithError:@"Contacto incorrecto"];
    } else {
        [SVProgressHUD dismiss];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) requestFailed:(ASIHTTPRequest *) request
{
    [SVProgressHUD dismissWithError:[request.error localizedDescription]];
    if ([request.error code] == 404) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
     

@end
