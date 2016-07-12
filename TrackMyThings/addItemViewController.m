//
//  addItemViewController.m
//  TrackMyThings
//
//  Created by Paras Gorasiya on 28/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "addItemViewController.h"
#import "XLForm.h"
#import "constants.h"


@interface addItemViewController ()
{
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
}

@end

@implementation addItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

    if (self.itemObject != nil)
    {
        self.navigationItem.title = @"Edit Item";
    }
    else
    {
        self.navigationItem.title = @"Add Item";
    }
    
    [self initializeForm];
}


-(void) initializeForm
{
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    //Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Description" rowType:XLFormRowDescriptorTypeText title:@"Description*"];
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:NameValidator regex:RegExNameValidation]];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    if (self.itemObject != nil)
    {
        row.value = self.itemObject.name;
    }
    [section addFormRow:row];
    
    
    //Category
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Category" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Category"];
    row.action.formSegueIdentifier = @"categoryList";
    if (self.itemObject != nil)
    {
        row.value = [[self.itemObject valueForKey:@"category"] isEqualToString:@"NULL"] ? NULL : [self.itemObject valueForKey:@"category"];
    }
    [section addFormRow:row];
    
    
    //Notes
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Location & Notes" rowType:XLFormRowDescriptorTypeTextView title:@"Location & Notes"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textView.textAlignment"];
    if (self.itemObject != nil)
    {
        row.value = [[self.itemObject valueForKey:@"notes"] isEqualToString:@"NULL"] ? NULL : [self.itemObject valueForKey:@"notes"];
    }
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:RegExUpto500CharWarning regex:RegExUpto500Char]];
    [section addFormRow:row];
    
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Fields marked with asterisk(*) are required"];
    [form addFormSection:section];
    
    self.form = form;
}



- (IBAction)saveButtonTapped:(id)sender
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0)
    {
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    [self.tableView endEditing:YES];
    
    if (self.itemObject == nil)
    {
        RLMResults *items = [item objectsWhere:@"name =[c] %@", [self.formValues objectForKey:@"Description"]];
        
        if ([items count] > 0)
        {
            [SVProgressHUD showErrorWithStatus:@"Item with same description already exist!"];
            return;
        }
    }
    
    RLMRealm *realm = RLMRealm.defaultRealm;
    
    [realm transactionWithBlock:^{
        
        item *itemObjectToAdd = [[item alloc] init];
        
        if (self.itemObject != nil)
        {
            itemObjectToAdd.index = [self.itemObject valueForKey:@"index"];
        }
        else
        {
            itemObjectToAdd.index = [NSString stringWithFormat:@"%lu", ([[item allObjects] count] + 1)];
        }
        
        
        //Item Description
        itemObjectToAdd.name = [self.formValues objectForKey:@"Description"];
        
        
        //Item Description
        if (![[self.formValues objectForKey:@"Category"] isEqual:[NSNull null]])
        {
            itemObjectToAdd.category = [self.formValues objectForKey:@"Category"];
        }
        
        
        //Item Location
        if (![[self.formValues objectForKey:@"Location & Notes"] isEqual:[NSNull null]])
        {
            itemObjectToAdd.notes = [self.formValues objectForKey:@"Location & Notes"];
        }
        
        [realm addOrUpdateObject:itemObjectToAdd];
    }];
    
    if (self.itemObject != nil)
    {
        [SVProgressHUD showSuccessWithStatus:@"Item Updated"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"Item Added"];
    }
    
    self.itemObject = nil;
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
