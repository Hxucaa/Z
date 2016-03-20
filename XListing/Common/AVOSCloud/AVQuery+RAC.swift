//
//  AVQuery+RAC.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
//public struct NetworkError : ErrorType {
//    
//    
//    case InternalServer : "遇到错误啦,请重试 🙏",
//    
//    case ConnectionFailed: "网络不给力哦,连接超时啦! 😲",
//    
//    case ObjectNotFound: "遇到错误啦,请重试 🙏",
//    
//    case InvalidQuery: "遇到错误啦,请重试 🙏",
//    
//    case InvalidClassName: "遇到错误啦,请重试 🙏",
//    
//    case MissingObjectId: "遇到错误啦,请重试 🙏",
//    
//    case InvalidKeyName: "遇到错误啦,请重试 🙏",
//    
//    case InvalidPointer: "遇到错误啦,请重试 🙏",
//    
//    case InvalidJSON: "遇到错误啦,请重试 🙏",
//    
//    case CommandUnavailable: "遇到错误啦,请重试 🙏",
//    
//    case IncorrectType: "遇到错误啦,请重试 🙏",
//    
//    case InvalidChannelName: "遇到错误啦,请重试 🙏",
//    
//    case InvalidDeviceToken: "无效装置标记",
//    
//    case PushMisconfigured: "消息推送失败 😲",
//    
//    case ObjectTooLarge: "遇到错误啦,请重试 🙏",
//    
//    case OperationForbidden: "遇到错误啦,请重试 🙏",
//    
//    case CacheMiss: "遇到错误啦,请重试 🙏",
//    
//    case InvalidNestedKey: "遇到错误啦,请重试 🙏",
//    
//    case InvalidFileName: "无效文件名,请重试 🙏",
//    
//    case InvalidACL: "遇到错误啦,请重试 🙏",
//    
//    case Timeout: "网络不给力哦,连接超时啦! 😲",
//    
//    case InvalidEmailAddress: "无效邮件地址,请重试 🙏",
//    
//    case DuplicateValue: "遇到错误啦,请重试 🙏",
//    
//    case InvalidRoleName: "遇到错误啦,请重试 🙏",
//    
//    case ExceededQuota: "遇到错误啦,请重试 🙏",
//    
//    case ScriptError: "遇到错误啦,请重试 🙏",
//    
//    case ValidationError: "验证失败,请重试 🙏",
//    
//    case ReceiptMissing: "购买失败, 请重试 🙏",
//    
//    case InvalidPurchaseReceipt: "购买失败, 请重试 🙏",
//    
//    case PaymentDisabled: "支付功能还未添加,请关注版本更新信息 🙏",
//    
//    case InvalidProductIdentifier: "无法识别产品 😑",
//    
//    case ProductNotFoundInAppStore: "在AppStore未找到相关App 😑",
//    
//    case InvalidServerResponse: "遇到错误啦,请重试 🙏",
//    
//    case ProductDownloadFileSystemFailure: "遇到错误啦,请重试 🙏",
//    
//    case InvalidImageData: "图片读取失败,请重试 😑",
//    
//    case UnsavedFile: "文件未保存,请重试 😑",
//    
//    case FileDeleteFailure: "删除文件错误,请重试 😑",
//    
//    case UsernameMissing: "请输入用户名 😑",
//    
//    case UserPasswordMissing: "请输入密码 😑",
//    
//    case UsernameTaken: "用户名已被使用了😂",
//    
//    case UserEmailTaken: "这个邮件已经被注册拉 😑",
//    
//    case UserEmailMissing: "请输入邮件地址 😑",
//    
//    case UserWithEmailNotFound: "相关用户未找到 😑",
//    
//    case UserCannotBeAlteredWithoutSession: "无法提交更改,请重试 😕",
//    
//    case UserCanOnlyBeCreatedThroughSignUp: "请点击右上角的个人资料提交注册吧 😊",
//    
//    //    case FacebookAccountAlreadyLinked: "Facebook账号已与另一个账号连接 😕",
//    
//    case AccountAlreadyLinked: "账户已与另一用户关联,请重试 😕",
//    
//    case UserIdMismatch: "用户名无效,请重试 😕",
//    
//    case UsernamePasswordMismatch: "无效用户名或密码错误,请重试 😕",
//    
//    case UserNotFound: "无效用户名或密码错误,请重试 😕",
//    
//    //    case FacebookIdMissing: "无效Facebook用户,请重试 😕",
//    
//    case LinkedIdMissing: "遇到错误啦,请重试 🙏",
//    
//    //    case FacebookInvalidSession: "无效的Facebook session,请重试 😕",
//    
//    case InvalidLinkedSession: "遇到错误啦,请重试 🙏"
//
//    public var errorMessage: String {
//        switch self {
//            
//        }
//    }
//}
public extension AVQuery {
    
    /**
     Finds objects asynchronously.
     
     - returns: SignalProducer sequence of the objects.
     */
    public func rac_findObjects() -> SignalProducer<[AVObject], NSError> {
        
        return SignalProducer { observer, disposable in
            self.findObjectsInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! [AVObject])
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Gets an object asynchronously.
     
     - returns: SignalProducer sequence of the object.
     */
    public func rac_getFirstObject() -> SignalProducer<AVObject, NSError> {
        return SignalProducer { observer, disposable in
            self.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Counts objects asynchronously.
     
     - returns: SignalProducer sequence of the count.
     */
    public func rac_countObjects() -> SignalProducer<Int, NSError> {
        return SignalProducer { observer, disposable in
            self.countObjectsInBackgroundWithBlock { (count, error) -> Void in
                if error == nil {
                    observer.sendNext(count)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Gets a AVObject based on objectId asynchronously.
     
     - parameter objectId: The id of the object being requested.
     
     - returns: SignalProducer sequence of the object.
     */
    public func rac_getObjectWithId(objectId: String) -> SignalProducer<AVObject, NSError> {
        return SignalProducer { observer, disposable in
            self.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Remove all objects asynchronously.
     
     - returns: SignalProducer sequence of operation status.
     */
    public func rac_deleteAll() -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            self.deleteAllInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
}
