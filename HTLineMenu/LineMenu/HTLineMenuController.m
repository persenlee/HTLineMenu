//
//  HTLineMenuController.m
//  HTLineMenu
//
//  Created by duomai on 16/3/11.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import "HTLineMenuController.h"
#import "HTLineMenuItem.h"
#import "ColorResource.h"
#import <View+MASAdditions.h>
@interface HTLineMenuController()
{
    CGRect _animateFromFrame;
    CGRect _animateToFrame;
    CGFloat _menuHeight;
    CGFloat _menuWidth;
}
@property(nonatomic,strong)UIView *view;
@end

@implementation HTLineMenuController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initlization];
    }
    return self;
}

- (void)initlization
{
    _view = [UIView  new];
    _view.backgroundColor = color003366;
    _view.layer.cornerRadius = 5.f;
    _menuHeight = 40.f;
    _menuWidth = 240;
}

+(instancetype) sharedMenuController
{
    static HTLineMenuController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HTLineMenuController new];
    });
    return instance;
}

- (void)setMenuItems:(NSArray<HTLineMenuItem *> *)menuItems
{
    _menuItems = menuItems;
    [self setupSubviews];
}

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView
{
    CGPoint targetLeftCenter = targetRect.origin;
    targetLeftCenter.y += floor(CGRectGetHeight(targetRect) / 2);
    CGPoint targetRightCenter = targetLeftCenter;
    targetRightCenter.x += CGRectGetWidth(targetRect);
    
    CGRect containerFrame = targetView.frame;
    
    if (CGRectContainsRect(containerFrame, CGRectMake(targetLeftCenter.x - _menuWidth, targetLeftCenter.y - _menuHeight / 2, _menuWidth, _menuHeight))) { //向左边弹出
        _animateFromFrame = CGRectMake(targetLeftCenter.x, targetLeftCenter.y - _menuHeight / 2, 0, _menuHeight);
        _animateToFrame = CGRectMake(targetLeftCenter.x - _menuWidth, targetLeftCenter.y - _menuHeight / 2, _menuWidth, _menuHeight);
    } else if (CGRectContainsRect(containerFrame, CGRectMake(targetRightCenter.x, targetRightCenter.y - _menuHeight / 2, _menuWidth, _menuHeight))) {
        _animateFromFrame = CGRectMake(targetRightCenter.x, targetRightCenter.y - _menuHeight / 2, _menuWidth, _menuHeight);
        _animateToFrame = CGRectMake(targetRightCenter.x, 0, _menuWidth, _menuHeight);
    }
    self.view.frame = _animateFromFrame;
    [self.view removeFromSuperview];
    [targetView addSubview:self.view];
    [self layoutSubviews];
}


- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
{
    if (menuVisible) {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = _animateToFrame;
            }];
        } else {
            self.view.frame = _animateToFrame;
        }
    } else {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = _animateFromFrame;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        } else {
            [self.view removeFromSuperview];
        }
    }
    
}

-(void) setupSubviews
{
    [self.menuItems enumerateObjectsUsingBlock:^(HTLineMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self viewWithMenuItem:obj];
        button.tag = idx;
        [self.view addSubview:button];
    }];
}

- (void)layoutSubviews
{
    CGRect rect = self.view.bounds;
    NSInteger menuCount = self.menuItems.count;
//    CGFloat menuWidth = CGRectGetWidth(rect) / menuCount;
//    CGFloat menuHeight = CGRectGetHeight(rect);
    CGFloat menuItemWith = _menuWidth / menuCount;
//    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.frame = CGRectMake(idx * menuItemWith, 0, menuItemWith, _menuHeight);
//    }];
    
    //using autolayout
    __weak typeof(self) weakSelf = self;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            if (idx == 0) {
                make.left.equalTo(weakSelf.view);
            } else {
                UIView *view = weakSelf.view.subviews[idx -1];
                make.left.equalTo(view.mas_right);
                make.width.equalTo(view.mas_width);
            }
            
            if (idx == menuCount -1) {
                make.right.equalTo(weakSelf.view);
            }
            
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }];
    }];
}


- (UIButton *)viewWithMenuItem: (HTLineMenuItem *)menuItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[menuItem valueForKey:@"title"] forState:UIControlStateNormal];
    [button setImage:[menuItem valueForKey:@"image"] forState:UIControlStateNormal];
    [button setImage:[menuItem valueForKey:@"selectedImage"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapMenu:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color33ccff forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
    return button;
}

- (void)tapMenu: (UIButton *)sender
{
    NSInteger idx = sender.tag;
    if (self.didTapMenuAtIndex) {
        self.didTapMenuAtIndex(idx);
    }
    [self setMenuVisible:NO animated:YES];
}
@end
