//
//  FDJDataModel.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDJTable.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FDJDataModel
+ (FDJTable *)table;
@end

@interface FDJDataModel : NSObject<FDJDataModel>

- (instancetype)initWithDic:(NSDictionary *)dic;
- (BOOL)save;

+ (FDJTable *)table;

//Override Methods
+ (NSArray *)columes;
+ (NSString *)tableName;

//Database operation
+ (BOOL)insertOrUpdate:(NSArray<FDJDataModel *> *)models;
+ (BOOL)insertOrUpdateWithDic:(NSDictionary *)dataDic;
+ (BOOL)insertOrUpdateWithDics:(NSArray *)dataDics;

+ (BOOL)update:(NSArray<FDJDataModel *> *)models;
+ (BOOL)updateWithDic:(NSDictionary *)dataDic;
+ (BOOL)updateWithDics:(NSArray *)dataDics;

+ (BOOL)remove:(NSArray<FDJDataModel *> *)models;
+ (BOOL)removeWhere:(NSString *)format, ...;

+ (NSArray *)queryWhere:(NSString *)format, ...;
+ (NSArray *)queryAll;
+ (FDJDataModel *)queryOne:(NSString *)primaryValue;

@end

NS_ASSUME_NONNULL_END
