//
//  GHSUploadData.h
//  GHS
//
//  Created by readtv_smx on 16/1/29.
//  Copyright © 2016年 ghs.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface GHSUploadData : NSObject<NSURLConnectionDataDelegate>

/**
 * @author ----------, 16-01-29 15:01:56
 *
 * @brief 实时更改头像，没有网络就用本地的，有网络，先用本地显示再用刚下载下来的图片显示
 *
 * @param urlString 头像网址
 * @param sblock    下载后的回调
 *
 * @return 本地图片的返回
 */
+ (UIImage *)uploadDataTempImgWithURL:(NSString *)urlString backBlock:(void (^)(UIImage * obj, BOOL sucess))sblock;

@end
