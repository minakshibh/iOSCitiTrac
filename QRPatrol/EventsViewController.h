//
//  EventsViewController.h
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface EventsViewController : UIViewController
{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UITableView *eventsTableView;
    NSMutableArray*eventListArray;
    
}


- (IBAction)backBttn:(id)sender;
@end
