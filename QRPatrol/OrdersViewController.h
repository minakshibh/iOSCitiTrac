//
//  OrdersViewController.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Orders.h"
#import "Logs.h"
@interface OrdersViewController : UIViewController
{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*evntName, *officerIdStr, *shiftIdStr, *checkpointStr;
    NSMutableData *webData;
    Orders *orderOC;
    NSMutableArray *ordersListArray;
    IBOutlet UITableView *ordersHistoryTableView;
    int webservicecode;
    NSMutableArray*logListArray;
    Logs *logsOC;
    IBOutlet UILabel *orderTitleLbl;
    IBOutlet UIButton *addLogBtn;
}
@property (strong, nonatomic) NSString *viewType;

- (IBAction)backBttn:(id)sender;
- (IBAction)addLogsbttn:(id)sender;
@end
