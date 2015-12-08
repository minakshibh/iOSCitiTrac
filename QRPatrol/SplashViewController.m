//
//  SplashViewController.m
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    self.navigationController.navigationBarHidden=YES;
    [super viewDidLoad];
    

    NSString*officerId=[[NSUserDefaults standardUserDefaults]valueForKey:@"Officer_Id"];
    
    if (![officerId isEqualToString:@"(null)"])
    {
        if (officerId.length!=0)
        {
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(GetDetails) userInfo:nil repeats:NO];
            
            
        }
        else{
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(MoveToLoginView) userInfo:nil repeats:NO];
        }
    }
    else{
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(MoveToLoginView) userInfo:nil repeats:NO];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)LoginWebCall
{
    guardPinStr= [[NSUserDefaults standardUserDefaults] valueForKey:@"guardPin"];
     guardIdStr= [[NSUserDefaults standardUserDefaults] valueForKey:@"guardId"];
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetDetails
{
    
    
    [self LoginWebCall];
    
   
    
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
            [self MoveToLoginView];
        }
        else
        {
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








-(void)MoveToLoginView
{
    LoginViewController *loginvc=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginvc animated:YES];
}
- (void)ReceivedResponse
{
    DashboardViewController*dashboardVc=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController: dashboardVc animated:YES];
}



@end
