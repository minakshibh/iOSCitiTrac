//
//  DashboardViewController.h
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController
{
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UIButton *checkOutBtn;
}
- (IBAction)checkOutBttn:(id)sender;
- (IBAction)aboutUsBTTn:(id)sender;
- (IBAction)settingBttn:(id)sender;
- (IBAction)viewOrderBttn:(id)sender;
- (IBAction)patrolBttn:(id)sender;
- (IBAction)scheduleBttn:(id)sender;
- (IBAction)logsBttn:(id)sender;

@end
