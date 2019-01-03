//
//  ZHFVIDCardController.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVIDCardController.h"
#import "STIdCardScanner.h"
#import "ZHFVNetworkManager.h"
#import "ZHFVUserInfoController.h"

@interface ZHFVIDCardController ()<STIdCardScannerDelegate, STCardScannerControllerDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UILabel *tipsLabel;
@property (nonatomic, strong)UIImageView *frontImageView;
@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong)UIView *resultView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *numLabel;
@property (nonatomic, strong)UILabel *nameResLabel;
@property (nonatomic, strong)UILabel *numResLabel;

@property (nonatomic, strong)UIButton *confirmButton;



@property (nonatomic, strong)STIdCard *frontRes;
@property (nonatomic, strong)STIdCard *backRes;

@end

@implementation ZHFVIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self creatSubviews];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(nextStep)];;
}

- (void)creatSubviews{
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tipsLabel];
    [self.scrollView addSubview:self.frontImageView];
    [self.scrollView addSubview:self.backImageView];
    [self.scrollView addSubview:self.resultView];
    [self.resultView addSubview: self.nameLabel];
    [self.resultView addSubview:self.nameResLabel];
    [self.resultView addSubview:self.numResLabel];
    [self.resultView addSubview:self.numLabel];
    [self.scrollView addSubview:self.confirmButton];
    self.scrollView.contentSize = CGSizeMake(0  , self.confirmButton.stBottom+30);
}


#pragma mark - 跳到下个界面
- (void)nextStep{
    ZHFVUserInfoController *con = [ZHFVUserInfoController new];
    con.userModel = self.userModel;
    con.frontRes = self.frontRes;
    con.fvID = self.fvID;
    con.imageData = self.imageData;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - 确定
- (void)confirm:(UIButton *)sender{
    if (self.frontRes && self.backRes) {
        DECLARE_WEAK_SELF;
        [self showIndicatorView];
        [ZHFVNetworkManager requestPostIDCard:self.frontRes backIDCard:self.backRes userInfo:self.userModel?self.userModel.identity:@"test" token:self.userModel.access_token progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            [weakSelf dismissIndicatorView];
            if([[responseObject objectForKey:@"status"] boolValue]==1){
                [weakSelf nextStep];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [weakSelf dismissIndicatorView];
        }];
    }
}


#pragma mark - 扫描
- (void)scanFront:(UITapGestureRecognizer *)tap{
    STIdCardScanner *controller = [[STIdCardScanner alloc]initWithOrientation:AVCaptureVideoOrientationPortrait apiKey:ZH_FV_API_KEY apiSecret:ZH_FV_API_SECRET delegate:self];
    [controller setTitle:@"扫描身份证"];
    [controller.idCardRecognizer setTimeoutSeconds:180];
    [controller.idCardRecognizer setImageMaxLossPrecentage:5];
    [controller.idCardRecognizer setScanMode:STIdCardScanSingle
                                    scanSide:STIdCardScanFrontal
                         recognizeItemOption:STIdCardFrontALL];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scanBack:(UITapGestureRecognizer *)tap{
    STIdCardScanner *controller = [[STIdCardScanner alloc]initWithOrientation:AVCaptureVideoOrientationPortrait apiKey:ZH_FV_API_KEY apiSecret:ZH_FV_API_SECRET delegate:self];
    [controller setTitle:@"扫描身份证"];
    [controller.idCardRecognizer setTimeoutSeconds:180];
    [controller.idCardRecognizer setImageMaxLossPrecentage:5];
    [controller.idCardRecognizer setScanMode:STIdCardScanSingle
                                    scanSide:STIdCardScanBack
                         recognizeItemOption:STIdCardBackALL];
    
    [self.navigationController pushViewController:controller animated:YES];
}




#pragma mark - 扫描结果
- (void)receivedIdCardResult:(STIdCard *)idCard requestId:(NSString *)requestId{
    NSLog(@"%@",idCard.idCardName);
    [self.navigationController popToViewController:self animated:YES];
    if (idCard.cardSide == STIdCardSideFront) {
        self.nameResLabel.text = idCard.idCardName;
        self.numResLabel.text = idCard.idCardId;
        self.frontImageView.image = idCard.idCardFrontImage;
        self.frontRes = idCard;
    }else{
        self.backImageView.image = idCard.idCardBackImage;
        self.backRes = idCard;
    }
}

- (void)receivedIdCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId{
    NSLog(@"%ld",(long)errorCode);
}


#pragma mark -  getter

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = UIColorFromRGB(0xefefef);
        _scrollView.frame = CGRectMake(0,AILStatusBarHeight+AILNavigationBarHeight, AILScreenWidth, AILScreenHeight-AILStatusBarHeight-AILNavigationBarHeight);
        _scrollView.showsVerticalScrollIndicator = _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.font = [UIFont systemFontOfSize:18];
        _tipsLabel.text = @"上传身份证正/反面";
        _tipsLabel.frame = CGRectMake(30, 20, 200, 25);
    }
    return _tipsLabel;
}

