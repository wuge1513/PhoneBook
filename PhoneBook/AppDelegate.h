//
//  AppDelegate.h
//  PhoneBook
//
//  Created by LiuLei on 12-3-15.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "ModalAlert.h"

//Address Book contact
#define KPHONELABELDICDEFINE		@"KPhoneLabelDicDefine"
#define KPHONENUMBERDICDEFINE	@"KPhoneNumberDicDefine"
#define KPHONENAMEDICDEFINE	@"KPhoneNameDicDefine"


#define BARBUTTON(TITLE, SELECTOR)		[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]//UIBarButtonItem
#define NUMBER(X) [NSNumber numberWithInt:X]

ABAddressBookRef addressBook;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
