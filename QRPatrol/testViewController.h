//
//  testViewController.h
//  QRPatrol
//
//  Created by Krishna_Mac_1 on 6/15/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "testOC.h"
@interface testViewController : UIViewController<CLLocationManagerDelegate>
{
    NSMutableData *webData;
    IBOutlet UILabel *testNameLbl;
    testOC *testObj;
    NSMutableArray *testListArray;
    IBOutlet UITableView *testTableView;
    NSString *officerIdStr,*patrolIdStr,*shiftIdStr,*evntName,*_postData;
    int webservice;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    double current_latitude;
    double current_longitude;
}
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *checkPointName, *checkPointId;
- (IBAction)submitBtnAction:(id)sender;
- (IBAction)endTestBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@end
