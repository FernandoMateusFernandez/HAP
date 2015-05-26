//
//  FindContactTableViewController.m
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "FindContactTableViewController.h"
#import "ProfileCollectionViewController.h"
#import "UserTableViewCell.h"


@interface FindContactTableViewController ()

@property (strong, nonatomic) NSMutableArray *aIndexPath;
@property (strong, nonatomic) NSMutableArray *aUsers;

@end

@implementation FindContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialization
    self.aUsers = [NSMutableArray new];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Downloads from Parse

- (void)downloadUsersWithString:(NSString *)text
{
    
    if (text.length > 0)
    {
        PFQuery *query = [PFUser query];
        
        [query whereKey:@"name" containsString:text.capitalizedString];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error == nil)
            {
                self.aUsers.array = objects;
                
                [self insertUsersIntoTableView];
            }
            
        }];
    }
    else
    {
        [self.aUsers removeAllObjects];
        
        [self insertUsersIntoTableView];
    }
    
}


-(void)insertUsersIntoTableView
{
    [self.tableView beginUpdates];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return self.aUsers.count;
            break;
            
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            FindUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findCell" forIndexPath:indexPath];
            
            cell.delegate = self;
            
            return cell;
            
            
        }
            break;
            
        case 1:
        {
            UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"forIndexPath:indexPath];
            
            PFUser *user = self.aUsers[indexPath.row];
            
            cell.lbl_name.text = [NSString stringWithFormat:@"%@ %@",user[@"name"],user[@"surname"]];
            
            
            
            
            PFFile *imageFile = user[@"image"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (error == nil)
                {
                    cell.img_user.image = [UIImage imageWithData:data];
                }
                
            }];
            
            return cell;
            
        }
            
        default:
            return nil;
            break;
    }
}

#pragma mark - FindContactDelegate

- (void)FindUserTableViewCellDelegateDidWriteText:(NSString *)text
{
    [self downloadUsersWithString:text];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *cNav = [segue destinationViewController];
    
    ProfileCollectionViewController *cProfile = (ProfileCollectionViewController *)[cNav topViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    PFUser *selectedUser = self.aUsers[indexPath.row];
    
    cProfile.profileUser = selectedUser;
}


@end
