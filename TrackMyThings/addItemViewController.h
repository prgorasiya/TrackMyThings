//
//  addItemViewController.h
//  TrackMyThings
//
//  Created by Paras Gorasiya on 28/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "RealmObjectClass.h"

#import "XLFormViewController.h"

@interface addItemViewController : XLFormViewController

@property (strong, nonatomic) item *itemObject;
- (IBAction)saveButtonTapped:(id)sender;

@end
