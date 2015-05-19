//
//  UsersLikesPopUpView.h
//  Venner
//
//  Created by Joaquin Pereira on 4/16/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AlertPopUpViewDelegate <NSObject>

-(void)AlertPopUpViewDidClose;

@end

@interface alertPopUpView : UIView

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *img_ClosePopUp;
@property (strong, nonatomic) UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewbackView;

@property (strong, nonatomic) id<AlertPopUpViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame
          transform:(CGAffineTransform)transform
     backgroundView:(UIView *)bView
backgroundViewColor:(UIColor *)bColor
backgroundViewAlpha:(CGFloat)bAlpha
          superView:(UIView *)superView;




-(void)openPopUp;
-(void)closePopUp;

@end
