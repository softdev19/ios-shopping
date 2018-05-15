//
//  OCNavigationController.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCNavigationController.h"
#import "OCTabObj.h"
#import "OCMainWebViewController.h"
#import "OCMenuViewController.h"
#import "OCsocialViewController.h"
#import "OCLauncherCounterManager.h"
#import "OCNavigationBar.h"

@interface OCNavigationController () <UINavigationControllerDelegate>{
    
}

@property (nonatomic, retain) OCTabObj* tabDO;
@property (nonatomic, assign) BOOL isDefaultScreen;

@end

@implementation OCNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[OCNavigationBar class] toolbarClass:nil];
    if (self) {

        [self setup];
    }
    return self;
}

- (instancetype)initWith:(OCTabObj *)tabObj isDefaultScreen:(BOOL)isDefaultScreen
{
    self = [super initWithNavigationBarClass:[OCNavigationBar class] toolbarClass:nil];
    if (self) {
        self.tabDO = tabObj;
        self.isDefaultScreen = isDefaultScreen;
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    if (self.tabDO) {
        switch (self.tabDO.type) {
            case OCTabType_Menu:
                [self setupMenuPage];
                break;
                
            case OCTabType_MultiWebPage:
                [self setupMultiWebPage];
                break;
                
            case OCTabType_Webview:
                [self setupMainWebviewPage];
                break;
                
            case OCTabType_Social:
                [self setupSocialPage];
                break;
                
            default:
                break;
        }
    }
}

- (void)setupSocialPage {
    OCsocialViewController* socialViewController = [[OCsocialViewController alloc] initWithNibName:@"OCsocialViewController" bundle:nil andSocialArray:self.tabDO.listArray];
    [socialViewController setupCartButtonAndSearchOnRight];

    self.viewControllers = [NSArray arrayWithObjects:socialViewController, nil];
}

- (void)setupMenuPage {
    OCMenuViewController* webpageViewController = [[OCMenuViewController alloc] initWithNibName:@"OCMenuViewController" bundle:nil andTabObj:self.tabDO];
    [webpageViewController dowanlodCategoriesList];
    [webpageViewController setupCartButtonAndSearchOnRight];

    self.viewControllers = [NSArray arrayWithObjects:webpageViewController, nil];
}

- (void)setupMultiWebPage {
    OCMenuViewController* webpageViewController = [[OCMenuViewController alloc] initWithNibName:@"OCMenuViewController" bundle:nil andTabObj:self.tabDO];
    webpageViewController.menuObj = self.tabDO.categories;
    [webpageViewController setupCartButtonAndSearchOnRight];
    
    self.viewControllers = [NSArray arrayWithObjects:webpageViewController, nil];
}

- (void)setupMainWebviewPage {
    OCMainWebViewController* webpageViewController = [[OCMainWebViewController alloc] initWithPageUrl:self.tabDO.pageUrl];
    if (self.isDefaultScreen) {
        webpageViewController.updateLaunchCounter = YES;
    }
    if (self.isDefaultScreen) {
        [[OCLauncherCounterManager sharedInstance] increaseCounter];
    }
    [webpageViewController setupCartButtonAndSearchOnRight];

//    [webpageViewController reloadWebview];
    
    self.viewControllers = [NSArray arrayWithObjects:webpageViewController, nil];
}

#pragma - Mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@"willShowViewController");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ocShowBar" object:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@"didShowViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
