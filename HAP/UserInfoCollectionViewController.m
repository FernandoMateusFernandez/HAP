//
//  UserInfoCollectionViewController.m
//  Hi
//
//  Created by Joaquin Pereira on 26/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "UserInfoCollectionViewController.h"
#import "InterestUserInfoHeaderCollectionViewCell.h"

@interface UserInfoCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *aIndexPath;
@property (strong, nonatomic) NSArray *aInterests;

@end

@implementation UserInfoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aIndexPath = [NSMutableArray new];
    
    //
    [self downloadInterests];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadInterests
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserHobbie"];
    
    [query whereKey:@"user" equalTo:self.userToShow];
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"hobbie"];
    [query includeKey:@"topics"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil)
        {
            self.aInterests = objects;
            
            [self insertArrayIntoCollectionView];
        }
    }];
}

#pragma mark - CollectionView Methods

-(void)insertArrayIntoCollectionView
{
    [self.collectionView performBatchUpdates:^{
        
        
        for (int i = 0; i < self.aInterests.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i+1 inSection:1];
            
            [self.aIndexPath addObject:indexPath];
            
        }
        
        [self.collectionView insertItemsAtIndexPaths:self.aIndexPath];
        
        
        
    } completion:nil];
}


#pragma mark <UICollectionViewDataSource>

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1 + self.aIndexPath.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            CGSize itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            return itemSize;
            
            break;
        }
            
        case 1:
        {
            if (indexPath.row == 0)
            {
                CGSize itemSize = CGSizeMake(self.view.frame.size.width, 135);
                return itemSize;
            }
            else
            {
                CGSize itemSize = CGSizeMake(self.view.frame.size.width, 40);
                return itemSize;
            }
            break;
        }
            
        default:
            return CGSizeZero;
            break;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section)
    {
        case 0:
        {
            UserInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"userInfoCell" forIndexPath:indexPath];
            
            
            PFUser *user = self.userToShow;
            
            PFFile *imageFile = user[@"image"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                cell.img_image.image = [UIImage imageWithData:data];
                
            }];
            
            cell.lbl_nameSurname.text = [NSString stringWithFormat:@"%@ %@",user[@"name"],user[@"surname"]];
            cell.lbl_personality.text = user[@"personality"];
            
            // Delegate
            cell.delegate = self;
            
            return cell;
            
            break;
        }
            
        case 1:
        {
            if (indexPath.row == 0)
            {
                InterestUserInfoHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
                
                
                return cell;
            }
            else
            {
                InterestUserInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCell" forIndexPath:indexPath];
                
                
                PFObject *object = self.aInterests[indexPath.row - 1];
                PFObject *interest = object[@"hobbie"];
                
                
                cell.lbl_interest.text = interest[@"name"];
                
                PFFile *imageFile = interest[@"image"];
                
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    
                    cell.img_image.image = [UIImage imageWithData:data];
                    
                }];
                
                return cell;
            }
            
            
            break;
        }
            
        default:
            return nil;
            break;
    }
    
}

#pragma mark - UserInfo Delegate

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)dissmissController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
