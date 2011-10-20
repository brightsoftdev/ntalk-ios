//
//  ContactsViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 02/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "ContactsViewController.h"

@implementation ContactsViewController
@synthesize table = _table, contacts = _contacts;

static NSString *contactsUrl = @"/api/v1/contacts.json";
static int maxContacts = 10;

- (void)dealloc
{
    [_table release];
    [_contacts release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Contactos";
 
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTouchAddContactButton:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    self.navigationController.navigationBarHidden = NO;
    [addButtonItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber *usesPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"usesPassword"];
    
    if ([usesPassword boolValue]) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelPasscodeEntry:)];
        KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
        passcodeController.delegate = self;
        passcodeController.navigationItem.rightBarButtonItem = cancelButtonItem;
        UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:passcodeController];
        
        passcodeController.instructionLabel.text = NSLocalizedString(@"Ingresa contraseña para ver contactos", @"");
        [self.navigationController presentModalViewController:passcodeNavigationController animated:YES];
        [passcodeNavigationController release];
        [passcodeController release];
        [cancelButtonItem release];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showInView:self.view];
    
    //TODO decidir si cachear esta peticion
    ASIHTTPRequest* request = [self requestWithURL:contactsUrl tokenIncluded:YES];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AsyncCell *cell = (AsyncCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AsyncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *obj = [_contacts objectAtIndex:indexPath.row];

    [cell updateCellInfo:obj];
    
    return cell;
}

-(void)didTouchAddContactButton:(id)sender
{
    DebugLog(@"agregado contacto");
    if ([_contacts count] < maxContacts) {
        ContactDetailsViewController *detailViewController = [[ContactDetailsViewController alloc] initWithContact:[NSDictionary dictionary]];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"Demasiados Contactos";
        alert.message = @"Haz alcanzado el límite de contactos\nBorra algunos";
        [alert show];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AsyncCell *cell = (AsyncCell *)[self tableView:_table cellForRowAtIndexPath:indexPath];
    
    ContactDetailsViewController *detailViewController = [[ContactDetailsViewController alloc] initWithContact:[cell contact]];

    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

}

#pragma mark - Async HTTP


- (void) requestFinished:(ASIHTTPRequest *)request 
{
    [SVProgressHUD dismiss];
    
    self.contacts = [[request responseString] objectFromJSONString];
    [_table reloadData];
    
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:[[request error] localizedDescription]];
}


#pragma mark - Passcode Delegate
- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode {
    if ([passCode isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"passCode"]]) {
        [controller dismissModalViewControllerAnimated:YES];
    } else {
        controller.instructionLabel.text = NSLocalizedString(@"Contraseña incorrecta", @"");
        [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];
    }
}

-(void)didCancelPasscodeEntry:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 1;
}
@end
