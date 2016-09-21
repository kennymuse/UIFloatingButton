//
//  UIFloatingButton.m
//
//
//  Created by Enrico De Michele on 26/08/16.
//  Copyright (c) 2016. All rights reserved.
//

#import "UIFloatingButton.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ANIMATION_TIME 0.25
#define ORIENTATION_PADDING 6

///

@implementation UIFloatingButtonCell

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imgView = [[UIImageView alloc] init];
        self.title = [[UILabel alloc] init];
        
        self.imgView.userInteractionEnabled = NO;
        self.title.userInteractionEnabled = NO;
        
        [self addSubview: self.imgView];
        [self addSubview: self.title];
    }
    
    return self;
}

- (void) setFrame:(CGRect)frame {

    double size = frame.size.height;
    double padding = 8;
    
    self.imgView.frame = CGRectMake(0, 0, size, size);
    self.title.frame = CGRectMake(size + padding, 0, frame.size.width - (size + padding), size);
}

@end


///

@interface UIFloatingButton() {
    
    NSInteger noOfRows;
    
    UIView *windowView;
    UIView *_bgView;
    
    UICollectionView  *_collectionview;
    
    BOOL _isMenuVisible;
}

@end

///

@implementation UIFloatingButton

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
    
    }
    
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    if (self.titleLabel.hidden)
        NSLog(@"UIFloatingButton: set whitespace inside button title, otherwise title color not work");
    
    originalSizeHeight = self.frame.size.height;
    
    noOfRows = 0;
    
    windowView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionview = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [_collectionview registerClass:[UIFloatingButtonCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.userInteractionEnabled = YES;
    
    _collectionview.showsVerticalScrollIndicator = NO;
    _collectionview.showsHorizontalScrollIndicator = NO;
    
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    
    _isMenuVisible = false;
    
    UITapGestureRecognizer *buttonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:buttonTap];
    
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([delegate respondsToSelector:@selector(viewColorForPresentFloatingButton:)]) {
        _bgView.backgroundColor = [delegate viewColorForPresentFloatingButton: self];
    } else {
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
    }
    
    _bgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *buttonTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    buttonTap2.cancelsTouchesInView = NO;
    
    [_bgView addGestureRecognizer:buttonTap2];
    [_bgView addSubview:_collectionview];
}

//Show Menu
-(void)handleTap:(id)sender {

    if (_isMenuVisible) {
        [self dismissMenu:nil];
        
        _isMenuVisible  = !_isMenuVisible;
        
    } else {
        [windowView addSubview:_bgView];
        
        UIViewController *viewCToPresent = [delegate viewControllerForPresentFloatingButton:self];
        
        if (viewCToPresent != nil) {
            [[delegate viewControllerForPresentFloatingButton:self].view insertSubview:windowView belowSubview:self];
            [self showMenu:nil];
            
            _isMenuVisible  = !_isMenuVisible;
            
        } else {
            if ([delegate respondsToSelector: @selector(floatingButton:clickedButtonAtIndex:)]) {
                [delegate floatingButton:self clickedButtonAtIndex: -1];
            }
        }
    }
}

#pragma mark -- Animations
#pragma mark ---- button tap Animations

