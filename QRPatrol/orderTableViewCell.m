//
//  orderTableViewCell.m
//  QRPatrol
//
//  Created by Krishna_Mac_1 on 6/12/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "orderTableViewCell.h"

@implementation orderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)orderDescription :(NSString*)date : (NSString*) checkpoint
{
    orderDescpLbl.text = [NSString stringWithFormat:@"%@",orderDescription];
    dateLbl.text = [NSString stringWithFormat:@"%@",date];
    NSString *checkPointStr = [NSString stringWithFormat:@"%@",checkpoint];
    if ([checkPointStr isEqualToString:@"(null)"]) {
        checkPointStr = @"";
    }
    checkpointLbl.text =[NSString stringWithFormat:@"%@",checkPointStr];
}
@end
