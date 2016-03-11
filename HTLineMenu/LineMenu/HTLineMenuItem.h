//
//  HTLineMenuItem.h
//  HTLineMenu
//
//  Created by duomai on 16/3/11.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface HTLineMenuItem : NSObject<NSCopying>
-(nullable instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image  selectedImage:(nullable UIImage *)selectedImage;
@end
