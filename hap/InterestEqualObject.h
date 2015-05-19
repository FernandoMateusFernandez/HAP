//
//  InterestEqualObject.h
//  HAP
//
//  Created by Joaquin Pereira on 18/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface InterestEqualObject : NSObject

@property (strong, nonatomic) PFObject *Interests;
@property (strong, nonatomic) NSArray *aTopics;
@property (nonatomic) CGFloat percentage;


-(id)initWithInterest:(PFObject *)interest TopicsArray:(NSArray *)aTopics percentage:(CGFloat)percentage;

@end
