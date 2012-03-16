//
//  MasterViewController.h
//  PhoneBook
//
//  Created by LiuLei on 12-3-15.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABContactsHelper.h"
#import "ABContact.h"


@class DetailViewController;

@interface MasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,ABNewPersonViewControllerDelegate, 
ABPersonViewControllerDelegate,UISearchBarDelegate>
{
    NSString *sectionName;
	CGFloat redcolor, greencolor, bluecolor;
    BOOL isSearch, isEdit, isGroup;
}
@property (strong, nonatomic) UITableView *allPeopleTabelView;
@property (strong, nonatomic) DetailViewController *detailViewController;



@property (retain) NSArray *contacts;
@property (retain) NSMutableArray *filteredArray;
@property (retain) NSMutableArray *contactNameArray;
@property (retain) NSMutableDictionary *contactNameDic;
@property (retain) NSMutableArray *sectionArray;
@property (retain) UISearchDisplayController *searchDC;
@property (retain) UISearchBar *searchBar;
@property (retain) UINavigationController *aBPersonNav;
@property (retain) UINavigationController *aBNewPersonNav;

//添加联系人
-(void)initData;
-(IBAction)addContactItemBtn:(id)sender;
-(IBAction)editContactItemBtn:(id)sender;
-(IBAction)groupBtnAction:(id)sender;

@end
