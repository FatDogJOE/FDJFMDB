//
//  FDJQueryRule.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJQueryRule.h"

@implementation FDJQueryRule

- (NSString *)sql {
    
    NSMutableArray * sqls = [NSMutableArray array];
    
    if (self.limit > 0) {
        NSString * limitSql = FDJ_STR(@"LIMIT %@ OFFSET %@", @(self.limit), @(self.offset));
        
        [sqls addObject:limitSql];
    }
    
    if (self.orderColumes.count > 0) {
        NSString * orderSql = FDJ_STR(@"ORDER BY (%@) %@", [self.orderColumes componentsJoinedByString:@","], (self.orderRule == FDJOrderAsc ? @"ASC" : @"DESC"));
        
        [sqls addObject:orderSql];
    }

    if (sqls.count > 0) {
        return [sqls componentsJoinedByString:@" "];
    }else {
        return @"";
    }
    
}

@end
