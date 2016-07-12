//
//  disclaimerViewController.m
//  TrackMyThings
//
//  Created by Paras Gorasiya on 28/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "disclaimerViewController.h"

@interface disclaimerViewController ()

@end

@implementation disclaimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
