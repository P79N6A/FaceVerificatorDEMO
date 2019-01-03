//
//  STScanEnumHeader.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/10.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#ifndef STScanEnumHeader_h
#define STScanEnumHeader_h

typedef NS_ENUM(NSInteger, STIdCardScanSide) {
    /**< 身份证正面 */
    STIdCardScanFrontal = 1,
    /**< 身份证背面 */
    STIdCardScanBack = 2,
    /**< 自动识别正反面 */
    STIdCardScanAuto = 3,
};

typedef NS_ENUM(NSInteger, STIdCardScanMode) {
    /** 单面扫描 */
    STIdCardScanSingle = 1,
    /** 双面扫描 */
    STIdCardScanDouble = 2,
};

typedef NS_ENUM(NSInteger, STIdCardSide) {
    /** 身份证正面 */
    STIdCardSideFront = 1,
    /** 身份证背面 */
    STIdCardSideBack = 2,
};

typedef NS_ENUM(NSInteger, STIdCardType) {
    /** 未知 */
    STIdCardTypeUnknow = 0,
    /** 正常身份证 */
    STIdCardTypeNormal
};

typedef NS_ENUM(NSInteger, STCardClassify) {
    /** 正常拍摄 */
    STCardClassifyNormal = 0,
    /** 复印件 */
    STCardClassifyPhotoCopy = 1,
    /** PS */
    STCardClassifyPS = 2,
    /** 屏幕翻拍 */
    STCardClassifyReversion = 3,
    /** 其他 */
    STCardClassifyOther = 4,
    /** 未知 */
    STCardClassifyUnknow = 5,
};

typedef NS_OPTIONS(uint32_t, STIdCardItemOption) {
    /** 姓名 */
    STIdCardItemName = 1 << 0,
    /** 性别 */
    STIdCardItemGender = 1 << 1,
    /** 民族 */
    STIdCardItemNation = 1 << 2,
    /** 生日 */
    STIdCardItemBirthday = 1 << 3,
    /** 地址  */
    STIdCardItemAddr = 1 << 4,
    /** 身份证号 */
    STIdCardItemNum = 1 << 5,
    /** 签发机关 */
    STIdCardItemAuthority = 1 << 6,
    /** 有效期限 */
    STIdCardItemTimelimit = 1 << 7,
    /** 全部正面字段 */
    STIdCardFrontALL = STIdCardItemName | STIdCardItemGender | STIdCardItemNation | STIdCardItemBirthday |
        STIdCardItemAddr | STIdCardItemNum,
    /** 全部反面字段 */
    STIdCardBackALL = STIdCardItemAuthority | STIdCardItemTimelimit,
    /** 全部包括 */
    STIdCardItemAll = STIdCardFrontALL | STIdCardBackALL,

};
#endif /* STScanEnumHeader_h */
