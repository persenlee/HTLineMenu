//
//  HTLineMenuItem.m
//  HTLineMenu
//
//  Created by duomai on 16/3/11.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import "HTLineMenuItem.h"
@interface HTLineMenuItem()
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImage *selectedImage;
@end
@implementation HTLineMenuItem
-(nullable instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image  selectedImage:(nullable UIImage *)selectedImage
{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _selectedImage = selectedImage;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    HTLineMenuItem *copy = [[[HTLineMenuItem class] allocWithZone:zone] init];
    if (copy) {
        copy->_title = self.title;
        copy->_selectedImage = self.selectedImage;
        copy->_image = self.image;
    }
    return copy;
}
@end