-(UIImageView *)frontImageView{
    if (!_frontImageView) {
        _frontImageView = [UIImageView new];
        _frontImageView.frame = CGRectMake(30, self.tipsLabel.stBottom+20, AILScreenWidth-60, (AILScreenWidth-60)*4/7);
        _frontImageView.image = [UIImage imageWithContentsOfFile:[FrameworkBundle pathForResource:@"frontImage@2x" ofType:@"png"]];
        _frontImageView.userInteractionEnabled = YES;
        [_frontImageView addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanFront:)]];
    }
    return _frontImageView;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.frame = CGRectMake(30, self.frontImageView.stBottom+20, AILScreenWidth-60, (AILScreenWidth-60)*4/7);
        _backImageView.image = [UIImage imageWithContentsOfFile:[FrameworkBundle pathForResource:@"backImage@2x" ofType:@"png"]];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanBack:)]];
    }
    return _backImageView;
}

-(UIView *)resultView{
    if (!_resultView) {
        _resultView = [UIView new];
        _resultView.backgroundColor = UIColorFromRGB(0xffffff);
        _resultView.frame = CGRectMake(0, self.backImageView.stBottom+15, AILScreenWidth, 90);
        UIView *sep = [UIView new];
        sep.backgroundColor = UIColorFromRGB(0xcccccc);
        sep.frame = CGRectMake(30, 45, AILScreenWidth-60, 0.5);
        [_resultView addSubview:sep];
    }
    return _resultView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.frame = CGRectMake(30, 11, 40, 22);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.text = @"姓名";
    }
    return _nameLabel;
}

-(UILabel *)nameResLabel{
    if (!_nameResLabel) {
        _nameResLabel = [UILabel new];
        _nameResLabel.frame = CGRectMake(self.nameLabel.stRight, 11, AILScreenWidth - self.nameLabel.stRight- 30, 22);
        _nameResLabel.font = [UIFont systemFontOfSize:16];
        _nameResLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameResLabel;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.frame = CGRectMake(30, self.nameLabel.stBottom+23, 120, 22);
        _numLabel.font = [UIFont systemFontOfSize:16];
        _numLabel.text = @"姓名";
    }
    return _numLabel;
}

-(UILabel *)numResLabel{
    if (!_numResLabel) {
        _numResLabel = [UILabel new];
        _numResLabel.frame = CGRectMake(self.numLabel.stRight, self.nameLabel.stBottom+23, AILScreenWidth - self.numLabel.stRight- 30, 22);
        _numResLabel.font = [UIFont systemFontOfSize:16];
        _numResLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numResLabel;
}

-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(30, self.resultView.stBottom+35, AILScreenWidth-60, 45);
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = UIColorFromRGB(0x6396ea);
        [_confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}



@end
