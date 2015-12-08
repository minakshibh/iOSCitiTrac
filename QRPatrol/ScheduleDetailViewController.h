//
//  ScheduleDetailViewController.h
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleList.h"

#import <QuartzCore/QuartzCore.h>
#import <GoogleMapsM4B/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ScheduleDetailViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    //ScheduleList*scheduleListObj;
    GMSMapView *mapView;
    GMSMarker*marker;
    float lat;
    float lon;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *headrLbl;
    IBOutlet UILabel *preferTimeLbl;
    IBOutlet UILabel *citylbl;
    IBOutlet UITextView *notesLbl;
    IBOutlet UILabel *statelbl;
    IBOutlet UITextView *addressLbl;
    IBOutlet UILabel *countryLbl;
    IBOutlet UILabel *zipLbl;
    IBOutlet UILabel *contCtLbl;
    IBOutlet UILabel *altContactLbl;
    IBOutlet UILabel *starttimelbl;
    IBOutlet UILabel *endTimeLbl;
    IBOutlet UIButton *getDirectionBtn;
}
- (IBAction)GetDirectionBttn:(id)sender;
@property (strong,nonatomic) ScheduleList *scheduleObj ;
@property(nonatomic, strong) CLLocationManager *locationManager;

- (IBAction)backBttn:(id)sender;

@end
