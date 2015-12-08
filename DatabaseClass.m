    //
//  DatabaseClass.m
//  QRPatrol
//
//  Created by Br@R on 07/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "DatabaseClass.h"
#import "ScheduleList.h"
#import "Logs.h"

@implementation DatabaseClass

@synthesize someProperty;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static DatabaseClass *shareddatabase = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareddatabase = [[self alloc] init];
    });
    return shareddatabase;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
    }
    return self;
}

-(void)saveOfficerDetails :(NSDictionary*)officerDetailDict{
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
    
    NSString*OfficerId=[NSString stringWithFormat:@"%@",[officerDetailDict valueForKey:@"Officer_Id"]];
    
    if ([officerIdarray containsObject:OfficerId])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_OFFICER SET officerId = %@ , firstName = \"%@\", lastName = \"%@\", email =\"%@\", contactInfo = \"%@\" ,alt_info = \"%@\" , per_address = \"%@\", cur_address = \"%@\", State =\"%@\", City = \"%@\" ,Country = \"%@\", ZipCode =\"%@\", DOJ = \"%@\" ,shiftId = \"%@\" ,patrolId = \"%@\" , IsTestInProcess = \"%@\" , eventName = \"%@\"  where officerId = %@" , [officerDetailDict valueForKey:@"Officer_Id"],
                               [officerDetailDict valueForKey:@"firstname"],
                               [officerDetailDict valueForKey:@"lastname"],
                               [officerDetailDict valueForKey:@"email"],
                               [officerDetailDict valueForKey:@"contact_number"],
                               [officerDetailDict valueForKey:@"alt_c_number"],
                               [officerDetailDict valueForKey:@"permanent_address"],
                               [officerDetailDict valueForKey:@"current_address"],
                               [officerDetailDict valueForKey:@"state"],
                               [officerDetailDict valueForKey:@"city"],
                               [officerDetailDict valueForKey:@"country"],
                               [officerDetailDict valueForKey:@"zipcode"],
                               [officerDetailDict valueForKey:@"DOJ"],
                               [officerDetailDict valueForKey:@"shift_id"],
                               [officerDetailDict valueForKey:@"patrol_id"],
                               [officerDetailDict valueForKey:@"IsTestInProcess"],
                               [officerDetailDict valueForKey:@"event_name"],
                               [officerDetailDict valueForKey:@"Officer_Id"]
                               ];
        
        [[NSUserDefaults standardUserDefaults ]setValue:[officerDetailDict valueForKey:@"event_name"] forKey:@"eventName"];
        
        
        
        
        [database executeUpdate:updateSQL];
    }
    else{
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO TABLE_OFFICER (officerId, firstName, lastName, email, contactInfo, alt_info,per_address,cur_address,State,City,Country,ZipCode,DOJ,shiftId,patrolId,IsTestInProcess,eventName) VALUES (%@, \"%@\",\"%@\",\"%@\", \"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                            [officerDetailDict valueForKey:@"Officer_Id"],
                            [officerDetailDict valueForKey:@"firstname"],
                            [officerDetailDict valueForKey:@"lastname"],
                            [officerDetailDict valueForKey:@"email"],
                            [officerDetailDict valueForKey:@"contact_number"],
                            [officerDetailDict valueForKey:@"alt_c_number"],
                            [officerDetailDict valueForKey:@"permanent_address"],
                            [officerDetailDict valueForKey:@"current_address"],
                            [officerDetailDict valueForKey:@"state"],
                            [officerDetailDict valueForKey:@"city"],
                            [officerDetailDict valueForKey:@"country"],
                            [officerDetailDict valueForKey:@"zipcode"],
                            [officerDetailDict valueForKey:@"DOJ"],
                            [officerDetailDict valueForKey:@"shift_id"],
                            [officerDetailDict valueForKey:@"patrol_id"],
                            [officerDetailDict valueForKey:@"IsTestInProcess"],
                            [officerDetailDict valueForKey:@"event_name"]];
        [[NSUserDefaults standardUserDefaults ]setValue:[officerDetailDict valueForKey:@"event_name"] forKey:@"eventName"];


        [database executeUpdate:insert];
    }
    [database close];
    
}


