//
//  QuestionnaireCollectionViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "QuestionnaireCollectionViewController.h"
#import "TopViewController.h"
#import "QuestionnairePopUpView.h"

@interface QuestionnaireCollectionViewController ()

@property (strong, nonatomic) NSArray *aQuestions;
@property (strong, nonatomic) NSMutableArray *aIndexPath;

@property (strong, nonatomic) NSString *personality;
@property (strong, nonatomic) NSString *neurotype;

@property (nonatomic) int e;
@property (nonatomic) int n;

@property (strong, nonatomic) TopViewController *topView;

@property (nonatomic) BOOL progressCell;

@end

@implementation QuestionnaireCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.aIndexPath = [NSMutableArray new];
    self.progressCell = YES;
    
    //View
    self.topView = [[TopViewController alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width - 50, 40)];
    
    self.topView.center = self.view.center;
    self.topView.frame = CGRectMake(self.topView.frame.origin.x, 15, self.topView.frame.size.width, 40);
    [self.topView startPosition];
    
    [self.view addSubview:self.topView];
    
    // Navigation Bar
    self.navigationItem.hidesBackButton = YES;
    
    // Image a the top
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    image.image = [UIImage imageNamed:@"logoHi_2.png"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    sview.center = self.navigationController.navigationBar.center;
    
    [sview addSubview:image];
    
    self.navigationItem.titleView = sview;
    
    
    //
    [self downloadQuestions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse

-(void)downloadQuestions
{

    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query orderByAscending:@"number"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if (error == nil)
        {
            //
            self.progressCell = NO;
            
            self.aQuestions = objects;
            
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
        
        
        for (int i = 0; i < self.aQuestions.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self.aIndexPath addObject:indexPath];
            
        }
        
        [self.collectionView insertItemsAtIndexPaths:self.aIndexPath];
        
        // Delete progress Cell
        
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]];
        
        
        
    } completion:nil];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    switch (section) {
        case 0:
            return self.aIndexPath.count;
            break;
            
        case 1:
        {
            if (self.progressCell == YES)
            {
                return 1;
            }
            else
            {
                return 0;
            }
            break;
        }
            
            
        default:
            return 0;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    return itemSize;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            QuestionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"questionCell" forIndexPath:indexPath];
            
            PFObject *question = self.aQuestions[indexPath.row];
            
            cell.delegate = self;
            cell.letter = question[@"letter"];
            cell.value = question[@"answer"];
            
            // Text
            cell.lbl_question.text = question[@"text"];
            [cell.lbl_question sizeToFit];
            
            
            // Image
            PFFile *imageFile = question[@"image"];
            cell.img_image.image = nil;
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                cell.img_image.image = [UIImage imageWithData:data];
                
                //[cell.activityView stopAnimating];
                
            }];
            
            if(indexPath.row == 47)
            {
                cell.lbl_lastQuestion.hidden = NO;
            }
            
            return cell;
            
            break;
        }
            
        case 1:
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"progressCell" forIndexPath:indexPath];
            
            return cell;
        }
            
            
        default:
            return nil;
            break;
    }

}





#pragma mark - Question delegate

- (void)QuestionCollectionViewCellDidTouchYesWithCell:(QuestionCollectionViewCell *)cell
{
    if (cell.value.boolValue == YES)
    {
        if([cell.letter isEqualToString:@"E"])
        {
            self.e++;
        }
        else
        {
            self.n++;
        }
    }
    
    NSIndexPath *currentItem = [self.collectionView indexPathForCell:cell];
    
    if(currentItem.row != 47)
    {
        NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item + 1 inSection:currentItem.section];
        
        [self.topView moveToQuestiong:currentItem.row];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem.item inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else
    {
        
        // calculate personality
        [self calculatePersonality];
        
        // Save result in Parse
        PFUser *user = [PFUser currentUser];
        user[@"personality"] = self.personality;
        [user saveInBackground];
        
        // open Pop up
        
        UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        QuestionnairePopUpView *PopUp = [[QuestionnairePopUpView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height - 10)
                                                                            transform:CGAffineTransformMakeScale(1.4, 1.4)
                                                                       backgroundView:backView
                                                                  backgroundViewColor:[UIColor blackColor]
                                                                  backgroundViewAlpha:0.6
                                                                            superView:self.view];
        
        PopUp.delegate = self;
        
        
        [PopUp openPopUp];
    }
    
    
}

