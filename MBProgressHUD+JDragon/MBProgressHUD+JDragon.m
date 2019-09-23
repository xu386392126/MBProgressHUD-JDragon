//
//  MBProgressHUD+JDragon.m
//  JDragonHUD
//
//  Created by JDragon on 2017/1/17.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import "MBProgressHUD+JDragon.h"

@implementation MBProgressHUD (JDragon)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow
{
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self findCurrentShowingViewController].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText=message?message:@"加载中.....";
    hud.labelFont=[UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    return hud;
}
#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message
{
    [self showTipMessage:message isWindow:true timer:2];
}
+ (void)showTipMessageInView:(NSString*)message
{
    [self showTipMessage:message isWindow:false timer:2];
}
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer
{
    [self showTipMessage:message isWindow:true timer:aTimer];
}
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer
{
    [self showTipMessage:message isWindow:false timer:aTimer];
}
+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:aTimer];
}
#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityMessageInWindow:(NSString*)message
{
    [self showActivityMessage:message isWindow:true timer:0];
}
+ (void)showActivityMessageInView:(NSString*)message
{
    [self showActivityMessage:message isWindow:false timer:0];
}
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer
{
    [self showActivityMessage:message isWindow:true timer:aTimer];
}
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer
{
    [self showActivityMessage:message isWindow:false timer:aTimer];
}
+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (aTimer>0) {
        [hud hide:YES afterDelay:aTimer];
    }
}
#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+JDragon.bundle/MBProgressHUD/MBHUD_Success";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showErrorMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+JDragon.bundle/MBProgressHUD/MBHUD_Error";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showInfoMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+JDragon.bundle/MBProgressHUD/MBHUD_Info";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showWarnMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+JDragon.bundle/MBProgressHUD/MBHUD_Warn";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIcon:iconName message:message isWindow:true];
    
}
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIcon:iconName message:message isWindow:false];
}
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:2];
    
}
+ (void)hideHUD
{
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideAllHUDsForView:winView animated:YES];
    [self hideAllHUDsForView:[self findCurrentShowingViewController].view animated:YES];
}
#pragma mark --- 获取当前Window试图---------
#pragma mark - FindCurrentShowingViewController
/* 完整的描述请参见文件头部 */
+ (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
/* 完整的描述请参见文件头部 */
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;
    
    /*
    //方法2：遍历方法
    while (1)
    {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            
        //} else if (vc.childViewControllers.count > 0) {
        //    //如果是普通控制器，找childViewControllers最后一个
        //    vc = [vc.childViewControllers lastObject];
        } else {
            break;
        }
    }
    return vc;
    //*/
}


#pragma mark - FindBelongViewControllerForView
+ (nullable UIViewController *)findBelongViewControllerForView:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

////通过view找到拥有这个View的Controller
//+ (UIViewController *)findBelongViewControllerForView:(UIView *)view
//{
//    for (UIView *next = [view superview]; next; next = next.superview) {
//        UIResponder *nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)nextResponder;
//        }
//    }
//    return nil;
//}







////获取当前屏幕显示的viewcontroller
//+(UIViewController*)getCurrentWindowVC
//{
//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
//    if (window.windowLevel != UIWindowLevelNormal) {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows) {
//            if (tmpWin.windowLevel == UIWindowLevelNormal) {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    id nextResponder = nil;
//    UIViewController *appRootVC = window.rootViewController;
//    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
//    if (appRootVC.presentedViewController) {
//        nextResponder = appRootVC.presentedViewController;
//    }else{
//        //2、通过navigationcontroller弹出VC
//        //        NSLog(@"subviews == %@",[window subviews]);
//        UIView *frontView = [[window subviews] objectAtIndex:0];
//        nextResponder = [frontView nextResponder];
//    }
//    return nextResponder;
//}
//
//+(UINavigationController*)getCurrentNaVC
//{
//    
//    UIViewController  *viewVC = (UIViewController*)[ self getCurrentWindowVC ];
//    UINavigationController  *naVC;
//    if ([viewVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController  *tabbar = (UITabBarController*)viewVC;
//        naVC = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
//        if (naVC.presentedViewController) {
//            while (naVC.presentedViewController) {
//                naVC = (UINavigationController*)naVC.presentedViewController;
//            }
//        }
//    }else
//        if ([viewVC isKindOfClass:[UINavigationController class]]) {
//            
//            naVC  = (UINavigationController*)viewVC;
//            if (naVC.presentedViewController) {
//                while (naVC.presentedViewController) {
//                    naVC = (UINavigationController*)naVC.presentedViewController;
//                }
//            }
//        }else
//            if ([viewVC isKindOfClass:[UIViewController class]])
//            {
//                if (viewVC.navigationController) {
//                    return viewVC.navigationController;
//                }
//                return  (UINavigationController*)viewVC;
//            }
//    return naVC;
//}
//
//+(UIViewController*)getCurrentUIVC
//{
//    UIViewController   *cc;
//    UINavigationController  *na = (UINavigationController*)[[self class] getCurrentNaVC];
//    if ([na isKindOfClass:[UINavigationController class]]) {
//        cc =  na.viewControllers.lastObject;
//        
//        if (cc.childViewControllers.count>0) {
//            
//            cc = [[self class] getSubUIVCWithVC:cc];
//        }
//    }else
//    {
//        cc = (UIViewController*)na;
//    }
//    return cc;
//}
//+(UIViewController *)getSubUIVCWithVC:(UIViewController*)vc
//{
//    UIViewController   *cc;
//    cc =  vc.childViewControllers.lastObject;
//    if (cc.childViewControllers>0) {
//        
//        [[self class] getSubUIVCWithVC:cc];
//    }else
//    {
//        return cc;
//    }
//    return cc;
//}

@end
