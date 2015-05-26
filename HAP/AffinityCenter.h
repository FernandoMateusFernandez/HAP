//
//  AffinityCenter.h
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AffinityCenter : NSObject


+(void)calculateAffinityWithUser:(PFUser *)user
                         contact:(PFUser *)contact
                      completion:(void (^)(NSNumber *factor, NSArray *aSimilarInterests))completionHandler;

@end
