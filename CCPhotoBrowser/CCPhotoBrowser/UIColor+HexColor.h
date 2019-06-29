//
//  UIColor+HexColor.h
//  DrivingTour
//
//  Created by Chan on 2019/6/14.
//  Copyright © 2019 Zack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kColorHex(xxx)  [UIColor colorWithHexString:xxx]
@interface UIColor (HexColor)

+ (UIColor *) colorWithHexString: (NSString *)color;


@end

NS_ASSUME_NONNULL_END