- (void)QuestionCollectionViewCellDidTouchNoWithCell:(QuestionCollectionViewCell *)cell
{
    if (cell.value.boolValue == NO)
    {
        if([cell.letter isEqualToString:@"E"])
        {
            self.e++;
        }
        else
        {
            self.n++;
        }
    }
    
    NSIndexPath *currentItem = [self.collectionView indexPathForCell:cell];
    
    if(currentItem.row != 47)
    {
        
        NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item + 1 inSection:currentItem.section];
        
        [self.topView moveToQuestiong:currentItem.row];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem.item inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else
    {
        
        // calculate personality
        [self calculatePersonality];
        
        // Save result in Parse
        PFUser *user = [PFUser currentUser];
        user[@"personality"] = self.personality;
        user[@"neurotype"] = self.neurotype;
        [user saveInBackground];
        
        // Show pop Up
        
        
        UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        QuestionnairePopUpView *PopUp = [[QuestionnairePopUpView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height - 80)
                                                                            transform:CGAffineTransformMakeScale(1.4, 1.4)
                                                                       backgroundView:backView
                                                                  backgroundViewColor:[UIColor blackColor]
                                                                  backgroundViewAlpha:0.6
                                                                            superView:self.view];
        
        PopUp.delegate = self;
        
        
        [PopUp openPopUp];
    }
}

#pragma mark - PopUp Delegate

- (void)QuestionnairePopUpViewDidClose
{
    [self.topView removeFromSuperview];
    [self performSegueWithIdentifier:@"profile" sender:self];
}


-(void)calculatePersonality
{
    if (self.n >= 0 && self.n <= 6)
    {
        if (self.n >= 0 && self.n <= 12 )
        {
            self.personality = @"Altamente Flematico";
            self.neurotype = @"F";
        }
        else
        {
            self.personality = @"Altamente Sanguineo";
            self.neurotype = @"S";
        }
        
    }
    
    if (self.n >= 7 && self.n <= 11)
    {
        if (self.n >= 0 && self.n <= 9 )
        {
            self.personality = @"Altamente Flematico";
            self.neurotype = @"F";
        }
        
        if (self.n >= 10 && self.n <= 12 )
        {
            self.personality = @"Flematico";
            self.neurotype = @"F";
        }
        
        if (self.n >= 13 && self.n <= 15 )
        {
            self.personality = @"Sanguineo";
            self.neurotype = @"S";
        }
        
        if (self.n >= 16 && self.n <= 24 )
        {
            self.personality = @"Altamente Sanguineo";
            self.neurotype = @"S";
        }
        
    }
    
    if (self.n >= 13 && self.n <= 17)
    {
        if (self.n >= 0 && self.n <= 9 )
        {
            self.personality = @"Altamente Melancolico";
            self.neurotype = @"M";
        }
        
        if (self.n >= 10 && self.n <= 12 )
        {
            self.personality = @"Melancolico";
            self.neurotype = @"M";
        }
        
        if (self.n >= 13 && self.n <= 15 )
        {
            self.personality = @"Colerico";
            self.neurotype = @"C";
        }
        
        if (self.n >= 16 && self.n <= 24 )
        {
            self.personality = @"Altamente Colerico";
            self.neurotype = @"C";
        }
        
    }
    
    if (self.n >= 18 && self.n <= 24)
    {
        if (self.n >= 0 && self.n <= 12 )
        {
            self.personality = @"Altamente Melancolico";
            self.neurotype = @"M";
        }
        else
        {
            self.personality = @"Altamente Colerico";
            self.neurotype = @"C";
        }
        
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].

     
 }

@end