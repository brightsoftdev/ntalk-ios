//
//  PreferencesViewController.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 02/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()
- (void) switchChanged:(id)sender;
@end

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
	
	rows = [NSArray arrayWithObjects:@"Usar contraseña", @"Cambiar contraseña", nil];
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
    UITableViewCell* cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        if( cell == nil ) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SwitchCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [switchView release];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.textLabel.text = [[[data objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row]; 
    
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
            vc = [[UIViewController alloc] init];
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

@end
