//
//  InterestEqualObject.m
//  HAP
//
//  Created by Joaquin Pereira on 18/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "InterestEqualObject.h"

@implementation InterestEqualObject

- (id)initWithInterest:(PFObject *)interest TopicsArray:(NSArray *)aTopics percentage:(CGFloat)percentage
{
    self  = [super init];
    
    if (self != nil)
    {
        _Interest = interest;
        _aTopics = aTopics;
        _percentage = percentage;
    }
    
    return self;
}

@end
