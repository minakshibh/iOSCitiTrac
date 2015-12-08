//
//  EventList.h
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventList : NSObject
@property (strong, nonatomic) NSString *eventId,*patrolID, *eventName, *Latitude, *Longitude,*CheckPoint_Id,*reportedTime,*Incident_Desc,*isSentViaEmail,*text,*imageUrl,*soundUrl;

@end
