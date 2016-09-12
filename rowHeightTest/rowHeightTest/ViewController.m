//
//  ViewController.m
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/7.
//  Copyright © 2016年 alan. All rights reserved.
//


#import "ViewController.h"
#import "ATTableViewCell.h"
#import "ATModel.h"
#import "UITableViewCell+ATCalcCellHeight.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *contents;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *mainTableView = [[UITableView alloc] init];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainTableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (NSMutableArray *)contents {
    if (!_contents) {
        _contents = [NSMutableArray array];
        for (NSUInteger i = 0; i < 20; i++) {
            ATModel *model = [[ATModel alloc] init];
            model.title = (i % 2) ? [self title] : [self desc];
            model.desc = (i % 3) ? [self title] : [self desc];
            model.cacheId = i + 1;
            model.expand = NO;
            [_contents addObject:model];
        }
    }
    return _contents;
}
- (NSString *)title {
    return @"我们知道，在 Objective-C 中可以通过 Category 给一个现有的类添加属性，但是却不能添加实例变量，这似乎成为了 Objective-C 的一个明显短板。然而值得庆幸的是，我们可以通过 Associated Objects 来弥补这一不足。本文将结合 runtime 源码深入探究 Objective-C 中 Associated Objects 的实现原理。";
}
- (NSString *)desc {
    return @"关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？";
}
#pragma mark - UITableViewDelegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    ATTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ATModel *model = self.contents[indexPath.row];
    cell.model = model;
    
    cell.expandBlock = ^(BOOL isExpand) {
        model.expand = isExpand;
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ATModel *model = self.contents[indexPath.row];
    
//    return [ATTableViewCell cellHeightWithTableView:tableView transModel:^(UITableViewCell *sourceCell) {
//        ATTableViewCell *cell = (ATTableViewCell *)sourceCell;
//        // 配置数据
//        cell.model = model;
//
//    }];
    
    
    NSString *stateKey = nil;
    if (model.isExpand) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }

    return [ATTableViewCell cellHeightWithTableView:tableView transModel:^(UITableViewCell *sourceCell) {
        ATTableViewCell *cell = (ATTableViewCell *)sourceCell;
        // 配置数据
        cell.model = model;

    } cache:^NSDictionary *{
        return @{ATCacheUniqueKey: [NSString stringWithFormat:@"%ld", model.cacheId],
                 ATCacheStateKey : stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 ATRecalcForStateKey : @(NO) // 标识不用重新更新
                 };

    }];
    
}
@end
