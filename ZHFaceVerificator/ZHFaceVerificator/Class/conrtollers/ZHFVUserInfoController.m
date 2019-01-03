//
//  ZHFVUserInfoController.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVUserInfoController.h"
#import <CoreServices/CoreServices.h>
#import "ZHFVNetworkManager.h"
#import "ZHFVManager.h"

@interface ZHFVUserInfoController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *userHeaderButton;

@property (nonatomic, strong) UITextField *userNickTextField;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIButton *confirmButton;




@end

@implementation ZHFVUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self loadSubViews];
}

- (void)loadSubViews
{
    [self.view addSubview:self.userHeaderButton];
    [self.view addSubview:self.userNickTextField];
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(30, self.userNickTextField.stBottom, AILScreenWidth - 60, 0.5)];
    sep.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:sep];
    [self.view addSubview:self.confirmButton];
}



-(void)chooseImage:(UIButton *)sender{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];;
    [action showInView:self.view];
}

- (void)confirm:(UIButton *)sender{
    [self showIndicatorView];
    DECLARE_WEAK_SELF;
    [ZHFVNetworkManager finishRegist:self.frontRes.idCardId name:self.frontRes.idCardName cloudDataID:self.fvID token:self.userModel.access_token image:UIImagePNGRepresentation(self.imageData) progress:^(NSProgress * _Nonnull progress) {
        
    } ssuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf dismissIndicatorView];
        if([[responseObject objectForKey:@"status"] boolValue]==YES){
            [[[UIAlertView alloc] initWithTitle:@"是否立即登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即登录", nil] show];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [weakSelf dismissIndicatorView];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (![title isEqualToString:@"取消"]) {
        [[ZHFVManager shareInstance] performSelector:@selector(loginWithData:) withObject:UIImagePNGRepresentation(self.imageData)];
    }
}

- (void)uploadimage{
    NSData *data =UIImagePNGRepresentation(self.selectedImage);
    [ZHFVNetworkManager requestPostUserHeader:data userID:self.userModel.identity token:self.userModel.access_token progress:^(NSProgress * _Nonnull progress) {
        
    } ssuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"图片上传：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - getter

-(UIButton *)userHeaderButton{
    if (!_userHeaderButton) {
        _userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userHeaderButton setImage:[UIImage imageWithContentsOfFile:[FrameworkBundle pathForResource:@"userHead@2x" ofType:@"png"]] forState:UIControlStateNormal];
        _userHeaderButton.frame = CGRectMake(0, 0, 88, 88);
        [_userHeaderButton setStCenterX:AILScreenWidth/2];
        [_userHeaderButton setStTop:AILStatusBarHeight+AILNavigationBarHeight+66];
        [_userHeaderButton addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        _userHeaderButton.layer.cornerRadius = 44;
        _userHeaderButton.layer.masksToBounds = YES;
    }
    return _userHeaderButton;
}

-(UITextField *)userNickTextField{
    if (!_userNickTextField) {
        _userNickTextField = [UITextField new];
        _userNickTextField.delegate = self;
        _userNickTextField.returnKeyType = UIReturnKeyDone;
        _userNickTextField.placeholder = @"请输入昵称";
        _userNickTextField.frame = CGRectMake(0, self.userHeaderButton.stBottom+30, AILScreenWidth, 40);
        _userNickTextField.textAlignment = NSTextAlignmentCenter;
        _userNickTextField.borderStyle = UITextBorderStyleNone;
    }
    return _userNickTextField;
}

-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:UIColorFromRGB(0x6396ea)];
        _confirmButton.frame = CGRectMake(30, self.userNickTextField.stBottom+66, AILScreenWidth - 60, 45);
        [_confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 6;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}


#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [ZHFVNetworkManager requestPostUserNick:textField.text userID:self.userModel.identity token:self.userModel.access_token progress:^(NSProgress * _Nonnull progress) {
        
    } ssuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"设置昵称%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 选择图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"拍照"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            UIImagePickerController* ctl = [[UIImagePickerController alloc]init];
            // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
            ctl.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置拍摄照片
            ctl.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            // 设置使用手机的后置摄像头（默认使用后置摄像头）
            ctl.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            // 设置拍摄的照片允许编辑
            ctl.allowsEditing = YES;
            //设置代理
            ctl.delegate = self;
            //显示视图控制器
            [self presentViewController:ctl animated:YES completion:nil];
            
        }
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"相册"]){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController* ctl = [[UIImagePickerController alloc]init];
            // 设置选择载相册的图片或视频
            ctl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //是否允许编辑
            ctl.allowsEditing = YES;
            //设置代理
            ctl.delegate = self;
            //显示视图控制器
            [self presentViewController:ctl animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info);
    //从info取出此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    DECLARE_WEAK_SELF;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取照片的原图
        //UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //获取图片裁剪的图
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* edit = [self scaleImage:image Percent:0.8];
        self.selectedImage = edit;
        [self.userHeaderButton setImage:edit forState:UIControlStateNormal];
        [self uploadimage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [weakSelf setNeedsStatusBarAppearanceUpdate];
            
        }];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DECLARE_WEAK_SELF;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [weakSelf setNeedsStatusBarAppearanceUpdate];
            
        }];
        
    }];
}

- (UIImage *)scaleImage:(UIImage *)image Percent:(CGFloat)percent{
    NSData *data =UIImageJPEGRepresentation(image, percent);
    if (data) {
        return [UIImage imageWithData:data];
    }
    return image;
}

@end
