//
//  NSData+AES.h
//  Smile
//
//  Created by 周 敏 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@class NSString;


@interface  NSData (NSData_MD5)
- (NSString*) dataMd5;
@end



@interface NSData (NSDataAES)


- (NSString *) hexRepresentationWithSpaces_AS:(BOOL)spaces;

/* 这个函数 */
//- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密

- (NSData *)aesEncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

//加密
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

//解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

//解密  options 可以选择模式
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv options:(CCOptions) options;

//解密  可以选择模式
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv options:(CCOptions) options;

- (NSData *) ungzipData ;

- (NSData *) gzipData ;

//转16进制字符串
- (NSString *)convertDataToHexStr;

@end
