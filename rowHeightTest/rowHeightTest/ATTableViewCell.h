//
//  ATTableViewCell.h
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/7.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATModel;
@interface ATTableViewCell : UITableViewCell
@property (nonatomic, strong) ATModel *model;

typedef void(^ATExpandBlock)(BOOL isExpand);
@property (nonatomic, copy) ATExpandBlock expandBlock;
@end
