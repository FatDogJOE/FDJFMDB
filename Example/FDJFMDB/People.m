//
//  People.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "People.h"

@implementation People

+ (NSArray *)columes {
    return @[
        fdj_colume(@"name", @[ColumeConstraintPrimaryKey], FDJDataTypeText),
        fdj_colume(@"age", nil, FDJDataTypeInteger),
        fdj_colume(@"male", nil, FDJDataTypeNumeric),
        fdj_colume(@"money", nil, FDJDataTypeReal),
        fdj_colume(@"date", nil, FDJDataTypeDate)
    ];
}

+ (NSString *)tableName {
    return @"People";
}

@end
