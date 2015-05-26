


#import "HAPSpinnerViewController.h"
#import "FeSpinnerTenDot.h"
#import "ResultTableViewController.h"


@interface HAPSpinnerViewController () <FeSpinnerTenDotDelegate>
{
    NSInteger index;
}
@property (strong, nonatomic) FeSpinnerTenDot *spinner;
@property (strong, nonatomic) NSArray *arrTitile;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSNumber *factor;

- (IBAction)start:(id)sender;
- (IBAction)dismiss:(id)sender;
-(void) changeTitle;
-(void) longTask;
@end

@implementation HAPSpinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.img_user.layer.cornerRadius = 40;
    self.img_contact.layer.cornerRadius = 40;
    
    // Set user Info
    
    [self setUsersInformation];
    
    self.navigationController.navigationBar.hidden = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    //*********
    index = 0;
    _arrTitile = @[@"Calculating",@"Almost ready",@"Just one sec",@"SUCCESSFUL"];
    
    // init Loader
    _spinner = [[FeSpinnerTenDot alloc] initWithView:self.view withBlur:NO];
    _spinner.titleLabelText = _arrTitile[index];
    _spinner.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:36];
    _spinner.delegate = self;
    
    [self.view addSubview:_spinner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self start:self];
    
    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:7.0f];
}
- (IBAction)start:(id)sender
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    }
    
    [_spinner showWhileExecutingSelector:@selector(longTask) onTarget:self withObject:nil completion:^{
        [_timer invalidate];
        _timer = nil;
        
        index = 0;
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
-(void) longTask
{
    // Do a long take
    sleep(5);
}
- (IBAction)dismiss:(id)sender
{
    [_timer invalidate];
    [_spinner dismiss];
    
    // pop
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void) changeTitle
{
    //NSLog(@"index = %ld",(long)index);
    
    if (index >= _arrTitile.count)
        return;
    
    _spinner.titleLabelText = _arrTitile[index];
    index++;
}
-(void) FeSpinnerTenDotDidDismiss:(FeSpinnerTenDot *)sender
{
    [self performSegueWithIdentifier:@"result" sender:self];
}


#pragma mark - UserInterface




-(void)setUsersInformation
{
    self.img_user.image = self.userImage;
    self.img_contact.image = self.contactImage;
    
    PFUser *user = [PFUser currentUser];
    
    self.lbl_contactName.text = [NSString stringWithFormat:@"%@ %@", self.contact[@"name"], self.contact[@"surname"]];
    self.lbl_user.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ResultTableViewController *cResult = [segue destinationViewController];
    
    cResult.user = [PFUser currentUser];
    cResult.contact = self.contact;
}





@end
