//
//  ViewController.h
//  TrackMyThings
//
//  Created by Paras Gorasiya on 26/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@import GoogleMobileAds;

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) RLMResults *items;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;

@property (nonatomic)BOOL searchBarActive;
@property (nonatomic, strong) RLMResults *searchResults;
@property (nonatomic, strong) RLMResults *filterResults;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDisclaimer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAddItem;
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;


- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)categoryBtnPressed:(id)sender;

@end

