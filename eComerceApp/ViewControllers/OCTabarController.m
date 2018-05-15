//
//  OCTabarController.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCTabarController.h"
#import "OCNavigationController.h"
#import "JASidePanelController.h"
#import "OCWebPageViewController.h"
#import "OCPlistParser.h"
#import "OCTabsView.h"
#import "AppDelegate.h"
#import "OCCartWebViewController.h"
#import "OCMainWebViewController.h"
#import "OCSocialObj.h"
#import "OCMenuDataObj.h"

@interface OCTabarController ()<OCTabsProtocol, UITabBarControllerDelegate, NSURLConnectionDelegate> {
    NSMutableData *responseData;
}


@property (nonatomic, retain) OCTabsView *tabsView;
@property (strong, nonatomic) OCMenuDataObj *menuObj;
@property (strong, nonatomic) NSURLQueryItem *parameters;
@end

@implementation OCTabarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;

    [self setupTabsView];
    [self setupPages];

    [self registerNotifications];
    [self loadViewControllers];

    OCTabsViewsObj* tabs = [[OCPlistParser sharedOCPlistParser] getTabsObject];
    [self pressDefaultTab];
    [self tabsTappedAtIndex:tabs.selectedTabIndex];

}

- (void)loadViewControllers
{
    for (int i = 0; i < self.viewControllers.count; i++) {
        [self setSelectedIndex:i];
    }
    [self setSelectedIndex:0];
}

- (void)dealloc
{
    [self unregisterNotifications];

}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeButtonTapped:) name:OCGoToHome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCartViewController) name:OCGoToCart object:nil];

    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNavigationStyle) name:OCCheckNavigationStyle object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OCGoToHome object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OCGoToCart object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:OCCheckNavigationStyle object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupPages {
    
    NSMutableArray* mutArr = [NSMutableArray array];
    
    OCTabsViewsObj* tabs = [[OCPlistParser sharedOCPlistParser] getTabsObject];
    
    for (int i = 0; (i < tabs.tabsDOArray.count) && (i < 5); i ++) {
        OCTabObj* tabOD = tabs.tabsDOArray[i];
        BOOL flag = NO;
        if (tabs.selectedTabIndex == i) {
            flag = YES;
        }
        OCNavigationController * nav = [[OCNavigationController alloc] initWith:tabOD isDefaultScreen:flag];
        [mutArr addObject:nav];
    }
    
    self.viewControllers = [NSArray arrayWithArray:mutArr];
    self.tabBar.hidden = YES;
    
}

- (void)reloadScreenIfNeeded {
    NSLog(@"selectedIndex: %lu", (unsigned long)self.selectedIndex);
    
    if (self.viewControllers <= 0) {
        return;
    }
    OCNavigationController *nav = self.viewControllers[self.selectedIndex];
    OCTabsViewsObj* tabs = [[OCPlistParser sharedOCPlistParser] getTabsObject];
    OCTabObj* tabOD = tabs.tabsDOArray[self.selectedIndex];
    if (tabOD.isReload) {
        id sceen = [nav.viewControllers firstObject];
        if ([sceen isKindOfClass:[OCMainWebViewController class]]) {
            [((OCMainWebViewController *)sceen) reloadWebview];
        }
    }
}

- (void)setupTabsView {
    self.tabsView = [[OCTabsView alloc] init]; //]WithFrame:CGRectMake(0, y, width, height)];
    self.tabsView.delegate = self;
    [self.tabsView setupTabsWith:[[OCPlistParser sharedOCPlistParser] getTabsObject]];
    self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.tabsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    

    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"didSelectViewController");

}

#pragma mark - OCTabsProtocol
- (void)homeButtonTapped:(id)sender {
    NSLog(@"homeButtonTapped");

    [self pressDefaultTab];
    [((OCNavigationController *)self.selectedViewController) popToRootViewControllerAnimated:YES];
}

- (void)pushCartViewController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        OCNavigationObj* navObj = [[OCPlistParser sharedOCPlistParser] getNavigationObject];
        
        OCCartWebViewController* webpageViewController = [[OCCartWebViewController alloc] initWithPageUrl:navObj.rightButton.url];
        
        [webpageViewController setupNavigationForMenuSideStyle];
        
        UINavigationController* navCont = [[UINavigationController alloc] initWithRootViewController:webpageViewController];
        navCont.view.backgroundColor = [UIColor whiteColor];
        
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:navCont animated:YES completion:nil];
    });
}

