//
//  ChangePasswordViewController.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "GetDetailCommonView.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>

@interface ChangePasswordViewController : UIViewController
{
    
    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    
    
    
    IBOutlet UITextField *enterOldPassTxt;
    IBOutlet UIButton *changePasswrdbttn;
    IBOutlet UITextField *confirmPassTxt;
    IBOutlet UITextField *enterNewPassTxt;
    
    IBOutlet UILabel *oldPassLbl;
    
    IBOutlet UILabel *newPassLbl;
    IBOutlet UILabel *confirmPassLbl;
}
- (IBAction)backBttn:(id)sender;
- (IBAction)changePasswordBttn:(id)sender;

@end
