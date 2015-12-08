//
//  DatabaseClass.h
//  QRPatrol
//
//  Created by Br@R on 07/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "ScheduleList.h"

@interface DatabaseClass : NSObject

{
    NSString *someProperty;
    
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic) NSString *to_get_checkPoint_status,*check_id;
+ (id)sharedManager;

-(void)saveOfficerDetails :(NSDictionary*)officerDetailDict;
-(void)saveIncedentDetails:(NSArray*)incedentdetail;
-(void)saveEventDetails:(NSArray*)eventdetail :(NSString*)patrolIdStr;
-(void)saveScheduleDetails :(NSArray*)schedulDetail;
-(void)saveLogDetails:(NSArray*)logsdetail;
-(void)saveOrderDetails:(NSArray*)orderdetail;
-(void)deleteEvents;
-(void)UpdatePatrolId :(NSString*)patrolId;

-(NSString *) getOfficerName;
-(NSArray*) getScheduleDataFromDatabase;
-(NSArray*) getCheckedScheduleDataFromDatabase;
-(NSArray*) getLogsDataFromDatabase;
-(NSArray*) getOrderDataFromDatabase:(NSString *)checkPointName;
@end
