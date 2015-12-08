//
//  OrdersViewController.m
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "OrdersViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "orderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "DashboardViewController.h"
#import "AddLogsViewController.h"
@interface OrdersViewController ()

@end

@implementation OrdersViewController
@synthesize viewType;
- (void)viewDidLoad {
    [super viewDidLoad];
    officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    if ([self.viewType isEqualToString:@"order"]) {
        orderTitleLbl.text = @"Orders";
        addLogBtn.hidden = YES;
    }else{
        orderTitleLbl.text = @"Logs";
        addLogBtn.hidden = NO;
    }
    [self GetOfficerStaffIdCheckpointStr];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBttn:(id)sender {
    DashboardViewController *orderVC = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    [self.navigationController pushViewController:orderVC animated:NO];
    
}
-(void)GetOfficerStaffIdCheckpointStr
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
        shiftIdStr=[NSString stringWithFormat:@"%@",[results1 stringForColumn:@"shiftId"]];
        
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
        
        [checkPtArray objectAtIndex:j];
        
        
    }
    checkpointStr = [NSString stringWithFormat:@"%@",checkPtArray];
    checkpointStr = [checkpointStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    checkpointStr = [checkpointStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",checkpointStr);
    [database close];
    if ([viewType isEqualToString:@"order"]) {
        [self fetchOrders];
    }else{
        [self fetchlogs];
    }
    
}

-(void)fetchOrders
{
    [kappDelegate ShowIndicator];
    NSString *lastUpdated = [NSString stringWithFormat:@""];
    
    NSString *_postData = [NSString stringWithFormat:@"shift_id=%@&checkpoint_id=%@&last_updated=%@",shiftIdStr,checkpointStr,lastUpdated];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-orders.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webservicecode =1;
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
-(void)fetchlogs
{
    [kappDelegate ShowIndicator];
    NSString *lastUpdated = [NSString stringWithFormat:@""];
    
    NSString *_postData = [NSString stringWithFormat:@"shift_id=%@&checkpoint_id=%@&last_updated=%@",shiftIdStr,checkpointStr,lastUpdated];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-logs.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webservicecode =2;
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
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.view.userInteractionEnabled=YES;
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.view.userInteractionEnabled=YES;
    //  [kappDelegate HideIndicator];
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
    NSLog(@"%@",[userDetailDict valueForKey:@"checkpoints"]);
    NSMutableArray *checkPointArray =[userDetailDict valueForKey:@"checkpoints"];
    if (webservicecode == 1) {
        NSMutableArray *orderArray = [checkPointArray valueForKey:@"order"];
        NSMutableArray *checkPointsArray = [orderArray valueForKey:@"checkpoints"];
        NSLog(@"%@",checkPointsArray);
        ordersListArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [checkPointsArray count]; i++) {
            orderOC = [[Orders alloc] init];
            orderOC.checkpoint_id = [[[checkPointsArray valueForKey:@"checkpoint_id"]objectAtIndex:i] intValue];
            orderOC.checkpoint_latitude = [[checkPointsArray valueForKey:@"checkpoint_latitude"]objectAtIndex:i];
            orderOC.checkpoint_longitude = [[checkPointsArray valueForKey:@"checkpoint_longitude"]objectAtIndex:i];
            orderOC.descp = [[checkPointsArray valueForKey:@"description"]objectAtIndex:i];
            orderOC.instruction = [[checkPointsArray valueForKey:@"instruction"]objectAtIndex:i];
            orderOC.is_active = [[checkPointsArray valueForKey:@"is_active"]objectAtIndex:i];
            orderOC.last_updated = [[checkPointsArray valueForKey:@"last_updated"]objectAtIndex:i];
            orderOC.order_ID = [[checkPointsArray valueForKey:@"order_ID"]objectAtIndex:i];
            
            [ordersListArray addObject:orderOC];
        }
    }else{
        NSMutableArray *orderArray = [checkPointArray valueForKey:@"logs"];
        NSMutableArray *checkPointsArray = [orderArray valueForKey:@"checkpoints"];
        NSLog(@"%@",checkPointsArray);
        logListArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [checkPointsArray count]; i++) {
            logsOC = [[Logs alloc] init];
            logsOC.checkpoint_id = [[checkPointsArray valueForKey:@"checkpoint_id"]objectAtIndex:i];
            logsOC.is_active = [[checkPointsArray valueForKey:@"is_active"]objectAtIndex:i];
            logsOC.last_updated = [[checkPointsArray valueForKey:@"last_updated"]objectAtIndex:i];
            logsOC.logdescription = [[checkPointsArray valueForKey:@"description"]objectAtIndex:i];
            logsOC.log_ID = [[checkPointsArray valueForKey:@"log_ID"]objectAtIndex:i];
            logsOC.notes = [[checkPointsArray valueForKey:@"notes"]objectAtIndex:i];
            logsOC.observation = [[checkPointsArray valueForKey:@"observation"]objectAtIndex:i];
            logsOC.passedby_officer_contact_detail = [[checkPointsArray valueForKey:@"passedby_officer_contact_detail"]objectAtIndex:i];
            logsOC.passedby_officer_id = [[checkPointsArray valueForKey:@"passedby_officer_id"]objectAtIndex:i];
            logsOC.passedby_officer_name = [[checkPointsArray valueForKey:@"passedby_officer_name"]objectAtIndex:i];
            logsOC.shift_id = [[checkPointsArray valueForKey:@"shift_id"]objectAtIndex:i];
            
            [logListArray addObject:logsOC];
        }
    }
    [kappDelegate HideIndicator];
    [ordersHistoryTableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([viewType isEqualToString:@"order"]) {
        return [ordersListArray count];
    }else{
        return [logListArray count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    orderTableViewCell *cell = (orderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"orderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    if ([viewType isEqualToString:@"order"]) {
        orderOC = [ordersListArray objectAtIndex:indexPath.row];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where CheckPoint_Id= \"%d\"",orderOC.checkpoint_id];
        
        FMResultSet *results1 = [database executeQuery:queryString1];
        NSString *checkPointName;
        while([results1 next])
        {
            checkPointName=[NSString stringWithFormat:@"Associated CheckPoint: %@",[results1 stringForColumn:@"CheckPointName"]];
            
        }
        
        NSString *dateOfOrder = [NSString stringWithFormat:@"Date: %@",orderOC.last_updated];
        
        
        [cell setLabelText:orderOC.descp :dateOfOrder :checkPointName];
    }else{
        logsOC = [logListArray objectAtIndex:indexPath.row];
        NSString *dateOfOrder = [NSString stringWithFormat:@"Date: %@",logsOC.last_updated];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where CheckPoint_Id= \"%@\"",logsOC.checkpoint_id];
        
        FMResultSet *results1 = [database executeQuery:queryString1];
        NSString *checkPointName;
        while([results1 next])
        {
            checkPointName=[NSString stringWithFormat:@"Associated CheckPoint: %@",[results1 stringForColumn:@"CheckPointName"]];
            
        }
        [cell setLabelText:logsOC.logdescription :dateOfOrder :checkPointName ];
    }
    
    // ~~~~~~~~~ Date conpairison
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([viewType isEqualToString:@"order"]) {
        orderOC = [ordersListArray objectAtIndex:indexPath.row];
        OrderDetailViewController *orderDetailsVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        orderDetailsVC.orderOC = orderOC;
        orderDetailsVC.viewType = viewType;
        [self.navigationController pushViewController:orderDetailsVC animated:NO];
    }else{
        logsOC = [logListArray objectAtIndex:indexPath.row];
        OrderDetailViewController *orderDetailsVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        orderDetailsVC.logsOC = logsOC;
        orderDetailsVC.viewType = viewType;
        [self.navigationController pushViewController:orderDetailsVC animated:NO];
    }
    
}
- (IBAction)addLogsbttn:(id)sender {
    AddLogsViewController*nextVc=[[AddLogsViewController alloc]initWithNibName:@"AddLogsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
}
@end
