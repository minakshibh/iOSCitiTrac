//
//  MMEViewController.m
//  QRPatrol
//
//  Created by Br@R on 26/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "MMEViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "Base64.h"
@interface MMEViewController ()

@end

@implementation MMEViewController

- (void)viewDidLoad {
    officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    [self GetOfficerDetailFromDataBase];
    

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)MMEwebCall
{
    [kappDelegate ShowIndicator];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    float  current_longitude=self.locationManager.location.coordinate.longitude;
    float current_latitude=self.locationManager.location.coordinate.latitude;
    
    
    
    NSString *img,*Txt,*video;
    evntName=@"MME";
    
    
    NSData* imgdata = UIImageJPEGRepresentation(MmeImageView.image, 0.3f);
    img = [Base64 encode:imgdata];
    Txt=enterDescriptionTxt.text;

    NSDictionary *_params;
            webservice=1;
            _params = @{@"patrol_id" : patrolIdStr,
                        @"officer_id" : officerIdStr,
                        @"shift_id" : shiftIdStr,
                        @"event_name" :evntName,
                        @"latitude" :[NSString stringWithFormat:@"%f",current_latitude],
                        @"longitude":[NSString stringWithFormat:@"%f",current_longitude],
                        @"checkpoint_id": checkpointStr,
                        @"text" :Txt
                        };
  
    
    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
     NSString *VideofileName = [NSString stringWithFormat:@"%ld%c%c.mp4", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    // BASIC AUTH (if you need):
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // BASIC AUTH END
    
    NSString *URLString = [NSString stringWithFormat:@"%@/report-mme.php",Kwebservices];
    
    /// !!! only jpg, have to cover png as well
    // image size ca. 50 KB
    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"img" fileName:fileName mimeType:@"image"];
        [formData appendPartWithFileData:videoData name:@"video" fileName:VideofileName mimeType:@"video/quicktime"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success %@", responseObject);
        [kappDelegate HideIndicator];
        NSString *messageStr = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"message"]];
        if ([messageStr isEqualToString:@"Success"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR Petrol" message:@"MME is reported Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 1;
            [alert show];
        }
//        NSMutableArray *vehicleInfoArray = [responseObject valueForKey:@"vehicle_info"];
//        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        documentsDir = [docPaths objectAtIndex:0];
//        dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
//        database = [FMDatabase databaseWithPath:dbPath];
//        [database open];
//        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM vehiclesList"];
//        [database executeUpdate:queryString1];
//        
//        for (int i = 0; i < [vehicleInfoArray count]; i++) {
//            NSString *vehicleIDs = [[vehicleInfoArray valueForKey:@"ID"] objectAtIndex:i];
//            NSString *vehicleColor = [[vehicleInfoArray valueForKey:@"color"] objectAtIndex:i];
//            NSString *vehicleNumber = [[vehicleInfoArray valueForKey:@"vehicle_no"] objectAtIndex:i];
//            NSString *vehicleMake = [[vehicleInfoArray valueForKey:@"vehicle_make"] objectAtIndex:i];
//            NSString *vehicleModal = [[vehicleInfoArray valueForKey:@"vehicle_modal"] objectAtIndex:i];
//            NSString *vehicleImage = [[vehicleInfoArray valueForKey:@"vehicle_imageUrl"] objectAtIndex:i];
//            NSString *insert = [NSString stringWithFormat:@"INSERT INTO vehiclesList (vehicleId, vehicleColor, vehicleNumber, vehicleMake,vehicleModal,vehicleImageUrl) VALUES (\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\")",vehicleIDs,vehicleColor,vehicleNumber,vehicleMake,vehicleModal,vehicleImage];
//            [database executeUpdate:insert];
//        }
//        [database close];
//        [kappDelegate HideIndicator];
//        if ([self.addVehicleDataType isEqualToString:@"Edit"])
//        {
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] animated:NO];
//            
//        }
//        else{
//            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Profile Build"];
//            homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];
//            [self.navigationController pushViewController:homeVC animated:NO];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];


