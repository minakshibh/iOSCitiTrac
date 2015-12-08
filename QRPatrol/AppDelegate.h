//
//  AppDelegate.h
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMapsM4B/GoogleMaps.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    UIActivityIndicatorView *activityIndicatorObject;
    UIView  *DisableView;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) CLLocationManager *locationManager;
-(void)ShowIndicator;
-(void)HideIndicator;



@end

