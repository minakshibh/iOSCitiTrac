//
//  LoginViewController.h
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
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


@interface LoginViewController : UIViewController
{
    NSString*guardPinStr;
    NSString*guardIdStr;
    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    
    IBOutlet UILabel *guardPinBackLbl;
    IBOutlet UILabel *guardIdBackLbl;
    IBOutlet UIButton *loginBtn;

    GetDetailCommonView*getDetailView;
    
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;

    
    IBOutlet UITextField *guardIdTxt;
    IBOutlet UITextField *guardPinTxt;
}
- (IBAction)LoginBtn:(id)sender;
@end
