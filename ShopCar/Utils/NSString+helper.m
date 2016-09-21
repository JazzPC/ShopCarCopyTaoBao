//
//  NSString+helper.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "NSString+helper.h"

@implementation NSString (helper)
#pragma mark -计算字符串高度
+(CGSize)getTextHeight:(NSString *)textStr font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName :font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [textStr boundingRectWithSize:maxSize
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:attributes
                                               context:nil].size;
    return contentSize;
}
@end
