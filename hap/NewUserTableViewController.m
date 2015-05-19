//
//  NewUserTableViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/16/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "NewUserTableViewController.h"
#import <Parse/Parse.h>
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "ProgressIndicatorView.h"

@interface NewUserTableViewController ()

@property (strong, nonatomic) NSArray *arrayGenders;
@property (strong, nonatomic) UIPickerView *picker_GenderPicker;
@property (strong, nonatomic) UIImage *userImage;

@end

@implementation NewUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create views
    self.picker_GenderPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.arrayGenders = @[@"Female",@"Male"];
    self.picker_GenderPicker.delegate = self;
    self.picker_GenderPicker.backgroundColor = [UIColor whiteColor];
    self.txt_gender.inputView = self.picker_GenderPicker;
    
    [self barButtonItemsPickers];
    
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(changeImage)];
    
    
    [self.img_image setUserInteractionEnabled:YES];
    [self.img_image addGestureRecognizer:newTap];
    
    
    //User Image
    self.img_image.layer.cornerRadius = 60;
    self.img_image.layer.borderWidth = 1;
    self.img_image.layer.borderColor = [UIColor colorWithRed:0.992 green:0.722 blue:0.004 alpha:1].CGColor;
    
    //
    
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [self.img_back addGestureRecognizer:tapBack];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView DataSource and Delegate


// Data Source

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrayGenders objectAtIndex:row];
}


// Delegate

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.txt_gender.text = [self.arrayGenders objectAtIndex:row];
}



-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField.tag == 3)
    {
        // asign the first value
        self.txt_gender.text = [self.arrayGenders objectAtIndex:0];
        
    }
}

#pragma mark - Customization methods

-(void)barButtonItemsPickers
{
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    
    // adding buttons
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPicker:)];
    
    // Adding spacing
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    // assign them to the bar
    
    [toolBar setItems:@[space,done]];
    
    
    // Then to the textfield
    
    self.txt_gender.inputAccessoryView = toolBar;
    
}


-(void) dismissPicker:(id)sender
{
    [self.view endEditing:YES];
}


#pragma mark - actionSheet

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
    
    // Get the actually iPhone Size
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGSize size = CGSizeMake(400, 400);
    
    // Using trevors API to resize and fix orientation
    self.userImage = [pickerImage resizedImage:size interpolationQuality:kCGInterpolationMedium];
    self.img_image.image = self.userImage;
    
    self.img_image.image = pickerImage;
    self.img_image.contentMode = UIViewContentModeScaleAspectFit;
    self.img_image.clipsToBounds = YES;
    // Send it to coredata or parse
    
    //Close image picker
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

- (IBAction)createAccount:(id)sender {
    
    
    // Open progressView
    
    //Show indicator
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    ProgressIndicatorView *viewProgress = [[ProgressIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height - 10)
                                                                             transform:CGAffineTransformMakeScale(1.4, 1.4)
                                                                        backgroundView:backView
                                                                   backgroundViewColor:[UIColor clearColor]
                                                                   backgroundViewAlpha:0.6
                                                                             superView:self.view textToShow:@"Creating account"];
    
    [viewProgress openPopUp];
    
    //Parse work
    
    PFUser *newUser = [PFUser user];
    PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(self.userImage)];
    
    newUser.username = self.txt_email.text;
    newUser.email = self.txt_email.text;
    newUser.password = self.txt_password.text;
    
    newUser[@"gender"] = self.txt_gender.text;
    newUser[@"name"] = self.txt_name.text;
    newUser[@"surname"] = self.txt_surname.text;
    newUser[@"image"] = imageFile;
    
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if(succeeded == YES)
        {
            [viewProgress closePopUp];
            
            [viewProgress removeFromSuperview];
            
            [self performSegueWithIdentifier:@"questionnaire" sender:self];
        }
        else
        {
            NSLog(@"Error");
        }
        
    }];
    
    
    
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
