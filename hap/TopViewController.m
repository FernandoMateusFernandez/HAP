//
//  TopViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/14/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "TopViewController.h"

@implementation TopViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        
        // Create XIB Connection With Owner
        [[NSBundle mainBundle] loadNibNamed:@"TopView" owner:self options:nil];
        
        // Stablish the frame (Without this, UIViews doesn't get user responds)
        self.mainView.frame = self.bounds;
        
        // add XIB to this "View"
        [self addSubview:self.mainView];
        
        
        self.viewBackBar.layer.cornerRadius = 4;
        self.viewBackBar.layer.borderColor = [UIColor whiteColor].CGColor;
        self.viewBackBar.layer.borderWidth = 1;
    }
    
    
    return self;
}



-(void)startPosition
{
    self.viewBar.frame = CGRectMake(0, 0, 0, 20);
    self.img_tootlTip.frame = CGRectMake(-9, self.img_tootlTip.frame.origin.y, self.img_tootlTip.frame.size.width, self.img_tootlTip.frame.size.height);
    self.lbl_percentage.center = self.img_tootlTip.center;
    self.lbl_percentage.frame = CGRectMake(self.lbl_percentage.frame.origin.x, self.lbl_percentage.frame.origin.y - 2,self.lbl_percentage.frame.size.width, self.lbl_percentage.frame.size.height);
    
    self.lbl_percentage.text = @"0%";
}

-(void)moveToQuestion:(int)question
{
    int percentage = ((question*100)/47);
    
    CGFloat width = ((percentage * self.viewBackBar.frame.size.width) / 100);
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.viewBar.frame = CGRectMake(0, 0, width, self.viewBar.frame.size.height);
        
        self.img_tootlTip.frame = CGRectMake(-9 + width, self.img_tootlTip.frame.origin.y, self.img_tootlTip.frame.size.width, self.img_tootlTip.frame.size.height);
        self.lbl_percentage.center = self.img_tootlTip.center;
        
        self.lbl_percentage.frame = CGRectMake(self.lbl_percentage.frame.origin.x, self.lbl_percentage.frame.origin.y - 2,self.lbl_percentage.frame.size.width, self.lbl_percentage.frame.size.height);
        
        self.lbl_percentage.text = [NSString stringWithFormat:@"%d%%",percentage];
        
    } completion:nil];
}
@end
