//
//  EventDetailViewController.h
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventList.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMapsM4B/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EventDetailViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    GMSMapView *mapView;
    GMSMarker*marker;
    IBOutlet UIImageView *eventImag;
    
    IBOutlet UILabel *timelbl;
    IBOutlet UILabel *headerLbl;
    IBOutlet UITextView *notesLbl;
    IBOutlet UITextView *addressLbl;
    IBOutlet UIButton *viewChckPointBtn;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *checkPointArray;
    
    IBOutlet UIButton *playVideoBttn;
    IBOutlet UILabel *lblPlayVideo;
}

- (IBAction)backBttn:(id)sender;
@property(strong,nonatomic) EventList *eventObj;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString *unhide_PlayVideo;
- (IBAction)playVideoBttn:(id)sender;
- (IBAction)viewCheckPointBtn:(id)sender;
@end
