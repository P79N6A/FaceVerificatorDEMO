#  集成注意事项

## info.plist
1，info.plist需要添加 Privacy - Camera Usage Description 相机权限
2，info.plist需要添加 App Transport Security Settings -----Allow Arbitrary Loads：YES
3，info.plist需要添加 Privacy - Location When In Use Usage Description   定位权限

## copy bundle
1，主工程的copy bundle需要添加 ZHFaceVerificator.framework ，不然会出现资源找不到，数据模型出错crash

## 系统动态库依赖
1，SystemConfiguration.framework
2，libresolv.tbd
3，CoreTelephony.framework
4，libc++.tbd
5，CoreLocation.framework
6，CoreTelephony.framework

## build setting 
1，关闭bitcode
2，最低支持iOS8
3，other link flags 添加 -all_load

## 三方库可能导致的冲突
1，本framework中集成了AFNetwork
2，本framework中集成了阿里云oss


