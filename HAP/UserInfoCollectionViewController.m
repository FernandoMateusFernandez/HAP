//
//  UserInfoCollectionViewController.m
//  Hi
//
//  Created by Joaquin Pereira on 26/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "UserInfoCollectionViewController.h"

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
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
