//
//  CustomeOnlineStoreRightView.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "CustomeOnlineStoreRightView.h"

@interface CustomeOnlineStoreRightView ()
//购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;
//消息按钮
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
//消息提示图标
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
//查看购物车
- (IBAction)checkShopCar:(UIButton *)sender;
//查看消息
- (IBAction)checkMessage:(UIButton *)sender;

@end

@implementation CustomeOnlineStoreRightView

/**
 *  隐藏购物车按钮
 *
 *  @param hiddenShopCarItem YES 隐藏  NO 不隐藏
 */
- (void)setHiddenShopCarItem:(BOOL)hiddenShopCarItem{
    _hiddenShopCarItem = hiddenShopCarItem;
    if (_hiddenShopCarItem) {
        self.shopCarBtn.hidden = YES;
    }else{
        self.shopCarBtn.hidden = NO;
    }
}

/**
 *  隐藏消息按钮
 *
 *  @param hiddenShopCarItem YES 隐藏  NO 不隐藏
 */
- (void)setHiddenMessageItem:(BOOL)hiddenMessageItem{
    _hiddenMessageItem = hiddenMessageItem;
    if (_hiddenMessageItem) {
        self.messageBtn.hidden = YES;
    }else{
        self.messageBtn.hidden = NO;
    }
}

/**
 *  隐藏消息提示
 *
 *  @param hiddenShopCarItem YES 隐藏  NO 不隐藏
 */
- (void)setHiddenMessageTip:(BOOL)hiddenMessageTip{
    _hiddenMessageTip = hiddenMessageTip;
    if (_hiddenMessageTip) {
        self.tipImageView.hidden = YES;
    }else{
        self.tipImageView.hidden = NO;
    }
}

- (IBAction)checkShopCar:(UIButton *)sender {
    if (self.shopClick) {
        self.shopClick();
    }
}

- (IBAction)checkMessage:(UIButton *)sender {
    if (self.messageClick) {
        self.messageClick();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
