//
//  ResultTableViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/17/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "ResultTableViewController.h"
#import "ResultTableViewCell.h"
#import "InterestTableViewCell.h"
#import "ShareTableViewCell.h"
#import "InterestEqualObject.h"

@interface ResultTableViewController ()

@property (strong, nonatomic) NSNumber *factor;
@property (strong, nonatomic) NSArray *aInterests;

@property (strong, nonatomic) NSArray *aUserInterests;
@property (strong, nonatomic) NSArray *aContactInterest;

@property (strong, nonatomic) NSMutableArray *aEqualsInterests;

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialization
    self.aEqualsInterests = [NSMutableArray new];
    
    self.factor = [NSNumber numberWithInt:0];
    self.aInterests = [NSMutableArray new];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self downloadInterests];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)downloadInterests
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserHobbie"];
    
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"hobbie"];
    [query includeKey:@"topics"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            self.aInterests = objects;
            
            [self calculateNeuroTypeFactor];
        }
    }];
}

- (void)calculateNeuroTypeFactor
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Algorithm"];
    
    [query whereKey:@"usertype" equalTo:user[@"neurotype"]];
    [query whereKey:@"contacttype" equalTo:self.contact[@"neurotype"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            PFObject *factor = [objects lastObject];
            
            self.factor = factor[@"factor"];
            
            [self calculateInterestsMatrix];
        }
        
    }];
}

-(void)calculateInterestsMatrix
{
    [self getUserInterests];
}

-(void)getUserInterests
{

    //User
    PFQuery *query = [PFQuery queryWithClassName:@"UserHobbie"];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"hobbie"];
    [query includeKey:@"topics"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            self.aUserInterests = objects;
            
            [self getContactInterestsWithUserArray:objects];
        }
    }];
}

-(void)getContactInterestsWithUserArray:(NSArray *)aUser;
{
    //Contact
    PFQuery *query = [PFQuery queryWithClassName:@"UserHobbie"];
    
    [query whereKey:@"user" equalTo:self.contact];
    [query includeKey:@"hobbie"];
    [query includeKey:@"topics"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            self.aContactInterest = objects;
            
            [self fillEqualInterestsArrayWithUserArray:aUser andContactArray:objects];
        }
    }];
}


-(void) fillEqualInterestsArrayWithUserArray:(NSArray *)aUser andContactArray:(NSArray *)aContact;
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
    
    [self compareInterestsBetweenUserArray:aUserInterestsObjects andContactArray:aContactInterestsObjects];
}

-(void)compareInterestsBetweenUserArray:(NSArray *)aUser andContactArray:(NSArray *)aContact
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
    
    [self compareTopicsWithEqualInterestArray:aEquals];
}

-(void)compareTopicsWithEqualInterestArray:(NSArray *)aEquals;
{
    //Get Topics
    
    for (int i = 0; i < aEquals.count; i++)
    {
        
        PFObject *interest = aEquals[i];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hobbie.objectId MATCHES %@",interest.objectId];
        
        NSArray *aUserResult = [self.aUserInterests filteredArrayUsingPredicate:predicate];
        NSArray *aContactResult = [self.aUserInterests filteredArrayUsingPredicate:predicate];
        
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
        
        [self.aEqualsInterests addObject:interestObject];
        
    }
    
    
    
    [self insertInterestIntoTableView];
}


-(NSArray *)compareTopicsBetwenArray:(NSArray *)aUser andArray:(NSArray *)aContact
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


#pragma mark - TableView Methods

-(void)insertInterestIntoTableView
{
    [self.tableView beginUpdates];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section)
    {
        case 0:
            return 2;
            break;
            
        case 1:
            return self.aInterests.count;
            break;
        
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: // Header
            if (indexPath.row == 0)
            {
                return 55;
            }
            else
            {
                return 205;
            }
            
            break;
            
        case 1: // interests
            return 55;
            break;
            
        case 2: // Share
            return 60;
            break;
            
        default:
            return 55;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
                
                return cell;
            }
            else
            {
            
            
            ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
            
            //User
            
            PFUser *user = [PFUser currentUser];
            
            cell.lbl_user.text = [NSString stringWithFormat:@"%@ %@",user[@"name"],user[@"surname"]];
            
            PFFile *imageFileUser = user[@"image"];
            [imageFileUser getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (error == nil)
                {
                    cell.img_user.image = [UIImage imageWithData:data];
                }
            }];
            
            
            // Contact
            
            cell.lbl_contactName.text = [NSString stringWithFormat:@"%@ %@",self.contact[@"name"],self.contact[@"surname"]];
            PFFile *imageFileContact = self.contact[@"image"];
            [imageFileContact getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (error == nil)
                {
                    cell.img_contact.image = [UIImage imageWithData:data];
                }
            }];
            
            // Factor
                
                PFQuery *query = [PFQuery queryWithClassName:@"Algorithm"];
                
                [query whereKey:@"usertype" equalTo:self.contact[@"neurotype"]];
                [query whereKey:@"contacttype" equalTo:user[@"neurotype"]];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (error == nil)
                    {
                        PFObject *factor = [objects lastObject];
                        
                        self.factor = factor[@"factor"];
                        
                        int factorPercent = ((self.factor.intValue * 100) / 8);
                        
                        
                        cell.lbl_pertentage.text = [NSString stringWithFormat:@"%d%%",factorPercent];
                    }
                    
                }];
            
            return cell;
                
            }
            
        }
            break;
            
        case 1:
        {
            InterestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interestCell" forIndexPath:indexPath];
            
            PFObject *userInterest = self.aInterests[indexPath.row];
            
            PFObject *interest = userInterest[@"hobbie"];
            
            int percentage = [self verifyContainInterest:interest] * 100;
            
            // cell info
            
            cell.lbl_interest.text = interest[@"name"];
            
            if (percentage > -1)
            {
                cell.lbl_interest.enabled = YES;
                cell.lbl_pertentageInterest.text = [NSString stringWithFormat:@"%d %%",percentage];
            }
            else
            {
                cell.lbl_interest.enabled = NO;
            }
            
            return cell;
        }
            
        case 2:
        {
            ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell" forIndexPath:indexPath];

            
            return cell;
        }
        
            
        default:
            return nil;
            break;
    }
    
}

-(int)verifyContainInterest:(PFObject *)interest
{

    for (int i = 0; i < self.aEqualsInterests.count; i++)
    {
        InterestEqualObject *interestObject = self.aEqualsInterests[i];
        
        if ([interestObject.Interests.objectId isEqualToString:interest.objectId])
        {
            return interestObject.percentage;
            break;
        }
        
    }
    
    return -1;
}

#pragma mark - Actions

-(void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
