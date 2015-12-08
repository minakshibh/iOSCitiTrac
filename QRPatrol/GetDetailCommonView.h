//
//  DDCalendarView.h
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "DatabaseClass.h"


@protocol GetDetailCommonViewDelegate <NSObject>

@optional
- (void)ReceivedResponse ;

@end

@interface GetDetailCommonView : UIView  {
    id <GetDetailCommonViewDelegate> GetDetaildelegate;

    int webservice;
    NSString*shiftId  ;
      // NSString*OfficerId;
    NSMutableData*webdata;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath,*checkpointStr;
    FMDatabase *database;
    DatabaseClass *sharedManager ;
}

@property(nonatomic, assign) id <GetDetailCommonViewDelegate> GetDetaildelegate;

- (id)initWithFrame:(CGRect)frame officerId:(NSString *)officerId delegate:(id)theDelegate;
-(void)fetchIncidentWebCall;

//- (void)addBookingBtnPressed:(id)sender;

@end




