//
//  DashboardViewController.m
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "DashboardViewController.h"
#import "PatrolViewController.h"
#import "ScheduleViewController.h"
#import "LogsListViewController.h"
#import "OrdersViewController.h"
#import "SettingsViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    
    NSString*name=[ sharedManager getOfficerName];

    nameLbl.text=[NSString stringWithFormat:@"Hi, %@ !!!  ",name];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkOutBttn:(id)sender
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    
    [defs synchronize];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"guardPin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"guardId"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Officer_Id"];
    
    LoginViewController*loginVc=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginVc animated:NO];
}

- (IBAction)aboutUsBTTn:(id)sender
{
    AboutUsViewController*nextVc=[[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (IBAction)settingBttn:(id)sender
{
    SettingsViewController*nextVc=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (IBAction)viewOrderBttn:(id)sender
{
    OrdersViewController*orderVc=[[OrdersViewController alloc]initWithNibName:@"OrdersViewController" bundle:[NSBundle mainBundle]];
    orderVc.viewType = @"order";
    [self.navigationController pushViewController:orderVc animated:YES];
}

- (IBAction)patrolBttn:(id)sender
{
    PatrolViewController*patrolVc=[[PatrolViewController alloc]initWithNibName:@"PatrolViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:patrolVc animated:YES];
}

- (IBAction)scheduleBttn:(id)sender
{
    ScheduleViewController*schduleVc=[[ScheduleViewController alloc]initWithNibName:@"ScheduleViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:schduleVc animated:YES];
}

- (IBAction)logsBttn:(id)sender
{
    OrdersViewController*orderVc=[[OrdersViewController alloc]initWithNibName:@"OrdersViewController" bundle:[NSBundle mainBundle]];
    orderVc.viewType = @"logs";
    [self.navigationController pushViewController:orderVc animated:YES];
}
@end
