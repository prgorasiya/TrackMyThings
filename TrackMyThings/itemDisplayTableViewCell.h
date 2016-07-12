//
//  itemDisplayTableViewCell.h
//  TrackMyThings
//
//  Created by Paras Gorasiya on 29/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface itemDisplayTableViewCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *itemCategory;
@property (strong, nonatomic) IBOutlet UILabel *itemLocation;

@end
