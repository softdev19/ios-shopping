//
//  OCMenuViewController.h
//  eComerceApp
//
//  Created by Tarek Issa on 5/16/14.
//  Copyright (c) 2014 Tvinci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCNavigationButtonsViewController.h"

@class OCMenuDataObj;

@interface OCMenuViewController : OCNavigationButtonsViewController 

@property (nonatomic, strong) OCMenuDataObj* menuObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTabObj:(OCTabObj *)tabDO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMenuObj:(OCMenuDataObj *)menu;
- (void)dowanlodCategoriesList;

@property (weak) IBOutlet UITableView *tableview;

@end
