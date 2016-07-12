//
//  ViewController.m
//  TrackMyThings
//
//  Created by Paras Gorasiya on 26/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "ViewController.h"
#import "RealmObjectClass.h"
#import "itemDisplayTableViewCell.h"
#import "addItemViewController.h"
#import "constants.h"


@interface ViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger selectedObjectIndex;
    NSInteger currentSelection;
    
    NSMutableArray *dataArray;
    NSString *selectedCategory;
}

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    
    currentSelection = -1;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Replace below ID with your app's ID
    self.bannerView.adUnitID = @"ca-app-pub-5435076282465664/8265204433";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];

    self.btnDisclaimer.title = @"Disclaimer";
    NSUInteger size = 14.0;
    UIFont * font = [UIFont systemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [self.btnDisclaimer setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    selectedObjectIndex = 0;
    selectedCategory = @"Category";
    
    [self.btnCategory setTitle:@"Category" forState:UIControlStateNormal];
    
    self.items = [[item allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
    
    dataArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy];
    
    if ([dataArray count] > 0)
    {
        [dataArray addObject:@"All"];
    }
    [self.tableview registerNib:[UINib nibWithNibName:@"MyCustomTableViewCellNibFileName" bundle:nil] forCellReuseIdentifier:@"MyCustomCell"];
    [self.tableview reloadData];
    
    self.searchBar.delegate = self;
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self.pickerView reloadAllComponents];
}



- (IBAction)doneButtonTapped:(id)sender
{
    [self.tableview setUserInteractionEnabled:YES];
    [self.searchBar setUserInteractionEnabled:YES];
    [self.btnCategory setUserInteractionEnabled:YES];
    [self.btnDisclaimer setEnabled:YES];
    [self.btnAddItem setEnabled:YES];
    [self.btnCategory setTitle:selectedCategory forState:UIControlStateNormal];
    
    if ([selectedCategory isEqualToString:@"Category"] || [selectedCategory isEqualToString:@"All"])
    {
        self.items = [[item allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
    }
    else
    {
        self.items = [[item objectsWhere:@"category = %@", selectedCategory] sortedResultsUsingProperty:@"name" ascending:YES];
    }
    
    [self.tableview reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.frame =  CGRectMake(0, self.view.frame.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);
    }];
    
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self.tableview setUserInteractionEnabled:YES];
    [self.searchBar setUserInteractionEnabled:YES];
    [self.btnCategory setUserInteractionEnabled:YES];
    [self.btnDisclaimer setEnabled:YES];
    [self.btnAddItem setEnabled:YES];
    
    selectedCategory = @"Category";
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.frame =  CGRectMake(0, self.view.frame.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);
    }];
}


-(IBAction)categoryBtnPressed:(id)sender
{
    if ([dataArray count] > 0)
    {
        [self.tableview setUserInteractionEnabled:NO];
        [self.searchBar setUserInteractionEnabled:NO];
        [self.btnCategory setUserInteractionEnabled:NO];
        [self.btnDisclaimer setEnabled:NO];
        [self.btnAddItem setEnabled:NO];
        
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        selectedCategory = [dataArray firstObject];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.containerView.frame =  CGRectMake(0, self.view.frame.size.height - self.containerView.frame.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"No Category added"];
    }
}


#pragma mark PickerView Delegates
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    selectedCategory = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:row]];
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataArray count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataArray objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 300;
    return sectionWidth;
}



