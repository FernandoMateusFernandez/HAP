//
//  RightMenuVC.m
//  AMSlideMenu
//
// The MIT License (MIT)
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import "ProfileRightSlidingMenu.h"
#import <Parse/Parse.h>
#import "UserTableViewCell.h"

@interface ProfileRightSlidingMenu ()

@property (strong, nonatomic) NSMutableArray *aContacts;

@end

@implementation ProfileRightSlidingMenu

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    // Pull To Refresh
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    
    
    [self.tableView addSubview:refreshControl];
    
    
    [self downloadContactsFromParseWithBlock:nil];
}

#pragma mark - Parse

-(void)downloadContactsFromParseWithBlock:(void (^)(BOOL))completion
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"contact"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            self.aContacts = [NSMutableArray arrayWithArray: objects];
            
            [self insertContactsIntoTableView];
            
            if (completion != nil)
            {
                completion(YES);
            }

        }
        else
        {
            if (completion != nil)
            {
                completion(NO);
            }
        }
        
    }];
}


-(void)deleteContact:(PFObject *)contact completion:(void(^)(BOOL successfull))completion
{
    [contact deleteInBackground];

    completion(YES);
}

#pragma mark - TableView Methods

-(void)insertContactsIntoTableView
{
    [self.tableView beginUpdates];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
}


#pragma mark - TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aContacts.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"forIndexPath:indexPath];
    
    PFObject *contactObject = self.aContacts[indexPath.row];
    PFUser *contact = contactObject[@"contact"];
    
    cell.lbl_name.text = [NSString stringWithFormat:@"%@ %@",contact[@"name"],contact[@"surname"]];
    
    
    
    
    PFFile *imageFile = contact[@"image"];
    cell.img_user.image = [UIImage imageNamed:@"placeholder"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if (error == nil)
        {
            cell.img_user.image = [UIImage imageWithData:data];
        }
        
    }];
    
    return cell;
    
    
}

// Delete

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PFObject *contactToDelete = self.aContacts[indexPath.row];
        
        [self deleteContact:contactToDelete completion:^(BOOL successfull) {
            
            
            [self.aContacts removeObjectAtIndex:indexPath.row];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        
    }
}




#pragma mark - PullToRefresh

-(void)startRefresh:(UIRefreshControl *)refreshControl
{

    [refreshControl beginRefreshing];

    [self downloadContactsFromParseWithBlock:^(BOOL successfull) {
        
        
        [refreshControl endRefreshing];
        
    }];
}

@end
