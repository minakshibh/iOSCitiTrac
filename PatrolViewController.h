//
//  PatrolViewController.h
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
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
#import "ZBarSDK.h"
#import "ScheduleList.h"
#import "GetDetailCommonView.h"

@interface PatrolViewController : UIViewController<MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate,ZBarReaderDelegate,ZBarReaderViewDelegate>
{
    
    NSString *patrolIdStr,*officerIdStr,*shiftIdStr;
    NSString *_postData ;
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    ScheduleList *scheduledOC;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*evntName;
    BOOL isStarted;
    NSMutableArray *checkPointArray;
    GMSMapView *mapView;
    GMSMarker*marker;
    IBOutlet UILabel *eventLbl;
    IBOutlet UIButton *scanQrCode;
    IBOutlet UIButton *MMEbtn;
    IBOutlet UIButton *testBtn;
    IBOutlet UIButton *sosBttn;
    IBOutlet UIButton *incedentBtn;
    IBOutlet UIButton *tourBtn;
    double current_latitude;
    double current_longitude;
    IBOutlet UIView *assignedCheckPointsView;
    IBOutlet UITableView *assignedCheckpointsTableView;
    GetDetailCommonView *refresh;
}
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString*checkpointStr;
-(void)remainingQRUpdate:(NSMutableArray*)arr;
- (IBAction)scanQRCode:(id)sender;
- (IBAction)mmeBtn:(id)sender;
- (IBAction)sosBtn:(id)sender;
- (IBAction)tourBtn:(id)sender;
- (IBAction)incidentBtn:(id)sender;
- (IBAction)testBtn:(id)sender;
- (IBAction)eventBtn:(id)sender;
- (IBAction)homeBtn:(id)sender;
- (IBAction)locateBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
@end
