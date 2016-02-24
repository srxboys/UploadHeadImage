//
//  GHSUploadData.m
//  GHS
//
//  Created by readtv_smx on 16/1/29.
//  Copyright © 2016年 ghs.net. All rights reserved.
//

#import "GHSUploadData.h"
#define APP_UserHeadImgPath          @"APP_userHeadImgPNG.PNG" //头像图片地址名


GHSUploadData * _uploadData = nil;

//声明block
typedef void (^SuccessBlock)(UIImage * obj, BOOL sucess);

@interface GHSUploadData ()
{
    NSURLConnection *_connection;
    NSMutableData *_mutData;
    NSURLRequest * _request;
}

@property(copy,nonatomic)SuccessBlock sblock;
@end

@implementation GHSUploadData
-(id)init
{
    self=[super init];
    if (self) {
        _mutData=[[NSMutableData alloc]init];
    }
    return self;
}

+ (instancetype)shareGHSUploadData {
    static dispatch_once_t onecToken;
    dispatch_once(&onecToken, ^{
        _uploadData = [[GHSUploadData alloc] init];
    });
    return _uploadData;
}


//加载网络数据
-(void)loadURL:(NSString *)str
{
    //iOS7 会有请求缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURL *url=[NSURL URLWithString:str];
    _request=[[NSURLRequest alloc]initWithURL:url];
    _connection=[[NSURLConnection alloc]initWithRequest:_request delegate:self];
}


#pragma -mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp=(NSHTTPURLResponse *)response;
    NSLog(@"%li",(long)resp.statusCode);
    if(_mutData.length > 0) {
        _mutData.length = 0;
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    id obj=[NSJSONSerialization JSONObjectWithData:_mutData options:NSJSONReadingMutableContainers error:nil];
    //调用block
    if(_mutData.length > 0) {
        
        NSData * data = [NSData dataWithContentsOfFile:[[GHSUploadData documentDirectory] stringByAppendingPathComponent:APP_UserHeadImgPath]];
        if(![data isEqualToData:_mutData]) {
            [GHSUploadData writeData:_mutData toFile:APP_UserHeadImgPath];
        }
        
        dispatch_after(1, dispatch_get_main_queue(), ^{
            _sblock([UIImage imageWithData:_mutData],YES);
        });
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _sblock(nil,NO);
}


+ (UIImage *)uploadDataTempImgWithURL:(NSString *)urlString backBlock:(void (^)(UIImage *, BOOL))sblock {
    
    UIImage * image = [UIImage imageWithContentsOfFile:[self readerDataForName:urlString]];
    //请求换地址
    [[GHSUploadData shareGHSUploadData] loadURL:urlString];
    [GHSUploadData shareGHSUploadData].sblock = ^(UIImage * obj, BOOL sucess) {
        sblock(obj,sucess);
    };
    
    NSLog(@"地址=%@", [[self documentDirectory]stringByAppendingPathComponent:APP_UserHeadImgPath]);
    
    return image;
}

#pragma mark - ~~~~~~~~~~~ 缓存 二进制文件【图片】 ~~~~~~~~~~~~~~~
+ (NSString*)documentDirectory
{
    //for test
    //    static NSString *documentPath = @"/Users/majianglin/Desktop";
    
    static NSString *documentPath = nil;
    
    if (documentPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,   NSUserDomainMask, YES);
        documentPath = [paths objectAtIndex:0];
    }
    
    return documentPath;
}

+ (BOOL)writeData:(NSData *)data toFile:(NSString *)fileName {
    NSString * filePath = [[self documentDirectory] stringByAppendingPathComponent:fileName];
    BOOL isSucess = [data writeToFile:filePath atomically:YES];
    if(!isSucess) {
        // TTLog(@"TTCacheUtil.m writeData is fail");
        [self removeDataForName:filePath];
    }
    return isSucess;
}

+ (BOOL)removeDataForName:(NSString *)aName {
    NSString * filePath = [[self documentDirectory] stringByAppendingPathComponent:aName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]) {
        NSError * error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if(error) {
            // TTLog(@"TTCacheUtil.m removeDataForName is fail");
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSString *)readerDataForName:(NSString *)avaster{
    // TTLog(@"readerDataForName=%@", avaster);
    NSString * filePath = [[self documentDirectory] stringByAppendingPathComponent:APP_UserHeadImgPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]) {
        [self cacheHeadImgWithUrlString:avaster];
        return @"";
    }
    return filePath;
}


+ (void)DownLoadImgForHeadImg:(NSString *)avastString {
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(cacheHeadImgWithUrlString:) object:avastString];
    [thread start];
}

+ (void)cacheHeadImgWithUrlString:(NSString *)urlString {
    // TTLog(@"cacheHeadImgWithUrlString=%@", urlString);
    if(![urlString isKindOfClass:[NSNull class]] && urlString.length >0) {
        [[GHSUploadData shareGHSUploadData] loadURL:urlString];
    }
}


@end
