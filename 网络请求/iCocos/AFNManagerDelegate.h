//
//  AFNManagerDelegate.h
//  网络请求
//
//  Created by caolipeng on 15/12/10.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFNManager;

@protocol AFNManagerDelegate <NSObject>

@optional


/**
 *  发送请求成功
 *
 *  @param manager AFNManager
 */
-(void)AFNManagerDidSuccess:(id)data;


/**
 *  发送请求失败
 *
 *  @param manager AFNManager
 */
-(void)AFNManagerDidFaild:(NSError *)error;


@end