//
//  ViewController.m
//  UIFloatingButton
//
//  Created by Enrico De Michele on 29/08/16.
//  Copyright © 2016 Enrico De Michele. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

///

-(UIViewController *) viewControllerForPresentFloatingButton:(UIFloatingButton *)button {
    
    return self;
}

-(NSUInteger) numberForRowInFloatingButton:(UIFloatingButton *)button {
    
    return 4;
}

-(NSString *) floatingButton:(UIFloatingButton *)button imageForRowAtIndex:(NSInteger)index {
    
    NSArray *imgs = @[@"twitter-icon", @"linkedin-icon", @"fb-icon", @"google-icon"];
    return [imgs objectAtIndex:index];
}

-(NSString *) floatingButton:(UIFloatingButton *)button textForRowAtIndex:(NSInteger)index {
    
    NSArray *labels = @[@"Twitter", @"Linked in", @"Facebook", @"Google Plus"];
    return [labels objectAtIndex:index];
}

-(UIFloatingButtonOrientation) orientationForPresentFloatingButton:(UIFloatingButton *)button {
    return UIFloatingButtonOrientationTopRight;
}

-(void) floatingButton:(UIFloatingButton *)button clickedButtonAtIndex:(NSInteger)index {
    
    NSLog(@"UIFloatingButton clicked %tu", index);
}

@end
