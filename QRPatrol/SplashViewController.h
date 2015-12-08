//
//  SplashViewController.h
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetDetailCommonView.h"

@interface SplashViewController : UIViewController
{
    GetDetailCommonView*getDetailView;
    NSMutableData*webData;
    NSString*guardPinStr;
    NSString*guardIdStr;
}
@end
