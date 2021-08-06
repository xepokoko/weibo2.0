//
//  EPStatuses.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/17.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import "EPStatuses.h"

#import "NSDate+WeiboTime.h"

@implementation EPStatuses
//字典转模型的方法
- (instancetype)initWithDic: (NSDictionary*)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
        if (self.created_atNumber==nil)
        {
        self.created_atNumber = dic[@"created_at"];
        }
    }
    
    return  self;
}
+ (instancetype)statusWithDic: (NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}

//防止模型属性不足，程序崩溃的方法，用来跳过没有对应属性的key。
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@",key);
}

#pragma mark - 模型转字典
+ (NSDictionary*)dicWithModel:(EPStatuses*)status
{
    NSNumber* number1 = [NSNumber numberWithUnsignedInteger:status.attitudes_count];
    NSNumber* number2 = [NSNumber numberWithUnsignedInteger:status.comments_count];
    NSNumber* number3 = [NSNumber numberWithUnsignedInteger:status.reposts_count];
    
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc]init];
    [tempDic setValue:number1 forKey:@"attitudes_count"];
    [tempDic setValue:number2 forKey:@"comments_count"];
    [tempDic setValue:number3 forKey:@"reposts_count"];
    [tempDic setValue:status.text forKey:@"text"];
    [tempDic setValue:status.created_atNumber forKey:@"created_atNumber"];//原版创建时间
    [tempDic setValue:status.retweeted_status forKey:@"retweeted_status"];//转发的
    [tempDic setValue:status.original_pic forKey:@"original_pic"];
    [tempDic setValue:status.collectionCount forKey:@"collectionCount"];
    [tempDic setValue:[EPUser dicWithUser:status.users] forKey:@"user"];
//    [tempDic setValue:status.retweeted_status forKey:@"retweeted_status"];
    [tempDic setValue:status.pic_urls forKey:@"pic_urls"];//多图字典数组
    
    NSDictionary* dic = tempDic;
    return dic;
}






#pragma mark - 日期getter方法的重写
//重写getter方法
- (NSString *)created_at
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];//设置时区偏移量
    
   
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}




@end
