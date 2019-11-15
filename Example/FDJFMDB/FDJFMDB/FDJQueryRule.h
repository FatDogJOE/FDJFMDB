//
//  FDJQueryRule.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDJSQL.h"
#import "FDJColume.h"

typedef NS_ENUM(NSUInteger, FDJOrder) {
    FDJOrderAsc,
    FDJOrderDesc
};

NS_ASSUME_NONNULL_BEGIN

@interface FDJQueryRule : NSObject<FDJSQL>

@property (nonatomic, strong) NSArray <FDJColume *> * orderColumes;
@property (nonatomic, assign) FDJOrder orderRule;

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;

@end

NS_ASSUME_NONNULL_END
