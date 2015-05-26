//
//  InterestsCollectionViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "InterestsCollectionViewController.h"
#import "InterestCollectionViewCell.h"
#import "SubInterestsCollectionViewController.h"
#import "alertPopUpView.h"
#import "NextCollectionViewCell.h"

@interface InterestsCollectionViewController ()


@property (strong, nonatomic) NSMutableArray *aIndexPath;
@property (strong, nonatomic) NSArray *aInterests;
@property (strong, nonatomic) NSMutableArray *aSelectedInterest;
@property (nonatomic) BOOL animating;

@end

@implementation InterestsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aIndexPath = [NSMutableArray new];
    self.aSelectedInterest = [NSMutableArray new];
    self.animating = YES;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Navigation Bar
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    // Image a the top
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    image.image = [UIImage imageNamed:@"logoHi_2.png"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    sview.center = self.navigationController.navigationBar.center;
    
    [sview addSubview:image];
    
    self.navigationItem.titleView = sview;
    
    
    
    // methods
    
    [self downloadInterests];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    
    alertPopUpView *alertPopUp = [[alertPopUpView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height - 150)
                                                                      transform:CGAffineTransformMakeScale(1.4, 1.4)
                                                                 backgroundView:backView
                                                            backgroundViewColor:[UIColor blackColor]
                                                            backgroundViewAlpha:0.6
                                                                      superView:self.view];
    
    
    [alertPopUp openPopUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse

- (void)downloadInterests
{
    PFQuery *query = [PFQuery queryWithClassName:@"Hobbie"];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if(error == nil)
        {
            self.aInterests = objects;
            
            //
            self.animating = NO;
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
            
            [self insertArrayIntoCollectionView];
        }
        
    }];
    
    
}

#pragma mark - CollectionView Methods

-(void)insertArrayIntoCollectionView
{
    [self.collectionView performBatchUpdates:^{
        
        
        //
        
        [self.collectionView deleteItemsAtIndexPaths:self.aIndexPath];
        [self.aIndexPath removeAllObjects];
        
        
        for (int i = 0; i < self.aInterests.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
            
            [self.aIndexPath addObject:indexPath];
            
        }
        
        [self.collectionView insertItemsAtIndexPaths:self.aIndexPath];
        
        
        
    } completion:nil];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    switch (section)
    {
        case 0:
        {
            if(self.animating == YES)
            {
                return 2;
            }
            else
            {
                return 1;
            }
            
            break;
        }

        case 1:
            return self.aIndexPath.count;
            break;
        
        case 2:
            return 1;
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
            CGSize itemSize = CGSizeMake(self.view.frame.size.width, 55);
            return itemSize;
            
            break;
        }
            
        case 1:
        {
            CGSize itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3);
            return itemSize;
            
            break;
        }
            
        case 2:
        {
            CGSize itemSize = CGSizeMake(self.view.frame.size.width, 100);
            return itemSize;
            
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
            if (self.animating == YES)
            {
                if (indexPath.row == 0)
                {
                    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
                    return cell;
                }
                else
                {
                    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"animatingCell" forIndexPath:indexPath];
                    return cell;
                }
            }
            else
            {
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
                return cell;
            }
            
            break;
        }
            
        case 1:
        {
            InterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCell" forIndexPath:indexPath];
            
            PFObject *interest = self.aInterests[indexPath.row];
            
            
            cell.lbl_name.text = interest[@"name"];
            
            PFFile *imageFile = interest[@"image"];
            
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if(error == nil)
                {
                    cell.img_image.image = [UIImage imageWithData:data];
                }
                
            }];
            
            
            // Configure the cell
            
            return cell;
            break;
        }
            
        case 2:
        {
            NextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nextCell" forIndexPath:indexPath];
            
            return cell;
        }
            
            
        default:
            return nil;
            break;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
        case 1:
        {
            InterestCollectionViewCell *cell = (InterestCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            if(cell.img_checkImage.hidden == NO)
            {
                cell.img_checkImage.hidden = YES;
                
                // Remove item
                
                NSNumber *item = @(indexPath.row);
                
                [self.aSelectedInterest removeObjectIdenticalTo:item];
                
                
            }
            else
            {
                cell.img_checkImage.hidden = NO;
                
                // Add item
                
                NSNumber *item = @(indexPath.row);
                
                [self.aSelectedInterest addObject:item];
                
                //[self.aSelectedInterest addObject:interest];
            }
            break;
        }
        
        case 2:
        {
            break;
        }
        default:
            break;
    }
    
}

-(NSArray *)createInterestArray
{
    NSMutableArray *array = [NSMutableArray new];
    
    //Sort Array
    
    NSSortDescriptor *sortItems = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.aSelectedInterest sortUsingDescriptors:@[sortItems]];
    
    for (int i = 0; i < self.aSelectedInterest.count; i++)
    {
        
        NSNumber *item = self.aSelectedInterest[i];
        
        PFObject *interest = [PFObject objectWithClassName:@"UserHobbie"];
        
        interest[@"user"] = [PFUser currentUser];
        interest[@"hobbie"] = self.aInterests[item.intValue];
        
        [array addObject:interest];
    }
    
    return array;
}


 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 
     SubInterestsCollectionViewController *cSubInterest = [segue destinationViewController];
     
     cSubInterest.aInterest = [self createInterestArray];
     
 }
@end
