
//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GetDetailCommonView.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "DatabaseClass.h"

int patrolIdStr;

@implementation GetDetailCommonView
@synthesize GetDetaildelegate;

- (id)initWithFrame:(CGRect)frame officerId:(NSString *)officerId delegate:(id)theDelegate {
    
	if ((self = [super initWithFrame:frame]))
    {
        
        sharedManager = [DatabaseClass sharedManager];

		self.GetDetaildelegate = theDelegate;
        self.backgroundColor= [UIColor colorWithRed:16.0/255.0f green:22.0f/255.0f blue:38.0f/255.0f alpha:1];
        [self fetchIncidentWebCall];
    }
    return self;
}


#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    webdata = [[NSMutableData alloc]init];

    NSLog(@"Received Response");
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webdata =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data>>%@",data);
    [webdata appendData:data];


}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webdata length]);
  
    if ([webdata length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webdata encoding:NSUTF8StringEncoding];
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
                NSString*lastUpdated=[userDetailDict valueForKey:@"greatest_last_updated"];
                [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"greatest_last_updated"];
                
                NSArray*incident_list=[userDetailDict valueForKey:@"incident_list"];
                
                if (incident_list.count>0)
                {
                    [sharedManager saveIncedentDetails :incident_list ];
                }
                [self  fetchScheduleWebCall];

            }
            else if (webservice==2)
            {
                NSString*lastUpdated=[userDetailDict valueForKey:@"greatest_last_updated"];
                if ([lastUpdated isKindOfClass:[NSNull class]])
                {
                    lastUpdated=@"";
                }
                [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"Schedule_greatest_last_updated"];
                
                NSArray*schedule_list=[userDetailDict valueForKey:@"checkpoint"];
                
                
                if (schedule_list.count>0)
                {
                    [sharedManager saveScheduleDetails:schedule_list  ];
                }
                 [self  fetchEventsWebCall];
               
            }
             else if (webservice==3)
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
                    [sharedManager saveEventDetails :event_list :[NSString stringWithFormat:@"%d",patrolIdStr] ];
                    
                }
                [self fetchLogsWebCall];
            }
             else if (webservice==4)
             {
                 NSString*lastUpdated=[userDetailDict valueForKey:@"last_updated"];
                 if ([lastUpdated isKindOfClass:[NSNull class]])
                 {
                     lastUpdated=@"";
                 }
                 
                 [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"log_greatest_last_updated"];
                 
                 NSArray*logs=[[[userDetailDict valueForKey:@"checkpoints"] valueForKey:@"logs"] valueForKey:@"checkpoints"];
                 
                 if (logs.count>0)
                 {
                     [sharedManager saveLogDetails:logs ];
                     
                 }
                 webservice=5;
                 
                 [self FetchOrdersWebCall];
             }
            
             else if (webservice==5)
             {
                 NSString*lastUpdated=[userDetailDict valueForKey:@"last_updated"];
                 if ([lastUpdated isKindOfClass:[NSNull class]])
                 {
                     lastUpdated=@"";
                 }
                 
                 [[NSUserDefaults standardUserDefaults ]setValue:lastUpdated forKey:@"order_greatest_last_updated"];
                 
                 NSArray*logs=[[[userDetailDict valueForKey:@"checkpoints"] valueForKey:@"order"] valueForKey:@"checkpoints"];
                 
                 if (logs.count>0)
                 {
                     [sharedManager saveOrderDetails:logs ];
                     
                 }
                 webservice=6;
                 
                 [self.GetDetaildelegate ReceivedResponse];
             }
        }
    }
}

-(void)fetchLogsWebCall
{
    webservice=4;
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString*officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where officerId =\"%@\" ",officerIdStr];
    FMResultSet *results = [database executeQuery:queryString];
    NSString* checkpoint = @"";
    
    NSMutableArray *checkPtArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
    NSString* checkpointSt=@"";
       checkpointSt=[NSString stringWithFormat:@"%@",[results stringForColumn:@"checkpoint_id"]];
        
       // checkpointStr= [checkpointStr stringByReplacingOccurrencesOfString:@"(null)" withString:@"\"\""];
        if (checkpointSt.length!=0)
        {
           [ checkPtArray addObject:checkpointSt];
        }
    }
    
   checkpoint = [[checkPtArray valueForKey:@"description"] componentsJoinedByString:@""];

    for ( int j=0;j<checkPtArray.count;j++)
    {
        
        [checkPtArray objectAtIndex:j];
        
        
    }
    checkpointStr = [NSString stringWithFormat:@"%@",checkPtArray];
    checkpointStr = [checkpointStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    checkpointStr = [checkpointStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId =\"%@\"",officerIdStr];
    FMResultSet *results1 = [database executeQuery:queryString1];
    NSString*shiftIdStr = nil;
    
    while([results1 next])
    {
        shiftIdStr=[NSString stringWithFormat:@"%@",[results1 stringForColumn:@"shiftId"]];
    }
    
    
    
    [database close];
    
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"log_greatest_last_updated"];
    NSString*_postData ;
    if (lastUpdatedStr.length!=0)
    {
        _postData = [NSString stringWithFormat:@"shift_id=%@&checkpoint_id=%@&last_updated=%@",shiftIdStr,checkpointStr,lastUpdatedStr];
    }
    else{
        _postData = [NSString stringWithFormat:@"shift_id=%@&checkpoint_id=%@&last_updated= ",shiftIdStr,checkpointStr];
    }
    
    
    
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-logs.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webdata==nil)
        {
            webdata = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webdata=nil;
            webdata = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}
