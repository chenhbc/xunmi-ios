//
//  SettingsViewController.m
//  xunmi
//
//  Created by LarryChen on 15/6/3.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "SettingsViewController.h"
#import "DonateViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  返回按钮触发的事件
 *
 *  @param sender 返回按钮
 */
- (void)backBarButtonPressed:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

//NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//
//NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//
//_lblAppVersion.text = [NSString stringWithFormat:@"v%@", app_Version];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self sendmail];
                    break;
                    
                case 1:
                    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"aboutViewController"] animated:YES];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"noticeViewController"] animated:YES];
                    break;
                    
                case 1:
                    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"donateViewController"] animated:YES];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendmail {
    // 1. 先判断能否发送邮件
    if (![MFMailComposeViewController canSendMail]) {NSLog(@"Can not send email.");
        // 提示用户设置邮箱
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您尚未设置邮箱客户端，您可以主动发送反馈意见到「chenhbc@gmail.com」，谢谢！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    // 2. 实例化邮件控制器，准备发送邮件
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    // 1) 主题 xxx的工作报告
    [controller setSubject:@"[寻觅]iOS客户端使用反馈"];
    // 2) 收件人
    [controller setToRecipients:@[@"chenhbc@gmail.com"]];

    // 7) 设置代理
    [controller setMailComposeDelegate:self];
    
    // 显示控制器
    [self presentViewController:controller animated:YES completion:nil];
}

//同样要记得发完邮件记得调用代理方法关闭窗口

#pragma mark - 邮件代理方法
/**
 MFMailComposeResultCancelled,      取消
 MFMailComposeResultSaved,          保存邮件
 MFMailComposeResultSent,           已经发送
 MFMailComposeResultFailed          发送失败
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
    NSLog(@"%d", result);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
