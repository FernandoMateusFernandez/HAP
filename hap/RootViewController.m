//
//  RootViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "RootViewController.h"
#import "SplashViewController.h"

@interface RootViewController ()

//@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *aImages;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    self.aImages = @[@"intro_0.jpg",@"intro_1.jpg",@"intro_2.jpg",@"intro_3.jpg",@"intro_4.jpg"];
    
    SplashViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    //
    
    // Image a the top
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 35, 35)];
    image.image = [UIImage imageNamed:@"logoHi_2.png"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(-10, 10, 145, 16)];
    lbl_title.font = [UIFont fontWithName:@"HelveticaNeue-light" size:20];
    lbl_title.textAlignment = NSTextAlignmentRight;
    lbl_title.textColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    lbl_title.text = @"Welcome to";
    
    
    UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    sview.center = self.navigationController.navigationBar.center;
    
    [sview addSubview:image];
    [sview addSubview:lbl_title];
    
    self.navigationItem.titleView = sview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Data Source

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SplashViewController*) viewController).pageIndex;
    
    if (index == 0)
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SplashViewController*) viewController).pageIndex;
    
    index++;
    
    if (index == 5)
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (SplashViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= 5)
    {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    SplashViewController *SplashViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    SplashViewController.pageIndex = index;
    SplashViewController.imageNamed = self.aImages[index];
    
    return SplashViewController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)skipIntro:(id)sender {
    
    
    // Save nsuserdefaults
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    
    [userDefautls setObject:[NSNumber numberWithBool:YES] forKey:@"introSeen"];
    
    [userDefautls synchronize];
}
@end
