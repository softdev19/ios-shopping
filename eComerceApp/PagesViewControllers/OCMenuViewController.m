//
//  OCMenuViewController.m
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import "OCMenuViewController.h"
#import "XMLDictionary.h"
#import "OCMenuDataObj.h"
#import "OCMenuPageCell.h"
#import "OCWebPageViewController.h"
#import "JASidePanelController.h"
#import "OCTabarController.h"

@interface OCMenuViewController () <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableData *responseData;
}

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) OCTabObj *tabDO;

@end

@implementation OCMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMenuObj:(OCMenuDataObj *)menu;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.menuObj = menu;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTabObj:(OCTabObj *)tabDO {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabDO = tabDO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview reloadData];
    [self.navigationItem setTitle:self.menuObj.title];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ocShowBar" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.tableview.delegate = self;
//    [self.tableview reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)cartButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCGoToCart object:nil];
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index: %@", indexPath);
    OCMenuDataObj* menu = (OCMenuDataObj*)self.menuObj.subDirArr[indexPath.row];

    if (menu.subDirArr.count > 0) {
        NSLog(@"Url: %@", menu.subDirArr);
        NSLog(@"Title: %@", menu.title);
        OCMenuViewController* menuViewController = [[OCMenuViewController alloc] initWithNibName:@"OCMenuViewController" bundle:nil andMenuObj:menu];

        [self.navigationController pushViewController:menuViewController animated:YES];
        [menuViewController setupBackButton];
        [menuViewController setupCartButtonOnRight];
        menuViewController= nil;
    }else{
        NSLog(@"Url: %@", menu.url);
        NSLog(@"Title: %@", menu.title);
        NSURL* url = [NSURL URLWithString:[NSString stringWithString:[menu.url absoluteString]]];
        OCWebPageViewController* webpageViewController = [[OCWebPageViewController alloc] initWithNibName:@"OCWebPageViewController" bundle:nil andPageUrl:url];

        [self.navigationController pushViewController:webpageViewController animated:YES];

        [webpageViewController setupBackButton];
        [webpageViewController setupCartButtonOnRight];
        [webpageViewController.navigationItem setTitle:menu.title];
        webpageViewController = nil;
    }
    NSLog(@"Pushed");


}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuObj.subDirArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OCMenuPageCell";
  
    OCMenuPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OCMenuPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLabel.text = ((OCMenuDataObj*)self.menuObj.subDirArr[indexPath.row]).title;
    
    return cell;
}

#pragma mark - NSURLConnectionDelegate
- (void)dowanlodCategoriesList {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCShowLoad object:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tabDO.categoryUrl]];
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
    NSError *e = nil;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];
  
    int index = [self setJSONArray:JSON];
    NSArray *smallArray = [NSArray alloc];
    if (index != 0) {
        smallArray = [JSON subarrayWithRange:NSMakeRange(index, 1)];
    }
    else {
        smallArray = JSON;
    }
    if (!e) {
        self.menuObj = [[OCMenuDataObj alloc] initWithJSONArray:smallArray];
        
        NSLog(@"Menu Obj = : %@", JSON);
    }else{
        //  Error
        NSLog(@"Error: %@", e);
    }
    [self.tableview reloadData];
}

- (int)setJSONArray:(NSArray *)jsonArr {
    long i = 0;
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:jsonArr.count];
    for (NSDictionary *subObj in jsonArr) {
        i++;
        NSDictionary *dataDict = [subObj objectOrNilForKey:@"data"];
        if (dataDict != nil && [dataDict objectOrNilForKey:@"link"]) {
            long categoryId = (long)[[dataDict objectOrNilForKey:@"id"] longLongValue];
            if (categoryId == [self.tabDO.categoryId longLongValue]) {
                return i;
            }
        }
    }
    return 0;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:OCHideLoad object:nil];

}

@end