#pragma mark TableView delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBarActive)
    {
        if ([self.searchResults count] == 0)
        {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.size.height/4.0, [UIScreen mainScreen].bounds.size.width, 50.0)];
            
            messageLabel.text = @"No Matching Results.";
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20];
            
            UIImageView *messageImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.size.height/6.0,[UIScreen mainScreen].bounds.size.width,50.0)];
            [messageImage setImage:[UIImage imageNamed:@"noresults"]];
            [messageImage setContentMode:UIViewContentModeScaleAspectFit];
            
            
            UIView *msgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            [msgView addSubview:messageImage];
            [msgView addSubview:messageLabel];
            
            self.tableview.backgroundView = msgView;
            
        }
        else
        {
            self.tableview.backgroundView = nil;
        }
        
        return [self.searchResults count];
    }
    else
    {
        self.tableview.backgroundView = nil;
        return [self.items count];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchBarActive)
    {
        return @"Search Result";
    }
    return nil;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    itemDisplayTableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    item *itemObject;
    
    if (self.searchBarActive)
    {
        itemObject = self.searchResults[indexPath.row];
    }
    else
    {
        itemObject = [self.items objectAtIndex:indexPath.row];
    }
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;

    cell.itemDescription.text = [itemObject valueForKey:@"name"];
    
    if (![[itemObject valueForKey:@"category"] isEqual:@"NULL"])
    {
        cell.itemCategory.text = [itemObject valueForKey:@"category"];
    }
    else
    {
        cell.itemCategory.text = @"";
    }
    
    if (![[itemObject valueForKey:@"notes"] isEqual:@"NULL"])
    {
        NSString *itemNotes = [itemObject valueForKey:@"notes"];
        
        NSMutableAttributedString *attributedDescriptionText =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", itemNotes] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15]}];
        
        NSMutableAttributedString *contactAndSummeryText = [[NSMutableAttributedString alloc] initWithAttributedString:attributedDescriptionText];
        
        cell.itemLocation.attributedText = contactAndSummeryText;
    }
    else
    {
        cell.itemLocation.text = @"-";
    }
    
    if(currentSelection == indexPath.row)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow"]];
    }
    else
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    }

    return cell;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            NSLog(@"Edit button was pressed");
            NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
            selectedObjectIndex = cellIndexPath.row;
            [self performSegueWithIdentifier:@"editItem" sender:nil];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
            
            RLMRealm *realm = RLMRealm.defaultRealm;
            
            [realm beginWriteTransaction];
            [realm deleteObject:[self.items objectAtIndex:cellIndexPath.row]];
            [realm commitWriteTransaction];
            
            [self.tableview deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableview reloadData];
            break;
        }
        default:
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentSelection == indexPath.row)
    {
        currentSelection = -1;
        [tableView beginUpdates];
        [tableView endUpdates];
        [self.tableview reloadData];
    }
    else
    {
        currentSelection = indexPath.row;
        [tableView beginUpdates];
        [tableView endUpdates];
        [self.tableview reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == currentSelection)
    {
        item *itemObject;
        
        if (self.searchBarActive)
        {
            itemObject = [self.searchResults objectAtIndex:indexPath.row];
        }
        else
        {
            itemObject = [self.items objectAtIndex:indexPath.row];
        }
        
        NSString *strCommentText = [NSString stringWithFormat:@"%@", itemObject.notes];
        CGSize labelHeight = [self heigtForCellwithString:strCommentText withFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
        return  labelHeight.height+100;
    }
    else return 85;
}


-(CGSize)heigtForCellwithString:(NSString *)stringValue withFont:(UIFont*)font
{
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width-90,9999); // Replace 300 with your label width
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [stringValue boundingRectWithSize:constraint
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    return rect.size;
    
}



#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *pred;
    if ([self.btnCategory.titleLabel.text isEqualToString:@"Category"] || [self.btnCategory.titleLabel.text isEqualToString:@"All"])
    {
        pred = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ OR category CONTAINS[c] %@ OR notes CONTAINS[c] %@",searchText,searchText, searchText];
    }
    else
    {
        pred = [NSPredicate predicateWithFormat:@"(name CONTAINS[c] %@ OR notes CONTAINS[c] %@) AND category = %@",searchText, searchText, self.btnCategory.titleLabel.text];
    }
    
    self.searchResults = [self.items objectsWithPredicate:pred];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.tableview reloadData];
    }
    else
    {
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self.tableview reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
    [self.tableview reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    self.searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editItem"])
    {
        item *selectedObject = [self.items objectAtIndex:selectedObjectIndex];
        
        if (selectedObject != nil)
        {
            addItemViewController *editTask = segue.destinationViewController;
            editTask.itemObject = selectedObject;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
