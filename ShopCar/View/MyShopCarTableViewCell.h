//
//  MyShopCarTableViewCell.h
//  ShopCarDemo
//
//  Created by PanChuang on 16/9/20.
//  Copyright © 2016年 PanChuang. All rights reserved.
//
//
//                            _oo0oo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                           O\  =  /O
//                        ____/`---'\____
//                      .'  \\|     |//  `.
//                     /  \\|||  :  |||//  \
//                    /  _||||| -:- |||||-  \
//                    |   | \\\  -  /// |   |
//                    | \_|  ''\---/''  |   |
//                    \  .-\__  `-`  ___/-. /
//                   ___`. .'  /--.--\  `. . __
//                ."" '<  `.___\_<|>_/___.'  >'"".
//              | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//              \  \ `-.   \_ __\ /__ _/   .-` /  /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//
//
//

#import <UIKit/UIKit.h>
@class CarDetailModel;

@protocol ShopTableViewCellSelectDelegate <NSObject>
/** 选择按钮点击事件 */
- (void)cellSelectBtnClick:(UIButton *)sender;
/** 删除按钮点击事件 */
- (void)deleteShopGoodTouch:(UIButton *)sender;
/** 增减数量按钮点击事件 */
- (void)changeShopCount:(UIButton *)sender;
/** 手动输入数量 */
- (void)tableViewScroll:(UITextField *)textField;
/** 选择商品规格点击事件 */
- (void)changeShopDetail:(UIView *)detailView;
@end

@interface MyShopCarTableViewCell : UITableViewCell

@property (nonatomic, strong) CarDetailModel *goodsModel;

@property (nonatomic, weak) id<ShopTableViewCellSelectDelegate>delegate;

/** cell编辑状态 */
@property (nonatomic, assign) BOOL shopCellEditState;
/** 选择按钮的选择状态 */
@property (nonatomic, assign) BOOL shopCellSelectBtnState;
/** 删除按钮的状态 */
@property (nonatomic, assign) BOOL shopCellDeleteBtnState;

/** 获取商品价格 */
- (NSInteger)getShopPrice;
@end
