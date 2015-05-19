//
//  ProfileCollectionViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/13/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "UIImage+Resize.h"

@interface ProfileCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *aIndexPath;
@property (strong, nonatomic) NSArray *aInterests;

@property (strong, nonatomic) UIImage *userImage;

@end

@implementation ProfileCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aIndexPath = [NSMutableArray new];
    
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
            ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileCell" forIndexPath:indexPath];
            
            
            PFUser *user = [PFUser currentUser];
            
            PFFile *imageFile = user[@"image"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                cell.img_image.image = [UIImage imageWithData:data];
                
            }];
            
            cell.lbl_name.text = [NSString stringWithFormat:@"%@ %@",user[@"name"],user[@"surname"]];
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
                InterestsHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestsHeaderCell" forIndexPath:indexPath];
                
                
                return cell;
            }
            else
            {
                InterestProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCell" forIndexPath:indexPath];
                
                
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

#pragma mark - Profile cell Delegate

- (void)ProfileCollectionViewCellDidTouchPicture
{
    [self changeImage];
}


-(void)changeImage{
    
    
    // Create actionSheet
    
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Select an option"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Camera",@"Photo Library", nil];
    
    
    [aSheet showInView:self.view];
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self showImagePickerForSource:@"camera"];
            break;
            
        case 1:
            [self showImagePickerForSource:@"photoLibrary"];
            break;
            
        default:
            break;
    }
}


-(void)showImagePickerForSource:(NSString *)source
{
    // Change image
    
    UIImagePickerController *cPicker = [UIImagePickerController new];
    
    //Do you have a camera?
    
    if([source isEqualToString:@"camera"])
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            cPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else{
            
            cPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    else
    {
        cPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    
    // delegate
    cPicker.delegate = self;
    
    //Editing
    cPicker.allowsEditing = YES;
    
    [self presentViewController:cPicker animated:YES completion:nil];
    
}


#pragma mark - UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Warning, could be a memory warning here!
    
    
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // lets resize the image to avoid memory warnings
    
    CGSize size = CGSizeMake(400, 400);
    
    // Using trevors API to resize and fix orientation
    self.userImage = [pickerImage resizedImage:size interpolationQuality:kCGInterpolationMedium];
    
    // Send it to coredata or parse
    
    //Close image picker
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PFUser *currentUser = [PFUser currentUser];
        
        PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(self.userImage)];
        
        currentUser[@"image"] = imageFile;
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            
            if (succeeded == YES)
            {
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
            }
            
        }];
    }];
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    
    // Picture shadow circle
    
    if ([navigationController.viewControllers count] == 3)
    {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        UIView *plCropOverlay = [[[viewController.view.subviews objectAtIndex:1]subviews] objectAtIndex:0];
        
        plCropOverlay.hidden = YES;
        
        int yPosition = 0;
        int width = 0;
        int height = 0;
        
        
        
        //iPHone 4s / 5 / 5s
        if(screenWidth == 320)
        {
            width = screenWidth;
            
            if(screenHeight == 568) //iPhone 5 / 5s
            {
                yPosition = 124;
                height = 320;
            }
            else // iPhone 4s
            {
                yPosition = 79;
                height = 320;
            }
        }
        
        // iPhone 6
        if(screenWidth == 375)
        {
            yPosition = 145;
            width = 375;
            height = 375;
        }
        
        
        // iPhone 6 plus
        if(screenWidth == 414)
        {
            yPosition = 160;
            width = 414;
            height = 414;
        }
        
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        
        
        // Circle Path
        UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                               CGRectMake(0.0f, yPosition, width, height)];
        
        
        [path2 setUsesEvenOddFillRule:YES];
        [circleLayer setPath:[path2 CGPath]];
        [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        
        // Full path
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, screenHeight-72) cornerRadius:0];
        [path appendPath:path2];
        [path setUsesEvenOddFillRule:YES];
        
        
        
        // Customize Path
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor blackColor].CGColor;
        fillLayer.opacity = 0.3;
        [viewController.view.layer addSublayer:fillLayer];
        
        
        // Top label
        UILabel *moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, width, 50)];
        [moveLabel setText:@"Move and Scale"];
        [moveLabel setTextAlignment:NSTextAlignmentCenter];
        [moveLabel setTextColor:[UIColor whiteColor]];
        
        [viewController.view addSubview:moveLabel];
    }
    
}
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

@end
