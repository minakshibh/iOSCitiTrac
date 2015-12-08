//
//  ScheduleDetailViewController.m
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ScheduleDetailViewController.h"

@interface ScheduleDetailViewController ()

@end

@implementation ScheduleDetailViewController
@synthesize scheduleObj;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    getDirectionBtn.layer.borderColor=[UIColor clearColor].CGColor;
    getDirectionBtn.layer.borderWidth=1.0f;
    getDirectionBtn.layer.cornerRadius=5.5;

    
    
    
    headrLbl.text=scheduleObj.CheckPointName;
    notesLbl.text=scheduleObj.Notes;
    addressLbl.text=scheduleObj.Address;
    citylbl.text=scheduleObj.City;
    statelbl.text=scheduleObj.State;
    countryLbl.text=scheduleObj.Country;
    zipLbl.text=scheduleObj.ZipCode;
    starttimelbl.text=scheduleObj.OpenTimings;
    endTimeLbl.text=scheduleObj.CloseTimings;
    contCtLbl.text = scheduleObj.ContactInfo;
    altContactLbl.text = scheduleObj.AlternateContact;
    preferTimeLbl.text=[NSString stringWithFormat:@"Prefered Time : %@",scheduleObj.PrefferedTime];
    
    if (IS_IPHONE_5) {
        scrollView.contentSize = CGSizeMake(320, 380);
    }
    else if(IS_IPHONE_4_OR_LESS)
    {
        scrollView.contentSize = CGSizeMake(320, 470);
    }
    else{
        scrollView.contentSize = CGSizeMake(414, 600);
    }

    [self AddMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)GetDirectionBttn:(id)sender
{
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL])
    {
        NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f",lat,lon,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
        
     
        NSURL* url = [[NSURL alloc] initWithString:[directionsRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSString *directionsRequest = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f",lat,lon,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
        
        NSURL* url = [[NSURL alloc] initWithString:[directionsRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
        
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

- (IBAction)backBttn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AddMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    lat=[scheduleObj.Latitude floatValue];
    lon=[scheduleObj.Longitude floatValue];
    
    NSLog(@"%f %f",lat,lon);
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:15];
    
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,70, self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.size.height-60) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,55,self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.size.height) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.size.height-100) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.size.height-100) camera:camera];
    }
    
    // mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    mapView.layer.borderWidth = 1.5;
    
    mapView.layer.cornerRadius = 5.0;
    
    [mapView setClipsToBounds:YES];
    [self.view addSubview:mapView];
   
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat ,lon );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.snippet=scheduleObj.Address;
    marker.title=scheduleObj.CheckPointName;
        
    marker.map = mapView;
}

@end
