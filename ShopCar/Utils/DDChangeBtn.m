///
//  DDChangeBtn.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "DDChangeBtn.h"

@implementation DDChangeBtn

- (void)changeFrame:(CGSize)imageSize margin:(CGFloat)margin
{
    self.imageSize = imageSize;
    
    self.margin = margin;
}

- (void)changeFrame:(CGSize)imageSize
{
    self.noLeft = YES;
    
    self.imageSize = imageSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.noLeft) {
        self.imageView.frame = CGRectMake(0, (self.height - self.imageSize.height)/2, self.imageSize.width, self.imageSize.height);
        CGSize size = [NSString getTextHeight:self.titleLabel.text font:self.titleLabel.font maxSize:CGSizeMake(100, 100)];

        self.titleLabel.size = size;
        self.titleLabel.y = (self.height - size.height)/2;
        
        self.titleLabel.right = self.width;
    }else if ([self.titleLabel.text isEqualToString:@""]) {
        self.imageView.size = self.imageSize;
        self.imageView.center = CGPointMake(self.width/2, self.height/2);
    }else{
        CGSize size = [NSString getTextHeight:self.titleLabel.text font:self.titleLabel.font maxSize:CGSizeMake(100, 100)];

        
        CGFloat imageX = (self.width - self.imageSize.width - size.width - self.margin)/2;
        CGFloat imageY = (self.height - self.imageSize.height)/2;
        
        self.imageView.frame = (CGRect){{imageX,imageY},self.imageSize};
        
        self.titleLabel.frame = (CGRect){{self.imageView.right + self.margin,(self.height - size.height)/2},size};
    }
}

@end