//////////  INCEDENT//////////
-(void)saveIncedentDetails:(NSArray*)incedentdetail{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_INCIDENT "];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *incedentIdarray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        [incedentIdarray addObject:[results stringForColumn:@"Incident_Id"]];
    }
    
    for (int i=0; i<incedentdetail.count; i++)
    {
        NSDictionary*tempDict=[incedentdetail objectAtIndex:i];
        
        NSLog(@"%lu",(unsigned long)[tempDict count]);
        if ([tempDict count]>0)
        {
            NSString*incedentId=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"Incident_Id"]];
            
            if ([incedentIdarray containsObject:incedentId])
            {
                NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_INCIDENT SET  , Incident_Desc = \"%@\" where Incident_Id = %@" ,[tempDict valueForKey:@"inc_desc"],[tempDict valueForKey:@"inc_id"]];
                
                [database executeUpdate:updateSQL];
            }
            else
            {
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO TABLE_INCIDENT (Incident_Id, Incident_Desc, Incident_isChecked) VALUES (%@, \"%@\",\"%@\")",[tempDict valueForKey:@"inc_id"],[tempDict valueForKey:@"inc_desc"],@"False"];
                [database executeUpdate:insert];
            }
        }
    }
    
    [database close];
    
}
-(void)saveEventDetails:(NSArray*)eventdetail :(NSString*)patrolIdStr{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_EVENT "];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *eventPointIdArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        [eventPointIdArray addObject:[results stringForColumn:@"eventId"]];
    }
    
    
    for (int i=0; i<eventdetail.count; i++)
    {
        NSDictionary*tempDict=[eventdetail objectAtIndex:i];
        
        NSLog(@"%lu",(unsigned long)[tempDict count]);
        if ([tempDict count]>0)
        {
            NSString*event_Id=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"event_ID"]];
            
            if ([eventPointIdArray containsObject:event_Id])
            {
                NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_EVENT SET OfficerId = \"%@\" , patrolID = \"%@\", eventName = \"%@\", Latitude =\"%@\", Longitude = \"%@\" ,CheckPoint_Id = \"%@\" , reportedTime = \"%@\", Incident_Desc = \"%@\", isSentViaEmail =\"%@\", text = \"%@\" ,imageUrl = \"%@\", soundUrl =\"%@\" where eventId = \"%@\"" ,
                                       [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"],
                                       patrolIdStr,
                                       [tempDict valueForKey:@"event_name"],
                                       [tempDict valueForKey:@"latitude"],
                                       [tempDict valueForKey:@"longitude"],
                                       [tempDict valueForKey:@"checkpoint_ID"],
                                       [tempDict valueForKey:@"reported_time"],
                                       [tempDict valueForKey:@"incident_description"],
                                       [tempDict valueForKey:@"isSentViaEmail"],
                                       [tempDict valueForKey:@"text"],
                                       [tempDict valueForKey:@"imageurl"],
                                       [tempDict valueForKey:@"soundurl"],
                                       [tempDict valueForKey:@"event_ID"]];
                
                [database executeUpdate:updateSQL];
            }
            else
            {
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO TABLE_EVENT (OfficerId,eventId, patrolID, eventName, Latitude, Longitude,CheckPoint_Id,reportedTime,Incident_Desc,isSentViaEmail,text,imageUrl,soundUrl) VALUES (\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\")",
                                    [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"],
                                    [tempDict valueForKey:@"event_ID"],
                                    patrolIdStr,
                                    [tempDict valueForKey:@"event_name"],
                                    [tempDict valueForKey:@"latitude"],
                                    [tempDict valueForKey:@"longitude"],
                                    [tempDict valueForKey:@"checkpoint_ID"],
                                    [tempDict valueForKey:@"reported_time"],
                                    [tempDict valueForKey:@"incident_description"],
                                    [tempDict valueForKey:@"isSentViaEmail"],
                                    [tempDict valueForKey:@"text"],
                                    [tempDict valueForKey:@"imageurl"],
                                    [tempDict valueForKey:@"soundurl"]];
                
                
                [database executeUpdate:insert];
            }
        }
    }
    [database close];
}

