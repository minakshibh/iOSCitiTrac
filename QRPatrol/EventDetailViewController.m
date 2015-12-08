//
//  EventDetailViewController.m
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "EventDetailViewController.h"
#import "ScheduleDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
@synthesize eventObj;

- (void)viewDidLoad
{
    playVideoBttn.hidden = YES;
    lblPlayVideo.hidden = YES;
    if ([_unhide_PlayVideo isEqualToString:@"yes"])
    {
        playVideoBttn.hidden = NO;
        lblPlayVideo.hidden = NO;

    }
    headerLbl.text=eventObj.eventName;
    timelbl.text=[NSString stringWithFormat:@"Reported Time : %@",eventObj.reportedTime];
    if ([eventObj.text isEqualToString:@"<null>"])
    {
        notesLbl.text=@"";
    }
    else {
        notesLbl.text=eventObj.text;
    }
    
    if ([eventObj.Incident_Desc isEqualToString:@"<null>"])
    {
        addressLbl.text = @" ";
    }else{
    addressLbl.text = eventObj.Incident_Desc;
    }
    
    NSURL *imageURL = [NSURL URLWithString:eventObj.imageUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            eventImag.image = [UIImage imageWithData:imageData];
        });
    });
    
    [self AddMap];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AddMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
   float lat=[eventObj.Latitude floatValue];
   float lon=[eventObj.Longitude floatValue];
    
    NSLog(@"%f %f",lat,lon);
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:15];
    
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,70, self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.size.height-60) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,60,self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.size.height-60) camera:camera];
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
  //  marker.snippet=eventObj.Address;
   // marker.title=scheduleObj.CheckPointName;
    
    marker.map = mapView;
}
- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)playVideoBttn:(id)sender {
}

- (IBAction)viewCheckPointBtn:(id)sender {
   
    ScheduleList *scheduleObj ;
    checkPointArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    sharedManager.to_get_checkPoint_status = @"yes1";
    sharedManager.check_id =eventObj.CheckPoint_Id;
    checkPointArray= [[sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    if(checkPointArray.count >0)
    scheduleObj = [checkPointArray objectAtIndex:0];

    
    
    
    
    
    
//    scheduleObj = (ScheduleList *)[scheduleListArray objectAtIndex:indexPath.row];
    
    ScheduleDetailViewController*scheduletDetailVc=[[ScheduleDetailViewController alloc]initWithNibName:@"ScheduleDetailViewController" bundle:[NSBundle mainBundle]];
    scheduletDetailVc.scheduleObj=scheduleObj;
    //  studentDetailVc.parentObj=parentObj;
    
    [self.navigationController pushViewController:scheduletDetailVc  animated:YES];
}
@end
