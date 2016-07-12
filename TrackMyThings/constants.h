//
//  constants.h
//  TrackMyThings
//
//  Created by Paras Gorasiya on 29/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "SVProgressHUD.h"

#ifndef constants_h


#define NameValidator   @"Description should start with 1-9 or A-Z & special character(s) are not allowed."
#define RegExNameValidation @"^[a-zA-Z1-9]{1}[a-zA-Z0-9@#$&*()_=|;.,'äöüÄÖÜ -]*$"
#define RegExUpto500Char      @"(^[a-zA-Z0-9_ !@#$%^&*()_+={}|\'\";:/?.>,<`~-].{0,499}?$)"
#define RegExUpto500CharWarning @"Notes can't be more than 500 characters"
#define messageBackgroundColour [UIColor colorWithRed:255/255.0f green:102/255.0f blue:0/255.0f alpha:1.0]


#endif /* constants_h */
