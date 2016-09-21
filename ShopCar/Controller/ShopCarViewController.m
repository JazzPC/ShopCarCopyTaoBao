//
//  ShopCarViewController.m
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//

#import "ShopCarViewController.h"
#import "DDChangeBtn.h"
#import "MyShopCarTableViewCell.h"
#import "MyShopCarTableHeaderView.h"
#import "CustomeOnlineStoreRightView.h"
#import "ShopCarDetailModel.h"
#import "ShopCarCurrentGoodModel.h"
#import "GoodsSpecificationsModel.h"
#import "ShopCarSpecificationsView.h"


NSString *const MyShopCarTableViewCellIdentifier   = @"MyShopCarTableViewCell";
NSString *const MyShopCarTableViewHeaderIdentifier = @"MyShopCarTableHeaderView";

@interface ShopCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarTableViewHeaderViewDelegate,ShopTableViewCellSelectDelegate>
{
    int _keyboardHeight;
    //记录所改规格的数量
    NSString *_goodNumber;
    //记录所改规格的购物车id
    NSString *_shopCarId;
    //记录所改规格的商品id
    NSString *_goodId;
    //记录所改规格的商品的indexPath
    NSIndexPath *_speIndexPath;
    
}
@property (nonatomic, strong) UITableView *tableView;
/** 全选按钮 */
@property (nonatomic, strong) DDChangeBtn *selectButton;
/** 结算按钮 */
@property (nonatomic, strong) UIButton *settleBtn;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIViewController *animationVC;
@property (nonatomic, strong) UIViewController *rootViewVC;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) ShopCarSpecificationsView *specificationsView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIView *keyBoardTopView;

@property (nonatomic, strong) NSMutableArray *shopCarGoodsArray;
//存储要删除商品的购物车id
@property (nonatomic, strong) NSMutableArray *shopCarDeleteIdArray;
//当前商品规格model数组
@property (nonatomic, strong) NSMutableArray *currentSpecificationsArray;
//当前商品所有规格model数组
@property (nonatomic, strong) NSMutableArray *allSpecificationsArray;
//当前商品所选规格model数组
@property (nonatomic, strong) NSMutableArray *selectSpecificationsArray;

@end

@implementation ShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"我的购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpAnimationViewController];
    [self setUpNavRightView];
    [self setUpBottomView];
    [self setUpTableView];
    [self setUpKeyboardTopView];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)setUpNavRightView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize_W, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenSize_W - 80, 25, 100, 25)];
    CustomeOnlineStoreRightView *right = [CustomeOnlineStoreRightView viewFromeXib];
    right.frame = CGRectMake(10, 0, 60, 25);
    right.hiddenShopCarItem = YES;
    right.messageClick = ^{
        NSLog(@"购物车的消息被点击了");
        
    };
    [rightView addSubview:right];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 40, 25);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [editBtn setTitleColor:RgbColor(144, 144, 146, 1) forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editShopCar) forControlEvents:UIControlEventTouchUpInside];
    _editBtn = editBtn;
    [rightView addSubview:editBtn];
    [topView addSubview:rightView];
   
}

- (void)setUpBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenSize_H - 50, MainScreenSize_W, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    DDChangeBtn *selectButton = [DDChangeBtn new];
    selectButton.frame = CGRectMake(10, (50 - 23)/2, 60, 23);
    [selectButton changeFrame:CGSizeMake(23, 23) margin:10];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectButton setTitleColor:RgbColor(78, 79, 80, 1) forState:UIControlStateNormal];
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectAllGoods) forControlEvents:UIControlEventTouchUpInside];
    _selectButton = selectButton;
    [bottomView addSubview:selectButton];
    //结算按钮
    UIButton *settleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settleBtn.frame = CGRectMake(MainScreenSize_W - 105, 0, 105, 50);
    [settleBtn setBackgroundColor:RgbColor(253, 69, 51, 1)];
    [settleBtn setTitle:@"结算" forState:UIControlStateNormal];
    [settleBtn setTitle:@"删除" forState:UIControlStateSelected];
    settleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [settleBtn addTarget:self action:@selector(settlementGoods) forControlEvents:UIControlEventTouchUpInside];
    _settleBtn = settleBtn;
    [bottomView addSubview:settleBtn];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.right, 15, MainScreenSize_W - selectButton.right - 115, 20)];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = RgbColor(78, 79, 80, 1);
    moneyLabel.text = @"合计：¥0";
    _moneyLabel = moneyLabel;
    moneyLabel.attributedText = [self setAttributeString:3 string:moneyLabel.text];
    
    [bottomView addSubview:moneyLabel];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(selectButton.right, 0, MainScreenSize_W -selectButton.right - 115, 50);
    [collectionBtn setTitle:@"移入收藏夹" forState:UIControlStateNormal];
    [collectionBtn setTitleColor:RgbColor(253, 71, 53, 1) forState:UIControlStateNormal];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    collectionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _collectionBtn = collectionBtn;
    collectionBtn.hidden = YES;
    [bottomView addSubview:collectionBtn];
    
    
}

