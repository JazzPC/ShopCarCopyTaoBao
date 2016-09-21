//
//  ShopCarSpecificationsView.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "ShopCarSpecificationsView.h"
#import "ShopCarDetailModel.h"
#import "GoodsSpecificationsModel.h"
#import "ShopCarCurrentGoodModel.h"

#define titleLabelH 15
#define titleButtonBet 15
@interface ShopCarSpecificationsView ()
{
    NSString *_goodSpecification;
}
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodDetailLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//规格详情数组
@property (nonatomic, copy) NSMutableArray *detailArray;
//所有规格数组
@property (nonatomic, copy) NSMutableArray *specificationsArray;
//当期所选规格数组
@property (nonatomic, copy) NSMutableArray *currentSpecificationsArray;
//规格名称数组
@property (nonatomic, copy) NSMutableArray *speNameArray;

@property (nonatomic, assign) CGFloat labelTop;
@property (nonatomic, copy) NSString *speDerailId;
- (IBAction)completeBtn:(UIButton *)sender;

@end

@implementation ShopCarSpecificationsView

- (void)creatView:(CarDetailModel *)carDetailModel arrayOfGoodsDetail:(NSMutableArray *)detailArray arrayOfgoodsSpecifications:(NSMutableArray *)specificationsArray arrayOfCurrentSpecifications:(NSMutableArray *)currentSpecificationsArray{
    
    [self removeScrollViewSubViews];
    _speDerailId = @"";
    
    self.goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",carDetailModel.detaileprice];
    self.goodCountLabel.text = [NSString stringWithFormat:@"库存%@件",carDetailModel.stock];

    self.detailArray = detailArray;
    self.specificationsArray = specificationsArray;
    self.currentSpecificationsArray = currentSpecificationsArray;
    [self.speNameArray removeAllObjects];
    [self initSpecificationsBtn];
    [self setDefaultSpecification];
    
}


- (void)initSpecificationsBtn{
    
    _labelTop = 0;
    
    NSInteger buttonTag = 0;
    
    for (int j = 0 ; j < self.specificationsArray.count; j++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        
        GoodsSpecificationsModel *spectficationModel = self.specificationsArray[j];
        
        [self.speNameArray addObject:spectficationModel.specificationsKey];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 1, 1)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 10 + j;
        [self.scrollView addSubview:view];
        
        label.text = spectficationModel.specificationsKey;
        label.frame = CGRectMake(15, 10, [NSString getTextHeight:spectficationModel.specificationsKey font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(200, titleLabelH)].width, titleLabelH);
        [view addSubview:label];
        
        NSArray *valueArray = [spectficationModel.specificationsValue componentsSeparatedByString:@","];
        
        buttonTag += valueArray.count;
        [self creactBtn:valueArray tag:buttonTag backView:view];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, view.height - 1, MainScreenSize_W - 30, 1)];
        
        lineView.backgroundColor = RgbColor(239, 240, 241, 1);
        [view addSubview:lineView];
        
    }
    
}
//创建规格按钮
- (void)creactBtn:(NSArray *)stringArray tag:(NSInteger)buttonTag backView:(UIView *)view{
    
    CGFloat buttonBet = 10;
    CGFloat buttonH = 20;
    CGFloat allWidth = 0;
    CGFloat buttonLeft = 0;
    CGFloat lineIndex = 0;
    CGFloat number = 0;
    for (int i = 0; i < stringArray.count; i++) {
        NSString *nameString = stringArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"%@",nameString] forState:UIControlStateNormal];
        CGFloat buttonW = [NSString getTextHeight:nameString font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(100, 30) ].width + 15;
        
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:RgbColor(217, 217, 217, 1) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 6;
        if (buttonLeft + buttonW + number*(buttonBet) > MainScreenSize_W - 15 ) {
            allWidth = 0;
            buttonLeft = 0;
            number = 0;
            lineIndex ++;
            button.frame = CGRectMake(15, (buttonH + buttonBet) * lineIndex + titleLabelH + titleButtonBet , buttonW, buttonH);
            buttonLeft = buttonLeft + buttonW;
        }else{
            button.frame = CGRectMake(15 + buttonLeft + number*buttonBet , (buttonH + buttonBet) *lineIndex + titleLabelH + titleButtonBet, buttonW, buttonH);
            buttonLeft = buttonLeft + buttonW;
        }
        
        number ++;
        button.tag = 100 + buttonTag + i;
        [button addTarget:self action:@selector(clickUsuallyCity:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        if (i == stringArray.count-1) {
            view.frame = CGRectMake(0, _labelTop, MainScreenSize_W, button.bottom + 5);
            _labelTop = button.bottom + 5;
            self.scrollView.contentSize = CGSizeMake(0, button.bottom + 5);
            
        }
    }
    
}
//设置默认选中的按钮
- (void)setDefaultSpecification{
    NSInteger buttonTag = 0;
    for (int i = 0; i < self.specificationsArray.count; i++) {
        GoodsSpecificationsModel *allModel = self.specificationsArray[i];
        
        NSArray *stringArray = [allModel.specificationsValue componentsSeparatedByString:@","];
        buttonTag += stringArray.count;
        [self compareWithAllSpecification:stringArray currentKey:allModel.specificationsKey tag:buttonTag];
    }
}

