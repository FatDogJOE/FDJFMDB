//
//  FDJTable.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJTable.h"
#import "FDJDatabaseDefines.h"
#import "FDJColume+ValueConvert.h"

@interface FDJTable()

@property (nonatomic, strong) NSMutableDictionary * columesDic;

@end

@implementation FDJTable

- (instancetype)initWithName:(NSString *)name columes:(NSArray<FDJColume *> *)columes {
    self = [super init];
    if (self) {
        self.name = name;
        self.columes = columes;
        self.columesDic = [NSMutableDictionary dictionary];
        [self.columes enumerateObjectsUsingBlock:^(FDJColume * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.columesDic[obj.name] = obj;
            if ([obj haveConstraint:ColumeConstraintPrimaryKey]) {
                _primaryColume = obj;
            }
        }];
    }
    return self;
}

#pragma mark - Public Methods

- (FDJColume *)columeWithName:(NSString *)name {
    return self.columesDic[name];
}

- (NSString *)createSQL {
    
    NSMutableArray * columeSqls = [NSMutableArray array];
    
    [self.columes enumerateObjectsUsingBlock:^(FDJColume * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [columeSqls addObject:obj.sql];
    }];
    
    return FDJ_STR(@"CREATE TABLE IF NOT EXISTS %@ (%@)", self.sql, [columeSqls componentsJoinedByString:@","]);
}

- (NSString *)insert:(id (^)(FDJColume * colume))operation {
    
    NSMutableArray * columes = [NSMutableArray array];
    NSMutableArray * values  = [NSMutableArray array];
    
    [self.columes enumerateObjectsUsingBlock:^(FDJColume * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [columes addObject:FDJ_STR(@"%@",obj.name)];
        id value = [obj convertValue:operation(obj)];
        [values addObject:value];
    }];
    
    return FDJ_STR(@"INSERT INTO %@ (%@) VALUES (%@)", self.sql, [columes componentsJoinedByString:@","], [values componentsJoinedByString:@","]);
}

- (NSString *)insertOrUpdate:(id (^)(FDJColume * colume))operation {
    
    NSMutableArray * columes = [NSMutableArray array];
    NSMutableArray * values  = [NSMutableArray array];
    
    [self.columes enumerateObjectsUsingBlock:^(FDJColume * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [columes addObject:FDJ_STR(@"%@",obj.name)];
        id value = [obj convertValue:operation(obj)];
        [values addObject:value];
    }];
    
    return FDJ_STR(@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", self.sql, [columes componentsJoinedByString:@","], [values componentsJoinedByString:@","]);
}

- (NSString *)update:(NSArray<NSString *> *)columeNames operation:(id (^)(FDJColume * colume))operation where:(NSString *)condition {
    
    NSMutableArray * sets = [NSMutableArray array];
    
    [columeNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FDJColume * colume = self.columesDic[obj];
        if (colume) {
            NSString * value = [colume convertValue:operation(colume)];
            NSString * set = FDJ_STR(@"%@ = %@", obj, value);
            [sets addObject:set];
        }
        
    }];
    
    return FDJ_STR(@"UPDATE %@ SET %@ WHERE %@", self.sql, [sets componentsJoinedByString:@","], condition); 
}

- (NSString *)update:(NSDictionary *)dataDic where:(NSString *)condition {
    
    NSMutableArray * sets = [NSMutableArray array];
    
    [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        FDJColume * colume = self.columesDic[key];
        if (colume) {
            NSString * value = [colume convertValue:obj];
            NSString * set = FDJ_STR(@"%@ = %@",key, value);
            [sets addObject:set];
        }
        
    }];
    
    return FDJ_STR(@"UPDATE %@ SET %@ WHERE %@", self.sql, [sets componentsJoinedByString:@","], condition);
}

- (NSString *)removeAll {
    return FDJ_STR(@"DELETE FROM %@", self.sql);
}
- (NSString *)removeWhere:(NSString *)condition {
    return FDJ_STR(@"DELETE FROM %@ WHERE %@", self.sql, condition);
}

- (NSString *)query:(NSString *)condition rule:(FDJQueryRule *)rule {
    
    NSString * sql = FDJ_STR(@"SELECT * FROM %@", self.sql);
    
    if (condition.length > 0) {
        sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
    }
    
    if (rule) {
        sql = [sql stringByAppendingFormat:@" %@", [rule sql]];
    }
    
    return sql;
}

#pragma mark - FDJSQL

- (NSString *)sql {
    return self.name;
}

@end
