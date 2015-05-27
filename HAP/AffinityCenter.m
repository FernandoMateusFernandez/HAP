//
//  AffinityCenter.m
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "AffinityCenter.h"
#import "InterestEqualObject.h"

@interface AffinityCenter ()

@property (strong, nonatomic) NSMutableArray *aSimilarInterests;

@end

@implementation AffinityCenter



+(void)affinityWithUser:(PFUser *)user
                         contact:(PFUser *)contact
                      completion:(void (^)(NSNumber *factor, NSArray *aSimilarInterests))completionHandler
{
    __block NSNumber *affinityFactor;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Algorithm"];
    
    [query whereKey:@"usertype" equalTo:user[@"neurotype"]];
    [query whereKey:@"contacttype" equalTo:contact[@"neurotype"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            
            // Getting Factor
            
            PFObject *factor = [objects lastObject];
            affinityFactor = factor[@"factor"];
            affinityFactor = [NSNumber numberWithInt:((affinityFactor.intValue * 100) / 8)];
            

            //User hobbies
            PFQuery *query = [PFQuery queryWithClassName:@"UserHobbie"];
            
            [query whereKey:@"user" equalTo:user];
            [query includeKey:@"hobbie"];
            [query includeKey:@"topics"];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (error == nil)
                {
                    NSArray *userHobbies = objects;
                    
                    //Contact hobbies
                    PFQuery *query = [PFQuery queryWithClassName:@"UserHobbie"];
                    
                    [query whereKey:@"user" equalTo:contact];
                    [query includeKey:@"hobbie"];
                    [query includeKey:@"topics"];
                    
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        if (error == nil)
                        {
                            NSArray *contactHobbies = objects;
                            
                            NSArray *aSimilarInterests = [self fillEqualInterestsArrayWithUserArray:userHobbies andContactArray:contactHobbies];
                            
                            completionHandler(affinityFactor,aSimilarInterests);
                        }
                    }];

                }
            }];

        }
        
    }];
}



+(NSArray *) fillEqualInterestsArrayWithUserArray:(NSArray *)aUser andContactArray:(NSArray *)aContact;
{
    NSMutableArray *aUserInterestsObjects = [NSMutableArray new];
    NSMutableArray *aContactInterestsObjects = [NSMutableArray new];
    
    for (int i = 0; i < aUser.count; i++)
    {
        PFObject *object = aUser[i];
        
        [aUserInterestsObjects addObject:object[@"hobbie"]];
    }
    
    for (int i = 0; i < aContact.count; i++)
    {
        PFObject *object = aContact[i];
        
        [aContactInterestsObjects addObject:object[@"hobbie"]];
    }
    
    return [self compareInterestsBetweenUserArray:aUserInterestsObjects andContactArray:aContactInterestsObjects];
}

+(NSArray *) compareInterestsBetweenUserArray:(NSArray *)aUser andContactArray:(NSArray *)aContact
{
    // COMPARE INTERESTS
    
    NSMutableArray *aEquals = [NSMutableArray new];
    
    for (int i = 0; i < aUser.count; i++)
    {
        if ([aContact containsObject:aUser[i]])
        {
            [aEquals addObject:aUser[i]];
        }
    }

    return [self compareTopicsWithUserArray:aUser contactArray:aContact EqualInterestArray:aEquals];
}

+(NSArray *)compareTopicsWithUserArray:(NSArray *)aUser contactArray:(NSArray *)aContact EqualInterestArray:(NSArray *)aEquals
{
    //Get Topics
    
    NSMutableArray *aSimilarInterests = [NSMutableArray new];
    
    for (int i = 0; i < aEquals.count; i++)
    {
        
        PFObject *interest = aEquals[i];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hobbie.objectId MATCHES %@",interest.objectId];
        
        NSArray *aUserResult = [aUser filteredArrayUsingPredicate:predicate];
        NSArray *aContactResult = [aUser filteredArrayUsingPredicate:predicate];
        
        PFObject *userObject = [aUserResult lastObject];
        PFObject *contactObject = [aContactResult lastObject];
        
        NSArray *userTopics = userObject[@"topics"];
        NSArray *contactTopics = contactObject[@"topics"];
        
        NSArray *aEqualTopics = [self compareTopicsBetwenArray:userTopics andArray:contactTopics];
        
        
        CGFloat percentage = userTopics.count / aEqualTopics.count;
        
        InterestEqualObject *interestObject = [[InterestEqualObject alloc]
                                               initWithInterest:aEquals[i]
                                               TopicsArray:aEqualTopics
                                               percentage:percentage];
        
        [aSimilarInterests addObject:interestObject];
        
    }
    
    return aSimilarInterests;
}


+(NSArray *)compareTopicsBetwenArray:(NSArray *)aUser andArray:(NSArray *)aContact
{
    NSMutableArray *aEquals = [NSMutableArray new];
    
    for (int i = 0; i < aUser.count; i++)
    {
        if ([aContact containsObject:aUser[i]])
        {
            [aEquals addObject:aUser[i]];
        }
    }
    
    return aEquals;
    
}

@end
