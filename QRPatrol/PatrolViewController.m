//
//  PatrolViewController.m
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "PatrolViewController.h"
#import "EventsViewController.h"
#import "IncedentsViewController.h"
#import "DatabaseClass.h"
#import "MMEViewController.h"
#import "testViewController.h"
#import "DashboardViewController.h"
#import "GetDetailViewController.h"
@interface PatrolViewController ()

@end

@implementation PatrolViewController
@synthesize locationManager;

- (void)viewDidLoad {
    
    
    officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];

    [self GetOfficerDetailFromDataBase];
    refresh = [[GetDetailCommonView alloc]init];
    [refresh fetchIncidentWebCall];
    if (patrolIdStr.length==0)
    {
        DatabaseClass* sharedManager = [DatabaseClass sharedManager];
        [sharedManager  deleteEvents ];
        
        [scanQrCode setTitle:@"START" forState:UIControlStateNormal];
        isStarted=NO;
        
        [MMEbtn setBackgroundColor:[UIColor grayColor]];
        [tourBtn setBackgroundColor:[UIColor grayColor]];
        [testBtn setBackgroundColor:[UIColor grayColor]];
        [sosBttn setBackgroundColor:[UIColor grayColor]];
        [incedentBtn setBackgroundColor:[UIColor grayColor]];

        MMEbtn.userInteractionEnabled=NO;
        tourBtn.userInteractionEnabled=NO;
        testBtn.userInteractionEnabled=NO;
        sosBttn.userInteractionEnabled=NO;
        incedentBtn.userInteractionEnabled=NO;
    }
    else
    {
        [scanQrCode setTitle:@"Scan QR Code" forState:UIControlStateNormal];
        isStarted=YES;
    }
    
    scanQrCode.layer.borderColor=[UIColor clearColor].CGColor;
    scanQrCode.layer.borderWidth=1.0f;
    scanQrCode.layer.cornerRadius=5.5;
    
    MMEbtn.layer.borderColor=[UIColor clearColor].CGColor;
    MMEbtn.layer.borderWidth=1.0f;
    MMEbtn.layer.cornerRadius=5.5;
    
    testBtn.layer.borderColor=[UIColor clearColor].CGColor;
    testBtn.layer.borderWidth=1.0f;
    testBtn.layer.cornerRadius=5.5;
    
    sosBttn.layer.borderColor=[UIColor clearColor].CGColor;
    sosBttn.layer.borderWidth=1.0f;
    sosBttn.layer.cornerRadius=5.5;
    
    tourBtn.layer.borderColor=[UIColor clearColor].CGColor;
    tourBtn.layer.borderWidth=1.0f;
    tourBtn.layer.cornerRadius=5.5;
    
    incedentBtn.layer.borderColor=[UIColor clearColor].CGColor;
    incedentBtn.layer.borderWidth=1.0f;
    incedentBtn.layer.cornerRadius=5.5;
    
    //   [self EnableButtons];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    
    if([[UIScreen mainScreen] bounds].size.height == 480){
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,55, 320, 175) camera:camera];
    }
    else{
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,60, 320, 245) camera:camera];
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
    
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.map = mapView;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    evntName=[[NSUserDefaults standardUserDefaults]valueForKey:@"eventName"];
    eventLbl.text=evntName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [mapView clear];
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    // [locationManager stopUpdatingLocation];
    current_longitude=newLocation.coordinate.longitude;
    current_latitude=newLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
   
    marker.position = local;
    marker.map = mapView;
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local];
    [mapView animateWithCameraUpdate:cams];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation*currentLocation;
    
    if (locations.count>0) {
        currentLocation = [locations objectAtIndex:0];
    }
    
   // NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [mapView clear];
    current_longitude=currentLocation.coordinate.longitude;
    current_latitude=currentLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker.position = local;
    marker.map = mapView;
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local];
    [mapView animateWithCameraUpdate:cams];
}

