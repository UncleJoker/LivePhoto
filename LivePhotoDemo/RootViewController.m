//
//  RootViewController.m
//  LivePhoto
//
//  Created by shenzhenshihua on 2018/5/23.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "PhotoLibrary.h"
#import "UploadVideoTool.h"

@interface RootViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *getVideo;

@property (weak, nonatomic) IBOutlet UIButton *makeVideo;

@property(nonatomic,copy)NSString *path;

@property(nonatomic,strong)UploadVideoTool *actionTool;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.makeVideo.hidden = YES;
}

- (IBAction)action:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            {
                // 获取或者录制视频 返回视频路径
                [self.actionTool chooseMultimediaWihtType:MultimediaTypeForVideo chooseVideoDone:^(NSString *videoPath) {
                    
                    /*
                     录制或者选择后
                     1.通过网络上传工具根据视频路径进行上传
                     2.传给制作壁纸工具，制作动态壁纸
                     3.保存视频到本地
                     */
                    NSLog(@"videoPath = %@",videoPath);
                    
                    // 获取视频路径并传给下一个界面
                    ViewController * VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                    VC.originVideoPath = videoPath;
                    [self.navigationController pushViewController:VC animated:YES];
                    
                } chooseImageDone:nil];
            }
            break;
        case 1:
            {
                // 相册选择
                [self handleChoosePhoto];
            }
            break;
        default:
            break;
    }
}


/// 相册选择视频
- (void)handleChoosePhoto {
    if ([PhotoLibrary photoLibraryIsAuth]) {
        //已授权
        [[PhotoLibrary sharePhotoLibrary] chooseVideoFromPhotoLibraryResult:^(NSURL *path, BOOL success) {
            if (success) {
                //选择成功
                [self handlePath:path];
            }
        }];
    } else {
        UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"App需要访问你的相册才能将数据写入相册，现在去设置开启权限。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"不写入了" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"现在去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
            }
        }];
        [alertCon addAction:cancel];
        [alertCon addAction:action];
        [self.navigationController presentViewController:alertCon animated:YES completion:nil];
    }
}

//处理share Extension 传递过来的数据
- (void)handleShareExtensionWithPath:(NSString *)groupPath {
    NSFileManager * manger = [NSFileManager defaultManager];
    NSURL * group_url = [manger containerURLForSecurityApplicationGroupIdentifier:@"group.com.livephoto"];
    NSURL *fileUrl = [group_url URLByAppendingPathComponent:groupPath];
    [self handlePath:fileUrl];
}

- (void)handlePath:(NSURL *)path
{
    NSString * lastPading = [[[path absoluteString] componentsSeparatedByString:@"/"] lastObject];
    NSString * originPath = [self getFilePathWithKey:lastPading];
    //保存在document 下
    [[NSFileManager defaultManager] copyItemAtURL:path toURL:[NSURL fileURLWithPath:originPath] error:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    ViewController * VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    VC.originVideoPath = originPath;
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 获取沙盒路径
 
 @param key eg. im.jpg vo.mov
 @return 返回路径
 */
- (NSString *)getFilePathWithKey:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths.firstObject;
    return [documentDirectory stringByAppendingPathComponent:key];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UploadVideoTool *)actionTool
{
    if (!_actionTool) {
        _actionTool = [[UploadVideoTool alloc]init];
    }
    return _actionTool;
}


@end