- (void)setUpTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenSize_W, MainScreenSize_H - 50 - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 125;
    tableView.sectionHeaderHeight = 50;
    tableView.backgroundColor = RgbColor(239, 240, 241, 1);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"MyShopCarTableViewCell" bundle:nil] forCellReuseIdentifier:MyShopCarTableViewCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"MyShopCarTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:MyShopCarTableViewHeaderIdentifier];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [self getShopCarData];
}

- (void)setUpKeyboardTopView{
    
    UIView *keyBoardTopView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenSize_H, MainScreenSize_W, 40)];
    _keyBoardTopView = keyBoardTopView;
    keyBoardTopView.backgroundColor = RgbColor(240, 240, 240, 1);
    [self.view addSubview:keyBoardTopView];
    
    UIButton *alredyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alredyBtn.frame = CGRectMake(MainScreenSize_W - 51, 6, 45, 28);
    [alredyBtn setTitle:@"完成" forState:UIControlStateNormal];
    [alredyBtn setTitleColor:RgbColor(254, 96, 48, 1) forState:UIControlStateNormal];
    alredyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    alredyBtn.layer.cornerRadius = 4;
    alredyBtn.layer.borderColor = RgbColor(254, 96, 48, 1).CGColor;
    alredyBtn.layer.borderWidth = 1;
    [alredyBtn addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [keyBoardTopView addSubview:alredyBtn];
    
}

- (void)getShopCarData{
    
    NSString *pathSting = [[NSBundle mainBundle] pathForResource:@"goods" ofType:@"archive"];
    self.shopCarGoodsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pathSting];
    NSLog(@"%@",NSStringFromClass([_shopCarGoodsArray superclass]));
    [self.tableView reloadData];
}

- (void)setUpAnimationViewController{
    
    
    self.specificationsView = [ShopCarSpecificationsView viewFromeXib];
    self.specificationsView.frame = CGRectMake(0, MainScreenSize_H, MainScreenSize_W, MainScreenSize_H/2);
    _specificationsView.layer.shadowColor = [UIColor blackColor].CGColor;
    _specificationsView.layer.shadowRadius = 4;
    _specificationsView.layer.shadowOffset  =CGSizeMake(4, 4);
    _specificationsView.layer.shadowOpacity = 0.8;
    __weak typeof(self) weakSelf = self;
    _specificationsView.selectSpeBlock = ^(NSString *sepString,NSString *goodSpecification){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf clickHidden];
        ShopCarDetailModel *bigModel = strongSelf.shopCarGoodsArray[_speIndexPath.section];
        CarDetailModel *detailModel = bigModel.goodsDetails[_speIndexPath.row];
        detailModel.goodsDetailId = sepString;
        detailModel.specification = goodSpecification;
        [strongSelf.tableView reloadData];
    };
    
    // 设置maskView (第三层)
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize_W, MainScreenSize_H/2 + 15)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHidden)]];
    
}

- (void)clickShow{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.specificationsView];
    
    
    CGRect regec = self.specificationsView.frame;
    regec.origin.y = MainScreenSize_H/2;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.layer.transform = [self transformFirst];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.view.layer.transform = [self transformSecond];
            self.maskView.alpha = 0.5;
            self.specificationsView.frame = regec;
        }];
    }];
}



- (void)clickHidden{
    [UIView animateWithDuration:0.3f animations:^{
        self.specificationsView.frame = CGRectMake(0, MainScreenSize_H, MainScreenSize_W, MainScreenSize_H/2);
        self.maskView.alpha = 0;
        self.view.layer.transform = [self transformFirst];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.view.layer.transform = CATransform3DIdentity;
        }];
    }];
}

