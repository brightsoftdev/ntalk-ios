//
//  TextEditCell.m
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 04/09/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#import "TextEditCell.h"

@implementation TextEditCell
@synthesize textField = _textField;

-(void)dealloc {
    [_textField release];
    [super dealloc];
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //override point
    }
    return self;
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
