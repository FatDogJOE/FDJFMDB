//
//  FDJColume.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJColume.h"

NSString * _Nonnull const ColumeConstraintNotNull = @"NOT NULL";
NSString * _Nonnull const ColumeConstraintDefault = @"DEFAULT";
NSString * _Nonnull const ColumeConstraintUnique = @"UNIQUE";
NSString * _Nonnull const ColumeConstraintPrimaryKey = @"PRIMARY KEY";
NSString * _Nonnull const ColumeConstraintCheck = @"CHECK";

@interface FDJColume()

@end

@implementation FDJColume

- (NSString *)sql {
    if (self.constraints.count > 0) {
        
        NSString * constrantsSQL = [[self.constraints allObjects] componentsJoinedByString:@" "];
        
        return FDJ_STR(@"%@ %@ %@", self.name, [self dataTypeString],constrantsSQL);
    }else {
        return FDJ_STR(@"%@ %@", self.name, [self dataTypeString]);
    }
}

+ (instancetype)columeWithName:(NSString *)name constraints:(NSSet<NSString *> *)constraints dataType:(FDJDataType)dataType {
    return [[self alloc] initWithName:name constraints:constraints dataType:dataType];
}

+ (instancetype)columeWithName:(NSString *)name constraintsArr:(NSArray<NSString *> *)constraints dataType:(FDJDataType)dataType {
    return [[self alloc] initWithName:name constraints:[NSSet setWithArray:constraints] dataType:dataType];
}

- (instancetype)initWithName:(NSString *)name constraints:(NSSet<NSString *> *)constraints dataType:(FDJDataType)dataType {
    self = [super init];
    if (self) {
        self.name = name;
        self.constraints = constraints;
        self.dataType = dataType;
    }
    return self;
}

#pragma mark - Public Methods

- (NSString *)dataTypeString {
    switch (self.dataType) {
        case FDJDataTypeText:
            return @"TEXT";
        case FDJDataTypeInteger:
            return @"INTEGER";
        case FDJDataTypeDate:
            return @"DATE";
        case FDJDataTypeNumeric:
            return @"NUMBERIC";
        case FDJDataTypeReal:
            return @"REAL";
        default:
            return @"TEXT";
    }
}

- (BOOL)haveConstraint:(NSString *)constraint {
    return [self.constraints containsObject:constraint];
}

@end
