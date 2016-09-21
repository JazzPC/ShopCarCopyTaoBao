//
//  GoodsSpecificationsModel.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "GoodsSpecificationsModel.h"

@implementation GoodsSpecificationsModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"specificationsKey"   : @"keyCode",
             @"specificationsValue" : @"valueCode"};
}
@end
