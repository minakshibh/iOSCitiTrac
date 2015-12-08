//
//  LoginViewController.m
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "DatabaseClass.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    guardIdBackLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    guardIdBackLbl.layer.borderWidth=1.5f;
    guardIdBackLbl.layer.cornerRadius=5.0;
    
    guardPinBackLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    guardPinBackLbl.layer.borderWidth=1.5f;
    guardPinBackLbl.layer.cornerRadius=5.0;
    
    loginBtn.layer.borderColor=[UIColor clearColor].CGColor;
    loginBtn.layer.borderWidth=1.0f;
    loginBtn.layer.cornerRadius=5.5;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginBtn:(id)sender {
    [self.view endEditing:YES];
    guardIdStr=[NSString stringWithFormat:@"%@",guardIdTxt.text];
    guardPinStr=[NSString stringWithFormat:@"%@",guardPinTxt.text];
    
    if (guardIdStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter Guard Id." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if (guardPinStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter Guard Pin." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [kappDelegate ShowIndicator];
    
    NSString *_postData = [NSString stringWithFormat:@"guardid=%@&pin=%@",guardIdStr,guardPinStr];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/officer-login.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }

}

#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    //  data = [NSData dataWithContentsOfURL:urlString];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.view.userInteractionEnabled=YES;
    [kappDelegate HideIndicator];

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.view.userInteractionEnabled=YES;
  //  [kappDelegate HideIndicator];
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    if ([webData length]==0)
        return;

    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];

    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
             [kappDelegate HideIndicator];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            [[NSUserDefaults standardUserDefaults] setValue:guardPinStr forKey:@"guardPin"];
            [[NSUserDefaults standardUserDefaults] setValue:guardIdStr forKey:@"guardId"];

            NSString*Officer_Id=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Officer_Id"]];
            [[NSUserDefaults standardUserDefaults]setValue:Officer_Id forKey:@"Officer_Id"];
         
            DatabaseClass *sharedManager = [DatabaseClass sharedManager];

            [ sharedManager saveOfficerDetails:userDetailDict];
            
            getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) officerId:Officer_Id delegate:self];
            [self.view addSubview: getDetailView];
            
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)ReceivedResponse {
    [kappDelegate HideIndicator];

    [self MoveToDashboard];
}
-(void)MoveToDashboard
{
    
    DashboardViewController*dashboardVC=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    guardIdTxt.text=@"";
    guardPinTxt.text=@"";
    [self.navigationController pushViewController:dashboardVC animated:YES];
}


@end
