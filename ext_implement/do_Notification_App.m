//
//  do_Camera_App.m
//  DoExt_SM
//
//  Created by 刘吟 on 15/4/9.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Notification_App.h"
static do_Notification_App *instance;

@implementation do_Notification_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_Notification_App alloc]init];
    return instance;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation fromThridParty:(NSString*)_id
{
    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url fromThridParty:(NSString*)_id
{
    return NO;
}
@end