// 第一次形变
- (CATransform3D)transformFirst{
    // 每次进来都进行初始化 回归到正常状态
    CATransform3D form1 = CATransform3DIdentity;
    // m34就是实现视图的透视效果的（俗称近大远小）
    form1.m34 = 1.0/-900;
    //缩小的效果
    form1 = CATransform3DScale(form1, 0.95, 0.95, 1);
    //x轴旋转
    form1 = CATransform3DRotate(form1, 15.0 * M_PI/180.0, 1, 0, 0);
    return form1;
    
}

// 第二次形变
- (CATransform3D)transformSecond{
    // 初始化 再次回归正常
    CATransform3D form2 = CATransform3DIdentity;
    // 用上面用到的m34 来设置透视效果
    form2.m34 = [self transformFirst].m34;
    //向上平移一丢丢 让视图平滑点
    form2 = CATransform3DTranslate(form2, 0, self.view.frame.size.height * (-0.08), 0);
    //最终再次缩小到0.8倍
    form2 = CATransform3DScale(form2, 0.8, 0.8, 1);
    
    return form2;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shopCarGoodsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShopCarDetailModel *model = self.shopCarGoodsArray[section];
    return model.goodsDetails.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyShopCarTableViewCellIdentifier];
    cell.editing = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ShopCarDetailModel *shopModel = self.shopCarGoodsArray[indexPath.section];
    
    CarDetailModel *detailModel = shopModel.goodsDetails[indexPath.row];
    cell.goodsModel = detailModel;
    cell.delegate = self;
    cell.shopCellEditState = detailModel.cellEditState;
    cell.shopCellSelectBtnState = detailModel.selectState;
    cell.shopCellDeleteBtnState = detailModel.deleteBtnState;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyShopCarTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MyShopCarTableViewHeaderIdentifier];
    ShopCarDetailModel *shopModel = self.shopCarGoodsArray[section];
    
    headerView.selectBtnTag = section;
    headerView.editBtnTag = section;
    headerView.delegate = self;
    headerView.carModel = shopModel;
    if (_editBtn.selected) {
        headerView.hiddenEidtBtn = YES;
    }else{
        headerView.hiddenEidtBtn = NO;
    }
    headerView.headerViewAllSelectBtnState = shopModel.selectState;
    headerView.headerViewEditBtnState = shopModel.editState;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除商品
        [self deleteShopCarGood:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyShopCarTableHeaderView *headerView = (MyShopCarTableHeaderView *)[tableView headerViewForSection:indexPath.section];
    if (headerView.headerViewEditBtnState) {
        return NO;
    }else{
        return YES;
    }
    
}

#pragma mark -- 底部全选按钮
/**
 *  底部全选按钮点击事件
 */
- (void)selectAllGoods{
    
    _selectButton.selected = !_selectButton.selected;
    [self.shopCarDeleteIdArray removeAllObjects];
    NSMutableArray *detailArray = [NSMutableArray array];
    for (int i = 0; i < self.shopCarGoodsArray.count; i++) {
        ShopCarDetailModel *model = self.shopCarGoodsArray[i];
        model.selectState = _selectButton.selected;
        
        for (int j = 0; j < model.goodsDetails.count; j++) {
            CarDetailModel *detailModel = model.goodsDetails[j];
            if (_settleBtn.selected) {
                [self.shopCarDeleteIdArray addObject:detailModel.shoppingCartId];
            }
            //将cell中和全选按钮状态不一样的选中按钮 设置为和全选按钮的状态一样
            if (detailModel.selectState != _selectButton.selected) {
                detailModel.selectState  = _selectButton.selected;
                [detailArray addObject:detailModel];
            }
        }
    }
    
    [self calculateTotalMoney:detailArray addOrReduc:_selectButton.selected];
    
    [_tableView reloadData];
    
}
#pragma mark -- 计算总价
/**
 *  计算总价
 *
 *  @param detailModelArray 商品集合
 *  @param operation        YES 加  NO 减
 */
- (void)calculateTotalMoney:(NSMutableArray *)detailModelArray addOrReduc:(BOOL)operation{
    
    NSString *price;
    
    for (CarDetailModel *detailModel in detailModelArray) {
        price = [_moneyLabel.text substringFromIndex:4];
        if (operation) {
            
            _moneyLabel.text = [NSString stringWithFormat:@"合计：¥%d",[price intValue] + [detailModel.detaileprice intValue]*[detailModel.count intValue]];
        }else{
            _moneyLabel.text = [NSString stringWithFormat:@"合计：¥%d",[price intValue] - [detailModel.detaileprice intValue]*[detailModel.count intValue]];
        }
        
    }
    _moneyLabel.attributedText = [self setAttributeString:3 string:_moneyLabel.text];
}
/**
 *  返回可变属性字符串
 *
 *  @param fromIndex 截取起始index
 *  @param text      被编辑的字符串
 *
 *  @return 可变属性字符串
 */
