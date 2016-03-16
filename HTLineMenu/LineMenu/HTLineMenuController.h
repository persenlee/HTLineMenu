//
//  HTLineMenuController.h
//  HTLineMenu
//
//  Created by duomai on 16/3/11.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@class HTLineMenuItem;
@interface HTLineMenuController : NSObject
@property(nonatomic, strong,nonnull) NSArray <HTLineMenuItem *> *menuItems;
@property(nonatomic, copy,nullable) void (^didTapMenuAtIndex)(NSInteger index);
@property(nonatomic, getter=isMenuVisible) BOOL menuVisible;
+(nullable instancetype) sharedMenuController;
- (void)setTargetRect:(CGRect)targetRect inView:(nullable UIView *)targetView;
- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;
@end


@interface ContainerWindow : UIWindow
@property(nonatomic,copy,nullable) void (^tapBeyondSubviewsBlock)();
@end