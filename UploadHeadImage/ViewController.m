//
//  ViewController.m
//  UploadHeadImage
//
//  Created by readtv_smx on 16/2/24.
//  Copyright © 2016年 srxboys. All rights reserved.
//

//这两个是为了效果而定
#define path @"http://img3.redocn.com/tupian/20141121/jinpaiBBya_3482685.jpg"
#define path2 @"http://img3.redocn.com/20111011/Redocn_2011092710325280.jpg"

//这个是项目中我的头像地址，永久就一个，，，但是图片内容是变得
#define Url @"http://........    .png"

#import "ViewController.h"

#import "GHSUploadData.h"

@interface ViewController ()
{
    BOOL isShow;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imgView.image = [GHSUploadData uploadDataTempImgWithURL:path backBlock:^(UIImage *obj, BOOL sucess) {
        //刷新下载成功 -- 回调的block
        if(sucess) {
            _imgView.image = obj;
        }
    }];
    
    _imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [_imgView addGestureRecognizer:tap];
}

//点击刷新 头像【在项目里是 跳转到该界面 cell会刷新--视情况而定刷新】
- (void)click {
    ////////////////--由于地址不变，这里是为了效果，才写了两个地址，--////////////////
    ////////////////---但是我的项目，头像地址是永久不变的，图片内容是变的--////////////////
    isShow = !isShow;
    NSString * urlString = isShow ? path : path2;
    ////////////////-----////////////////
    _imgView.image = [GHSUploadData uploadDataTempImgWithURL:urlString backBlock:^(UIImage *obj, BOOL sucess) {
        //刷新下载成功
        if(sucess) {
            _imgView.image = obj;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
