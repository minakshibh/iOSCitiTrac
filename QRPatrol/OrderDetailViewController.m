//
//  OrderDetailViewController.m
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ScheduleDetailViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "OrdersViewController.h"
@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController
@synthesize orderOC,viewType,logsOC;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([viewType isEqualToString:@"order"]) {
        orderDetailTitleLbl.text = @"Order Detail";
        notesTitlelbl.hidden = YES;
        notesLbl.hidden =YES;
        notesLineLbl.hidden = YES;
        passedByLbl.hidden = YES;
        passedByTitle.hidden = YES;
        passedByLblLine.hidden =YES;
        instructionTitle.text = @"Instructions :";
        orderIDLbl.text = [NSString stringWithFormat:@"OrderId : %@",orderOC.order_ID];
        descriptionLbl.text = [NSString stringWithFormat:@"%@",orderOC.descp];
        instructionLbl.text = [NSString stringWithFormat:@"%@",orderOC.instruction];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where CheckPoint_Id= \"%d\"",orderOC.checkpoint_id];
        
        FMResultSet *results1 = [database executeQuery:queryString1];
        
        while([results1 next])
        {
            checkPointName=[NSString stringWithFormat:@"%@",[results1 stringForColumn:@"CheckPointName"]];
            officerIdStr = [NSString stringWithFormat:@"%@",[results1 stringForColumn:@"OfficerId"]];
        }
        checkpointLbl.text = [NSString stringWithFormat:@"CheckPoint: %@",checkPointName];
    }else{
        orderDetailTitleLbl.text = @"Log Detail";
        notesTitlelbl.hidden = NO;
        notesLbl.hidden =NO;
        notesLineLbl.hidden = NO;
        passedByLbl.hidden = NO;
        passedByTitle.hidden = NO;
        passedByLblLine.hidden =NO;
        instructionTitle.text = @"Observations :";
        orderIDLbl.text = [NSString stringWithFormat:@"LogId : %@",logsOC.log_ID];
        descriptionLbl.text = [NSString stringWithFormat:@"%@",logsOC.logdescription];
        instructionLbl.text = [NSString stringWithFormat:@"%@",logsOC.observation];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *checkpointIdStr = [NSString stringWithFormat:@"%@",logsOC.checkpoint_id];
        checkpointIdStr = [checkpointIdStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where CheckPoint_Id= \"%@\"",checkpointIdStr];
        
        FMResultSet *results1 = [database executeQuery:queryString1];
        
        while([results1 next])
        {
            checkPointName=[NSString stringWithFormat:@"%@",[results1 stringForColumn:@"CheckPointName"]];
            officerIdStr = [NSString stringWithFormat:@"%@",[results1 stringForColumn:@"OfficerId"]];
        }
        checkpointLbl.text = [NSString stringWithFormat:@"CheckPoint: %@",checkPointName];
        notesLbl.text = [NSString stringWithFormat:@"%@",logsOC.notes];
        passedByLbl.text = [NSString stringWithFormat:@"%@",logsOC.passedby_officer_name];
    }
    contactOfficerBtn.layer.borderColor = [UIColor clearColor].CGColor;
    contactOfficerBtn.layer.borderWidth = 1.0;
    contactOfficerBtn.layer.cornerRadius = 4.0;
    [contactOfficerBtn setClipsToBounds:YES];
    
    viewCheckpointBtn.layer.borderColor = [UIColor clearColor].CGColor;
    viewCheckpointBtn.layer.borderWidth = 1.0;
    viewCheckpointBtn.layer.cornerRadius = 4.0;
    [viewCheckpointBtn setClipsToBounds:YES];
    
    markAsCheckedBtn.layer.borderColor = [UIColor clearColor].CGColor;
    markAsCheckedBtn.layer.borderWidth = 1.0;
    markAsCheckedBtn.layer.cornerRadius = 4.0;
    [markAsCheckedBtn setClipsToBounds:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewCheckPointBtnAction:(id)sender {
    orderListArray = [[NSMutableArray alloc] init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    orderListArray= [[ sharedManager getOrderDataFromDatabase:checkPointName]mutableCopy];
    ScheduleList *scheduleObj ;
    
    scheduleObj = (ScheduleList *)[orderListArray objectAtIndex:0];
    ScheduleDetailViewController *scheduleVC = [[ScheduleDetailViewController alloc] initWithNibName:@"ScheduleDetailViewController" bundle:nil];
    
    scheduleVC.scheduleObj = scheduleObj;
    [self.navigationController pushViewController:scheduleVC animated:NO];
    
}

- (IBAction)markAsCheckedBtnAction:(id)sender {
        [kappDelegate ShowIndicator];
    NSString *triggerValue, *idsStr;
    if ([viewType isEqualToString:@"order"]) {
        triggerValue = [NSString stringWithFormat:@"order"];
        idsStr = [NSString stringWithFormat:@"%@",orderOC.order_ID];
        
    }else{
        triggerValue = [NSString stringWithFormat:@"log"];
        idsStr = [NSString stringWithFormat:@"%@",logsOC.log_ID];
    }
    
        
        NSString *_postData = [NSString stringWithFormat:@"officer_id=%@&id=%@&trigger=%@",officerIdStr,idsStr,triggerValue];
        NSLog(@"data post >>> %@",_postData);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mark-log-done.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (IBAction)contactOfficerBtnAction:(id)sender {
    NSURL *url = [NSURL URLWithString:@"telprompt://09463588928"];
    [[UIApplication  sharedApplication] openURL:url];
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
    NSLog(@"%@",userDetailDict);
    int result = [[userDetailDict valueForKey:@"result"] intValue];
    if (result == 0) {
        
            OrdersViewController *orderVC = [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
            orderVC.viewType = viewType;
            [self.navigationController pushViewController:orderVC animated:NO];
       
        
    }
    [kappDelegate HideIndicator];
}
@end
