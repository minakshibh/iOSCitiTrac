//
//  AppDelegate.m
//  QRPatrol
//
//  Created by Br@R on 31/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //required background modes
    //App registers for location updates in item 0
    [self createCopyOfDatabaseIfNeeded];
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
           NSLog(@"Family:'%@'",fontfamilyname);
    }
    //Get current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    
    NSLog(@"%f %f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    

    
    [GMSServices provideAPIKey:kAPIKey];
    
    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUDID=myDevice1.UUIDString;
    NSLog(@"Device udid is %@",deviceUDID);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
        
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
#endif

    

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav;
    SplashViewController *splashVc;
    
    splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
    nav=[[UINavigationController alloc]initWithRootViewController:splashVc];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [kappDelegate HideIndicator];
    // UIApplicationState state = [application applicationState];
    NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)_deviceToken
{
    
    // Get a hex string from the device token with no spaces or < >
    NSString*deviceToken = [[[[_deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Device Token: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Defined Functions

// Function to Create a writable copy of the bundled default database in the application Documents directory.
- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"QRPatrol.sqlite"];
    NSLog(@"db path %@", dbPath);
    NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:dbPath]);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"QRPatrol.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        //NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:defaultDBPath]);
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        } else {
            NSLog(@"DB copied.");
        }
    }else {
        NSLog(@"DB exists, no need to copy.");
    }
    
}
#pragma mark - Show Indicator

-(void)ShowIndicator
{
    // DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (IS_IPHONE_5 )
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 700)];
        
    }
    else if (IS_IPHONE_4_OR_LESS )
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
        
    }
    else if (IS_IPHONE_6)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 700)];
        
    }
    else if(IS_IPHONE_6P)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 800)];
    }
    
    DisableView.backgroundColor=[UIColor blackColor];
    DisableView.alpha=0.5;
    [self.window addSubview:DisableView];
    
    activityIndicatorObject.color=[UIColor grayColor];
    [DisableView addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];
}

#pragma mark - Hide Indicator

-(void)HideIndicator
{
    [activityIndicatorObject stopAnimating];
    [DisableView removeFromSuperview];
    
}

@end