- (NSMutableAttributedString *)setAttributeString:(NSInteger)fromIndex string:(NSString *)text{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:RgbColor(254, 36, 25, 1)} range:NSMakeRange(fromIndex, text.length - fromIndex)];
    return attributeString;
}
#pragma mark -- 结算
/**
 *  底部结算按钮点击事件
 */
- (void)settlementGoods{
    
    //    NSIndexPath *indexPath;
    for (int i = 0; i < self.shopCarGoodsArray.count; i++) {
        ShopCarDetailModel *model = self.shopCarGoodsArray[i];
        
        for (int j = 0; j < model.goodsDetails.count; j++) {
            
        }
    }
    
    if (_settleBtn.selected == YES) {
        [self lotsDeleteShopCarGoods];
        [_tableView reloadData];
    }
}

#pragma mark -- 编辑
/**
 *  顶部编辑按钮点击事件
 */
- (void)editShopCar{
    _editBtn.selected     =  !_editBtn.selected;
    _collectionBtn.hidden =  !_collectionBtn.hidden;
    _moneyLabel.hidden    =  !_moneyLabel.hidden;
    _settleBtn.selected   =  !_settleBtn.selected;
    
    for (int i = 0; i < self.shopCarGoodsArray.count; i++) {
        ShopCarDetailModel *shopModel = self.shopCarGoodsArray[i];
        //取消段头编辑按钮的选中状态
        shopModel.editState = NO;
        for (int j = 0; j < shopModel.goodsDetails.count; j++) {
            CarDetailModel *detailModel = shopModel.goodsDetails[j];
            detailModel.deleteBtnState = NO;
            detailModel.cellEditState = _editBtn.selected;
        }
    }
    [_tableView reloadData];
}

#pragma -- mark ShopCarTableViewHeaderViewDelegate
/**
 *  表头按钮代理
 *
 *  @param sender 编辑或选中商品
 */
- (void)selectOrEditGoods:(UIButton *)sender{
    
    ShopCarDetailModel *model = self.shopCarGoodsArray[sender.tag];
    NSMutableArray *detailModelArray = [NSMutableArray array];
    if (sender.titleLabel.text.length == 0) {//点击的是表头的全选按钮 设置cell的选中状态
        model.selectState = sender.selected;
        for (int i = 0; i < model.goodsDetails.count; i++) {
            CarDetailModel *detailModel = model.goodsDetails[i];
            if (detailModel.selectState != model.selectState) {
                detailModel.selectState = model.selectState;
                [detailModelArray addObject:detailModel];
            }
        }
        
        //计算价格
        [self calculateTotalMoney:detailModelArray addOrReduc:sender.selected];
        
        [self setBottomBtnSelectState];
        
        [_tableView reloadData];
        
    }else{//点击的是表头的编辑按钮 设置cell的状态为可编辑
        model.editState = sender.selected;
        for (int i = 0; i < model.goodsDetails.count; i++) {
            CarDetailModel *detailModel = model.goodsDetails[i];
            detailModel.deleteBtnState = sender.selected;
            detailModel.cellEditState = sender.selected;
        }
        
        [_tableView reloadData];
        
    }
}



#pragma mark -- ShopTableViewCellSelectDelegate
/**
 *  cell的选择代理
 *
 *  @param sender 选中按钮
 */
- (void)cellSelectBtnClick:(UIButton *)sender{
    MyShopCarTableViewCell *cell = (MyShopCarTableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath;
    indexPath = [_tableView indexPathForCell:cell];
    
    ShopCarDetailModel *bigModel = self.shopCarGoodsArray[indexPath.section];
    CarDetailModel *cellModel = bigModel.goodsDetails[indexPath.row];
    cellModel.selectState = sender.selected;
    //设置段头的选择按钮选中状态
    [self setHeaderViewSelectState:bigModel];
    //设置底部选择按钮的选中状态
    [self setBottomBtnSelectState];
    //计算价格
    [self calculateTotalMoney:[NSMutableArray arrayWithObject:cellModel] addOrReduc:sender.selected];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //    [_tableView reloadData];
    
}
/**
 *  修改商品数量
 *
 *  @param sender 1 减少  2 增加
 */
- (void)changeShopCount:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}

/**
 *  删除商品
 *
 *  @param sender 删除按钮
 */
