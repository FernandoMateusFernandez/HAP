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
#import "AffinityCenter.h"

@interface ResultTableViewController ()

@property (strong, nonatomic) NSNumber *factor;
@property (strong, nonatomic) NSArray *aSimilarInterests;

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialization
    self.aSimilarInterests = [NSMutableArray new];
    
    self.factor = [NSNumber numberWithInt:0];
    
    // Hi Logo at the top
    
    // Image a the top
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    image.image = [UIImage imageNamed:@"logoHi_2.png"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    sview.center = self.navigationController.navigationBar.center;
    
    [sview addSubview:image];
    
    self.navigationItem.titleView = sview;
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self calculateAffinity];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calculateAffinity
{
    [AffinityCenter calculateAffinityWithUser:self.user contact:self.contact completion:^(NSNumber *factor, NSArray *aSimilarInterests) {
        
        self.factor = factor;
        self.aSimilarInterests = aSimilarInterests;
        
        [self insertInterestIntoTableView];
        
    }];
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
            return self.aSimilarInterests.count;
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
            
            InterestEqualObject *userInterest = self.aSimilarInterests[indexPath.row];
            
            PFObject *interest = userInterest.Interest;
            int percentage = userInterest.percentage * 100;
            
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
