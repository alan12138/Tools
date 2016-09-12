//
//  ATTableViewCell.m
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/7.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATTableViewCell.h"
#import "ATModel.h"
#import "UITableViewCell+ATCalcCellHeight.h"

@interface ATTableViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UIButton *btn;
@property (nonatomic, weak) UIView *separatorView;

@property (nonatomic, assign) BOOL isExpandedNow;
@end

@implementation ATTableViewCell
- (void)setModel:(ATModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    
    if (model.isExpand != self.isExpandedNow) {
        self.isExpandedNow = model.isExpand;
        CGFloat margin = 20;
        if (self.isExpandedNow) {
            [self.descLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(margin);
                make.top.equalTo(self.titleLabel.bottom).offset(margin);
                make.right.equalTo(self.contentView).offset(-margin);
            }];
        } else {
            [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_lessThanOrEqualTo(60);
            }];
        }
    }

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubViews];
        [self autoLayoutSubViews];
        
        self.isExpandedNow = YES;
        self.lastViewToBottomDis = 10;

    }
    return self;
}
- (void)setupSubViews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.numberOfLines = 0;
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    self.descLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(onTap)];
    [self.descLabel addGestureRecognizer:tap];

    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UIColor greenColor]];
    [self.contentView addSubview:btn];
    self.btn = btn;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    // 应该始终要加上这一句
    // 不然在6/6plus上就不准确了
    self.titleLabel.preferredMaxLayoutWidth = w - 40;
    self.descLabel.preferredMaxLayoutWidth = w - 40;

    

}
- (void)autoLayoutSubViews {
    CGFloat margin = 20;
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(margin);
        make.top.equalTo(self.contentView).offset(margin);
        make.right.equalTo(self.contentView).offset(-margin);
    }];
    [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(margin);
    }];
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel);
        make.right.equalTo(self.descLabel);
        make.top.equalTo(self.descLabel.bottom).offset(margin);
        make.height.equalTo(44);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.btn.bottom).offset(margin);
        make.height.equalTo(1);
    }];
}

- (void)onTap {
    if (self.expandBlock) {
        self.expandBlock(!self.isExpandedNow);
    }
}
@end
