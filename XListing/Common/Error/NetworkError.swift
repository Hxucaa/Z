//
//  NetworkError.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-21.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

// TODO: Need better abstraction on Error handling 

public enum NetworkError : Int, ErrorType {
    case InternalServer = 1
    case ConnectionFailed = 100
    case ObjectNotFound = 101
    case InvalidQuery = 102
    case InvalidClassName = 103
    case MissingObjectId = 104
    case InvalidKeyName = 105
    case InvalidPointer = 106
    case InvalidJSON = 107
    case CommandUnavailable = 108
    case IncorrectType = 111
    case InvalidChannelName = 112
    case InvalidDeviceToken = 114
    case PushMisconfigured = 115
    case ObjectTooLarge = 116
    case OperationForbidden = 119
    case CacheMiss = 120
    case InvalidNestedKey = 121
    case InvalidFileName = 122
    case InvalidACL = 123
    case Timeout = 124
    case InvalidEmailAddress = 125
    case DuplicateValue = 137
    case InvalidRoleName = 139
    case ExceededQuota = 140
    case ScriptError = 141
    case ValidationError = 142
    case ReceiptMissing = 143
    case InvalidPurchaseReceipt = 144
    case PaymentDisabled = 145
    case InvalidProductIdentifier = 146
    case ProductNotFoundInAppStore = 147
    case InvalidServerResponse = 148
    case ProductDownloadFileSystemFailure = 149
    case InvalidImageData = 150
    case UnsavedFile = 151
    case FileDeleteFailure = 153
    case UsernameMissing = 200
    case UserPasswordMissing = 201
    case UsernameTaken = 202
    case UserEmailTaken = 203
    case UserEmailMissing = 204
    case UserWithEmailNotFound = 205
    case UserCannotBeAlteredWithoutSession = 206
    case UserCanOnlyBeCreatedThroughSignUp = 207
    case AccountAlreadyLinked = 208
    case UserIdMismatch = 209
    case UsernamePasswordMismatch = 210
    case UserNotFound = 211
    case UserMobilePhoneMissing = 212
    case UserWithMobilePhoneNotFound = 213
    case UserMobilePhoneNumberTaken = 214
    case UserMobilePhoneNotVerified = 215
    case LinkedIdMissing = 250
    case InvalidLinkedSession = 251
    
    public var message: String {
        switch self {
        case InternalServer : return "遇到错误啦,请重试 🙏"
        case ConnectionFailed: return "网络不给力哦,连接超时啦! 😲"
        case ObjectNotFound: return "遇到错误啦,请重试 🙏"
        case InvalidQuery: return "遇到错误啦,请重试 🙏"
        case InvalidClassName: return "遇到错误啦,请重试 🙏"
        case MissingObjectId: return "遇到错误啦,请重试 🙏"
        case InvalidKeyName: return "遇到错误啦,请重试 🙏"
        case InvalidPointer: return "遇到错误啦,请重试 🙏"
        case InvalidJSON: return "遇到错误啦,请重试 🙏"
        case CommandUnavailable: return "遇到错误啦,请重试 🙏"
        case IncorrectType: return "遇到错误啦,请重试 🙏"
        case InvalidChannelName: return "遇到错误啦,请重试 🙏"
        case InvalidDeviceToken: return "无效装置标记"
        case PushMisconfigured: return "消息推送失败 😲"
        case ObjectTooLarge: return "遇到错误啦,请重试 🙏"
        case OperationForbidden: return "遇到错误啦,请重试 🙏"
        case CacheMiss: return "遇到错误啦,请重试 🙏"
        case InvalidNestedKey: return "遇到错误啦,请重试 🙏"
        case InvalidFileName: return "无效文件名,请重试 🙏"
        case InvalidACL: return "遇到错误啦,请重试 🙏"
        case Timeout: return "网络不给力哦,连接超时啦! 😲"
        case InvalidEmailAddress: return "无效邮件地址,请重试 🙏"
        case DuplicateValue: return "遇到错误啦,请重试 🙏"
        case InvalidRoleName: return "遇到错误啦,请重试 🙏"
        case ExceededQuota: return "遇到错误啦,请重试 🙏"
        case ScriptError: return "遇到错误啦,请重试 🙏"
        case ValidationError: return "验证失败,请重试 🙏"
        case ReceiptMissing: return "购买失败, 请重试 🙏"
        case InvalidPurchaseReceipt: return "购买失败, 请重试 🙏"
        case PaymentDisabled: return "支付功能还未添加,请关注版本更新信息 🙏"
        case InvalidProductIdentifier: return "无法识别产品 😑"
        case ProductNotFoundInAppStore: return "在AppStore未找到相关App 😑"
        case InvalidServerResponse: return "遇到错误啦,请重试 🙏"
        case ProductDownloadFileSystemFailure: return "遇到错误啦,请重试 🙏"
        case InvalidImageData: return "图片读取失败,请重试 😑"
        case UnsavedFile: return "文件未保存,请重试 😑"
        case FileDeleteFailure: "删除文件错误,请重试 😑"
        case UsernameMissing: return "请输入用户名 😑"
        case UserPasswordMissing: return "请输入密码 😑"
        case UsernameTaken: return "用户名已被使用了😂"
        case UserEmailTaken: return "这个邮件已经被注册拉 😑"
        case UserEmailMissing: return "请输入邮件地址 😑"
        case UserWithEmailNotFound: return "相关用户未找到 😑"
        case UserCannotBeAlteredWithoutSession: return "无法提交更改,请重试 😕"
        case UserCanOnlyBeCreatedThroughSignUp: return "请点击右上角的个人资料提交注册吧 😊"
        case AccountAlreadyLinked: return "账户已与另一用户关联,请重试 😕"
        case UserIdMismatch: return "用户名无效,请重试 😕"
        case UsernamePasswordMismatch: return "无效用户名或密码错误,请重试 😕"
        case UserNotFound: return "无效用户名或密码错误,请重试 😕"
        case UserMobilePhoneMissing: return "手机号码不存在"
        case UserWithMobilePhoneNotFound: return "无法根据此手机号码找到用户"
        case UserMobilePhoneNumberTaken: return "手机号码已被使用"
        case UserMobilePhoneNotVerified: return "手机号码未验证"
        case LinkedIdMissing: return "遇到错误啦,请重试 🙏"
        case InvalidLinkedSession: return "遇到错误啦,请重试 🙏"
        }
    }
}