-(void)deleteEvents{
    
}
-(void)saveOrderDetails:(NSArray*)orderdetail;
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM TABLE_EVENT"];
    
    [database executeUpdate:queryString1];
    
    [database close];
    
    

}
-(void)saveScheduleDetails :(NSArray*)schedulDetail{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE "];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *CheckPointIdArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        [CheckPointIdArray addObject:[results stringForColumn:@"CheckPoint_Id"]];
    }
    
    
    for (int i=0; i<schedulDetail.count; i++)
    {
        NSDictionary*tempDict=[schedulDetail objectAtIndex:i];
        
        NSLog(@"%lu",(unsigned long)[tempDict count]);
        if ([tempDict count]>0)
        {
            NSString*checkPoint_Id=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"checkpoint_id"]];
            
            if ([CheckPointIdArray containsObject:checkPoint_Id])
            {
                NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_SCHEDULE SET CheckPoint_Id = %@ , PrefferedTime = \"%@\", Priority = \"%@\", CheckPointName =\"%@\", Address = \"%@\" ,City = \"%@\" , State = \"%@\", Country = \"%@\", ZipCode =\"%@\", ContactInfo = \"%@\" ,AlternateContact = \"%@\", Latitude =\"%@\", Longitude = \"%@\" ,Notes = \"%@\",OpenTimings=\"%@\",CloseTimings=\"%@\",isChecked=\"%@\",CheckedTime=\"%@\"  , OfficerId=\"%@\"  where CheckPoint_Id = %@" ,
                                       [tempDict valueForKey:@"checkpoint_id"],
                                       [tempDict valueForKey:@"preffered_time"],
                                       [tempDict valueForKey:@"priority"],
                                       [tempDict valueForKey:@"checkpoint_name"],
                                       [tempDict valueForKey:@"address"],
                                       [tempDict valueForKey:@"city"],
                                       [tempDict valueForKey:@"state"],
                                       [tempDict valueForKey:@"country"],
                                       [tempDict valueForKey:@"zipcode"],
                                       [tempDict valueForKey:@"contact_info"],
                                       [tempDict valueForKey:@"alternate_contact"],
                                       [tempDict valueForKey:@"latitude"],
                                       [tempDict valueForKey:@"longitude"],
                                       [tempDict valueForKey:@"notes"],
                                       [tempDict valueForKey:@"open_timings"],
                                       [tempDict valueForKey:@"close_timing"],
                                       [tempDict valueForKey:@"isChecked"],
                                       [tempDict valueForKey:@"CheckedTime"],
                                       [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"],
                                       [tempDict valueForKey:@"checkpoint_id"]];
                
                [database executeUpdate:updateSQL];
            }
            else
            {
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO TABLE_SCHEDULE (CheckPoint_Id, PrefferedTime, Priority, CheckPointName, Address,City,State,Country,ZipCode,ContactInfo,AlternateContact,Latitude,Longitude,Notes,OpenTimings,CloseTimings,isChecked,CheckedTime,OfficerId) VALUES (%@, \"%@\",\"%@\",\"%@\", \"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",
                                    [tempDict valueForKey:@"checkpoint_id"],
                                    [tempDict valueForKey:@"preffered_time"],
                                    [tempDict valueForKey:@"priority"],
                                    [tempDict valueForKey:@"checkpoint_name"],
                                    [tempDict valueForKey:@"address"],
                                    [tempDict valueForKey:@"city"],
                                    [tempDict valueForKey:@"state"],
                                    [tempDict valueForKey:@"country"],
                                    [tempDict valueForKey:@"zipcode"],
                                    [tempDict valueForKey:@"contact_info"],
                                    [tempDict valueForKey:@"alternate_contact"],
                                    [tempDict valueForKey:@"latitude"],
                                    [tempDict valueForKey:@"longitude"],
                                    [tempDict valueForKey:@"notes"],
                                    [tempDict valueForKey:@"open_timings"],
                                    [tempDict valueForKey:@"close_timing"],
                                    [tempDict valueForKey:@"isChecked"],
                                    [tempDict valueForKey:@"CheckedTime"],
                                    [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"]
                                    ];
                
                [database executeUpdate:insert];
                
            }
        }
    }
    
    [database close];
    
}
-(void)saveLogDetails:(NSArray*)logsdetail
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_LOGS where logid "];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *logidArray=[[NSMutableArray alloc]init];
    
    while([results next])
    {
        [logidArray addObject:[results stringForColumn:@"logid"]];
    }
    
    
    for (int i=0; i<logsdetail.count; i++)
    {
        NSDictionary*tempDict=[logsdetail objectAtIndex:i];
        
        NSLog(@"%lu",(unsigned long)[tempDict count]);
        if ([tempDict count]>0)
        {
            NSString*log_Id=[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"log_ID"]];
            
            if ([logsdetail containsObject:log_Id])
            {
                NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_LOGS SET CheckPoint_Id = %@ , logid = \"%@\", passedbyofficerid = \"%@\", passedbyofficername =\"%@\", passedbyofficercontactdetail = \"%@\" ,description = \"%@\" , notes = \"%@\",isActive=\"%@\", observation = \"%@\", shiftid =\"%@\", lastupdated = \"%@\" where logid = %@" ,
                                       [tempDict valueForKey:@"checkpoint_id"],
                                       [tempDict valueForKey:@"log_ID"],
                                       [tempDict valueForKey:@"passedby_officer_id"],
                                       [tempDict valueForKey:@"passedby_officer_name"],
                                       [tempDict valueForKey:@"passedby_officer_contact_detail"],
                                       [tempDict valueForKey:@"description"],
                                       [tempDict valueForKey:@"notes"],
                                       [tempDict valueForKey:@"is_active"],
                                       [tempDict valueForKey:@"observation"],
                                       [tempDict valueForKey:@"shift_id"],
                                       [tempDict valueForKey:@"last_updated"],
                                       [tempDict valueForKey:@"log_ID"]
                                       ];
                [database executeUpdate:updateSQL];
            }
            else
            {
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO TABLE_LOGS (CheckPoint_Id, logid, passedbyofficerid, passedbyofficername, passedbyofficercontactdetail,description,notes,isActive,observation,shiftid,lastupdated) VALUES (%@, \"%@\",\"%@\",\"%@\", \"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\",\"%@\")",
                                    [tempDict valueForKey:@"checkpoint_id"],
                                    [tempDict valueForKey:@"log_ID"],
                                    [tempDict valueForKey:@"passedby_officer_id"],
                                    [tempDict valueForKey:@"passedby_officer_name"],
                                    [tempDict valueForKey:@"passedby_officer_contact_detail"],
                                    [tempDict valueForKey:@"description"],
                                    [tempDict valueForKey:@"notes"],
                                    [tempDict valueForKey:@"is_active"],
                                    [tempDict valueForKey:@"observation"],
                                    [tempDict valueForKey:@"shift_id"],
                                    [tempDict valueForKey:@"last_updated"]
                                    ];
                
                [database executeUpdate:insert];
                
            }
        }
    }
    
    [database close];
    
}