- (void)deleteShopGoodTouch:(UIButton *)sender{
    MyShopCarTableViewCell *cell = (MyShopCarTableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath;
    indexPath = [_tableView indexPathForCell:cell];
    [self deleteShopCarGood:indexPath];
}

//单个删除商品
- (void)deleteShopCarGood:(NSIndexPath *)indexPath{
    ShopCarDetailModel *bigModel = self.shopCarGoodsArray[indexPath.section];
    CarDetailModel *detailModel = bigModel.goodsDetails[indexPath.row];
    [self.shopCarDeleteIdArray addObject:detailModel.shoppingCartId];
    
    NSMutableArray *detailArray = [NSMutableArray arrayWithArray:bigModel.goodsDetails];
    
    [detailArray removeObjectAtIndex:indexPath.row];
    
    bigModel.goodsDetails = detailArray;
    
    if (detailArray.count == 0) {
        [self.shopCarGoodsArray removeObjectAtIndex:indexPath.section];
    }
    
    [_tableView reloadData];
}

- (void)lotsDeleteShopCarGoods{
    //indexArray 储存所选中的cell的row
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < self.shopCarGoodsArray.count; i++) {
        ShopCarDetailModel *bigModel = self.shopCarGoodsArray[i];
        for (int j = 0; j < bigModel.goodsDetails.count; j++) {
            CarDetailModel *detailModel = bigModel.goodsDetails[j];
            if (_selectButton.selected == YES) {
                [self.shopCarDeleteIdArray addObject:detailModel.shoppingCartId];
            }else if (detailModel.selectState == YES) {
                [self.shopCarDeleteIdArray addObject:detailModel.shoppingCartId];
                [indexArray addObject:@(j)];
            }
        }
    }
    
    
    
    if (_selectButton.selected == YES) {
        _selectButton.selected = NO;
        [self.shopCarGoodsArray removeAllObjects];
    }else{
        for (int i = 0; i < self.shopCarGoodsArray.count; i++) {
            ShopCarDetailModel *bigModel = self.shopCarGoodsArray[i];
            for (int j = 0; j < bigModel.goodsDetails.count; j++) {
                CarDetailModel *detailModel = bigModel.goodsDetails[j];
                if (detailModel.selectState == YES) {//如果某一行处于选中状态 则删除改行的model
                    NSMutableArray *detailArray = [NSMutableArray arrayWithArray:bigModel.goodsDetails];
                    [detailArray removeObjectAtIndex:j];
                    bigModel.goodsDetails = detailArray;
                }
            }
            //如果这一段没数据 则删除整段
            if (bigModel.goodsDetails.count == 0) {
                [self.shopCarGoodsArray removeObjectAtIndex:i];
            }
        }
    }
    
    
    
    [_tableView reloadData];
    //    [HMTNETWORKREQUEST DeleteShopCarGoods:self.shopCarDeleteIdArray selfTarget:self success:^(id successModel) {
    //
    //    } failure:^(id failureModel) {
    //        BaseModel *baseModel = (BaseModel *)failureModel;
    //        [MessageTool showMessage:baseModel.desc isError:YES];
    //    }];
}

/**
 *  选择商品规格点击事件
 *
 *  @param detailView 响应View
 */