-(void)tabsTappedAtIndex:(NSInteger)index {
    
    //  If same button is tapped, then Pop to root.
    if (self.selectedIndex == index) {
        OCNavigationController *nav = self.viewControllers[self.selectedIndex];
        [nav popToRootViewControllerAnimated:YES];
        return;
    }

    [self setSelectedIndex:index];

    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];

    [self reloadScreenIfNeeded];
}

- (void)showTabWithParameters:(NSURLQueryItem *)parameters AtIndex:(NSInteger)index {
    
    [self.tabsView setSelectedTab:index];
    
    OCTabsViewsObj *tabs = [[OCPlistParser sharedOCPlistParser] getTabsObject];
    OCTabObj *tabOD = [tabs.tabsDOArray objectAtIndex:index];
    
    OCWebPageViewController *webpageViewController = nil;
    self.parameters = parameters;
    if ([parameters.name isEqualToString:@"networks"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", parameters.value];
        OCSocialObj *obj = [tabOD.listArray filteredArrayUsingPredicate:predicate].firstObject;
        
        webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:obj.SocialPageUrl];
        webpageViewController.DoNotCheckRedirects = YES;
        [webpageViewController setupCartButtonOnRight];
        [webpageViewController setupNavigationInnerWithBackButton];
    } else if ([parameters.name isEqualToString:@"paths"]) {
        [self dowanlodCategoriesList:tabOD];
    } else if ([parameters.name isEqualToString:@"multiWebPage"]) {
        
        NSString *path = [NSString stringWithFormat:@"%@", parameters.value];
        NSArray *pathsArray = [path componentsSeparatedByString:@"/"];
        NSInteger count = pathsArray.count - 2;
        NSArray *menuObjArray = tabOD.categories.subDirArr;
        for (NSString *oID in pathsArray) {
            do {
                for (OCMenuDataObj *obj in menuObjArray ) {
                    if (obj.categoryId == oID.intValue) {
                        menuObjArray = obj.subDirArr;
                        count--;
                        if (obj.subDirArr.count == 0 || count == 0) {
                            responseData = nil;
                            [self openWebPage:obj];
                            return;
                        }
                    }
                }
            } while (menuObjArray.count == 0);
        }

    }
    if (webpageViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UINavigationController *navigationController = [self.selectedViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self.selectedViewController : self.navigationController;
            [navigationController pushViewController:webpageViewController animated:NO];
 
        });
    }
}

- (void)pressDefaultTab {
    [self.tabsView setDefaultSelectedTab];
}

- (void)pressTab:(NSUInteger)tab {
    [self.tabsView setSelectedTab:tab];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"didSelectItem");
}

//[[NSNotificationCenter defaultCenter] postNotificationName:@"ocShowBar" object:nil];

#pragma mark - NSURLConnectionDelegate
- (void)dowanlodCategoriesList:(OCTabObj *)tabDO {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tabDO.categoryUrl]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"connection: %@", connection.description);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    if (responseData == nil) {
        responseData = [[NSMutableData alloc] init];
    }
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    NSLog(@"connectionDidFinishLoading");
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
    
    if (!error) {
        self.menuObj = [[OCMenuDataObj alloc] initWithJSONArray:JSON];
        NSString *path = [NSString stringWithFormat:@"%@",self.parameters.value];
        NSArray *pathsArray = [path componentsSeparatedByString:@"/"];
        NSInteger count = pathsArray.count - 2;
        NSArray *menuObjArray = self.menuObj.subDirArr;
        for (NSString *oID in pathsArray) {
            do {
                for (OCMenuDataObj *obj in menuObjArray ) {
                    if (obj.categoryId == oID.intValue) {
                        menuObjArray = obj.subDirArr;
                        count--;
                        if (obj.subDirArr.count == 0 || count == 0) {
                            responseData = nil;
                            [self openWebPage:obj];
                            return;
                        }
                    }
                }
            } while (menuObjArray.count == 0);
        }
    } else {
        NSLog(@"Error: %@", error);
    }
}
- (void)openWebPage:(OCMenuDataObj *)obj {
    OCWebPageViewController *webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:obj.url];
    [webpageViewController.navigationItem setTitle:obj.title];
    [webpageViewController setupBackButton];
    [webpageViewController setupCartButtonOnRight];
    UINavigationController *navigationController = [self.selectedViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self.selectedViewController : self.navigationController;
    [navigationController pushViewController:webpageViewController animated:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
    
}


@end