- (IBAction)scanQRCode:(id)sender
{
    NSString *img,*notes,*Desc;
    if (isStarted)
    {
        evntName=@"SCAN";
        
        // ADD: present a barcode reader that scans from the camera feed
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        // TODO: (optional) additional reader configuration here
        reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        // EXAMPLE: disable rarely used I2/5 to improve performance
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        // present and release the controller   
        [self presentViewController:reader animated:YES completion:nil];
    }
    else{
        
        
        
        
        //---when select end tour then empty the events list
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM TABLE_EVENT"];
        
        [database executeUpdate:queryString1];
        
        [database close];
        //----------------------------
        

        evntName=@"START";
    
    webservice=1;
    
    [kappDelegate ShowIndicator];
    
    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&img=%@&notes=%@&desc=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],self.checkpointStr,img,notes,Desc];
    NSLog(@"data post >>> %@",_postData);
    [self PostWebService];
    }
    
    
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        
        break;
    NSString *checkPointStr = [NSString stringWithFormat:@"%@",symbol.data];
    self.checkpointStr = checkPointStr;
    
    
    [kappDelegate ShowIndicator];
    [self updateCheckPoint:self.checkpointStr];
    
     NSString *img,*notes,*Desc;
    
    GetDetailViewController *obj = [[GetDetailViewController alloc]initWithNibName:@"GetDetailViewController" bundle:nil];
    
    NSArray *values = [[NSArray alloc]initWithObjects:patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],self.checkpointStr,img,notes,Desc, nil];
    obj.values = values;
    [kappDelegate HideIndicator];
    [reader dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
-(void)remainingQRUpdate:(NSMutableArray*)arr
{   webservice=1;
    evntName = @"SCAN";
    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&img=%@&notes=%@&desc=%@",[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2],[arr objectAtIndex:3],[arr objectAtIndex:4],[arr objectAtIndex:5],[arr objectAtIndex:6],@" ",[arr objectAtIndex:8],[arr objectAtIndex:8]];
    NSLog(@"data post >>> %@",_postData);
    [self PostWebService];

}
-(void) updateCheckPoint: (NSString *)CheckpointId
{
   
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_SCHEDULE SET isChecked = \"%@\" where CheckPoint_Id = \"%@\" ",[NSString stringWithFormat:@"true"],CheckpointId];
    
    [database executeUpdate:updateSQL];
    [kappDelegate HideIndicator];
}
-(void)PostWebService{
    if (webservice == 5) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-testlist.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/report-event.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
    

}
- (IBAction)mmeBtn:(id)sender {
    
    MMEViewController*nextVc=[[MMEViewController alloc]initWithNibName:@"MMEViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
   
}

- (IBAction)sosBtn:(id)sender {
    NSString *img,*notes,*Desc;
    evntName=@"SOS";
    webservice=3;
    
    [kappDelegate ShowIndicator];
    
    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&img=%@&notes=%@&desc=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],self.checkpointStr,img,notes,Desc];
    NSLog(@"data post >>> %@",_postData);
    [self PostWebService];
    
    
}

- (IBAction)tourBtn:(id)sender {
    NSString *img,*notes,*Desc;
    evntName=@"END";
    webservice=4;
    
    [kappDelegate ShowIndicator];
    
    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&img=%@&notes=%@&desc=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],self.checkpointStr,img,notes,Desc];
    NSLog(@"data post >>> %@",_postData);
    [self PostWebService];
    
}

