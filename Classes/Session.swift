import UIKit
import ObjectMapper

public class Session: NSObject {
    public static let `default` = Session()
    
    public var phone: String? {///登录账号
        get {
            return swiftDefaults.string(forKey: "PERSON_INFO_PHONE")
        }
        set {
            swiftDefaults.set(newValue, forKey: "PERSON_INFO_PHONE")
        }
    }
    
    public var password: String? {///登录密码
        get {
            return swiftDefaults.string(forKey: "PERSON_INFO_PASSWORD")
        }
        set {
            swiftDefaults.set(newValue, forKey: "PERSON_INFO_PASSWORD")
        }
    }
    
    public var token: String? {///登录凭证
        get {
            return swiftDefaults.string(forKey: "PERSON_INFO_TOKEN")
        }
        set {
            swiftDefaults.set(newValue, forKey: "PERSON_INFO_TOKEN")
        }
    }
    
    public var loginUser: UserInfo? {///用户数据
        get {
            return Persistence.default.getModel(UserInfo.self, withName: "PERSON_INFO_USERINFO")
        }
        set {
            _ = Persistence.default.writeModel(newValue, withName: "PERSON_INFO_USERINFO")
        }
    }
    
    public var deviceID: String? {///阿里云推送ID
        get {
            return swiftDefaults.string(forKey: "deviceID")
        }
        set {
            swiftDefaults.set(newValue, forKey: "deviceID")
        }
    }
    
    public var isDeniedNotification: Bool? {///是否拒绝推送
        get {
            return swiftDefaults.bool(forKey: "isDeniedNotification")
        }
        set {
            swiftDefaults.set(newValue, forKey: "isDeniedNotification")
        }
    }
    
    public var pushedUserInfo: [String : Any]? {//推送内容
        get {
            return swiftDefaults.dictionary(forKey: "pushedUserInfo")
        }
        set {
            swiftDefaults.set(newValue, forKey: "pushedUserInfo")
        }
    }
}

public struct UserInfo: Mappable {/// 用户信息
    public init?(map: Map) {}
    
    public var depositAmount: String?//代扣押金
    public var isDeduction: Int64?//是否已扣除押金(1.已扣除,2.未扣除)
    public var isOpenBusCode: Int64?//是否开通乘车码(1.未开通 2.已开通 3.黑名单 4.未绑定支付方式)
    public var obtainQRCodeResp: ObtainQRCodeResp?//
    public var payChannelList: PayChannelList?//支付方式列表
    public var mobile: String?//手机号,这里没有返回
    public var token: String?//这里没有返回
    public var undoneOrderNum: Int64?//未支付订单数
    
    public mutating func mapping(map: Map) {
        depositAmount             <- map["depositAmount"]
        isDeduction               <- map["isDeduction"]
        isOpenBusCode             <- map["isOpenBusCode"]
        obtainQRCodeResp          <- map["obtainQRCodeResp"]
        payChannelList            <- map["payChannelList"]
        mobile                    <- map["mobile"]
        token                     <- map["token"]
        undoneOrderNum            <- map["undoneOrderNum"]
    }
}

public struct PayChannelList: Mappable {
    public init?(map: Map) {}
    
    public var backUrl: String?//支付方式背景图标
    public var channelId: Int64?//支付渠道id
    public var channelName: String?//支付渠道名
    public var defaultDeductionFlag: String?//选中的支付方式
    public var iconUrl: String?//支付方式标签图标
    public var isBinding: Int64?//是否绑定(1.未绑定 2.已绑定)
    public var payType: Int64?//支付类型 1.支付宝 (绑定支付方式判断需要)
    public var remonnedStatus: Int64?//推荐状态(为2的时候为推荐支付方式)
    
    public mutating func mapping(map: Map) {
        backUrl                       <- map["backUrl"]
        channelId                     <- map["channelId"]
        channelName                   <- map["channelName"]
        defaultDeductionFlag          <- map["defaultDeductionFlag"]
        iconUrl                       <- map["iconUrl"]
        isBinding                     <- map["isBinding"]
        payType                       <- map["payType"]
        remonnedStatus                <- map["remonnedStatus"]
    }
}

public struct ObtainQRCodeResp: Mappable {
    public init?(map: Map) {}
    
    public var effectiveTime: Int64?
    public var expireTime: Int64?
    public var obtain: Bool?
    public var qrCode: String?
    
    public mutating func mapping(map: Map) {
        effectiveTime        <- map["effectiveTime"]
        expireTime           <- map["expireTime"]
        obtain               <- map["obtain"]
        qrCode               <- map["qrCode"]
    }
}
