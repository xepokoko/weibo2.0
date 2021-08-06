//
//  EPUser.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/18.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import "EPUser.h"

@implementation EPUser
- (instancetype)initWithDic: (NSDictionary*)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}


+ (instancetype)userWithDic: (NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (NSDictionary*)dicWithUser: (EPUser*)user
{
    NSMutableDictionary* mutDic = [[NSMutableDictionary alloc]init];
    [mutDic setValue:user.profile_image_url forKey:@"profile_image_url"];
    [mutDic setValue:user.screen_name forKey:@"screen_name"];
    
    return mutDic;
}




@end
