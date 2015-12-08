//
//  EventsViewController.m
//  QRPatrol
//
//  Created by Br@R on 06/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "EventsViewController.h"
#import "EventList.h"
#import "EventDetailViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)viewDidLoad {
    eventListArray=[[NSMutableArray alloc]init];
    
    [self getEventDataFromDatabase];
    [eventsTableView reloadData];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) getEventDataFromDatabase
{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TABLE_EVENT"];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next])
    {
        EventList*eventListObj=[[EventList alloc]init];
        
        eventListObj.eventId =[results stringForColumn:@"eventId"];
        eventListObj.patrolID=[results stringForColumn:@"patrolID"];
        eventListObj.eventName=[results stringForColumn:@"eventName"];
                eventListObj.Latitude=[results stringForColumn:@"Latitude"];
        eventListObj.Longitude=[results stringForColumn:@"Longitude"];
        eventListObj.CheckPoint_Id=[results stringForColumn:@"CheckPoint_Id"];
        eventListObj.reportedTime=[results stringForColumn:@"reportedTime"];
        eventListObj.Incident_Desc=[results stringForColumn:@"Incident_Desc"];
        eventListObj.isSentViaEmail=[results stringForColumn:@"isSentViaEmail"];
        eventListObj.text=[results stringForColumn:@"text"];
        eventListObj.imageUrl=[results stringForColumn:@"imageUrl"];
        eventListObj.soundUrl=[results stringForColumn:@"soundUrl"];
        
        [eventListArray addObject:eventListObj];
    }
    
    [database close];
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [eventListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   
    UILabel*eventName;
    UILabel*preferTimeLbl;
    UILabel*noteslbl;
    UITextView *notestextView;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
         }
//        eventName= [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 290,30)];
//        eventName.backgroundColor = [UIColor clearColor];
//        eventName.textColor=[UIColor redColor];
//        eventName.numberOfLines=1;
//        eventName.font =  [UIFont boldSystemFontOfSize:14];
//        [cell.contentView addSubview:eventName ];
//        
//        preferTimeLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 290,30)];
//        preferTimeLbl.backgroundColor = [UIColor clearColor];
//        preferTimeLbl.numberOfLines=1;
//        preferTimeLbl.font = [UIFont boldSystemFontOfSize:13];
//        [cell.contentView addSubview:preferTimeLbl ];
//        
//        
//        noteslbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 40,30)];
//        noteslbl.backgroundColor = [UIColor clearColor];
//        noteslbl.numberOfLines=1;
//        noteslbl.font = [UIFont boldSystemFontOfSize:13];
//        [cell.contentView addSubview:noteslbl ];
//       // noteslbl.text=@"Note :";
//        
//        
//        CGRect textViewFrame = CGRectMake(50, 50, 220,50);
//        notestextView = [[UITextView alloc] initWithFrame:textViewFrame];
//        notestextView.backgroundColor = [UIColor clearColor];
//        notestextView.font = [UIFont boldSystemFontOfSize:13];
//        notestextView.returnKeyType = UIReturnKeyDone;
//        [notestextView setEditable:NO];
//       // [cell.contentView addSubview:notestextView];
//        
//        if ( IS_IPHONE_6P || IS_IPHONE_6)
//        {
//            eventName.frame= CGRectMake(10, 1, 330,30);
//            preferTimeLbl.frame= CGRectMake(10, 25, 330,30);
//           // notestextView.frame= CGRectMake(60, 50, 330,50);
//           // noteslbl.frame=CGRectMake(10, 50, 50,50);
//        }
   
    
    
    EventList*eventlistObj = (EventList *)[eventListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    
    //eventName.text=[NSString stringWithFormat:@"%@",eventlistObj.eventName];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor=[UIColor redColor];
    cell.textLabel.numberOfLines=1;
    cell.textLabel.font =  [UIFont boldSystemFontOfSize:14];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",eventlistObj.eventName];
   // preferTimeLbl.text=[NSString stringWithFormat:@"Reported time : %@",eventlistObj.reportedTime];
    
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.numberOfLines=1;
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Reported time : %@",eventlistObj.reportedTime];
   // notestextView.text=[NSString stringWithFormat:@"%@",eventlistObj.text];
    //noteslbl.text=[NSString stringWithFormat:@"CheckPoint:"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
   
    
    EventList *eventObj = (EventList *)[eventListArray objectAtIndex:indexPath.row];
    
    
//    if([eventObj.eventName isEqualToString:@"START"] || [eventObj.eventName isEqualToString:@"SOS"])
//        {
//            
//        }else{
//
    
    
    EventDetailViewController*eventDetailVc=[[EventDetailViewController alloc]initWithNibName:@"EventDetailViewController" bundle:[NSBundle mainBundle]];
    eventDetailVc.eventObj=eventObj;
    
    if ([eventObj.eventName isEqualToString:@"MME"])
    {
        eventDetailVc.unhide_PlayVideo = @"yes";
    }
    
    [self.navigationController pushViewController:eventDetailVc  animated:YES];
//        }
}
@end
