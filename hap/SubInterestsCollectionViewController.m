//
//  SubInterestsCollectionViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "SubInterestsCollectionViewController.h"
#import "InterestCollectionViewCell.h"
#import "HeaderCollectionViewCell.h"

@interface SubInterestsCollectionViewController ()

@property (strong, nonatomic) NSArray *aSubInterests;
@property (strong, nonatomic) NSMutableArray *aIndexPath;
@property (strong, nonatomic) NSMutableArray *aInterestsToSave;
@property (strong, nonatomic) NSString *currentInterest;

@property (nonatomic) BOOL animating;

@property (nonatomic) int counter;

@end

@implementation SubInterestsCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aIndexPath = [NSMutableArray new];
    self.aInterestsToSave = [NSMutableArray new];
    self.animating = YES;
    
    [self downloadSubInterestFor:[self.aInterest firstObject]];
    self.counter++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Parse

-(void)downloadSubInterestFor:(PFObject *)object
{
    PFQuery *query = [PFQuery queryWithClassName:@"HobbieTopic"];
    [query whereKey:@"hobbie" equalTo:object[@"hobbie"]];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (error == nil)
        {
            self.aSubInterests = objects;
            
            //
            self.animating = NO;
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
            
            [self insertArrayIntoCollectionView];
        }
    }];
    
    
    // Set title
    [self setHeaderTitleWithCurrentObject:object];
    
}

-(void)setHeaderTitleWithCurrentObject:(PFObject *)object
{
    PFObject *interest = object[@"hobbie"];
    self.currentInterest = interest[@"name"];
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


#pragma mark - CollectionView Methods

-(void)insertArrayIntoCollectionView
{
    [self.collectionView performBatchUpdates:^{
        
        
        //Delete previous indexpaths
        
        [self.collectionView deleteItemsAtIndexPaths:self.aIndexPath];
        [self.aIndexPath removeAllObjects];
        
        
        for (int i = 0; i < self.aSubInterests.count; i++)
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
            CGSize itemSize = CGSizeMake(self.view.frame.size.width, 105);
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
                    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];

                    
                    cell.lbl_title.text = self.currentInterest;
                    
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
            
            PFObject *interest = self.aSubInterests[indexPath.row];
            
            [cell hideCheck];
            
            
            cell.lbl_name.text = interest[@"name"];
            
            cell.img_image.image = [UIImage imageNamed:@"placeholder.png"];
            
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
            
            cell.delegate = self;
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
                
                
            }
            else
            {
                cell.img_checkImage.hidden = NO;
                
                //Proceed
                PFObject *interest = self.aInterest[self.counter - 1];
                [interest addUniqueObject:self.aSubInterests[indexPath.row] forKey:@"topics"];
                
                [self.aInterestsToSave addObject:interest];
            }
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - NextCell delegate

- (void)NextCollectionViewCellDidTouchNext
{
    if (self.counter < self.aInterest.count)
    {
        //Remove all cells;
        
        [self.collectionView performBatchUpdates:^{
            
            [self.collectionView deleteItemsAtIndexPaths:self.aIndexPath];
            [self.aIndexPath removeAllObjects];
            
            self.animating = YES;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
        } completion:^(BOOL finished) {

            [self downloadSubInterestFor:self.aInterest[self.counter]];
            self.counter++;
            
        }];
    }
    else
    {
        //No more interests
        
        // Save all interest in Parse
        
        [PFObject saveAllInBackground:self.aInterestsToSave];
        
        [self performSegueWithIdentifier:@"questionnaire" sender:self];
    }
}

@end
