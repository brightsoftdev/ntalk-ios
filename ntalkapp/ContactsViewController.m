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

static NSString *contactsUrl = @"http://ntalk.dev/api/v1/contacts.json";

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
    [addButtonItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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

@end
