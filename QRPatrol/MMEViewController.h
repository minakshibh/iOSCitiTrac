//
//  MMEViewController.h
//  QRPatrol
//
//  Created by Br@R on 26/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMapsM4B/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "Base64.h"
#import "ScheduleList.h"
#import "AFHTTPRequestOperationManager.h"
@interface MMEViewController : UIViewController<MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate>

{
    NSData* imagedata,*videoData;
    CGPoint svos;
    NSString *patrolIdStr,*officerIdStr,*shiftIdStr,*checkpointStr;
    NSString *_postData ;
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    NSMutableArray *checkPointArray;
    NSArray *docPaths;
    IBOutlet UIImageView *MmeImageView;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*evntName;
    IBOutlet UITextField *enterDescriptionTxt;
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UIScrollView *addVehicleScroller;
    IBOutlet UITableView *assignedCheckpointsTableView;
    ScheduleList *scheduledOC;
    IBOutlet UIView *assignedCheckPointsView;
    IBOutlet UILabel *videoPathLbl;
}

- (IBAction)backBttn:(id)sender;
@property(nonatomic, strong) CLLocationManager *locationManager;
- (IBAction)ClickPicBttn:(id)sender;
- (IBAction)recordVideoBttn:(id)sender;
- (IBAction)assignCheckPointBtn:(id)sender;

- (IBAction)sendMmeBttn:(id)sender;


@end
