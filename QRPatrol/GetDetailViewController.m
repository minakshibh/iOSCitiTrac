//
//  GetDetailViewController.m
//  QRPatrol
//
//  Created by Krishna Mac Mini 2 on 13/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "GetDetailViewController.h"
#import "PatrolViewController.h"
#import "DatabaseClass.h"
@interface GetDetailViewController ()

@end

@implementation GetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    txtDesc.delegate = self;
    
    lblEventname.text = @"SCAN";
    newValues = [[NSMutableArray alloc]initWithArray:_values];
    
    
    checkPointArray=[[NSMutableArray alloc]init];
    DatabaseClass *sharedManager = [DatabaseClass sharedManager];
    sharedManager.to_get_checkPoint_status = @"yes";
    sharedManager.check_id =[_values objectAtIndex:6];
    checkPointArray= [[sharedManager getCheckedScheduleDataFromDatabase]mutableCopy];
    scheduledOC = [checkPointArray objectAtIndex:0];
    // Do any additional setup after loading the view from its nib.
    
    
    lblCheckPoint.text = scheduledOC.CheckPointName;
    lblNotes.text =  scheduledOC.City;
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

- (IBAction)backbtn:(id)sender {
    PatrolViewController *obj = [[PatrolViewController alloc]initWithNibName:@"PatrolViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)imageBTN:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    // picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker
                       animated:YES completion:nil];
}

- (IBAction)btnDone:(id)sender {
    UIAlertView *alert;
    if([imagedata isEqualToData:nil] || [txtDesc.text isEqual:@""])
    {
        alert = [[UIAlertView alloc]initWithTitle:@"QR Patrol" message:@"Please select an image and enter values in description text." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [newValues addObject:imagedata];
    [newValues addObject:txtDesc.text];
    
    PatrolViewController *obj = [[PatrolViewController alloc]initWithNibName:@"PatrolViewController" bundle:nil];
    [obj remainingQRUpdate:(NSMutableArray*)newValues];
    
    [self.navigationController pushViewController:obj animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y =0;
    [scrollView setContentOffset:pt animated:YES];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (IS_IPHONE_4_OR_LESS)
    {
        if ( textField == txtDesc) {
            
            CGPoint pt;
            CGRect rc = [textField bounds];
            rc = [textField convertRect:rc toView:scrollView];
            pt = rc.origin;
            pt.x = 0;
            pt.y -=85;
            [scrollView setContentOffset:pt animated:YES];
        }
        
    }
    else
        if (textField == txtDesc) {
            
            CGPoint pt;
            CGRect rc = [textField bounds];
            rc = [textField convertRect:rc toView:self.view];
            pt = rc.origin;
            pt.x = 0;
            pt.y -=100;
            [scrollView setContentOffset:pt animated:YES];
        }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    imageView.image = chosenImage;
    float actualHeight = chosenImage.size.height;
    float actualWidth = chosenImage.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [chosenImage drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    imagedata = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:NULL];
    getImagebtn.hidden = YES;
}


@end
