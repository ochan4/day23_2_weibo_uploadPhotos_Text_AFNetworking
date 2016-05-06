//
//  Account.h
//  达内微博
//
//  Created by tarena on 16/5/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

//用户属性：
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *uid;

//单例：
+(Account *)shareAccount;

//登出：
-(void)logout;

@end
