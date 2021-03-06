//
//  do_Notification_SM.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Notification_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doJsonHelper.h"
#import "doIPage.h"
#import "doServiceContainer.h"
#import "doIGlobal.h"

@implementation do_Notification_SM
#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
 NSDictionary *_dictParas = [parms objectAtIndex:0];
 a.在节点中，获取对应的参数
 NSString *title = [doJsonHelper GetOneText: _dictParas :@"title" :@"" ];
 说明：第一个参数为对象名，第二为默认值
 
 2.脚本运行时的引擎
 id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
 
 同步：
 3.同步回调对象(有回调需要添加如下代码)
 doInvokeResult *_invokeResult = [parms objectAtIndex:2];
 回调信息
 如：（回调一个字符串信息）
 [_invokeResult SetResultText:((doUIModule *)_model).UniqueKey];
 异步：
 3.获取回调函数名(异步方法都有回调)
 NSString *_callbackName = [parms objectAtIndex:2];
 在合适的地方进行下面的代码，完成回调
 新建一个回调对象
 doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
 填入对应的信息
 如：（回调一个字符串）
 [_invokeResult SetResultText: @"异步方法完成"];
 [_scritEngine Callback:_callbackName :_invokeResult];
 */
//同步
//异步
- (void)alert:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    NSString *_callbackName = [parms objectAtIndex:2];
    
    NSString *_title = [doJsonHelper GetOneText: _dictParas :@"title" :@"" ];
    NSString *_text = [doJsonHelper GetOneText: _dictParas :@"text" :@"" ];
    NSString *buttontext = [doJsonHelper GetOneText:_dictParas :@"buttontext" :@"确定"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ALERT");
        doConfirmView *confirmView = [[doConfirmView alloc] initWithTitle:_title message:_text delegate:self cancelButtonTitle:nil otherButtonTitles:buttontext  callbackName:_callbackName scriptEngine:_scritEngine];
        [confirmView show];
    });
}
- (void)confirm:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    NSString *_callbackName = [parms objectAtIndex:2];
    
    NSString *_title = [doJsonHelper GetOneText: _dictParas :@"title" :@"" ];
    NSString *_text = [doJsonHelper GetOneText: _dictParas :@"text" :@"" ];
    NSString *_button1text = [doJsonHelper GetOneText: _dictParas :@"button1text" :@"" ];
    NSString *_button2text = [doJsonHelper GetOneText: _dictParas :@"button2text" :@"" ];
    
    if (0 == _button1text.length)
    {
        _button1text = @"确定";
    }
    if (0 == _button2text.length)
    {
        _button2text = @"取消";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        doConfirmView *confirmView = [[doConfirmView alloc]initWithTitle:_title message:_text delegate:self cancelButtonTitle:_button1text otherButtonTitles:_button2text  callbackName:_callbackName scriptEngine:_scritEngine];
        [confirmView show];
    });
    
}
- (void)toast:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    id<doIPage>pageModel = _scritEngine.CurrentPage;
    UIViewController *currentVC = (UIViewController *)pageModel.PageView;
    CGFloat xZoom =  _scritEngine.CurrentPage.RootView.XZoom;
    CGFloat yZoom = _scritEngine.CurrentPage.RootView.YZoom;
    NSString *_text = [doJsonHelper GetOneText: _dictParas :@"text" :@"" ];
    dispatch_async(dispatch_get_main_queue(), ^{
        int x = -1,y = -1;
        
        if ([_dictParas.allKeys containsObject:@"x"]) {
            x = [doJsonHelper GetOneInteger:_dictParas :@"x" :-1];
        }
        if ([_dictParas.allKeys containsObject:@"y"]) {
            y = [doJsonHelper GetOneInteger:_dictParas :@"y" :-1];
            
        }
        CGFloat screenWidth = [doServiceContainer Instance].Global.ScreenWidth;
        CGFloat screenHeight = [doServiceContainer Instance].Global.ScreenHeight;
        CGRect _frame = CGRectMake(0, 0, screenWidth, screenHeight);
        NSDictionary *_attributeDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        NSStringDrawingOptions _drawingOptions = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize _strsize = [_text boundingRectWithSize:CGSizeMake(_frame.size.width*0.75, CGFLOAT_MAX) options:_drawingOptions attributes:_attributeDict context:nil].size;
        UIView *_mainView = [[UIView alloc] initWithFrame:_frame];
        float _tostWidth = 200;

        if (x >=0 && x <= _frame.size.width/xZoom) {
            x = x * xZoom;
        }
        else
        {
            x = (_mainView.frame.size.width-(_tostWidth+20))/2;
        }

        if (y >= 0 && y <= _frame.size.height/yZoom) {
            y = y * yZoom;
        }
        else
        {
            y = (_mainView.frame.size.height-(_strsize.height+20)-40);
        }
        UIView *_showView = [[UIView alloc] initWithFrame:CGRectMake(x,y, _tostWidth+20, _strsize.height+20)];
        _showView.backgroundColor = [UIColor blackColor];
        _showView.layer.cornerRadius = 6;
        UILabel *_showLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, _showView.frame.size.width-20, _showView.frame.size.height-10)];
        _showLabel.font = [UIFont systemFontOfSize:15];
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.text = _text;
        _showLabel.numberOfLines = 0;
        _showLabel.textAlignment = 1;
        _showLabel.backgroundColor = [UIColor clearColor];
        [_showView addSubview:_showLabel];
        [currentVC.view addSubview:_showView];
        
        [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _showView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_showView removeFromSuperview];
        }];
    });
    
}

@end


@implementation doConfirmView
{
    int _clickIndex;
}
- (void)Dispose
{
    _myCallBackName = nil;
    _myScritEngine = nil;
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles callbackName  :(NSString *)_callbackName scriptEngine:(id<doIScriptEngine>)_scritEngine
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.myCallBackName = _callbackName;
    self.myScritEngine = _scritEngine;
    return self;
}

- (void)alertView:(doConfirmView *)confirmView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = 0;
    
    if (buttonIndex == confirmView.cancelButtonIndex)
    {
        index = 1;
    }
    else
    {
        index = 2;
    }
    _clickIndex = index;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self confirmViewCallBack:(doConfirmView *)alertView];
}

- (void)confirmViewCallBack:(doConfirmView *)confirmView
{
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
    [_invokeResult SetResultInteger:_clickIndex];
    [confirmView.myScritEngine Callback:confirmView.myCallBackName :_invokeResult];
    [confirmView Dispose];
}
@end
