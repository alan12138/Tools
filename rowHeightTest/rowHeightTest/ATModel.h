//
//  ATModel.h
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/8.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSUInteger cacheId;
@property (nonatomic, assign,getter=isExpand) BOOL expand;


@end
