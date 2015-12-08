//
//  Orders.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Orders : NSObject
@property (strong, nonatomic) NSString *checkpoint_latitude,*checkpoint_longitude,*descp,*instruction,*is_active,*last_updated,*order_ID;
@property (assign, nonatomic) int checkpoint_id;
@end
