//
//  MyShopCarTableViewCell.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "MyShopCarTableViewCell.h"
#import "ShopCarDetailModel.h"

@interface MyShopCarTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *changeCountField;
@property (weak, nonatomic) IBOutlet UIButton *reducBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *changeShopDetailView;
@property (weak, nonatomic) IBOutlet UILabel *changeShopDetailLabel;

@property (weak, nonatomic) IBOutlet UIButton *shopNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnRight;


- (IBAction)changeShopNumClick:(UIButton *)sender;
- (IBAction)selectGoodsBtnClick:(UIButton *)sender;
- (IBAction)deleteShopGoodBtnClick:(UIButton *)sender;

@end

@implementation MyShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _addBtn.layer.borderColor = RgbColor(235, 239, 244, 1).CGColor;
    _addBtn.layer.borderWidth = 1.0f;
    
    _reducBtn.layer.borderColor = RgbColor(235, 239, 244, 1).CGColor;
    _reducBtn.layer.borderWidth = 1.0f;
    
    _changeCountField.layer.borderColor = RgbColor(235, 239, 244, 1).CGColor;
    _changeCountField.layer.borderWidth = 1.0f;
    [_changeCountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _changeCountField.delegate = self;
    
    [_changeShopDetailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeShopDetailInfo)]];
    // Initialization code
}

- (void)setGoodsModel:(CarDetailModel *)goodsModel{
    _goodsModel = goodsModel;
    
    _shopNameLabel.text = goodsModel.goodsName;
    _shopPriceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.detaileprice];
    _shopDetailLabel.text = [NSString stringWithFormat:@"产品参数：%@",goodsModel.specification];
    [_shopNumBtn setTitle:[NSString stringWithFormat:@"x%@",goodsModel.count] forState:UIControlStateNormal];
    _changeCountField.text = goodsModel.count;
    _changeShopDetailLabel.text = [NSString stringWithFormat:@"产品参数：%@",goodsModel.specification];
}

//更改商品规格
- (void)changeShopDetailInfo{
    if ([self.delegate respondsToSelector:@selector(changeShopDetail:)]) {
        [self.delegate changeShopDetail:_changeShopDetailView];
    }
}


// 改变商品数量 1 减少  2 增加
- (IBAction)changeShopNumClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            if ([_changeCountField.text intValue] == 1) {
                _reducBtn.userInteractionEnabled = NO;
            }else{
                _changeCountField.text = [NSString stringWithFormat:@"%d",[_changeCountField.text intValue] - 1];
            }
            
        }
            break;
        case 2:
        {
            if ([_changeCountField.text intValue] == [_goodsModel.stock intValue]) {
                _changeCountField.text = _goodsModel.stock;
                
            }else{
               _changeCountField.text = [NSString stringWithFormat:@"%d",[_changeCountField.text intValue] + 1];
            }
            
        }
            break;
        default:
            break;
    }
    
    _goodsModel.count = _changeCountField.text;
    
    [_shopNumBtn setTitle:[NSString stringWithFormat:@"x%@",_changeCountField.text] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(changeShopCount:)]) {
        [self.delegate changeShopCount:sender];
    }
}
//选中商品按钮
- (IBAction)selectGoodsBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(cellSelectBtnClick:)]) {
        [self.delegate cellSelectBtnClick:sender];
    }
}
//删除商品按钮
- (IBAction)deleteShopGoodBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteShopGoodTouch:)]) {
        [self.delegate deleteShopGoodTouch:sender];
    }
}
#pragma mark -- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(tableViewScroll:)]) {
        [self.delegate tableViewScroll:textField];
    }
}
- (void)textFieldDidChange:(UITextField *)textField{
    if ([textField.text intValue] >= [_goodsModel.stock intValue]) {
        textField.text = _goodsModel.stock;
        NSLog(@"最多只能买%@件哦",_goodsModel.stock);
    }
    _goodsModel.count = textField.text;
}

//设置选择按钮的状态
- (void)setShopCellSelectBtnState:(BOOL)shopCellSelectBtnState{
    _shopCellSelectBtnState = shopCellSelectBtnState;
    _selectBtn.selected = shopCellSelectBtnState;
}

//设置编辑状态
- (void)setShopCellEditState:(BOOL)shopCellEditState{
    _shopCellEditState = shopCellEditState;
    _changeShopDetailView.hidden = !shopCellEditState;
    _shopNumBtn.hidden = shopCellEditState;
    _addBtn.hidden = !shopCellEditState;
    _changeCountField.hidden = !shopCellEditState;
    _reducBtn.hidden = !shopCellEditState;
}

//设置删除按钮的位置和编辑状态
- (void)setShopCellDeleteBtnState:(BOOL)shopCellDeleteBtnState{
    _shopCellDeleteBtnState = shopCellDeleteBtnState;
    if (shopCellDeleteBtnState == YES) {
        [UIView animateWithDuration:0.3f animations:^{
            _deleteBtnRight.constant = 0;
            _delegateBtn.hidden = NO;
            [_delegateBtn layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3f animations:^{
            _deleteBtnRight.constant = -50;
            _delegateBtn.hidden = YES;
            [_delegateBtn layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

//返回商品价格
- (NSInteger)getShopPrice{
    NSString *priceString = [_shopPriceLabel.text substringFromIndex:1];
    return [priceString integerValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