-(void)FetchOrdersWebCall
{
    webservice=5;
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString*officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where officerId =\"%@\" ",officerIdStr];
    FMResultSet *results = [database executeQuery:queryString];
    NSString* checkpoint = @"";
    
    NSMutableArray *checkPtArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        NSString* checkpointStr=@"";
        checkpointStr=[NSString stringWithFormat:@"%@",[results stringForColumn:@"checkpoint_id"]];
        
        checkpointStr= [checkpointStr stringByReplacingOccurrencesOfString:@"(null)" withString:@"\"\""];
        if (checkpointStr.length!=0)
        {
            [ checkPtArray addObject:checkpointStr];
        }
    }
    
    checkpoint = [[checkPtArray valueForKey:@"description"] componentsJoinedByString:@""];
    
    
    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId =\"%@\" ",officerIdStr];
    FMResultSet *results1 = [database executeQuery:queryString1];
    NSString*shiftIdStr = nil;
    
    while([results1 next])
    {
        shiftIdStr=[NSString stringWithFormat:@"%@",[results1 stringForColumn:@"shiftId"]];
    }
    
    
    
    [database close];
    
    
    
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"log_greatest_last_updated"];
    NSString*_postData ;
    if (lastUpdatedStr.length!=0)
    {
        _postData = [NSString stringWithFormat:@"shift_id=%@&checkpoint_id=%@&last_updated=%@",shiftIdStr,checkpoint,lastUpdatedStr];
    }
    else{
        _postData = [NSString stringWithFormat:@"shift_id=%@&checkpoint_id=%@&last_updated= ",shiftIdStr,checkpoint];
    }
    
    
    
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-orders.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webdata==nil)
        {
            webdata = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webdata=nil;
            webdata = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

-(void)fetchIncidentWebCall
{
    webservice=1;
    
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"greatest_last_updated"];
     NSString*_postData ;
    if (lastUpdatedStr.length!=0)
    {
        _postData = [NSString stringWithFormat:@"last_updated_date=%@",lastUpdatedStr];
    }
    else{
        _postData = [NSString stringWithFormat:@"last_updated_date= "];
    }
    
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-incident.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webdata==nil)
        {
            webdata = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webdata=nil;
            webdata = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}


 

-(void)fetchScheduleWebCall
{
    webservice=2;
    NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"Schedule_greatest_last_updated"];

    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString*officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId =\"%@\" ",officerIdStr];
        
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next])
    {
        shiftId=[NSString stringWithFormat:@"%@",[results stringForColumn:@"shiftId"]];
    }
        
    [database close];
  
     NSString*_postData ;
    if (lastUpdatedStr.length!=0)
    {
        _postData = [NSString stringWithFormat:@"officer_id=%@&shift_id=%@&last_updated_date=%@&trigger=all",officerIdStr,shiftId,lastUpdatedStr];
    }
    else{
        _postData = [NSString stringWithFormat:@"officer_id=%@&shift_id=%@&trigger=all&last_updated_date= ",officerIdStr,shiftId];
    }
    

    
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/officer-schedule.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webdata==nil)
        {
            webdata = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webdata=nil;
            webdata = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
    
}

-(void)fetchEventsWebCall
{
    
        webservice=3;
        
        NSString*lastUpdatedStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"event_greatest_last_updated"];
    
   // nsdate *date = [NSDate ]
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
         NSString*officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
        
        NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId= \"%@\"",officerIdStr];
        
        FMResultSet *results = [database executeQuery:queryString];
        
        while([results next])
        {
                patrolIdStr=[[results stringForColumn:@"patrolId"]intValue];
        }
        //  patrolId=@"2";
        
        [database close];
        
        NSString*_postData ;
        
        
        if (lastUpdatedStr.length!=0)
        {
            _postData = [NSString stringWithFormat:@"patrol_id=%d&last_updated_date=%@",patrolIdStr,lastUpdatedStr];
        }
        else{
            _postData = [NSString stringWithFormat:@"patrol_id=%d&last_updated_date= ",patrolIdStr];
        }
        
        NSLog(@"data post >>> %@",_postData);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-event.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        
        
        
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webdata==nil)
            {
                webdata = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webdata=nil;
                webdata = [NSMutableData data] ;
            }
            NSLog(@"server connection made");
        }
        else
        {
            NSLog(@"connection is NULL");
        }
        
    
}



////////// GET OFFICER DETAIL /////////

-(void) getOffiverDetail :(NSString*)shiftId :(NSString*)checkpoint_id :(NSString*)last_updated
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER "];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *officerIdarray=[[NSMutableArray alloc]init];
    while([results next])
    {
        [officerIdarray addObject:[results stringForColumn:@"officerId"]];
    }
    
    [database close];
    
}
@end
