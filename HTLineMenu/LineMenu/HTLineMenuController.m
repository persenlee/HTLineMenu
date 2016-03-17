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
    UIView *_prevTargetView;
    CGRect _prevTargetRect;
}
@property(nonatomic,strong)UIView *view;
@property(nonnull,strong) UIWindow *mainWindow;
@property(nonatomic,strong)ContainerWindow *window;
@property(nonatomic,assign)BOOL animate;
@end

@implementation HTLineMenuController
@synthesize menuVisible = _menuVisible;
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
    _window = [[ContainerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _view.backgroundColor = color003366;
    _view.layer.cornerRadius = 5.f;
    _menuHeight = 40.f;
    _menuWidth = 240;
    _prevTargetView = nil;
    _prevTargetRect = CGRectZero;
    _animate = NO;
    UIApplication *appliction = [UIApplication sharedApplication];
    _mainWindow = appliction.keyWindow;
    [_window addSubview:self.view];
    __weak typeof(self) weakSelf = self;
    _window.tapBeyondSubviewsBlock = ^(){
        //animated=YES 存在动画冲突
        [weakSelf setMenuVisible:NO animated:/*weakSelf.animate*/NO];
    };
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
    if (CGRectEqualToRect(_prevTargetRect, targetRect) && targetView == _prevTargetView) {
        return;
    }
    _prevTargetView = targetView;
    _prevTargetRect = targetRect;
    
    CGPoint targetLeftCenter = targetRect.origin;
    targetLeftCenter.y += floor(CGRectGetHeight(targetRect) / 2);
    CGPoint targetRightCenter = targetLeftCenter;
    targetRightCenter.x += CGRectGetWidth(targetRect);
    
    CGRect containerFrame = targetView.bounds;
    
    if (CGRectContainsRect(containerFrame, CGRectMake(targetLeftCenter.x - _menuWidth, targetLeftCenter.y - _menuHeight / 2, _menuWidth, _menuHeight))) { //向左边弹出
        _animateFromFrame = CGRectMake(targetLeftCenter.x, targetLeftCenter.y - _menuHeight / 2, 0, _menuHeight);
        _animateToFrame = CGRectMake(targetLeftCenter.x - _menuWidth, targetLeftCenter.y - _menuHeight / 2, _menuWidth, _menuHeight);
    } else if (CGRectContainsRect(containerFrame, CGRectMake(targetRightCenter.x, targetRightCenter.y - _menuHeight / 2, _menuWidth, _menuHeight))) {
        _animateFromFrame = CGRectMake(targetRightCenter.x, targetRightCenter.y - _menuHeight / 2, 0, _menuHeight);
        _animateToFrame = CGRectMake(targetRightCenter.x, targetRightCenter.y - _menuHeight / 2, _menuWidth, _menuHeight);
    }
    _animateFromFrame = [targetView convertRect:_animateFromFrame toView:_mainWindow];
    _animateFromFrame = [self.window convertRect:_animateFromFrame fromWindow:_mainWindow];
    _animateToFrame = [targetView convertRect:_animateToFrame toView:_mainWindow];
    _animateToFrame = [self.window convertRect:_animateToFrame fromWindow:_mainWindow];
    self.view.frame = _animateFromFrame;
    
    [self.window makeKeyAndVisible];
}


- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
{
    _menuVisible = menuVisible;
    _animate = animated;
    if (menuVisible) {
        if (animated) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                self.view.frame = _animateToFrame;
            } completion:nil];
        } else {
            self.view.frame = _animateToFrame;
        }
    } else {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = _animateFromFrame;
            } completion:^(BOOL finished) {
                [self resignAfterInvisible];
            }];
        } else {
            self.view.frame = _animateFromFrame;
            [self resignAfterInvisible];
        }
    }
    
}

- (void)resignAfterInvisible
{
    [self.window resignKeyWindow];
    [_mainWindow makeKeyAndVisible];
    _prevTargetRect = CGRectZero;
    _prevTargetView = nil;
    _animate = NO;
}

- (void)setMenuVisible:(BOOL)menuVisible
{
    [self setMenuVisible:menuVisible animated:NO];
}

- (BOOL)isMenuVisible
{
    return _menuVisible;
}

-(void) setupSubviews
{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.menuItems enumerateObjectsUsingBlock:^(HTLineMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self viewWithMenuItem:obj];
        button.tag = idx;
        [self.view addSubview:button];
    }];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    NSInteger menuCount = self.menuItems.count;
//    CGFloat menuWidth = CGRectGetWidth(rect) / menuCount;
//    CGFloat menuHeight = CGRectGetHeight(rect);
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
    [button setImage:[menuItem valueForKey:@"selectedImage"] forState:UIControlStateSelected];
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


@implementation ContainerWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    __block UIView *viewHitted = nil;
    __weak typeof(self) weakSelf = self;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            CGRect frame = [obj1 convertRect:obj1.bounds toView:weakSelf];
            if (CGRectContainsPoint(frame, point)) {
                viewHitted = obj1;
                *stop1 = YES;
            }
            
        }];
        if (viewHitted) {
            *stop = YES;
        }
        if (!viewHitted && CGRectContainsPoint(obj.frame, point)) {
            viewHitted = obj;
            *stop = YES;
        }
        
    }];
    if (!viewHitted) {
        if (self.tapBeyondSubviewsBlock) {
            self.tapBeyondSubviewsBlock();
        }
        [[UIApplication sharedApplication].keyWindow sendEvent:event];
    }
    return viewHitted;
}

@end

