//
//  EPPicture.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/18.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import "EPPicture.h"

@implementation EPPicture

- (instancetype)initWithDic: (NSDictionary*)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return  self;
}
+ (instancetype)pictureWithDic: (NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}

//防止模型属性不足，程序崩溃的方法，用来跳过没有对应属性的key。
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@",key);
}
@end
