//
//  OrderDetailViewController.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Orders.h"
#import "Logs.h"
@interface OrderDetailViewController : UIViewController
{
    IBOutlet UILabel *orderIDLbl;
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UILabel *instructionLbl;
    IBOutlet UILabel *checkpointLbl;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*evntName, *officerIdStr, *shiftIdStr, *checkpointStr;
    IBOutlet UIButton *viewCheckpointBtn;
    IBOutlet UIButton *markAsCheckedBtn;
    NSMutableArray *orderListArray;
    NSString *checkPointName;
     NSMutableData *webData;
    IBOutlet UILabel *instructionTitle;
    IBOutlet UILabel *notesTitlelbl;
    IBOutlet UILabel *notesLbl;
    IBOutlet UILabel *passedByTitle;
    IBOutlet UILabel *passedByLbl;
    IBOutlet UILabel *notesLineLbl;
    IBOutlet UILabel *passedByLblLine;
    IBOutlet UIButton *contactOfficerBtn;
    IBOutlet UILabel *orderDetailTitleLbl;
  
}
- (IBAction)backBttn:(id)sender;
- (IBAction)viewCheckPointBtnAction:(id)sender;
- (IBAction)markAsCheckedBtnAction:(id)sender;
- (IBAction)contactOfficerBtnAction:(id)sender;
@property (strong, nonatomic) Orders *orderOC;
@property (strong, nonatomic) Logs *logsOC;
@property (strong, nonatomic) NSString *viewType;
@end
