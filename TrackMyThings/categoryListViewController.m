//
//  categoryListViewController.m
//  TrackMyThings
//
//  Created by Paras Gorasiya on 29/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "categoryListViewController.h"
#import "RealmObjectClass.h"
#import "constants.h"
#import "SWTableViewCell.h"

@interface categoryListViewController ()
{
    NSMutableArray *arSelectedRows;
    NSMutableArray *categoryList;
}

@end

@implementation categoryListViewController

@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arSelectedRows = [[NSMutableArray alloc] init];
//    arSelectedRows = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedCategories"];
    categoryList = [[NSMutableArray alloc] init];
    
    self.tableView.sectionIndexColor = messageBackgroundColour;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self reloadTableData];
}



- (IBAction)addCategory:(id)sender
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Category Name"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    dialog.tag = 100;
    [dialog show];
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSString *categoryName = [alertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (categoryName.length > 0)
        {
            NSMutableArray *categoryArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy];
            
            if (categoryArray == nil)
            {
                categoryArray = [[NSMutableArray alloc] init];
            }
            [categoryArray addObject:alertTextField.text];
            [[NSUserDefaults standardUserDefaults] setObject:categoryArray forKey:@"categories"];
            
            [self reloadTableData];
        }
        
    }
}


#pragma mark - UITableViewDataSource
-(void)reloadTableData
{
    [categoryList removeAllObjects];
    
    categoryList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy];
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SWTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    BOOL isObjectThere = false;
    
    if ([arSelectedRows count] > 0)
    {
        isObjectThere = [arSelectedRows containsObject:[categoryList objectAtIndex:indexPath.row]];
    }
    
    
    if (isObjectThere)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    

    cell.textLabel.text = [categoryList objectAtIndex:indexPath.row];
    
    return cell;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SWTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.rowDescriptor.value = cell.textLabel.text;
        
        if (![arSelectedRows containsObject:cell.textLabel.text])
        {
            [arSelectedRows addObject:cell.textLabel.text];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [arSelectedRows removeObject:cell.textLabel.text];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            RLMResults *results = [item objectsWhere:@"category = %@", [categoryList objectAtIndex:cellIndexPath.row]];
            
            if ([results count] > 0)
            {
                [SVProgressHUD showErrorWithStatus:@"Can't delete catgeory which is being used!"];
            }
            else
            {
                [categoryList removeObjectAtIndex:cellIndexPath.row];
                
                [[NSUserDefaults standardUserDefaults] setObject:categoryList forKey:@"categories"];
                
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                self.rowDescriptor.value = nil;
            }
            
            [self.tableView reloadData];

            break;
        }
        default:
            break;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
