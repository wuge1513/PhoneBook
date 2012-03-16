//
//  MasterViewController.m
//  PhoneBook
//
//  Created by LiuLei on 12-3-15.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "MasterViewController.h"
#import "ContactData.h"
#import "AppDelegate.h"
#import "pinyin.h"

#define SETCOLOR(RED,GREEN,BLUE) [UIColor colorWithRed:RED/255 green:GREEN/255 blue:BLUE/255 alpha:1.0]


@implementation MasterViewController

@synthesize contacts;
@synthesize filteredArray;
@synthesize contactNameArray;
@synthesize contactNameDic;
@synthesize sectionArray;
@synthesize searchBar;
@synthesize searchDC;
@synthesize aBPersonNav;
@synthesize aBNewPersonNav;
@synthesize detailViewController = _detailViewController;
@synthesize allPeopleTabelView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        
        //默认返回按钮
//        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(actionBack)];
//        self.navigationItem.leftBarButtonItem = leftButtonItem;
//        [leftButtonItem release];
        
        //默认确认按钮
//        UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(editContactItemBtn)];
//        self.navigationItem.rightBarButtonItem = selectButtonItem;
//        [selectButtonItem release];
        
        UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactItemBtn:)];
        self.navigationItem.rightBarButtonItem = btnItem;
    }
    return self;
}
							
- (void)dealloc
{
    [sectionArray release];
    [allPeopleTabelView release];
    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    //----------
    
    self.view.backgroundColor = [UIColor clearColor];
    isGroup = NO;
	
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.delegate = self;
    
    
    //Initialize all people list view
    UITableView *_allPeopleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0) style:UITableViewStylePlain];
    self.allPeopleTabelView = _allPeopleTableView;
    [_allPeopleTableView release];
    self.allPeopleTabelView.delegate = self;
    self.allPeopleTabelView.dataSource = self;
    
    [self.view addSubview:self.allPeopleTabelView];
	self.allPeopleTabelView.tableHeaderView =self.searchBar;
    
    
	// Create the search display controller
	self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;	
	
	
	NSMutableArray *filterearray =  [[NSMutableArray alloc] init];
	self.filteredArray = filterearray;
	[filterearray release];
	
	NSMutableArray *namearray =  [[NSMutableArray alloc] init];
	self.contactNameArray = namearray;
	[namearray release];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	self.contactNameDic = dic;
	[dic release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.allPeopleTabelView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)initData{
	self.contacts = [ContactData contactsArray];
	if([contacts count] <1)
	{
		[contactNameArray removeAllObjects];
		[contactNameDic removeAllObjects];
		for (int i = 0; i < 27; i++) [self.sectionArray replaceObjectAtIndex:i withObject:[NSMutableArray array]];
		return;
	}
	[contactNameArray removeAllObjects];
	[contactNameDic removeAllObjects];
	for(ABContact *contact in contacts)
	{
		NSString *phone;
		NSArray *phoneCount = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneCount count] > 0)
		{
			NSDictionary *PhoneDic = [phoneCount objectAtIndex:0];
			phone = [ContactData getPhoneNumberFromDic:PhoneDic];
		}
		if([contact.contactName length] > 0)
			[contactNameArray addObject:contact.contactName];
		else
			[contactNameArray addObject:phone];
	}
	
	self.sectionArray = [NSMutableArray array];
	for (int i = 0; i < 27; i++) [self.sectionArray addObject:[NSMutableArray array]];
	for (NSString *string in contactNameArray) 
	{
		if([ContactData searchResult:string searchText:@"曾"])
			sectionName = @"Z";
		else if([ContactData searchResult:string searchText:@"解"])
			sectionName = @"X";
		else if([ContactData searchResult:string searchText:@"仇"])
			sectionName = @"Q";
		else if([ContactData searchResult:string searchText:@"朴"])
			sectionName = @"P";
		else if([ContactData searchResult:string searchText:@"查"])
			sectionName = @"Z";
		else if([ContactData searchResult:string searchText:@"能"])
			sectionName = @"N";
		else if([ContactData searchResult:string searchText:@"乐"])
			sectionName = @"Y";
		else if([ContactData searchResult:string searchText:@"单"])
			sectionName = @"S";
		else
			sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])] uppercaseString];
		[self.contactNameDic setObject:string forKey:sectionName];
		NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
		if (firstLetter != NSNotFound) [[self.sectionArray objectAtIndex:firstLetter] addObject:string];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{ 
	if(tableView == self.allPeopleTabelView) 
        return 27;
	return 1; 
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
	if (tableView == self.allPeopleTabelView)  // regular table
	{
		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
		for (int i = 0; i < 27; i++) 
			if ([[self.sectionArray objectAtIndex:i] count])
				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
		//[indices addObject:@"\ue057"]; // <-- using emoji
		return indices;
	}
	else 
        return nil; // search table
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (title == UITableViewIndexSearch) 
	{
		[self.allPeopleTabelView scrollRectToVisible:self.searchBar.frame animated:NO];
		return -1;
	}
	return [ALPHA rangeOfString:title].location;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.allPeopleTabelView) 
	{
		if ([[self.sectionArray objectAtIndex:section] count] == 0) return nil;
		return [NSString stringWithFormat:@"%@", [[ALPHA substringFromIndex:section] substringToIndex:1]];
	}
	else return nil;
}