- (IBAction)incidentBtn:(id)sender
{
    IncedentsViewController*nextVc=[[IncedentsViewController alloc]initWithNibName:@"IncedentsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (IBAction)testBtn:(id)sender {
    checkPointArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    checkPointArray= [[ sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    if (checkPointArray.count > 0) {
        assignedCheckPointsView.hidden = NO;
        [self.view bringSubviewToFront:assignedCheckPointsView];
        [assignedCheckpointsTableView reloadData];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please scan the check point to start the test."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

- (IBAction)eventBtn:(id)sender
{
    
    EventsViewController*eventVc=[[EventsViewController alloc]initWithNibName:@"EventsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:eventVc animated:YES];
}

- (IBAction)homeBtn:(id)sender {
    DashboardViewController*eventVc=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:eventVc animated:YES];
}

- (IBAction)locateBtn:(id)sender {
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)EnableButtons
{
    [scanQrCode setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [MMEbtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [testBtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [incedentBtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [sosBttn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [tourBtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
}
-(void)Diasblebuttons
{
    [scanQrCode setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [MMEbtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [testBtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [incedentBtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [sosBttn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
    [tourBtn setBackgroundColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0]];
}


-(void)GetOfficerDetailFromDataBase

{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId= \"%@\"",officerIdStr];
    
    FMResultSet *results1 = [database executeQuery:queryString1];
    
    while([results1 next])
    {
        patrolIdStr=[results1 stringForColumn:@"patrolId"];
        shiftIdStr=[NSString stringWithFormat:@"%@",[results1 stringForColumn:@"shiftId"]];
    }
    
    if ([patrolIdStr isEqualToString:@"<null>"]|| [patrolIdStr isEqualToString:@"" ] || [patrolIdStr isEqualToString:@"0" ])
    {
        patrolIdStr=@"";
    }
   
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where officerId =\"%@\" ",officerIdStr];
    FMResultSet *results = [database executeQuery:queryString];
    
    NSMutableArray *checkPtArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        NSString* checkpoint = @"";
        checkpoint=[NSString stringWithFormat:@"%@",[results stringForColumn:@"checkpoint_id"]];
        
        // checkpointStr= [checkpointStr stringByReplacingOccurrencesOfString:@"(null)" withString:@"\"\""];
        if (checkpoint.length!=0)
        {
            [ checkPtArray addObject:checkpoint];
        }
    }
    
    // checkpoint = [[checkPtArray valueForKey:@"description"] componentsJoinedByString:@""];
    
    for ( int j=0;j<checkPtArray.count;j++)
    {
        if (j==0)
        {
           // checkpointStr =[checkPtArray objectAtIndex:j];
        }
        else{
           // checkpointStr =[NSString stringWithFormat:@"%@,%@",checkpointStr,[checkPtArray objectAtIndex:j]];
        }
        
    }
    
    [database close];
}


#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    webData = [[NSMutableData alloc]init];
    
    NSLog(@"Received Response");
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data>>%@",data);
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
   // responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    // DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (webservice==1)
            {
                if([evntName isEqualToString:@"START"])
                {
                    [scanQrCode setTitle:@"Scan QR Code" forState:UIControlStateNormal];
                    isStarted=YES;
                    
                    [scanQrCode setBackgroundColor:[UIColor colorWithRed:224.0f/192.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1.0f ]];

                    [MMEbtn setBackgroundColor:[UIColor colorWithRed:224.0f/192.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1.0f ]];
                    [tourBtn setBackgroundColor:[UIColor colorWithRed:224.0f/192.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1.0f ]];
                    [testBtn setBackgroundColor:[UIColor colorWithRed:224.0f/192.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1.0f ]];
                    [sosBttn setBackgroundColor:[UIColor colorWithRed:224.0f/192.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1.0f ]];
                    [incedentBtn setBackgroundColor:[UIColor colorWithRed:224.0f/192.0f green:0.0f/255.0f blue:6.0f/255.0f alpha:1.0f ]];
                    
                    MMEbtn.userInteractionEnabled=YES;
                    tourBtn.userInteractionEnabled=YES;
                    testBtn.userInteractionEnabled=YES;
                    sosBttn.userInteractionEnabled=YES;
                    incedentBtn.userInteractionEnabled=YES;
                }
                else{
                    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
                    
                    [ sharedManager UpdatePatrolId :[userDetailDict valueForKey:@"patrol_id"]];
                    [self GetOfficerDetailFromDataBase];
                }
            }
            else if (webservice==2)
            {
                
            }
            else if (webservice==3)
            {
            }
            else if (webservice==4)
            {
                DatabaseClass* sharedManager = [DatabaseClass sharedManager];
                [sharedManager  deleteEvents ];
                
                
                [MMEbtn setBackgroundColor:[UIColor grayColor]];
                [tourBtn setBackgroundColor:[UIColor grayColor]];
                [testBtn setBackgroundColor:[UIColor grayColor]];
                [sosBttn setBackgroundColor:[UIColor grayColor]];
                [incedentBtn setBackgroundColor:[UIColor grayColor]];
                
                MMEbtn.userInteractionEnabled=NO;
                tourBtn.userInteractionEnabled=NO;
                testBtn.userInteractionEnabled=NO;
                sosBttn.userInteractionEnabled=NO;
                incedentBtn.userInteractionEnabled=NO;
                
        }
            else if (webservice==5)
            {
                int str = [[userDetailDict valueForKey:@"result"] intValue];
                
                if (str == 0) {
                    
                    checkPointArray=[[NSMutableArray alloc]init];
                    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
                    checkPointArray= [[ sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
                    if (checkPointArray.count > 0) {
                        assignedCheckPointsView.hidden = NO;
                        [self.view bringSubviewToFront:assignedCheckPointsView];
                        [assignedCheckpointsTableView reloadData];
                    }else{
                        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please scan the check point before passing any log"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
            }
            else if (webservice==6)
            {
                NSString*lastUpdated=[userDetailDict valueForKey:@"MaxLastUpdatedValue"];
                if ([lastUpdated isKindOfClass:[NSNull class]])
                {
                    lastUpdated=@"";
                }
                [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"event_greatest_last_updated"];
                
                NSArray*event_list=[userDetailDict valueForKey:@"event_list"];
                
                if (event_list.count>0)
                {
                    DatabaseClass* sharedManager = [DatabaseClass sharedManager];
                    [sharedManager saveEventDetails :event_list :[NSString stringWithFormat:@"%@",patrolIdStr] ];
                }
            }
            
            if (webservice!=6)
            {
                eventLbl.text=evntName;
                [[NSUserDefaults standardUserDefaults ]setValue:evntName forKey:@"eventName"];

                if (webservice==4)
                {
                    eventLbl.text=@"";
                    [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"eventName"];
                    [scanQrCode setTitle:@"Start" forState:UIControlStateNormal];
                    isStarted = NO;
                }
                [self  fetchEventsWebCall];
            }
        }
    }
}

-(void)fetchEventsWebCall
{
    webservice=6;
    
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"event_greatest_last_updated"];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId= \"%@\"",officerIdStr];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next])
    {
        patrolIdStr=[results stringForColumn:@"patrolId"];
    }
    
    [database close];
    
    
    if (lastUpdatedStr.length!=0)
    {
        _postData = [NSString stringWithFormat:@"patrol_id=%@&last_updated_date=%@",patrolIdStr,lastUpdatedStr];
    }
    else{
        _postData = [NSString stringWithFormat:@"patrol_id=%@&last_updated_date= ",patrolIdStr];
    }
    
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-event.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return [checkPointArray count];
   
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
   
        scheduledOC = [checkPointArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",scheduledOC.CheckPointName];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
        assignedCheckPointsView.hidden = YES;
        scheduledOC = [checkPointArray objectAtIndex:indexPath.row];
    NSString *checkPointStr = [NSString stringWithFormat:@"%@",scheduledOC.CheckPointName];
    NSString *checkPointIDStr = [NSString stringWithFormat:@"%@",scheduledOC.CheckPoint_Id];
    testViewController *testVC = [[testViewController alloc] initWithNibName:@"testViewController" bundle:nil];
    testVC.checkPointName = checkPointStr;
    testVC.checkPointId = checkPointIDStr;
    [self.navigationController pushViewController:testVC animated:NO];
}
-(void) beginTest{
    NSString *img,*notes,*Desc;
    
    
    
    [kappDelegate ShowIndicator];
    webservice=5;
    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&img=%@&notes=%@&desc=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],self.checkpointStr,img,notes,Desc];
    NSLog(@"data post >>> %@",_postData);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/report-event.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

@end
