//
//  do_Notification_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Notification_App.h"
static do_Notification_App* instance;
@implementation do_Notification_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_Notification_App alloc]init];
    return instance;
}
@end
