//
//  NextCollectionViewCell.h
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NextCollectionViewCellDelegate <NSObject>

-(void)NextCollectionViewCellDidTouchNext;

@end

@interface NextCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property (strong, nonatomic) id<NextCollectionViewCellDelegate>delegate;

- (IBAction)nextController:(id)sender;

@end
