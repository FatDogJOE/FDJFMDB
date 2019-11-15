//
//  FDJDatabase.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDJDatabaseConfig.h"
#import "FDJDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDJDatabase : NSObject

+ (instancetype)db;

+ (void)setupWithConfig:(FDJDatabaseConfig *)config;

- (BOOL)executeUpdate:(NSString *)sql;
- (BOOL)executeUpdates:(NSArray<NSString *> *)sqls;
- (NSArray *)executeQuery:(NSString *)sql map:(id(^)(NSDictionary * dbDic))map;
- (void)registerTables:(NSArray<Class<FDJDataModel>> *)modelClasses;

@end

NS_ASSUME_NONNULL_END
