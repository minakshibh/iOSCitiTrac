//
//  IncedentsViewController.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <GoogleMapsM4B/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ScheduleList.h"

@interface IncedentsViewController : UIViewController<MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    ScheduleList *scheduledOC;
    
    NSString *patrolIdStr,*officerIdStr,*checkpointStr,*shiftIdStr,*evntName ;
    IBOutlet UITableView *assignedCheckPointsTableView;
    
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UITableView *incedentTableView;
    NSMutableArray*incedentsListArray,*checkPointArray;
    NSMutableArray*markArray;
    BOOL isMaintainance;
    BOOL sendByMail;
    
    IBOutlet UIView *priorityCheckBoxbackView;
    IBOutlet UIView *checkBoxesBackView;
    
    IBOutlet UIButton *sendByMailCheckBox;
    IBOutlet UIButton *maintainceCheckBox;
    
    IBOutlet UIButton *HighPriority;
    IBOutlet UIButton *mediumPriority;
    IBOutlet UIButton *lowPriority;
    
    IBOutlet UILabel *assignedCheckPointLbl;
    BOOL isHigh;
    BOOL isLow;
    BOOL isMedium;
    IBOutlet UIView *assignedCheckPointsList;
}

- (IBAction)mediumPriorityBttn:(id)sender;
- (IBAction)lowPriorityBttn:(id)sender;

- (IBAction)highPriorityBttn:(id)sender;

- (IBAction)backBttn:(id)sender;
- (IBAction)reportIncedentBttn:(id)sender;
- (IBAction)assignCheckPointBttn:(id)sender;
- (IBAction)isMaintanceBttn:(id)sender;
- (IBAction)sendByEmailBttn:(id)sender;

@property(nonatomic, strong) CLLocationManager *locationManager;

@end
