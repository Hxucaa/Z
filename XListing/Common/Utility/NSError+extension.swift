//
//  NSError+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

/// All domains of NSError in the app
private let AllDomainErrors = [
    "AVOS Cloud Error Domain" : AVOSCloudErrors
]

/// Specific errors with messages for AVOSCloud
private let AVOSCloudErrors = [
    // swiftlint:disable comma
    kAVErrorInternalServer : "遇到错误啦,请重试 🙏",
    
    kAVErrorConnectionFailed: "网络不给力哦,连接超时啦! 😲",
    
    kAVErrorObjectNotFound: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidQuery: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidClassName: "遇到错误啦,请重试 🙏",
    
    kAVErrorMissingObjectId: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidKeyName: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidPointer: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidJSON: "遇到错误啦,请重试 🙏",
    
    kAVErrorCommandUnavailable: "遇到错误啦,请重试 🙏",
    
    kAVErrorIncorrectType: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidChannelName: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidDeviceToken: "无效装置标记",
    
    kAVErrorPushMisconfigured: "消息推送失败 😲",
    
    kAVErrorObjectTooLarge: "遇到错误啦,请重试 🙏",
    
    kAVErrorOperationForbidden: "遇到错误啦,请重试 🙏",
    
    kAVErrorCacheMiss: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidNestedKey: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidFileName: "无效文件名,请重试 🙏",
    
    kAVErrorInvalidACL: "遇到错误啦,请重试 🙏",
    
    kAVErrorTimeout: "网络不给力哦,连接超时啦! 😲",
    
    kAVErrorInvalidEmailAddress: "无效邮件地址,请重试 🙏",
    
    kAVErrorDuplicateValue: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidRoleName: "遇到错误啦,请重试 🙏",
    
    kAVErrorExceededQuota: "遇到错误啦,请重试 🙏",
    
    kAVScriptError: "遇到错误啦,请重试 🙏",
    
    kAVValidationError: "验证失败,请重试 🙏",
    
    kAVErrorReceiptMissing: "购买失败, 请重试 🙏",
    
    kAVErrorInvalidPurchaseReceipt: "购买失败, 请重试 🙏",
    
    kAVErrorPaymentDisabled: "支付功能还未添加,请关注版本更新信息 🙏",
    
    kAVErrorInvalidProductIdentifier: "无法识别产品 😑",
    
    kAVErrorProductNotFoundInAppStore: "在AppStore未找到相关App 😑",
    
    kAVErrorInvalidServerResponse: "遇到错误啦,请重试 🙏",
    
    kAVErrorProductDownloadFileSystemFailure: "遇到错误啦,请重试 🙏",
    
    kAVErrorInvalidImageData: "图片读取失败,请重试 😑",
    
    kAVErrorUnsavedFile: "文件未保存,请重试 😑",
    
    kAVErrorFileDeleteFailure: "删除文件错误,请重试 😑",
    
    kAVErrorUsernameMissing: "请输入用户名 😑",
    
    kAVErrorUserPasswordMissing: "请输入密码 😑",
    
    kAVErrorUsernameTaken: "用户名已被使用了😂",
    
    kAVErrorUserEmailTaken: "这个邮件已经被注册拉 😑",
    
    kAVErrorUserEmailMissing: "请输入邮件地址 😑",
    
    kAVErrorUserWithEmailNotFound: "相关用户未找到 😑",
    
    kAVErrorUserCannotBeAlteredWithoutSession: "无法提交更改,请重试 😕",
    
    kAVErrorUserCanOnlyBeCreatedThroughSignUp: "请点击右上角的个人资料提交注册吧 😊",
    
//    kAVErrorFacebookAccountAlreadyLinked: "Facebook账号已与另一个账号连接 😕",
    
    kAVErrorAccountAlreadyLinked: "账户已与另一用户关联,请重试 😕",
    
    kAVErrorUserIdMismatch: "用户名无效,请重试 😕",
    
    kAVErrorUsernamePasswordMismatch: "无效用户名或密码错误,请重试 😕",
    
    kAVErrorUserNotFound: "无效用户名或密码错误,请重试 😕",
    
//    kAVErrorFacebookIdMissing: "无效Facebook用户,请重试 😕",
    
    kAVErrorLinkedIdMissing: "遇到错误啦,请重试 🙏",
    
//    kAVErrorFacebookInvalidSession: "无效的Facebook session,请重试 😕",
    
    kAVErrorInvalidLinkedSession: "遇到错误啦,请重试 🙏"

]

extension NSError {
    
    /// Returns customized error message
    public var customErrorDescription: String {
        if let domainErrors = AllDomainErrors[self.domain], message = domainErrors[self.code] {
            return message
        }
        else {
            print("Domain specific error has not been implemented yet... [\(self.description)]")
            return self.localizedDescription
        }
    }
}