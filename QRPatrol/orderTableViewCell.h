//
//  orderTableViewCell.h
//  QRPatrol
//
//  Created by Krishna_Mac_1 on 6/12/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderTableViewCell : UITableViewCell{
    
    IBOutlet UILabel *orderDescpLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *checkpointLbl;
}
-(void)setLabelText:(NSString*)orderDescription :(NSString*)date : (NSString*) checkpoint;
@end
