//
//  FDJColume+ValueConvert.m
//  FDJFMDB_Example
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 likethephoenix@163.com. All rights reserved.
//

#import "FDJColume+ValueConvert.h"
#import "FDJDatabaseDefines.h"



@implementation FDJColume (ValueConvert)

- (NSString *)convertValue:(id)value {
    static NSDateFormatter * dateFomatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFomatter = [[NSDateFormatter alloc] init];
        dateFomatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFomatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    
    if (self.dataType == FDJDataTypeText) {
        
        if (value && [value isKindOfClass:NSString.class]) {
            return FDJ_STR(@"'%@'",value);
        }else {
            return @"''";
        }
        
    } else if (self.dataType == FDJDataTypeDate) {
        
        if (value && [value isKindOfClass:NSDate.class]) {
            NSDate * dateValue = (NSDate *)value;
            return FDJ_STR(@"'%@'", [dateFomatter stringFromDate:dateValue]);
        }else {
            NSDate * dateValue = [NSDate dateWithTimeIntervalSince1970:0];
            return FDJ_STR(@"'%@'", [dateFomatter stringFromDate:dateValue]);
        }
        
    } else {
        
        if ([value isKindOfClass:NSNumber.class]) {
            return FDJ_STR(@"%@",value);
        }else {
            return @"0";
        }
        
    }
    
    
}

@end
