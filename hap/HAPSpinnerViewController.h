

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HAPSpinnerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *img_user;
@property (weak, nonatomic) IBOutlet UILabel *lbl_user;

@property (weak, nonatomic) IBOutlet UIImageView *img_contact;
@property (weak, nonatomic) IBOutlet UILabel *lbl_contactName;

@property (strong, nonatomic) PFUser *contact;
@property (strong, nonatomic) UIImage *contactImage;
@property (strong, nonatomic) UIImage *userImage;


@end
