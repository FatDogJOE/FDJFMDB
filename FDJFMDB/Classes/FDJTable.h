//
//  FDJTable.h
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDJColume.h"
#import "FDJSQL.h"
#import "FDJDatabaseDefines.h"
#import "FDJQueryRule.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDJTable : NSObject<FDJSQL>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, readonly) FDJColume * primaryColume;
@property (nonatomic, strong) NSArray<FDJColume *> * columes;

- (instancetype)initWithName:(NSString *)name columes:(NSArray<FDJColume *> *)columes;

- (FDJColume *)columeWithName:(NSString *)name;

- (NSString *)createSQL;

- (NSString *)insert:(id (^)(FDJColume * colume))operation;
- (NSString *)insertOrUpdate:(id (^)(FDJColume * colume))operation;
- (NSString *)update:(NSArray<NSString *> *)columeNames operation:(id (^)(FDJColume * colume))operation where:(NSString *)condition;
- (NSString *)update:(NSDictionary *)dataDic where:(NSString *)condition;
- (NSString *)removeAll;
- (NSString *)removeWhere:(NSString *)condition;

- (NSString *)query:(NSString *)condition rule:(FDJQueryRule *)rule;

@end

NS_ASSUME_NONNULL_END
