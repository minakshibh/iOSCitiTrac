//
//  IncedentsViewController.m
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "IncedentsViewController.h"
#import "Incedents.h"
#import "DashboardViewController.h"

@interface IncedentsViewController ()

@end

@implementation IncedentsViewController

- (void)viewDidLoad {
    
 
    officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];

    [self GetOfficerDetailFromDataBase];
    [super viewDidLoad];
    markArray=[[NSMutableArray alloc]init];
    [self getIncedentsDataFromDatabase];
    [incedentTableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)mediumPriorityBttn:(id)sender
{
        isMedium=YES;
        isHigh=NO;
        isLow=NO;
        [HighPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [lowPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [mediumPriority setImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
        
}

- (IBAction)lowPriorityBttn:(id)sender
{
        isLow=YES;
        isHigh=NO;
        isMedium=NO;
        [HighPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [mediumPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [lowPriority setImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
        
}

- (IBAction)highPriorityBttn:(id)sender {
        isMedium=NO;
        isHigh=YES;
        isMedium=NO;
        [lowPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [mediumPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [HighPriority setImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
}


- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reportIncedentBttn:(id)sender
{
//    if (assignedCheckPointLbl.text.length==0)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please select checkpoint." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    
    if (markArray.count==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please select any incident to report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    float  current_longitude=self.locationManager.location.coordinate.longitude;
    float current_latitude=self.locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    NSString*incidentStr ,*sendByMailStr ,*maintainance ,*urgenctStr;
    
    incidentStr= [[markArray valueForKey:@"description"] componentsJoinedByString:@""];

    
    if (sendByMail)
    {
        sendByMailStr=@"YES";
    }
    else{
        sendByMailStr=@"NO";
    }

    
    if (isMaintainance)
    {
        maintainance=@"true";
        if (isMedium)
        {
            urgenctStr=@"Medium";
        }
        else if (isHigh)
        {
            urgenctStr=@"High";
        }
        else if (isLow)
        {
            urgenctStr=@"Low";
        }
        else{
            urgenctStr=@"";
        }
    }
    else{
        maintainance=@"false";
    }
    
    webservice=1;
    
    [kappDelegate ShowIndicator];
    

    NSString *_postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&incident_id=%@&isSentViaEmail=%@&isMaintenance=%@&urgency=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],checkpointStr,incidentStr,sendByMailStr,maintainance,urgenctStr];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/report-incident.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    NSLog(@"%@",userDetailDict);
    int result = [[userDetailDict valueForKey:@"result"] intValue];
    if (result == 0) {
        DashboardViewController *dashboardVC = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
        [self.navigationController pushViewController:dashboardVC animated:NO];
    }
    [kappDelegate HideIndicator];
    
}




- (IBAction)assignCheckPointBttn:(id)sender {
    
    checkPointArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    checkPointArray= [[ sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    if (checkPointArray.count >0) {
        assignedCheckPointsList.hidden = NO;
        [assignedCheckPointsTableView reloadData];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please scan the check point before reporting Incedent."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (IBAction)isMaintanceBttn:(id)sender
{
    if (isMaintainance)
    {
        isMaintainance=NO;
        [maintainceCheckBox setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        
        isMedium=NO;
        isHigh=NO;
        isMedium=NO;
        [lowPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [mediumPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [HighPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        checkBoxesBackView.frame=CGRectMake(checkBoxesBackView.frame.origin.x, checkBoxesBackView.frame.origin.y+checkBoxesBackView.frame.size.height, checkBoxesBackView.frame.size.width, checkBoxesBackView.frame.size.height);
        priorityCheckBoxbackView.hidden=YES;
    }
    else{
        isMaintainance=YES;
        [maintainceCheckBox setImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
        checkBoxesBackView.frame=CGRectMake(checkBoxesBackView.frame.origin.x, checkBoxesBackView.frame.origin.y-checkBoxesBackView.frame.size.height, checkBoxesBackView.frame.size.width, checkBoxesBackView.frame.size.height);
        priorityCheckBoxbackView.hidden=NO;
        
        
        isLow=YES;
        [HighPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [mediumPriority setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
        [lowPriority setImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
  
    }
}

- (IBAction)sendByEmailBttn:(id)sender {
    if (sendByMail)
    {
        sendByMail=NO;
        [sendByMailCheckBox setImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
    }
    else{
        sendByMail=YES;
        [sendByMailCheckBox setImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
        
    }

}

-(void) getIncedentsDataFromDatabase
{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_INCIDENT "];
    
    FMResultSet *results = [database executeQuery:queryString];
    incedentsListArray=[[NSMutableArray alloc]init];
    int i = 0;
    while([results next])
    {   i++;
        Incedents*IncedentsListObj=[[Incedents alloc]init];
        
        IncedentsListObj.Incident_Id =[results stringForColumn:@"Incident_Id"];
        IncedentsListObj.Incident_Desc=[results stringForColumn:@"Incident_Desc"];
        IncedentsListObj.Incident_isChecked=[results stringForColumn:@"Incident_isChecked"];
        
        [incedentsListArray addObject:IncedentsListObj];
        if (i == 5) {
            break;
        }
    }
    
    [database close];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == incedentTableView) {
        return [incedentsListArray count];
    }else{
        return [checkPointArray count];
    }
    
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
    if (tableView == incedentTableView) {
    
    UILabel*incName;
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(261,5, 23, 23)];
    incName= [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 290,30)];
    incName.backgroundColor = [UIColor clearColor];
    incName.textColor=[UIColor blackColor];
    incName.numberOfLines=1;
    incName.font =  [UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:incName ];
    
    if ( IS_IPHONE_6P || IS_IPHONE_6)
    {
        imv.frame=CGRectMake(311,22, 23, 23);
        incName.frame= CGRectMake(10, 1, 330,30);
    }

    if ( IS_IPHONE_6P)
    {
        imv.frame=CGRectMake(345,22, 23, 23);
    }

    Incedents*incObj = [incedentsListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    
    if ([markArray containsObject:incObj.Incident_Id])
    {
        imv.image=[UIImage imageNamed:@"checked_checkbox.png"];
    }
    else{
        imv.image=[UIImage imageNamed:@"unchecked_checkbox.png"];
    }
    
   // imv.tag=indexPath.row+1000;
    [cell.contentView addSubview:imv];
    
    incName.text=[NSString stringWithFormat:@"%@",incObj.Incident_Desc];
    }else{
        scheduledOC = [checkPointArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",scheduledOC.CheckPointName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    if (tableView == incedentTableView) {
    
    Incedents *incObj = (Incedents *)[incedentsListArray objectAtIndex:indexPath.row];
    
    if ([markArray containsObject:incObj.Incident_Id])
    {
        [markArray removeObject:incObj.Incident_Id];
    }
    else{
        [markArray addObject:incObj.Incident_Id];
    }
    [incedentTableView reloadData];
    }else{
        assignedCheckPointsList.hidden = YES;
        scheduledOC = [checkPointArray objectAtIndex:indexPath.row];
        assignedCheckPointLbl.text = [NSString stringWithFormat:@"%@",scheduledOC.CheckPointName];
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
        evntName=[results1 stringForColumn:@"eventName"];
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
            [checkPtArray addObject:checkpoint];
        }
    }
    
   // checkpoint = [[checkPtArray valueForKey:@"description"] componentsJoinedByString:@""];
    
    for ( int j=0;j<checkPtArray.count;j++)
    {
        if (j==0)
        {
            checkpointStr =[checkPtArray objectAtIndex:j];
        }
        else{
            checkpointStr =[NSString stringWithFormat:@"%@,%@",checkpointStr,[checkPtArray objectAtIndex:j]];
        }
        
    }
    
    [database close];
}



@end
