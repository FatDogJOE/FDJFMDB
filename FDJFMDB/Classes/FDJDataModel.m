//
//  FDJDataModel.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJDataModel.h"
#import "FDJDatabase.h"
#import "FDJColume+ValueConvert.h"
#import <YYModel/YYModel.h>

@interface FDJDataModel()

@end

@implementation FDJDataModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (BOOL)save {
    return [[self class] insertOrUpdate:@[self]];
}

+ (FDJTable *)table {
    static NSMutableDictionary * dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary dictionary];
    });
    FDJTable * table;
    @synchronized (dic) {
        if (!dic[[self tableName]]) {
            table = [[FDJTable alloc] initWithName:[self tableName] columes:[self columes]];
            dic[[self tableName]] = table;
        }else {
            table = dic[[self tableName]];
        }
    }
    return table;
}

+ (NSString *)primaryKey {
    return [self table].primaryColume.name;
}

#pragma mark - Private Methods

- (NSString *)columeSQLValue:(NSString *)columeName {
    
    FDJColume * colume = [[FDJDataModel table] columeWithName:columeName];
    
    if (colume) {
        id value = [self valueForKeyPath:columeName];
        return [colume convertValue:value];
    }else {
        return @"";
    }
    
}

+ (NSString *)columeSQL:(NSString *)columeName value:(id)value {
    FDJColume * colume = [[FDJDataModel table] columeWithName:columeName];
    
    if (colume) {
        return [colume convertValue:value];
    }else {
        return @"";
    }
    
}

#pragma mark - Override Methods

+ (NSArray *)columes {
    NSAssert(NO, @"Need override method: %@", NSStringFromSelector(_cmd));
    return @[];
}

+ (NSString *)tableName {
    NSAssert(NO, @"Need override method: %@", NSStringFromSelector(_cmd));
    return @"";
}

#pragma mark - Database Operation

+ (BOOL)insertOrUpdate:(NSArray<FDJDataModel *> *)models {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(FDJDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * sql =  [[self table] insertOrUpdate:^id _Nonnull(FDJColume * _Nonnull colume) {
            return [obj valueForKey:colume.name];
        }];
        
        [sqls addObject:sql];
    }];
    
    BOOL success = [[FDJDatabase db] executeUpdates:sqls];
    
    return success;
}

+ (BOOL)insertOrUpdateWithDic:(NSDictionary *)dataDic {
    
    NSString * sql = [[self table] insertOrUpdate:^id _Nonnull(FDJColume * _Nonnull colume) {
        return [dataDic valueForKey:colume.name];
    }];
    
    BOOL success = [[FDJDatabase db] executeUpdate:sql];
    
    return success;
    
}

+ (BOOL)insertOrUpdateWithDics:(NSArray *)dataDics {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    [dataDics enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * sql =  [[self table] insertOrUpdate:^id _Nonnull(FDJColume * _Nonnull colume) {
            return [obj valueForKey:colume.name];
        }];
        
        [sqls addObject:sql];
    }];
    
    BOOL success = [[FDJDatabase db] executeUpdates:sqls];
    
    return success;
    
}

+ (BOOL)update:(NSArray<FDJDataModel *> *)models {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(FDJDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * sql =  [[self table] update:[obj yy_modelToJSONObject] where:FDJ_STR(@"%@ = %@", [self primaryKey], [obj columeSQLValue:[self primaryKey]])];

        [sqls addObject:sql];
        
    }];
    
    BOOL success = [[FDJDatabase db] executeUpdates:sqls];
    
    return success;
    
}

+ (BOOL)updateWithDic:(NSDictionary *)dataDic {
    
    if (!dataDic[[self primaryKey]]) {
        return NO;
    }
    
    NSString * sql = [[self table] update:dataDic where:FDJ_STR(@"%@ = %@", [self primaryKey], [FDJDataModel columeSQL:[self primaryKey] value:dataDic[[self primaryKey]]])];
    
    BOOL success = [[FDJDatabase db] executeUpdate:sql];
    
    return success;
    
}

+ (BOOL)updateWithDics:(NSArray *)dataDics {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    for (NSDictionary * dataDic in dataDics) {
        
        if (![dataDic isKindOfClass:NSDictionary.class] || !dataDic[[self primaryKey]]) {
            continue;
        }
        
        NSString * sql = [[self table] update:dataDic where:FDJ_STR(@"%@ = %@", [self primaryKey], [FDJDataModel columeSQL:[self primaryKey] value:dataDic[[self primaryKey]]])];
        
        [sqls addObject:sql];
        
    }
    
    BOOL success = [[FDJDatabase db] executeUpdates:sqls];
    
    return success;
    
}
 
+ (BOOL)remove:(NSArray<FDJDataModel *> *)models {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(FDJDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * sql = [[self table] removeWhere:FDJ_STR(@"%@ = %@", [self primaryKey], [obj columeSQLValue:[self primaryKey]])];
        [sqls addObject:sql];
    }];
    
    BOOL success = [[FDJDatabase db] executeUpdates:sqls];
    
    return success;
    
}

+ (BOOL)removeWhere:(NSString *)format, ... {
    
    va_list arggs;
    va_start(arggs, format);
    NSString * condition = [[NSString alloc] initWithFormat:format arguments:arggs];
    va_end(arggs);
    
    NSString * sql = [[self table] removeWhere:condition];
    
    BOOL success = [[FDJDatabase db] executeUpdate:sql];
    
    return success;
    
}

+ (NSArray *)queryWhere:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString * condition = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSString * sql = [[self table] query:condition rule:nil];
    
    NSArray * result = [[FDJDatabase db] executeQuery:sql map:^id _Nonnull(NSDictionary * _Nonnull dbDic) {
        return [self yy_modelWithJSON:dbDic];
    }];
    
    return result;
}

+ (NSArray *)queryAll {
    
    NSString * sql = [[self table] query:nil rule:nil];
    
    NSArray * result = [[FDJDatabase db] executeQuery:sql map:^id _Nonnull(NSDictionary * _Nonnull dbDic) {
        return [self yy_modelWithJSON:dbDic];
    }];
    
    return result;
}

+ (FDJDataModel *)queryOne:(NSString *)primaryValue {
    
    NSString * sql = [[self table] query:FDJ_STR(@"%@ = %@", [self primaryKey], [self columeSQL:[self primaryKey] value:primaryValue]) rule:nil];
    
    NSArray * result = [[FDJDatabase db] executeQuery:sql map:^id _Nonnull(NSDictionary * _Nonnull dbDic) {
        return [self yy_modelWithJSON:dbDic];
    }];
    
    return result.firstObject;

}

@end
