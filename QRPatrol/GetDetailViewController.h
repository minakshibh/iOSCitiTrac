//
//  GetDetailViewController.h
//  QRPatrol
//
//  Created by Krishna Mac Mini 2 on 13/07/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetDetailViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *getImagebtn;
    IBOutlet UILabel *lblNotes;
    IBOutlet UILabel *lblEventname;
    IBOutlet UILabel *lblCheckPoint;
    IBOutlet UITextField *txtDesc;
    IBOutlet UIImageView *imageView;
    NSMutableArray *newValues,*checkPointArray;
    NSData *imagedata ;
      ScheduleList *scheduledOC;
}
- (IBAction)backbtn:(id)sender;
- (IBAction)imageBTN:(id)sender;
- (IBAction)btnDone:(id)sender;


@property (strong,nonatomic) NSArray *values;
@end
