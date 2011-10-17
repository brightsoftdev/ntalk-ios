//
//  PreferencesViewController.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 02/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVPasscodeViewController.h"

#define NONE 0
#define TURNING_ON 1
#define TURNING_OFF 2
#define CONFIRMING 3

@interface PreferencesViewController : UIViewController <KVPasscodeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *data;
    BOOL usesPassword;
    int mode;
    NSString *tempPassword;
}

@property (nonatomic, retain) UISwitch *switchView;
@property (nonatomic, retain) IBOutlet UITableView *table;

- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode;
- (void) didCancelPasscode:(id) sender;

@end
