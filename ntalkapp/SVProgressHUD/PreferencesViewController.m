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
@synthesize switchView;
@synthesize table;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Preferencias";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enviar Alerta" style:UIBarButtonItemStyleBordered target:self action:@selector(didPushBackButtonItem:)];
    }
    return self;
}

- (void) dealloc 
{
    [data dealloc];
    [switchView release];
    [super dealloc];
}

- (void) setupCellData 
{
    NSArray *rows;
    NSDictionary *d;
	
	[data release];
	
	NSMutableArray *tmp = [NSMutableArray array];
	
	rows = [NSArray arrayWithObjects:@"Usar contraseña", nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Seguridad",@"title",nil];
	[tmp addObject:d];
    
    NSNumber *uses = (NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:@"usesPassword"];
    usesPassword = ([uses isEqualToNumber:[NSNumber numberWithBool:YES]]);
	
    data = [[NSArray alloc] initWithArray:tmp];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCellData];
    mode = NONE;
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
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            
            [switchView setOn:usesPassword animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
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

    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelPasscode:)];
    KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
    passcodeController.delegate = self;
    passcodeController.navigationItem.rightBarButtonItem = cancelButtonItem;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:passcodeController];
    
    if (switchView.on) {
        mode = TURNING_ON;
        passcodeController.instructionLabel.text = NSLocalizedString(@"Ingresa tu nueva contraseña", @"");
    } else {
        mode = TURNING_OFF;
        passcodeController.instructionLabel.text = NSLocalizedString(@"Ingresa tu contraseña para hacer cambios", @"");
    }
    
    [self.navigationController presentModalViewController:passcodeNavigationController animated:YES];
    [passcodeNavigationController release];
    [passcodeController release];
    [cancelButtonItem release];
}

#pragma mark - PasscodeViewDelegate
- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode {
    switch (mode) {
        case TURNING_ON:
            tempPassword = passCode;
            mode = CONFIRMING;
            controller.instructionLabel.text = NSLocalizedString(@"Por favor confirma tu contraseña", @"");
            [controller resetWithAnimation:KVPasscodeAnimationStyleConfirm];
            [tempPassword retain];
            break;
        case CONFIRMING:
            if ([passCode isEqualToString:tempPassword]) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"usesPassword"];
                [[NSUserDefaults standardUserDefaults] setValue:passCode forKey:@"passCode"];

                [controller dismissModalViewControllerAnimated:YES];
                mode = NONE;
            } else {
                controller.instructionLabel.text = NSLocalizedString(@"Las contraseñas no coinciden", @"");
                [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];
                mode = TURNING_ON;
            }
            tempPassword = nil;
            [tempPassword release];
            break;
        case TURNING_OFF:
            if ([passCode isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"passCode"]]) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNull null] forKey:@"passCode"];
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"usesPassword"];
                [controller dismissModalViewControllerAnimated:YES];
            } else {
                controller.instructionLabel.text = NSLocalizedString(@"Contraseña incorrecta", @"");
                [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];
            }
            break;
        default:
            break;
    }
}

-(void)didCancelPasscode:(id)sender {
    mode = NONE;
    tempPassword = nil;
    switchView.on = !switchView.on;
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
