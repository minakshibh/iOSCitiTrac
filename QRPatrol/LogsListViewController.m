//
//  LogsListViewController.m
//  QRPatrol
//
//  Created by Br@R on 22/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "LogsListViewController.h"
#import "Logs.h"
#import "LogDetailViewController.h"
#import "AddLogsViewController.h"

@interface LogsListViewController ()

@end

@implementation LogsListViewController

- (void)viewDidLoad {
    
    Logs*logsObj=[[Logs alloc]init];
    
    logListArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    logListArray= [[ sharedManager getLogsDataFromDatabase]mutableCopy];
    [logsTableView reloadData];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addLogsbttn:(id)sender {
    AddLogsViewController*nextVc=[[AddLogsViewController alloc]initWithNibName:@"AddLogsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (IBAction)BackBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [logListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UILabel*checkPointName= [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 290,30)];
    checkPointName.backgroundColor = [UIColor clearColor];
    checkPointName.textColor=[UIColor redColor];
    checkPointName.numberOfLines=1;
    checkPointName.font =  [UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:checkPointName ];
    
    UILabel*preferTimeLbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 290,30)];
    preferTimeLbl.backgroundColor = [UIColor clearColor];
    preferTimeLbl.numberOfLines=1;
    preferTimeLbl.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:preferTimeLbl ];
    
    
    UILabel*noteslbl= [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 40,30)];
    noteslbl.backgroundColor = [UIColor clearColor];
    noteslbl.numberOfLines=1;
    noteslbl.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:noteslbl ];
    noteslbl.text=@"Note :";
    
    
    CGRect textViewFrame = CGRectMake(50, 50, 220,50);
    UITextView *notestextView = [[UITextView alloc] initWithFrame:textViewFrame];
    notestextView.backgroundColor = [UIColor clearColor];
    notestextView.font = [UIFont boldSystemFontOfSize:13];
    notestextView.returnKeyType = UIReturnKeyDone;
    [notestextView setEditable:NO];
    [cell.contentView addSubview:notestextView];
    
    if ( IS_IPHONE_6P || IS_IPHONE_6)
    {
        checkPointName.frame= CGRectMake(10, 1, 330,30);
        preferTimeLbl.frame= CGRectMake(10, 25, 330,30);
        notestextView.frame= CGRectMake(60, 50, 330,50);
        noteslbl.frame=CGRectMake(10, 50, 50,50);
    }
    
    
    Logs*loglistObj = [logListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    
    checkPointName.text=[NSString stringWithFormat:@"%@",loglistObj.logdescription];
    preferTimeLbl.text=[NSString stringWithFormat:@"Date : %@",loglistObj.last_updated];
  //  notestextView.text=[NSString stringWithFormat:@"Associated checkPoint:%@",loglistObj.Notes];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    Logs *logObj  = (Logs *)[logListArray objectAtIndex:indexPath.row];
    
    LogDetailViewController*logDetailVc=[[LogDetailViewController alloc]initWithNibName:@"LogDetailViewController" bundle:[NSBundle mainBundle]];
    logDetailVc.logObj=logObj;
    [self.navigationController pushViewController:logDetailVc  animated:YES];
}



@end
