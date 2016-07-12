//
//  categoryListViewController.h
//  TrackMyThings
//
//  Created by Paras Gorasiya on 29/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import <Realm/Realm.h>

@interface categoryListViewController : UIViewController<XLFormRowDescriptorViewController, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addCategory:(id)sender;

@end
