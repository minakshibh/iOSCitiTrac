//
//  AddLogsViewController.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "ScheduleList.h"
@interface AddLogsViewController : UIViewController

{
    
    NSString *patrolIdStr,*officerIdStr,*shiftIdStr,*checkpointStr;
    ScheduleList *scheduledOC;
    IBOutlet UILabel *assignedCheckPointLbl;
    IBOutlet UITextField *enterDectxt;
    IBOutlet UITextField *enterNotestxt;
    IBOutlet UITextField *enterObsrvatioTxt;
    
    IBOutlet UILabel *enterDecLbl;
    IBOutlet UILabel *enterNotesLbl;
    IBOutlet UILabel *enterObsrvatioLbl;
    NSString *_postData ;
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray *checkPointArray;
    IBOutlet UIView *checkedCheckPointView;
    IBOutlet UITableView *checkedCheckpointTableView;

}
- (IBAction)assignCheckpointBttn:(id)sender;
- (IBAction)passLogBttn:(id)sender;
- (IBAction)backBttn:(id)sender;


@end
