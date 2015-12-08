//
//  ScheduleViewController.h
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMapsM4B/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ScheduleList.h"


@interface ScheduleViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    ScheduleList*scheduleListObj;
    GMSMapView *mapView;
    GMSMarker*marker;
    
    NSMutableArray*scheduleListArray;
    
    IBOutlet UITableView *scheduleTableView;
    IBOutlet UIButton *mapBtn;
    IBOutlet UIButton *listBtn;
    
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UIView *checkedCheckPointView;
    IBOutlet UITableView *checkedCheckpointTableView;
}
- (IBAction)scannedCheckpointBtnAction:(id)sender;
- (IBAction)listBttn:(id)sender;
- (IBAction)mapBttn:(id)sender;
@property(nonatomic, strong) CLLocationManager *locationManager;

- (IBAction)checkedCheckPointBackBtnAction:(id)sender;

- (IBAction)backBttn:(id)sender;
@end
