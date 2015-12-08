//
//  ChangePasswordViewController.m
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oldPassLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    oldPassLbl.layer.borderWidth=1.5f;
    oldPassLbl.layer.cornerRadius=5.0;
    
    newPassLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    newPassLbl.layer.borderWidth=1.5f;
    newPassLbl.layer.cornerRadius=5.0;
    
    confirmPassLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    confirmPassLbl.layer.borderWidth=1.5f;
    confirmPassLbl.layer.cornerRadius=5.0;

    
    changePasswrdbttn.layer.borderColor=[UIColor clearColor].CGColor;
    changePasswrdbttn.layer.borderWidth=1.0f;
    changePasswrdbttn.layer.cornerRadius=5.5;

    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBttn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePasswordBttn:(id)sender
{
    [self.view endEditing:YES];
     NSString*currentPassStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"guardPin"];
    NSString*IdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"guardId"];

    
    NSString*oldPassStr=[NSString stringWithFormat:@"%@",enterOldPassTxt.text];
    NSString*newPassStr=[NSString stringWithFormat:@"%@",enterNewPassTxt.text];
    NSString*ConfrmPassStr=[NSString stringWithFormat:@"%@",enterNewPassTxt.text];

    if (oldPassStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter your current password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if (![oldPassStr isEqualToString:currentPassStr])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Current password doesn't match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if (newPassStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter new password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if (ConfrmPassStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please enter password to confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if (![ConfrmPassStr isEqualToString:newPassStr])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"new password deosn't match to confirm password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [kappDelegate ShowIndicator];
    
    NSString *_postData = [NSString stringWithFormat:@"guardid=%@&pass=%@",IdStr,newPassStr];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/change-pass.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    [kappDelegate HideIndicator];
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    //responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            [[NSUserDefaults standardUserDefaults] setValue:confirmPassTxt.text forKey:@"guardPin"];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Password change successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert.tag=1;
            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
