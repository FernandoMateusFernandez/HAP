//
//  QuestionnairePopUpView.m
//  HAP
//
//  Created by Joaquin Pereira on 5/15/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "QuestionnairePopUpView.h"

@implementation QuestionnairePopUpView

- (id)initWithFrame:(CGRect)frame transform:(CGAffineTransform)transform backgroundView:(UIView *)bView backgroundViewColor:(UIColor *)bColor backgroundViewAlpha:(CGFloat)bAlpha superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        self.center = bView.center;
        self.transform = transform;
        
        _backgroundView = bView;
        
        // Create XIB Connection With Owner
        [[NSBundle mainBundle] loadNibNamed:@"QuestionnairePopUpView" owner:self options:nil];
        
        // Stablish the frame (Without this, UIViews doesn't get user responds)
        self.mainView.frame = self.bounds;
        //
        
        // add XIB to this "View"
        [self addSubview:self.mainView];
        
        // background customization
        
        _backgroundView.alpha = 0;
        _backgroundView.backgroundColor = [bColor colorWithAlphaComponent:bAlpha];
        
        
    }
    
    // BackgroundView
    [bView addSubview:self];
    
    //Super View
    [superView addSubview:bView];
    
    return self;
    
    
}

- (void)layoutSubviews
{
    //Initialization
    
    self.viewbackView.layer.cornerRadius = 10;
    self.viewbackView.layer.borderWidth = 2;
    self.viewbackView.layer.borderColor = [UIColor colorWithRed:0.992 green:0.722 blue:0.004 alpha:1].CGColor;
    
    // Gestures
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopUp)];
    
    
    [self.img_ClosePopUp addGestureRecognizer:tapClose];
    
}




#pragma mark - Methods


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
                            
                            
                        } completion:^(BOOL finished) {
                            
                            [self.delegate QuestionnairePopUpViewDidClose];
                            
                            
                        }];
    
    
}


-(CGFloat) screenWidth
{
    return [UIScreen mainScreen].applicationFrame.size.width;
}

@end
