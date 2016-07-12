//
//  RealmObjectClass.h
//  TrackMyThings
//
//  Created by Paras Gorasiya on 29/02/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <Realm/Realm.h>

@interface item : RLMObject

@property NSString *index;
@property NSString *name;
@property NSString *category;
@property NSString *notes;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmObjectClass>
RLM_ARRAY_TYPE(item)
