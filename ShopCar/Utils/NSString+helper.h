//
//  NSString+helper.h
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (helper)

+(CGSize)getTextHeight:(NSString *)textStr font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
