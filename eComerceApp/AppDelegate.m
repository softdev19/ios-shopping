//
//  AppDelegate.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "JACenterViewController.h"
#import "JALeftViewController.h"
#import "JARightViewController.h"
#import "OCTabarController.h"
#import "OCPlistParser.h"
#import "OCMenuSideViewController.h"
#import "OCNavigationController.h"
#import "OCLauncherViewController.h"
#import "MMMaterialDesignSpinner.h"
#import "OCsocialViewController.h"

UINavigationController *centerNavi;
OCLauncherViewController *launchLoaderViewController;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [self setupRootController];
    [self addActivitiIndicator];
    [self registerNotification];
    
    [self.window makeKeyAndVisible];
    [self addLaunchLoaderView];
    
    NSDictionary *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        [self application:application didReceiveRemoteNotification:notification];
    }
    
    [self registerToRemoteNotifications];

    return YES;
}

- (void)setupRootController {
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    self.viewController.leftPanel = [[OCMenuSideViewController alloc] initWithNibName:@"OCMenuSideViewController" bundle:nil];
    self.viewController.bounceOnCenterPanelChange = NO;
    self.viewController.leftGapPercentage = 0.85;
    
//    OCTabarController* centerController = [[OCTabarController alloc] init];
    self.viewController.centerPanel = [[OCTabarController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:centerController];

//    self.viewController.centerPanel = nav;
    
    self.viewController.rightPanel = nil;//[[JARightViewController alloc] init];
    
//    [centerController setupNavigationBar];
    self.window.rootViewController = self.viewController;
}

- (void)addActivitiIndicator {

    self.activitiIndicator = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(self.window.center.x, self.window.center.y, 40, 40)];
    self.activitiIndicator.center = self.window.center;
    self.activitiIndicator.hidesWhenStopped = YES;
    self.activitiIndicator.hidden = NO;
    [self.activitiIndicator stopAnimating];
    self.activitiIndicator.tintColor = [UIColor grayColor];
    
//    [self.viewController.view addSubview:self.activitiIndicator];
    [self.window addSubview:self.activitiIndicator];
}

- (void)addLaunchLoaderView {
    launchLoaderViewController = [[OCLauncherViewController alloc] initWithNibName:@"OCLauncherViewController" bundle:nil];
    [self.window.rootViewController presentViewController:launchLoaderViewController animated:NO completion:nil];
    
//    centerController
}

- (void)ocLoaderDidFinishLoading:(NSNotification *)aNotification {

    NSLog(@"ocLoaderDidFinishLoading");
    [launchLoaderViewController dismissAnimated];

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

    NSLog(@"notificationSettings: %@", notificationSettings);
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    NSLog(@"identifier: %@", identifier);
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSArray *)userInfo {
    
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground ) {
        UIViewController *centerPanel = self.viewController.centerPanel;
        NSString *payload = [userInfo valueForKey:@"aps"];
        NSString *linkapp = [payload valueForKey:@"linkapp"];
        if (linkapp && [centerPanel isKindOfClass:[OCTabarController class]]) {
            NSURLComponents *components = [[NSURLComponents alloc] initWithString:linkapp];
            NSString *host = components.host;
            NSRange range = [host rangeOfString:@"tab"];
            if (range.location == 0) {
                NSString *tabString = [host substringFromIndex:range.length];
                NSInteger tabInt = 4 - tabString.integerValue;
                if (tabString.length > 0 && tabInt >= 0) {
                    NSURLQueryItem *parameters = components.queryItems.firstObject;
                    [(OCTabarController *)centerPanel showTabWithParameters:parameters AtIndex:tabInt];
                }
            }
        }
        NSLog(@"%@", userInfo);
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *newToken = [self stringWithDeviceToken:deviceToken];
    NSString *NCRN  = [[OCPlistParser sharedOCPlistParser] NCRN];
    NSString *action  = nil;
    NSString *tokenToSend = [NSString stringWithString:newToken];
    
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (value == nil) {
        action = @"oninstall";
        //  Should Install
    }else{
        if (![newToken isEqualToString:value]) {
            //  Should Update
            action  = @"onupdate";
            tokenToSend = [NSString stringWithFormat:@"%@/%@", newToken, value];
        }else {
            return;
        }
    }

    NSString *strUrl = [NSString stringWithFormat:@"http://ec2-52-25-5-142.us-west-2.compute.amazonaws.com/platformapp/%@/%@/%@/apns", action, tokenToSend, NCRN];
//    NSString *strUrl = [NSString stringWithFormat:@"http://ec2-52-25-5-142.us-west-2.compute.amazonaws.com/platformapp/%@/%@/%@/apns_sandbox", action, tokenToSend, NCRN];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL* url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
//    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate: self];
//    [connection start];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", [self stringWithDeviceToken:deviceToken]);

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
         switch (httpResponse.statusCode) {
             case 200:  //  OK
                 [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"deviceToken"];
                 [[NSUserDefaults standardUserDefaults] synchronize];

                 break;
                 
             case 400:  //  Invalid parameter
                 
                 break;
                 
             case 404:  //  Not found
                 
                 break;
                 
             case 500:  //  Error - could not create/delete/subscribe endpoint
                 
                 break;
                 
             default:
                 break;
         }
         if (error) {
             NSLog(@"error: %@", error);
         }else {
             NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

             NSLog(@"responseStr: %@", responseStr);
         }
     }];

    
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//    {

//    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://megatam.net/notifications/SaveToken.php?token=%@", [self stringWithDeviceToken:deviceToken]]];
//    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
//    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate: self];
//    [connection start];
//    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", [self stringWithDeviceToken:deviceToken]);
}

- (NSString*)stringWithDeviceToken:(NSData*)deviceToken {
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register for remote notifications: %@", [error localizedDescription]);
}

#pragma - Mark Handle Notification

- (void)registerToRemoteNotifications {
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocLoaderDidFinishLoading:) name:@"ocDoneLoadingMainPages" object:nil];
    
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userConnectionChanged:) name:OCUserConnecttion object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoader:) name:OCHideLoad object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoader:) name:OCShowLoad object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSideMenu:) name:OCShowSideMenu object:nil];
    
    
}

- (void)userConnectionChanged:(NSNotification *)aNotification {
    
}

- (void)hideLoader:(NSNotification *)aNotification {
    [self.activitiIndicator stopAnimating];
    [self.window sendSubviewToBack:self.activitiIndicator];
}

- (void)showLoader:(NSNotification *)aNotification {
    [self.window bringSubviewToFront:self.activitiIndicator];
    [self.activitiIndicator startAnimating];
}

- (void)showSideMenu:(NSNotification *)aNotification {
    [self.viewController toggleLeftPanel:nil];
}


#pragma - Mark Application Lifesycle
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
