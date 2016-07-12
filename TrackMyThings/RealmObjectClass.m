//
//  RealmObjectClass.m
//  TrackMyThings
//
//  Created by Paras Gorasiya on 29/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "RealmObjectClass.h"

@implementation item

+ (NSString *)primaryKey
{
    return @"index";
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"name": @"NULL", @"category":@"NULL", @"notes":@"NULL"};
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
