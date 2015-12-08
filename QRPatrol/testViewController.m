//
//  testViewController.m
//  QRPatrol
//
//  Created by Krishna_Mac_1 on 6/15/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "testViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PatrolViewController.h"
@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    testNameLbl.text = [NSString stringWithFormat:@"%@",self.checkPointName];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    [self GetOfficerDetailFromDataBase];
    // Do any additional setup after loading the view from its nib.
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
    
    
    [database close];
    [self PostWebService];
}

-(void)PostWebService{
    [kappDelegate ShowIndicator];
    NSString *checkPointId = [NSString stringWithFormat:@"%@",self.checkPointId];
    NSString *_postData = [NSString stringWithFormat:@"checkpoint_id=%@",checkPointId];
    NSLog(@"data post >>> %@",_postData);
    webservice = 1;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-testlist.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];

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
-(void)submitBtn
{
    NSString *img,*notes,*Desc;
    
    webservice=2;
    
    [kappDelegate ShowIndicator];
    
    _postData = [NSString stringWithFormat:@"patrol_id=%@&officer_id=%@&shift_id=%@&event_name=%@&latitude=%@&longitude=%@&checkpoint_id=%@&img=%@&notes=%@&desc=%@",patrolIdStr,officerIdStr,shiftIdStr,evntName,[NSString stringWithFormat:@"%f",current_latitude],[NSString stringWithFormat:@"%f",current_longitude],_checkPointId,img,notes,Desc];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"%@",userDetailDict);
    // DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    if (webservice == 1) {
    
    NSMutableArray *testArray = [userDetailDict valueForKey:@"testlist"];
    testListArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [testArray count]; i++) {
        testObj = [[testOC alloc] init];
        testObj.checkpoint_id = [[testArray valueForKey:@"checkpoint_id"] objectAtIndex:i];
        testObj.is_active = [[testArray valueForKey:@"is_active"] objectAtIndex:i];
        testObj.test_description = [[testArray valueForKey:@"test_description"] objectAtIndex:i];
        testObj.testpoint_id = [[testArray valueForKey:@"testpoint_id"] objectAtIndex:i];
        [testListArray addObject:testObj];
    }
    [testTableView reloadData];
    }else{
        PatrolViewController *oetrolVC = [[PatrolViewController alloc] initWithNibName:@"PatrolViewController" bundle:nil];
        [self.navigationController pushViewController:oetrolVC animated:NO];
    }
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [testListArray count];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UILabel *bgLbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 304, 28)];
    bgLbl.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bgLbl];
    testObj = [testListArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",testObj.test_description];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    testObj = [testListArray objectAtIndex:indexPath.row];
//   evntName = [NSString stringWithFormat:@"%@",testObj.test_description];
   UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *bgLbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 304, 28)];
    bgLbl.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:bgLbl];
    [cell.contentView sendSubviewToBack:bgLbl];
}

- (IBAction)submitBtnAction:(id)sender {
    evntName =@"Test In Process";
    [self submitBtn];
}

- (IBAction)endTestBtnAction:(id)sender {
    evntName =@"End Test";
    [self submitBtn];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
