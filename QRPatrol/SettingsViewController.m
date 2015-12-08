//
//  SettingsViewController.m
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangePasswordViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)changePasswrdBttn:(id)sender
{
    ChangePasswordViewController*nextVc=[[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextVc animated:YES];
}
@end
