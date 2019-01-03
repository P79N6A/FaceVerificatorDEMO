//
//  NSObject+JsonHelper.m
//  FaceVerificatorDEMO
//
//  Created by Jason on 2019/1/3.
//  Copyright © 2019年 zhanghao. All rights reserved.
//

#import "NSObject+JsonHelper.h"
#import <objc/runtime.h>

@implementation NSObject (JsonHelper)

-(NSDictionary *)jsonValue {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *json = [NSMutableDictionary new];
    for (int i = 0 ; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        if (value ) {
            [json setValue:value forKey:key];
        } else {
            [json setValue:@"" forKey:key];
        }
    }
    return json;
}

@end
