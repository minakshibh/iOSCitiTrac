//
//  LogDetailViewController.h
//  QRPatrol
//
//  Created by Br@R on 25/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logs.h"

@interface LogDetailViewController : UIViewController

- (IBAction)backBttn:(id)sender;
@property (strong,nonatomic)  Logs *logObj;
@end
