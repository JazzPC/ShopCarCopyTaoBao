//
//  MyShopCarTableHeaderView.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "MyShopCarTableHeaderView.h"
#import "ShopCarDetailModel.h"

@interface MyShopCarTableHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (IBAction)allSelectBtnClick:(UIButton *)sender;
- (IBAction)editBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end
@implementation MyShopCarTableHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_backGroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToStore)]];
}

- (void)setCarModel:(ShopCarDetailModel *)carModel{
    _carModel = carModel;
    _storeName.text = carModel.storeName;
}

- (void)setSelectBtnTag:(NSInteger)selectBtnTag{
    if (_selectBtn.tag == selectBtnTag) {
        
    }else{
        _selectBtnTag = selectBtnTag;
        _selectBtn.tag = selectBtnTag;
    }
    _selectBtnTag = selectBtnTag;
    _selectBtn.tag = selectBtnTag;
}

- (void)setEditBtnTag:(NSInteger)editBtnTag{
    if (_editBtn.tag == editBtnTag) {
        
    }else{
        _editBtnTag = editBtnTag;
        _editBtn.tag = editBtnTag;
    }
    
}

// 1 全选
- (IBAction)allSelectBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectOrEditGoods:)]) {
        [self.delegate selectOrEditGoods:sender];
    }
}
//编辑按钮
- (IBAction)editBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%d",_editBtn.selected);
    if ([self.delegate respondsToSelector:@selector(selectOrEditGoods:)]) {
        [self.delegate selectOrEditGoods:sender];
    }
}

- (void)goToStore{
    
}

- (void)setSelectBtnState:(BOOL)state{
    _selectBtn.selected = state;
}
//设置全选按钮的状态
- (void)setHeaderViewAllSelectBtnState:(BOOL)headerViewAllSelectBtnState{
    _headerViewAllSelectBtnState = headerViewAllSelectBtnState;
    _selectBtn.selected = headerViewAllSelectBtnState;
}

//设置编辑按钮的状态
- (void)setHeaderViewEditBtnState:(BOOL)headerViewEditBtnState{
    _headerViewEditBtnState = headerViewEditBtnState;
    _editBtn.selected = headerViewEditBtnState;
}

- (void)setHiddenEidtBtn:(BOOL)hiddenEidtBtn{
    _hiddenEidtBtn = hiddenEidtBtn;
    if (hiddenEidtBtn) {
        _editBtn.hidden = YES;
        _lineView.hidden = YES;
    }else{
        _editBtn.hidden = NO;
        _lineView.hidden = NO;
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
