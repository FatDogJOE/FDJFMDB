//
//  FDJDatabase.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJDatabase.h"
#import <FMDB.h>

@interface FDJDatabase()

@property (nonatomic, strong) NSString * dbPath;
@property (nonatomic, strong) FMDatabaseQueue * dbQueue;

@property (nonatomic, strong) FDJDatabaseConfig * config;

@end

@implementation FDJDatabase

+ (instancetype)db {
    static FDJDatabase * database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[self alloc] init];
    });
    return database;
}

+ (void)setupWithConfig:(FDJDatabaseConfig *)config {
    [[self db] switchConfig:config];
}

#pragma mark - Private Methods

- (void)switchConfig:(FDJDatabaseConfig *)config {
    self.config = config;
    self.dbPath = config.path;
    self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:self.dbPath];
}

#pragma mark - Public Methods

- (BOOL)executeUpdate:(NSString *)sql {
    __block BOOL success = NO;
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        success = [db executeUpdate:sql];
    }];
    return success;
}

- (BOOL)executeUpdates:(NSArray<NSString *> *)sqls {
    
    __block BOOL success = NO;
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        success = [db executeStatements:[sqls componentsJoinedByString:@";"]];
    }];
    return success;
}

- (NSArray *)executeQuery:(NSString *)sql map:(id(^)(NSDictionary * dbDic))map {
    
    __block NSMutableArray * result = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet * resultSet = [db executeQuery:sql];
        
        while ([resultSet next]) {
            id model = map([resultSet resultDictionary]);
            [result addObject:model];
        }
        
        [db close];
    }];
    
    return [result mutableCopy];
}

- (void)registerTables:(NSArray<Class<FDJDataModel>> *)modelClasses {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    [modelClasses enumerateObjectsUsingBlock:^(Class<FDJDataModel>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * sql = [[obj table] createSQL];
        [sqls addObject:sql];
    }];
    
    [self executeUpdates:sqls];
    
}

@end