- (void)changeShopDetail:(UIView *)detailView{
    [self.currentSpecificationsArray removeAllObjects];
    [self.allSpecificationsArray removeAllObjects];
    [self.selectSpecificationsArray removeAllObjects];
    
    MyShopCarTableViewCell *cell = (MyShopCarTableViewCell *)[[detailView superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ShopCarDetailModel *bigModel = self.shopCarGoodsArray[indexPath.section];
    CarDetailModel *detailModel = bigModel.goodsDetails[indexPath.row];
    _speIndexPath = indexPath;
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"specifications" ofType:@"archive"];
    NSDictionary *modelDic = [NSKeyedUnarchiver unarchiveObjectWithFile:pathString];
    NSArray *detailArray = modelDic[@"goodsDetails"];
    
    for (NSDictionary *dict in detailArray) {
        ShopCarCurrentGoodModel *currentDetailModel = [ShopCarCurrentGoodModel yy_modelWithDictionary:dict];
        [self.selectSpecificationsArray addObject:currentDetailModel];
    }
    
    NSArray *specificationsArray = modelDic[@"goodsSpecifications"];
    for (NSDictionary *dict in specificationsArray) {
        GoodsSpecificationsModel *allSpecificationsModel = [GoodsSpecificationsModel yy_modelWithDictionary:dict];
        [self.allSpecificationsArray addObject:allSpecificationsModel];
    }
    
    NSArray *selectSpecificationsArray = modelDic[@"currentSpecifications"];
    for (NSDictionary *dict in selectSpecificationsArray) {
        GoodsSpecificationsModel *selectSpecificationsModel = [GoodsSpecificationsModel yy_modelWithDictionary:dict];
        [self.currentSpecificationsArray addObject:selectSpecificationsModel];
    }
    
    _goodNumber = detailModel.count;
    _shopCarId = detailModel.shoppingCartId;
    _goodId = detailModel.goodsId;
    
    [self.specificationsView creatView:detailModel arrayOfGoodsDetail:self.selectSpecificationsArray arrayOfgoodsSpecifications:self.allSpecificationsArray arrayOfCurrentSpecifications:self.currentSpecificationsArray];
    //动画效果
    [self clickShow];
}


/**
 *  当键盘出现时滑动tableView
 *
 *  @param textField 当前编辑的field
 */
- (void)tableViewScroll:(UITextField *)textField{
    MyShopCarTableViewCell *cell = (MyShopCarTableViewCell *)[[textField superview] superview];
    UITableView *tableView;
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 7.0) {
        tableView = (UITableView *)[cell superview];
    }else{
        tableView = (UITableView *)[[cell superview] superview];
    }
    _keyboardHeight = tableView.contentOffset.y;
    [UIView animateWithDuration:0.3f animations:^{
        tableView.contentOffset = CGPointMake(0, cell.y);
    }];
    
    _keyboardHeight = tableView.contentOffset.y - _keyboardHeight;
}

/**
 *  设置表头选中状态
 *
 *  @param bigModel 购物车model
 */
- (void)setHeaderViewSelectState:(ShopCarDetailModel *)bigModel{
    BOOL currentState = YES;
    //表头选中状态
    for (int i = 0 ; i < bigModel.goodsDetails.count; i++) {
        CarDetailModel *detailModel = bigModel.goodsDetails[i];
        if (detailModel.selectState != YES) {
            currentState = NO;
            break;
        }
    }
    bigModel.selectState = currentState;
}

/**
 *  设置下方全选按钮选中状态
 */
- (void)setBottomBtnSelectState{
    BOOL currentState = YES;
    //下方全选按钮选中状态
    for (int i = 0; i < self.shopCarGoodsArray.count; i++) {
        ShopCarDetailModel *model = self.shopCarGoodsArray[i];
        if (model.selectState != YES) {
            currentState = NO;
            break;
        }
    }
    //最下方的全选按钮的状态
    _selectButton.selected =currentState;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    _keyBoardTopView.y = MainScreenSize_H - height - 40;
    
    
}
//当键盘隐藏时调用
- (void)keyboardWillHidden:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    _keyBoardTopView.y = MainScreenSize_H;
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.contentOffset = CGPointMake(0, _tableView.contentOffset.y - _keyboardHeight);
    }];
    
    
}
/**
 *  隐藏键盘
 */
- (void)hiddenKeyboard{
    [self.view endEditing:YES];
    
}

#pragma mark -- 懒加载

- (NSMutableArray *)shopCarGoodsArray{
    if (_shopCarGoodsArray == nil) {
        _shopCarGoodsArray = [NSMutableArray array];
    }
    return _shopCarGoodsArray;
}

- (NSMutableArray *)shopCarDeleteIdArray{
    if (_shopCarDeleteIdArray == nil) {
        _shopCarDeleteIdArray = [NSMutableArray array];
    }
    return _shopCarDeleteIdArray;
}

- (NSMutableArray *)currentSpecificationsArray{
    if (_currentSpecificationsArray == nil) {
        _currentSpecificationsArray = [NSMutableArray array];
    }
    return _currentSpecificationsArray;
}
- (NSMutableArray *)allSpecificationsArray{
    if (_allSpecificationsArray == nil) {
        _allSpecificationsArray = [NSMutableArray array];
    }
    return _allSpecificationsArray;
}

- (NSMutableArray *)selectSpecificationsArray{
    if (_selectSpecificationsArray == nil) {
        _selectSpecificationsArray = [NSMutableArray array];
    }
    return _selectSpecificationsArray;
}

#pragma mark -- 防止表头悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat headerViewH = 45;
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= headerViewH) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y >= headerViewH){
        scrollView.contentInset = UIEdgeInsetsMake(-headerViewH, 0, 0, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