#pragma mark- TableView delegate methods
// Customize the number of sections in the table view.
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self initData];
	// Normal table
	if (tableView == self.allPeopleTabelView) 
        return [[self.sectionArray objectAtIndex:section] count];
	else
		[filteredArray removeAllObjects];
	// Search table
	for(NSString *string in contactNameArray)
	{
		NSString *name = @"";
		for (int i = 0; i < [string length]; i++)
		{
			if([name length] < 1)
				name = [NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:i])];
			else
				name = [NSString stringWithFormat:@"%@%c",name,pinyinFirstLetter([string characterAtIndex:i])];
		}
		if ([ContactData searchResult:name searchText:self.searchBar.text])
			[filteredArray addObject:string];
		else 
		{
			if ([ContactData searchResult:string searchText:self.searchBar.text])
				[filteredArray addObject:string];
			else {
				ABContact *contact = [ContactData byNameToGetContact:string];
				NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
				NSString *phone = @"";
				
				if([phoneArray count] == 1)
				{
					NSDictionary *PhoneDic = [phoneArray objectAtIndex:0];
					phone = [ContactData getPhoneNumberFromDic:PhoneDic];
					if([ContactData searchResult:phone searchText:self.searchBar.text])
						[filteredArray addObject:string];
				}else  if([phoneArray count] > 1)
				{
					for(NSDictionary *dic in phoneArray)
					{
						phone = [ContactData getPhoneNumberFromDic:dic];
						if([ContactData searchResult:phone searchText:self.searchBar.text])
						{
							[filteredArray addObject:string];	
							break;
						}
					}
				}
				
			}
		}
	}
	return self.filteredArray.count;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	self.searchBar.prompt = @"输入字母、汉字或电话号码搜索";
}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar setText:@""]; 
	self.searchBar.prompt = nil;
	[self.searchBar setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.allPeopleTabelView.tableHeaderView = self.searchBar;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
	if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"ContactCell"] autorelease];
	NSString *contactName;
	
	// Retrieve the crayon and its color
	if (tableView == self.allPeopleTabelView)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithCString:[contactName UTF8String] encoding:NSUTF8StringEncoding];
	
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	if(contact)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneArray count] > 0)
		{
			NSDictionary *dic = [phoneArray objectAtIndex:0];
			NSString *phone = [ContactData getPhoneNumberFromDic:dic];
			cell.detailTextLabel.text = phone;
		}
	}
	else
		cell.detailTextLabel.text = @"234";
	return cell;
}


