//
//  UIFloatingButton.h
//
//
//  Created by Enrico De Michele on 26/08/16.
//  Copyright (c) 2016. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIFloatingButton;

@interface UIFloatingButtonCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UILabel *title;

@end

///

typedef enum {
    UIFloatingButtonOrientationTopLeft,
    UIFloatingButtonOrientationTopRight,
    UIFloatingButtonOrientationBottomLeft,
    UIFloatingButtonOrientationBottomRight,
} UIFloatingButtonOrientation;

@protocol UIFloatingButtonDelegate <NSObject>

@required
-(UIViewController *) viewControllerForPresentFloatingButton:(UIFloatingButton *)button; //If return nil the panel is not shown and clickedButtonAtIndex is executed with index -1
-(NSUInteger) numberForRowInFloatingButton:(UIFloatingButton *)button;
-(NSString *) floatingButton:(UIFloatingButton *)button imageForRowAtIndex:(NSInteger)index;

@optional
-(UIColor *) viewColorForPresentFloatingButton:(UIFloatingButton *)button;
-(UIFloatingButtonOrientation) orientationForPresentFloatingButton:(UIFloatingButton *)button; //Default UIFloatingButtonOrientationTopLeft
-(NSString *) floatingButton:(UIFloatingButton *)button textForRowAtIndex:(NSInteger)index;
-(void) floatingButton:(UIFloatingButton *)button clickedButtonAtIndex:(NSInteger)index;

@end

///

@interface UIFloatingButton : UIButton <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    CGFloat originalSizeHeight;
}

@property (nonatomic, weak) IBOutlet id<UIFloatingButtonDelegate> delegate;

@end
