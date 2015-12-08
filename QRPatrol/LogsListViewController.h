//
//  LogsListViewController.h
//  QRPatrol
//
//  Created by Br@R on 22/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogsListViewController : UIViewController
{
    NSMutableArray*logListArray;

    IBOutlet UITableView *logsTableView;
}
- (IBAction)addLogsbttn:(id)sender;
- (IBAction)BackBttn:(id)sender;
@end
