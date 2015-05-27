//
//  ProgressIndicatorView.m
//  HAP
//
//  Created by Joaquin Pereira on 17/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "ProgressIndicatorView.h"

@implementation ProgressIndicatorView

- (id)initWithFrame:(CGRect)frame transform:(CGAffineTransform)transform backgroundView:(UIView *)bView backgroundViewColor:(UIColor *)bColor backgroundViewAlpha:(CGFloat)bAlpha superView:(UIView *)superView textToShow:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        self.center = bView.center;
        self.transform = transform;
        
        _backgroundView = bView;
        
        // Create XIB Connection With Owner
        [[NSBundle mainBundle] loadNibNamed:@"ProgressIndicatorView" owner:self options:nil];
        
        // Stablish the frame (Without this, UIViews doesn't get user responds)
        self.mainView.frame = self.bounds;
        //
        
        // add XIB to this "View"
        [self addSubview:self.mainView];
        
        // background customization
        
        _backgroundView.alpha = 0;
        _backgroundView.backgroundColor = [bColor colorWithAlphaComponent:bAlpha];
        
        _lbl_text.text = text;
        
        self.viewCenterView.layer.cornerRadius = 15;
        
        // Views
        
        _img_check.hidden = YES;
        
        
    }
    
    // BackgroundView
    [bView addSubview:self];
    
    //Super View
    [superView addSubview:bView];
    
    return self;
    
    
}

-(void)openPopUp
{
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.9
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            
                            self.backgroundView.alpha = 1;
                            self.alpha = 1;
                            self.transform = CGAffineTransformMakeScale(1, 1);
                            
                        } completion:nil];
}

-(void)closePopUp
{
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1.9
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            
                            self.backgroundView.alpha = 0;
                            self.transform = CGAffineTransformMakeScale(1.4, 1.4);
                            self.alpha = 0;
                            
                            
                        } completion:nil];
    
    
}

-(void)closePopUpWithMessage:(NSString *)text withCheck:(BOOL)showCheck completion:(void(^)(BOOL finished))completionHandler
{
    self.activityView.hidden = YES;
    self.lbl_text.text = text;
    
    if (showCheck == YES)
    {
        self.img_check.hidden = NO;
    }
    
    [UIView animateWithDuration:0.4
                          delay:1
         usingSpringWithDamping:1
          initialSpringVelocity:1.9
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            
                            self.backgroundView.alpha = 0;
                            self.transform = CGAffineTransformMakeScale(1.4, 1.4);
                            self.alpha = 0;
                            
                            
                        } completion:^(BOOL finished) {
                            
                            
                            completionHandler(YES);
                            
                        }];
    
    
}

@end
