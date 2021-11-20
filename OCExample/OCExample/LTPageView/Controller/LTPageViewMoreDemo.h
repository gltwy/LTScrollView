//
//  LTPageViewMoreDemo.h
//  OCExample
//
//  Created by gaoliutong on 2021/11/20.
//  Copyright © 2021 LT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EStyle) {
    EStyleDefault,
    EStyleSetSyle,
    EStyleSetSyleOther,
    EStyleCustomStyle
};

@interface LTPageViewMoreDemo : UIViewController

- (instancetype)initWithStyle:(EStyle)style;

@end