//del
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	ABPersonViewController *pvc = [[[ABPersonViewController alloc] init] autorelease];
	pvc.navigationItem.leftBarButtonItem = BARBUTTON(@"取消", @selector(cancelBtnAction:));
	
	NSString *contactName = @"";
	if (tableView == self.allPeopleTabelView)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	pvc.displayedPerson = contact.record;
	pvc.allowsEditing = YES;
	//[pvc setAllowsDeletion:YES];
	pvc.personViewDelegate = self;
	self.aBPersonNav = [[[UINavigationController alloc] initWithRootViewController:pvc] autorelease];
	self.aBPersonNav.navigationBar.tintColor = SETCOLOR(redcolor,greencolor,bluecolor);
	[self presentModalViewController:aBPersonNav animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == self.allPeopleTabelView)
		// Return NO if you do not want the specified item to be editable.
		return YES;
	else
		return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSString *contactName = @"";
	if (tableView == self.allPeopleTabelView)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	
	if ([ModalAlert ask:@"真的要删除 %@?", contact.compositeName])
	{
		/*CATransition *animation = [CATransition animation];
         animation.delegate = self;
         animation.duration = 0.2;
         animation.timingFunction = UIViewAnimationCurveEaseInOut;
         animation.fillMode = kCAFillModeForwards;
         animation.removedOnCompletion = NO;
         animation.type = @"suckEffect";//110		
         [DataTable.layer addAnimation:animation forKey:@"animation"];*/
		[[self.sectionArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
		[ContactData removeSelfFromAddressBook:contact withErrow:nil];
		[self.allPeopleTabelView reloadData];
	}
	[self.allPeopleTabelView  setEditing:NO];
	self.navigationItem.rightBarButtonItem.title = @"编辑";
	isEdit = NO;
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	[self.navigationController popViewControllerAnimated:YES];
	return NO;
}

- (void)cancelBtnAction:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


-(void)addContactItemBtn:(id)sender{
	// create a new view controller
	ABNewPersonViewController *npvc = [[[ABNewPersonViewController alloc] init] autorelease];
    
	npvc.navigationItem.leftBarButtonItem = BARBUTTON(@"取消", @selector(addNewBackAction:));
//	self.aBNewPersonNav = [[[UINavigationController alloc] initWithRootViewController:npvc] autorelease];
//	self.aBNewPersonNav.navigationBar.tintColor = SETCOLOR(redcolor,greencolor,bluecolor);
	ABContact *contact = [ABContact contact];
	npvc.displayedPerson = contact.record;
	npvc.newPersonViewDelegate = self;
    npvc.title = @"123";
	npvc.navigationController.navigationBar.tintColor = [UIColor colorWithRed:100 green:30 blue:30 alpha:1];

    [self.navigationController pushViewController:npvc animated:YES ];
}

//添加 返回
- (void)addNewBackAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark NEW PERSON DELEGATE METHODS

//添加完成
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	if (person)
	{
		ABContact *contact = [ABContact contactWithRecord:person];
		//self.title = [NSString stringWithFormat:@"Added %@", contact.compositeName];
		if (![ABContactsHelper addContact:contact withError:nil])
		{
			// may already exist so remove and add again to replace existing with new
			[ContactData removeSelfFromAddressBook:contact withErrow:nil];
			[ABContactsHelper addContact:contact withError:nil];
		}
	}
	else
	{
	}
	[self.allPeopleTabelView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)editContactItemBtn:(id)sender
{
	if(isEdit == NO)
	{	
		[self.allPeopleTabelView setEditing:YES];
		self.navigationItem.rightBarButtonItem.title = @"完成";
	}else {
		[self.allPeopleTabelView setEditing:NO];
		self.navigationItem.rightBarButtonItem.title = @"编辑";
	}
	isEdit = !isEdit;
}


-(void)groupBtnAction:(id)sender{
	
}

@end