//
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    [self.locationManager startUpdatingLocation];
//    
//    float  current_longitude=self.locationManager.location.coordinate.longitude;
//    float current_latitude=self.locationManager.location.coordinate.latitude;
//    
//
//    
//    NSString *img,*Txt,*video;
//    evntName=@"MME";
//    
//    
//    NSData* imgdata = UIImageJPEGRepresentation(MmeImageView.image, 0.3f);
//    img = [Base64 encode:imgdata];
//    Txt=enterDescriptionTxt.text;
//
//    webservice=1;
//    
//    [kappDelegate ShowIndicator];
//    
//    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&text=%@&img=%@&video=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],checkpointStr,Txt,img,video];
//    
//    NSLog(@"data post >>> %@",_postData);
//    
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/report-mme.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
//    [request setHTTPMethod:@"POST"];
//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    
//    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if(connection)
//    {
//        if(webData==nil)
//        {
//            webData = [NSMutableData data] ;
//            NSLog(@"data");
//        }
//        else
//        {
//            webData=nil;
//            webData = [NSMutableData data] ;
//        }
//        NSLog(@"server connection made");
//    }
//    else
//    {
//        NSLog(@"connection is NULL");
//    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    webData = [[NSMutableData alloc]init];
    
    NSLog(@"Received Response");
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
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
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    
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
                [[NSUserDefaults standardUserDefaults ]setValue:@"MME" forKey:@"eventName"];
                
                [self  fetchEventsWebCall];

            }
            else if (webservice==2)
            {
                NSString*lastUpdated=[userDetailDict valueForKey:@"MaxLastUpdatedValue"];
                [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"event_greatest_last_updated"];
                
                NSArray*event_list=[userDetailDict valueForKey:@"event_list"];
                
                if (event_list.count>0)
                {
                    DatabaseClass* sharedManager = [DatabaseClass sharedManager];
                    
                    [sharedManager saveEventDetails :event_list :[NSString stringWithFormat:@"%@",patrolIdStr] ];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
}


-(void)fetchEventsWebCall
{
    webservice=2;
    
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"event_greatest_last_updated"];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString*officerIdSt=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId= \"%@\"",officerIdSt];
    
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
    
    if ([patrolIdStr isEqualToString:@"<null>"]|| [patrolIdStr isEqualToString:@""])
    {
        patrolIdStr=@"";
    }
    evntName=[[NSUserDefaults standardUserDefaults]valueForKey:@"eventName"];
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


- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ClickPicBttn:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker
                       animated:YES completion:nil];

}




#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
//        NSString *moviePath = [[info objectForKey:
//                                UIImagePickerControllerMediaURL] path];
//        videoData = [NSData dataWithContentsOfFile:moviePath];
//        NSArray *pathArray = [moviePath componentsSeparatedByString: @"/"];
//        moviePath = [NSString stringWithFormat:@"%@/%@/%@", [pathArray objectAtIndex:8],[pathArray objectAtIndex:9],[pathArray objectAtIndex:10]];
//        videoPathLbl.text = [NSString stringWithFormat:@"%@",moviePath];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
//            UISaveVideoAtPathToSavedPhotosAlbum (
//                                                 moviePath, nil, nil, nil);
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSLog(@"found a video");
        
        // Code To give Name to video and store to DocumentDirectory //
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy||HH:mm:SS"];
        NSDate *now = [[NSDate alloc] init] ;
        NSString *theDate = [dateFormat stringFromDate:now];
        
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        
        NSString *videopath= [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.mov",documentsDirectory,theDate]];
        
        BOOL success = [videoData writeToFile:videopath atomically:NO];
        
        NSLog(@"Successs:::: %@", success ? @"YES" : @"NO");
        NSLog(@"video path --> %@",videopath);
        NSArray *pathArray = [videopath componentsSeparatedByString: @"/"];
        videopath = [NSString stringWithFormat:@"%@/%@", [pathArray objectAtIndex:7],[pathArray objectAtIndex:8]];
        videoPathLbl.text = [NSString stringWithFormat:@"%@",videopath];
    }
    else{

    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    MmeImageView.image = chosenImage;
    float actualHeight = chosenImage.size.height;
    float actualWidth = chosenImage.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [chosenImage drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    imagedata = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)recordVideoBttn:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *videoRecorder = [[UIImagePickerController alloc] init];
        videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoRecorder.delegate = self;
        
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *videoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"movie"]];
        
        if ([videoMediaTypesOnly count] == 0)		//Is movie output possible?
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sorry but your device does not support video recording"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
            [actionSheet showInView:[[self view] window]];
        }
        else
        {
            //Select front facing camera if possible
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
                videoRecorder.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            videoRecorder.mediaTypes = videoMediaTypesOnly;
            videoRecorder.videoQuality = UIImagePickerControllerQualityTypeMedium;
            videoRecorder.videoMaximumDuration = 180;			//Specify in seconds (600 is default)
            
            [self presentModalViewController:videoRecorder animated:YES];
        }
    }
    else
    {
        //No camera is availble
    }
}

- (IBAction)assignCheckPointBtn:(id)sender {
    
    [self.view bringSubviewToFront:assignedCheckPointsView];
    checkPointArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    checkPointArray= [[ sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    if (checkPointArray.count > 0) {
        assignedCheckPointsView.hidden = NO;
        [assignedCheckpointsTableView reloadData];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please scan the check point before sending MME."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (IBAction)sendMmeBttn:(id)sender {
    if (enterDescriptionTxt.text.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (checkpointStr.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please select checkPoint." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    
    [self MMEwebCall];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [addVehicleScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = addVehicleScroller.contentOffset;
    
    
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:addVehicleScroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y =50;
        [addVehicleScroller setContentOffset:pt animated:YES];
    
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
    checkpointStr = [NSString stringWithFormat:@"%@",scheduledOC.CheckPoint_Id];

}




@end