-(NSString *) getOfficerName
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString*officerIdStr=  [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER where officerId =\"%@\" ",officerIdStr];
    
    FMResultSet *results = [database executeQuery:queryString];

    NSString*name;
    while([results next])
    {
        name= [NSString stringWithFormat:@"%@ %@",[results stringForColumn:@"firstName"],[results stringForColumn:@"lastName"]];
    }

    
   // NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_OFFICER"];
    
    
    [database close];
    return name;
}


-(NSArray*) getScheduleDataFromDatabase
{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where OfficerId = \"%@\"", [[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray*scheduleListArray=[[NSMutableArray alloc]init];
    while([results next])
    {
        
        
        ScheduleList*scheduleObj=[[ScheduleList alloc]init];
        scheduleObj.CheckPoint_Id=[results stringForColumn:@"CheckPoint_Id"];
        scheduleObj.PrefferedTime=[results stringForColumn:@"PrefferedTime"];
        scheduleObj.Priority=[results stringForColumn:@"Priority"];
        scheduleObj.CheckPointName=[results stringForColumn:@"CheckPointName"];
        scheduleObj.Address=[results stringForColumn:@"Address"];
        scheduleObj.City=[results stringForColumn:@"City"];
        scheduleObj.State=[results stringForColumn:@"State"];
        scheduleObj.Country=[results stringForColumn:@"Country"];
        scheduleObj.ZipCode=[results stringForColumn:@"ZipCode"];
        scheduleObj.ContactInfo=[results stringForColumn:@"ContactInfo"];
        scheduleObj.AlternateContact=[results stringForColumn:@"AlternateContact"];
        scheduleObj.Latitude=[results stringForColumn:@"Latitude"];
        scheduleObj.Longitude=[results stringForColumn:@"Longitude"];
        scheduleObj.Notes=[results stringForColumn:@"Notes"];
        scheduleObj.OpenTimings=[results stringForColumn:@"OpenTimings"];
        scheduleObj.CloseTimings=[results stringForColumn:@"CloseTimings"];
        scheduleObj.isChecked=[results stringForColumn:@"isChecked"];
        scheduleObj.CheckedTime=[results stringForColumn:@"CheckedTime"];
        [scheduleListArray addObject:scheduleObj];
    }
    
    [database close];
    return  scheduleListArray;
}

-(NSArray*) getCheckedScheduleDataFromDatabase
{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString;
    if([_to_get_checkPoint_status isEqualToString:@"yes"])
       {
           queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where isChecked=\'%@\'& CheckPoint_Id=\'%@\'",[NSString stringWithFormat:@"true"],_check_id];
       }else if([_to_get_checkPoint_status isEqualToString:@"yes1"])
       {
           
        queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where CheckPoint_Id=\'%@\'",_check_id];
           
       }
       else{
    queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where isChecked=\'%@\'",[NSString stringWithFormat:@"true"]];
       }
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray*scheduleListArray=[[NSMutableArray alloc]init];
    while([results next])
    {
        
        
        ScheduleList*scheduleObj=[[ScheduleList alloc]init];
        scheduleObj.CheckPoint_Id=[results stringForColumn:@"CheckPoint_Id"];
        scheduleObj.PrefferedTime=[results stringForColumn:@"PrefferedTime"];
        scheduleObj.Priority=[results stringForColumn:@"Priority"];
        scheduleObj.CheckPointName=[results stringForColumn:@"CheckPointName"];
        scheduleObj.Address=[results stringForColumn:@"Address"];
        scheduleObj.City=[results stringForColumn:@"City"];
        scheduleObj.State=[results stringForColumn:@"State"];
        scheduleObj.Country=[results stringForColumn:@"Country"];
        scheduleObj.ZipCode=[results stringForColumn:@"ZipCode"];
        scheduleObj.ContactInfo=[results stringForColumn:@"ContactInfo"];
        scheduleObj.AlternateContact=[results stringForColumn:@"AlternateContact"];
        scheduleObj.Latitude=[results stringForColumn:@"Latitude"];
        scheduleObj.Longitude=[results stringForColumn:@"Longitude"];
        scheduleObj.Notes=[results stringForColumn:@"Notes"];
        scheduleObj.OpenTimings=[results stringForColumn:@"OpenTimings"];
        scheduleObj.CloseTimings=[results stringForColumn:@"CloseTimings"];
        scheduleObj.isChecked=[results stringForColumn:@"isChecked"];
        scheduleObj.CheckedTime=[results stringForColumn:@"CheckedTime"];
        [scheduleListArray addObject:scheduleObj];
    }
    
    [database close];
    return  scheduleListArray;
}

-(NSArray*) getLogsDataFromDatabase
{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_LOGS "];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray*logListArray=[[NSMutableArray alloc]init];
    while([results next])
    {
        
        Logs*logsObj=[[Logs alloc]init];
        logsObj.checkpoint_id=[results stringForColumn:@"CheckPoint_Id"];
        logsObj.log_ID=[results stringForColumn:@"logid"];
        logsObj.passedby_officer_id=[results stringForColumn:@"passedbyofficerid"];
        logsObj.passedby_officer_name=[results stringForColumn:@"passedbyofficername"];
        logsObj.passedby_officer_contact_detail=[results stringForColumn:@"passedbyofficercontactdetail"];
        logsObj.logdescription=[results stringForColumn:@"description"];
        logsObj.notes=[results stringForColumn:@"notes"];
        logsObj.is_active=[results stringForColumn:@"isActive"];
        logsObj.observation=[results stringForColumn:@"observation"];
        logsObj.shift_id=[results stringForColumn:@"shiftid"];
        logsObj.last_updated=[results stringForColumn:@"lastupdated"];
        [logListArray addObject:logsObj];
    }
    
    [database close];
    return  logListArray;
}






-(void)UpdatePatrolId :(NSString*)patrolId{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];

    NSString*OfficerId=[[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
   
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TABLE_OFFICER SET patrolId = \"%@\" where officerId = %@" ,patrolId,OfficerId ];
        
    
    [database executeUpdate:updateSQL];
       [database close];
}

-(NSArray*) getOrderDataFromDatabase:(NSString *)checkPointName
{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_SCHEDULE where CheckPointName = \"%@\"", checkPointName];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray*scheduleListArray=[[NSMutableArray alloc]init];
    while([results next])
    {
        
        
        ScheduleList*scheduleObj=[[ScheduleList alloc]init];
        scheduleObj.CheckPoint_Id=[results stringForColumn:@"CheckPoint_Id"];
        scheduleObj.PrefferedTime=[results stringForColumn:@"PrefferedTime"];
        scheduleObj.Priority=[results stringForColumn:@"Priority"];
        scheduleObj.CheckPointName=[results stringForColumn:@"CheckPointName"];
        scheduleObj.Address=[results stringForColumn:@"Address"];
        scheduleObj.City=[results stringForColumn:@"City"];
        scheduleObj.State=[results stringForColumn:@"State"];
        scheduleObj.Country=[results stringForColumn:@"Country"];
        scheduleObj.ZipCode=[results stringForColumn:@"ZipCode"];
        scheduleObj.ContactInfo=[results stringForColumn:@"ContactInfo"];
        scheduleObj.AlternateContact=[results stringForColumn:@"AlternateContact"];
        scheduleObj.Latitude=[results stringForColumn:@"Latitude"];
        scheduleObj.Longitude=[results stringForColumn:@"Longitude"];
        scheduleObj.Notes=[results stringForColumn:@"Notes"];
        scheduleObj.OpenTimings=[results stringForColumn:@"OpenTimings"];
        scheduleObj.CloseTimings=[results stringForColumn:@"CloseTimings"];
        scheduleObj.isChecked=[results stringForColumn:@"isChecked"];
        scheduleObj.CheckedTime=[results stringForColumn:@"CheckedTime"];
        [scheduleListArray addObject:scheduleObj];
    }
    
    [database close];
    return  scheduleListArray;
}

@end
