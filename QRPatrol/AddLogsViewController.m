//
//  AddLogsViewController.m
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AddLogsViewController.h"

@interface AddLogsViewController ()

@end

@implementation AddLogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    [self GetOfficerDetailFromDataBase];
    

    enterDecLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    enterDecLbl.layer.borderWidth=1.5f;
    enterDecLbl.layer.cornerRadius=5.0;
    
    enterNotesLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    enterNotesLbl.layer.borderWidth=1.5f;
    enterNotesLbl.layer.cornerRadius=5.0;
    
    enterObsrvatioLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    enterObsrvatioLbl.layer.borderWidth=1.5f;
    enterObsrvatioLbl.layer.cornerRadius=5.0;
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)assignCheckpointBttn:(id)sender
{
    
    checkPointArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    
    checkPointArray= [[ sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    if (checkPointArray.count > 0) {
        checkedCheckPointView.hidden = NO;
        [checkedCheckpointTableView reloadData];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please scan the check point before passing any log"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

    
}


- (IBAction)passLogBttn:(id)sender
{
    [self.view endEditing:YES];
    NSString*currentPassStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"guardPin"];
    NSString*IdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"guardId"];
    
    NSString*discriptionStr=[NSString stringWithFormat:@"%@",enterDectxt.text];
    NSString*notesStr=[NSString stringWithFormat:@"%@",enterNotestxt.text];
    NSString*observationStr=[NSString stringWithFormat:@"%@",enterObsrvatioTxt.text];
    
    if (discriptionStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
   
    else if (notesStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter notes." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if (observationStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter observations ." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (checkpointStr == nil) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please Assign some checkpoint."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
    webservice=1;
    
    [kappDelegate ShowIndicator];
    
    _postData = [NSString stringWithFormat:@"officer_id=%@&description=%@&notes=%@&observation=%@&shift_id=%@&checkpoint_id=%@",officerIdStr,discriptionStr,notesStr,observationStr,shiftIdStr,checkpointStr];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/pass-logs.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

    
    
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
    
//    for ( int j=0;j<checkPtArray.count;j++)
//    {
//        if (j==0)
//        {
//            checkpointStr =[checkPtArray objectAtIndex:j];
//        }
//        else{
//            checkpointStr =[NSString stringWithFormat:@"%@,%@",checkpointStr,[checkPtArray objectAtIndex:j]];
//        }
//        
//    }
    
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Log added Succesfully"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1;
                [alert show];
            }
        }
    }
    [kappDelegate HideIndicator];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
    
    checkedCheckPointView.hidden = YES;
    scheduledOC = [checkPointArray objectAtIndex:indexPath.row];
    assignedCheckPointLbl.text = [NSString stringWithFormat:@"Assigned Checkpoint :%@",scheduledOC.CheckPointName];
   checkpointStr = [NSString stringWithFormat:@"%@",scheduledOC.CheckPoint_Id];
    
}

@end
