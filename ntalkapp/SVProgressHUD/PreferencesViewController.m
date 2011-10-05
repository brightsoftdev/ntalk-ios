//
//  PreferencesViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 02/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "PreferencesViewController.h"

@implementation PreferencesViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Preferencias";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enviar Alerta" style:UIBarButtonItemStyleBordered target:self action:@selector(didPushBackButtonItem:)];
    }
    return self;
}

- (void) dealloc 
{
    [data dealloc];
    [super dealloc];
}

- (void) setupCellData 
{
    NSArray *rows;
    NSDictionary *d;
	
	[data release];
	
	NSMutableArray *tmp = [NSMutableArray array];
	
	rows = [NSArray arrayWithObjects:@"Contactos", nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Contactos",@"title",nil];
	[tmp addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Contraseña", nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Seguridad",@"title",nil];
	[tmp addObject:d];
	
    data = [[NSArray alloc] initWithArray:tmp];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCellData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didPushBackButtonItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[data objectAtIndex:section] objectForKey:@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[[data objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row]; 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc;
    int s = indexPath.section;
    int r = indexPath.row;
    
    if (0 == s) {
        if (0 == r) {
            vc = [[ContactsViewController alloc] init];
        }
    } else if (1 == s) {
        if (0 == r) {
            vc = [[UIViewController alloc] init];
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
