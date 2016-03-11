//
//  ViewController.m
//  HTLineMenu
//
//  Created by duomai on 16/3/11.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import "ViewController.h"
#import "HTLineMenuController.h"
#import "HTLineMenuItem.h"
@interface ViewController ()
{
    HTLineMenuController *menuController;
    BOOL selected;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    menuController = [HTLineMenuController sharedMenuController];
    HTLineMenuItem *item1 = [[HTLineMenuItem alloc] initWithTitle:@"关闭活动" image:[UIImage imageNamed:@"close"] selectedImage:nil];
    HTLineMenuItem *item2 = [[HTLineMenuItem alloc] initWithTitle:@"活动推送" image:[UIImage imageNamed:@"tuisong"] selectedImage:nil];
     HTLineMenuItem *item3 = [[HTLineMenuItem alloc] initWithTitle:@"分享" image:[UIImage imageNamed:@"share"] selectedImage:nil];
    menuController.menuItems = @[item1,item2,item3];
    selected = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    selected = !selected;
    [menuController setTargetRect:btn.frame inView:self.view];
    [menuController setMenuVisible:selected animated:YES];
}


//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    return YES;
//}
@end
