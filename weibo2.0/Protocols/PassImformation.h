//
//  PassImformation.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/23.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#ifndef PassImformation_h
#define PassImformation_h


#endif /* PassImformation_h */
#import "EPStatuses.h"
@protocol PassImformation <NSObject>

@optional

- (void)passUrlwith:(NSString*)str;

- (void)passStatus:(EPStatuses*)status;

- (void)passBtnClick:(NSIndexPath *)indexPath;


@end