//当前选中的规格 和所有规格进行比较 以确定button选中状态
- (void)compareWithAllSpecification:(NSArray *)specificationArray currentKey:(NSString *)keyString tag:(NSInteger)buttonTag{
    
    for (int i = 0; i < self.currentSpecificationsArray.count; i++) {
        GoodsSpecificationsModel *currentModel = self.currentSpecificationsArray[i];
        if ([currentModel.specificationsKey isEqualToString:keyString]) {
            for (int j = 0; j < specificationArray.count; j++) {
                if ([currentModel.specificationsValue isEqualToString:specificationArray[j]]) {
                    UIButton *specificationBtn = [(UIButton *)self.scrollView viewWithTag:buttonTag + j + 100];
                    specificationBtn.selected = YES;
                }
            }
        }
    }
    [self appendingString];
}

//完成按钮
- (IBAction)completeBtn:(UIButton *)sender {
    if (self.selectSpeBlock) {
        self.selectSpeBlock(_speDerailId,_goodSpecification);
    }
    self.selectSpeBlock = nil;
}
//选中规格按钮  @"尺寸:特大号||颜色:红色"	
- (void)clickUsuallyCity:(UIButton *)sender{
    
    UIView *view = (UIView *)sender.superview;
    
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            button.selected = NO;
        }
    }
    
    sender.selected = YES;
    
    //拼规格字符串
    [self appendingString];

}
////@"尺寸:特大号||颜色:红色"
- (void)appendingString{
    
    NSInteger index = 0;
    _goodSpecification = @"";
    NSMutableArray *buttonArray = [NSMutableArray array];
    NSString *speString = @"";
    
    for (UIView *subView in [self.scrollView subviews]) {
        for (UIView *buttonView in [subView subviews]) {
            if ([buttonView isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)buttonView;
                [buttonArray addObject:button];
            }
        }
    }
    
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = buttonArray[i];
        if (button.selected == YES) {
            if (index == _speNameArray.count - 1) {//去掉最后一组的 ||
              speString = [speString stringByAppendingFormat:@"%@:%@",_speNameArray[index],button.titleLabel.text];
                
            }else{
                speString = [speString stringByAppendingFormat:@"%@:%@||",_speNameArray[index],button.titleLabel.text];
            }
            _goodSpecification = [_goodSpecification stringByAppendingFormat:@"%@:%@ ",_speNameArray[index],button.titleLabel.text];
            index ++;
        }
    }
    
    
    for (int i = 0; i < self.detailArray.count; i++) {
        ShopCarCurrentGoodModel *detailModel = self.detailArray[i];
        if ([detailModel.goodsAttr isEqualToString:speString]) {
            _speDerailId = detailModel.goodsDetailId;
            
        }
    }
    
}
//懒加载
- (NSMutableArray *)specificationsArray{
    if (_specificationsArray == nil) {
        _specificationsArray = [NSMutableArray array];
    }
    return _specificationsArray;
}

- (NSMutableArray *)detailArray{
    if (_detailArray == nil) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}

- (NSMutableArray *)currentSpecificationsArray{
    if (_currentSpecificationsArray == nil) {
        _currentSpecificationsArray = [NSMutableArray array];
    }
    return _currentSpecificationsArray;
}

- (NSMutableArray *)speNameArray{
    if (_speNameArray == nil) {
        _speNameArray = [NSMutableArray array];
    }
    return _speNameArray;
}
//移除所有button
- (void)removeScrollViewSubViews{
    for(UIView *view in [self.scrollView subviews])
    {
        [view removeFromSuperview];
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
