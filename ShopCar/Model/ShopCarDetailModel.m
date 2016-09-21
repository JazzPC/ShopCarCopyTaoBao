//
//  ShopCarDetailModel.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "ShopCarDetailModel.h"

@implementation ShopCarDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"goodsDetails" : [CarDetailModel class]};
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end


@implementation CarDetailModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}

@end
