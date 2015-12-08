//
//  ScheduleViewController.m
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleList.h"
#import "ScheduleDetailViewController.h"
#import "DatabaseClass.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad
{
    scheduleListObj=[[ScheduleList alloc]init];

    scheduleListArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    
   scheduleListArray= [[ sharedManager getScheduleDataFromDatabase]mutableCopy];
    
    
    [scheduleTableView reloadData];
    [self AddMap];
    mapView.hidden=YES;
    listBtn.titleLabel.textColor=[UIColor whiteColor];
    mapBtn.titleLabel.textColor=[UIColor lightGrayColor];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)scannedCheckpointBtnAction:(id)sender {
    scheduleListArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    
    scheduleListArray= [[ sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    if (scheduleListArray.count > 0) {
        checkedCheckPointView.hidden = NO;
        [checkedCheckpointTableView reloadData];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please scan the check point before viewing Scanned Checkpoints."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        scheduleListArray=[[NSMutableArray alloc]init];
        DatabaseClass *sharedManager = [DatabaseClass sharedManager];
        
        scheduleListArray= [[ sharedManager getScheduleDataFromDatabase]mutableCopy];
        
        
        [scheduleTableView reloadData];
    }
}
- (IBAction)listBttn:(id)sender {
    listBtn.titleLabel.textColor=[UIColor whiteColor];
    mapBtn.titleLabel.textColor=[UIColor lightGrayColor];

    mapView.hidden=YES;
    scheduleTableView.hidden=NO;
}

- (IBAction)mapBttn:(id)sender {
    mapBtn.titleLabel.textColor=[UIColor whiteColor];
    listBtn.titleLabel.textColor=[UIColor lightGrayColor];
    mapView.hidden=NO;
    scheduleTableView.hidden=YES;
}

-(void)AddMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    
    float eventlat;
    float eventlong;
    
    eventlat=self.locationManager.location.coordinate.longitude;
    eventlong=self.locationManager.location.coordinate.latitude;
    
    for (int k=0;k<scheduleListArray.count; k++)
    {
        scheduleListObj=[scheduleListArray objectAtIndex:0];
        eventlat=[scheduleListObj.Latitude floatValue];
        eventlong=[scheduleListObj.Longitude floatValue];
    }

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:eventlat longitude:eventlong zoom:15];
    
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,85, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,100,self.view.frame.size.width, self.view.frame.size.height-100) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height-100) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height-100) camera:camera];
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
    
    for (int k=0;k<scheduleListArray.count; k++)
    {
        scheduleListObj=[scheduleListArray objectAtIndex:k];
        float lat=[scheduleListObj.Latitude floatValue];
        float lon=[scheduleListObj.Longitude floatValue];

        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat ,lon );
        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.snippet=scheduleListObj.Address;
        marker.title=scheduleListObj.CheckPointName;
        marker.zIndex=[scheduleListObj.CheckPoint_Id intValue];
        
        marker.map = mapView;

    }
}





- (void) mapView:(GMSMapView *)mapView1 didTapInfoWindowOfMarker:(GMSMarker *)marker1{
    
    //info window tapped
    NSLog(@"marker.zIndex --  %d",marker1.zIndex);
    for (int j=0;j<scheduleListArray.count; j++)
    {
        ScheduleList*schdule=(ScheduleList*)[scheduleListArray objectAtIndex:j];
        if ([schdule.CheckPoint_Id isEqualToString:[NSString stringWithFormat:@"%d",marker1.zIndex ]])
        {
            ScheduleDetailViewController*scheduletDetailVc=[[ScheduleDetailViewController alloc]initWithNibName:@"ScheduleDetailViewController" bundle:[NSBundle mainBundle]];
            scheduletDetailVc.scheduleObj=schdule;
            
            [self.navigationController pushViewController:scheduletDetailVc  animated:YES];

        }
    }
}



- (IBAction)checkedCheckPointBackBtnAction:(id)sender {
    checkedCheckPointView.hidden = YES;
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [scheduleListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    if (cell == nil)
//    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
//    }
    
    UILabel*checkPointName= [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 290,30)];
    checkPointName.backgroundColor = [UIColor clearColor];
    checkPointName.textColor=[UIColor redColor];
    checkPointName.numberOfLines=1;
    checkPointName.font =  [UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:checkPointName ];
    
    UILabel*preferTimeLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 19, 290,30)];
    preferTimeLbl.backgroundColor = [UIColor clearColor];
    preferTimeLbl.numberOfLines=1;
    preferTimeLbl.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:preferTimeLbl ];
    
    
    UILabel*noteslbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 40,30)];
    noteslbl.backgroundColor = [UIColor clearColor];
    noteslbl.numberOfLines=1;
    noteslbl.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:noteslbl ];
    noteslbl.text=@"Note :";
    
    
    CGRect textViewFrame = CGRectMake(50, 40, 220,50);
    UITextView *notestextView = [[UITextView alloc] initWithFrame:textViewFrame];
    notestextView.backgroundColor = [UIColor clearColor];
    notestextView.font = [UIFont boldSystemFontOfSize:13];
    notestextView.returnKeyType = UIReturnKeyDone;
    [notestextView setEditable:NO];
    [cell.contentView addSubview:notestextView];
    
    if ( IS_IPHONE_6P || IS_IPHONE_6)
    {
        checkPointName.frame= CGRectMake(10, 1, 330,30);
        preferTimeLbl.frame= CGRectMake(10, 29, 330,30);
        notestextView.frame= CGRectMake(60, 50, 330,50);
        noteslbl.frame=CGRectMake(10, 50, 50,50);
    }
    
    
    ScheduleList*schedulelistObj = [scheduleListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
   
    checkPointName.text=[NSString stringWithFormat:@"%@",schedulelistObj.CheckPointName];
    if ([schedulelistObj.isChecked isEqualToString:@"true"]) {
        preferTimeLbl.text=[NSString stringWithFormat:@"Checked Time : %@",schedulelistObj.PrefferedTime];
    }else{
        preferTimeLbl.text=[NSString stringWithFormat:@"PrefferedTime : %@",schedulelistObj.PrefferedTime];
    }
    notestextView.text=[NSString stringWithFormat:@"%@",schedulelistObj.Notes];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    ScheduleList *scheduleObj ;
    
    scheduleObj = (ScheduleList *)[scheduleListArray objectAtIndex:indexPath.row];
    
    ScheduleDetailViewController*scheduletDetailVc=[[ScheduleDetailViewController alloc]initWithNibName:@"ScheduleDetailViewController" bundle:[NSBundle mainBundle]];
    scheduletDetailVc.scheduleObj=scheduleObj;
    //  studentDetailVc.parentObj=parentObj;
    
    [self.navigationController pushViewController:scheduletDetailVc  animated:YES];
}





@end