-(void) showMenu:(id)sender {
    
    UIFloatingButtonOrientation orientation = UIFloatingButtonOrientationTopLeft;
    if ([delegate respondsToSelector:@selector(orientationForPresentFloatingButton:)]) {
        orientation = [delegate orientationForPresentFloatingButton:self];
    }
    
    ///
    
    CGRect buttonFrame = self.frame;
    noOfRows = [delegate numberForRowInFloatingButton:self];
    
    float bgViewH = _bgView.frame.size.height;
    
    float height;
    
    float statusBarH = 20.0;
    float navBarH = ([delegate viewControllerForPresentFloatingButton:self].navigationController == nil) ? 0.0 : 44;
    
    if (orientation == UIFloatingButtonOrientationTopLeft || orientation == UIFloatingButtonOrientationTopRight) {
        height = MIN(noOfRows * originalSizeHeight + statusBarH, bgViewH - (bgViewH - self.frame.origin.y) - statusBarH - navBarH);
        
    } else {
        height = MIN(noOfRows * originalSizeHeight + statusBarH, bgViewH - self.frame.origin.y - self.frame.size.height - statusBarH);
    }
    
    _collectionview.frame = CGRectMake(0, 0, 0.75 * SCREEN_WIDTH, height);
    
    ///
    
    if (orientation == UIFloatingButtonOrientationTopLeft) {
        
        _collectionview.transform = CGAffineTransformMakeScale(-1, 1);
        _collectionview.layer.anchorPoint = CGPointMake(0, 1);
        _collectionview.layer.position = CGPointMake(buttonFrame.origin.x + buttonFrame.size.width, buttonFrame.origin.y - ORIENTATION_PADDING);
        
    } else if (orientation == UIFloatingButtonOrientationBottomLeft) {
        
        _collectionview.transform = CGAffineTransformMakeScale(-1, 1);
        _collectionview.layer.anchorPoint = CGPointMake(0, 0);
        _collectionview.layer.position = CGPointMake(buttonFrame.origin.x + buttonFrame.size.width, buttonFrame.origin.y + buttonFrame.size.height + ORIENTATION_PADDING);
        
    } else if (orientation == UIFloatingButtonOrientationTopRight) {
        
        _collectionview.layer.anchorPoint = CGPointMake(0, 1);
        _collectionview.layer.position = CGPointMake(buttonFrame.origin.x, buttonFrame.origin.y - ORIENTATION_PADDING);
        
    } else if (orientation == UIFloatingButtonOrientationBottomRight) {
        
        _collectionview.layer.anchorPoint = CGPointMake(0, 0);
        _collectionview.layer.position = CGPointMake(buttonFrame.origin.x, buttonFrame.origin.y + buttonFrame.size.height + ORIENTATION_PADDING);
        
    } else {
        NSLog(@"Orientation not defined");
    }
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^ {
        
        _bgView.alpha = 1;
        self.transform = CGAffineTransformMakeRotation(M_PI/4);
    
        ///
        
        [_collectionview reloadData];
        
        if (orientation == UIFloatingButtonOrientationTopLeft || orientation == UIFloatingButtonOrientationTopRight) {
            //Scroll to bottom
            [_collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(noOfRows-1) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    
    } completion:^(BOOL finished) {

    }];
}

-(void) dismissMenu:(id) sender {
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        
        _bgView.alpha = 0;
        self.transform = CGAffineTransformIdentity;
         
     } completion:^(BOOL finished) {
         
         noOfRows = 0;
         [_bgView removeFromSuperview];
         [windowView removeFromSuperview];
         
         [_collectionview reloadData];
     }];
}

#pragma mark -- CollectionView methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, originalSizeHeight);
}

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return noOfRows;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
  
    double delay = (indexPath.row*indexPath.row) * 0.01;
    
    UIFloatingButtonOrientation orientation = UIFloatingButtonOrientationTopLeft;
    if ([delegate respondsToSelector:@selector(orientationForPresentFloatingButton:)]) {
        orientation = [delegate orientationForPresentFloatingButton:self];
    }
    
    if (orientation == UIFloatingButtonOrientationTopLeft || orientation == UIFloatingButtonOrientationTopRight) {
        delay = ANIMATION_TIME/2.0-delay;
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.95, 0.95);
    cell.transform = scaleTransform;
    
    cell.alpha = 0.f;
    
    [UIView animateWithDuration:ANIMATION_TIME delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        cell.transform = CGAffineTransformIdentity;
        cell.alpha = 1.f;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cellIdentifier";
    UIFloatingButtonCell *cell = [_collectionview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.frame = CGRectMake(0, 0, collectionView.frame.size.width, originalSizeHeight);
    
    cell.backgroundColor = self.backgroundColor;
    cell.imgView.backgroundColor = self.backgroundColor;
    
    cell.title.backgroundColor = self.backgroundColor;
    cell.title.textColor = self.titleLabel.textColor;
    cell.title.font = self.titleLabel.font;
    
    ///
    
    UIFloatingButtonOrientation orientation = UIFloatingButtonOrientationTopLeft;
    if ([delegate respondsToSelector:@selector(orientationForPresentFloatingButton:)]) {
        orientation = [delegate orientationForPresentFloatingButton:self];
    }
    
    if (orientation == UIFloatingButtonOrientationTopLeft || orientation == UIFloatingButtonOrientationBottomLeft) {
        
        cell.title.textAlignment = NSTextAlignmentRight;
        
        cell.title.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        cell.imgView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        
        cell.title.transform = CGAffineTransformMakeScale(-1, 1);
        cell.imgView.transform = CGAffineTransformMakeScale(-1, 1);
        
    } else if (orientation == UIFloatingButtonOrientationTopRight || orientation == UIFloatingButtonOrientationBottomRight) {
        
        cell.title.textAlignment = NSTextAlignmentLeft;
    }
    
    ///
    
    cell.imgView.image = [UIImage imageNamed:[delegate floatingButton:self imageForRowAtIndex:indexPath.row]];
    
    if ([delegate respondsToSelector:@selector(floatingButton:textForRowAtIndex:)]) {
        cell.title.text = [delegate floatingButton:self textForRowAtIndex:indexPath.row];
        
    } else {
        cell.title.text = @"";
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([delegate respondsToSelector: @selector(floatingButton:clickedButtonAtIndex:)]) {
        [delegate floatingButton:self clickedButtonAtIndex:indexPath.row];
    }
}

@end
