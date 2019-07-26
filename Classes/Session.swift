import UIKit
import ObjectMapper

public class Session: NSObject {
    public static let `default` = Session()
    
    var phone: String? {///登录账号
        get {
            return swiftDefaults.string(forKey: "PERSON_INFO_PHONE")
        }
        set {
            swiftDefaults.set(newValue, forKey: "PERSON_INFO_PHONE")
        }
    }
    
    var password: String? {///登录密码
        get {
            return swiftDefaults.string(forKey: "PERSON_INFO_PASSWORD")
        }
        set {
            swiftDefaults.set(newValue, forKey: "PERSON_INFO_PASSWORD")
        }
    }
    
    var token: String? {///登录凭证
        get {
            return swiftDefaults.string(forKey: "PERSON_INFO_TOKEN")
        }
        set {
            swiftDefaults.set(newValue, forKey: "PERSON_INFO_TOKEN")
        }
    }
    
    var loginUser: UserInfo? {///用户数据
        get {
            return Persistence.default.getModel(UserInfo.self, withName: "PERSON_INFO_USERINFO")
        }
        set {
            _ = Persistence.default.writeModel(newValue, withName: "PERSON_INFO_USERINFO")
        }
    }
    
    var deviceID: String? {///阿里云推送ID
        get {
            return swiftDefaults.string(forKey: "deviceID")
        }
        set {
            swiftDefaults.set(newValue, forKey: "deviceID")
        }
    }
    
    var isDeniedNotification: Bool? {///是否拒绝推送
        get {
            return swiftDefaults.bool(forKey: "isDeniedNotification")
        }
        set {
            swiftDefaults.set(newValue, forKey: "isDeniedNotification")
        }
    }
    
    var pushedUserInfo: [String : Any]? {//推送内容
        get {
            return swiftDefaults.dictionary(forKey: "pushedUserInfo")
        }
        set {
            swiftDefaults.set(newValue, forKey: "pushedUserInfo")
        }
    }
}

public struct UserInfo: Mappable {/// 用户信息
    init?(map: Map) {}
    
    var depositAmount: String?//代扣押金
    var isDeduction: Int64?//是否已扣除押金(1.已扣除,2.未扣除)
    var isOpenBusCode: Int64?//是否开通乘车码(1.未开通 2.已开通 3.黑名单 4.未绑定支付方式)
    var obtainQRCodeResp: ObtainQRCodeResp?//
    var payChannelResp: PayChannelResp?//支付方式列表
    var mobile: String?//手机号,这里没有返回
    var token: String?//这里没有返回
    var undoneOrderNum: Int64?//未支付订单数
    
    mutating func mapping(map: Map) {
        depositAmount             <- map["depositAmount"]
        isDeduction               <- map["isDeduction"]
        isOpenBusCode             <- map["isOpenBusCode"]
        obtainQRCodeResp          <- map["obtainQRCodeResp"]
        payChannelResp            <- map["payChannelResp"]
        mobile                    <- map["mobile"]
        token                     <- map["token"]
        undoneOrderNum            <- map["undoneOrderNum"]
    }
}

public struct PayChannelResp: Mappable {
    init?(map: Map) {}
    
    var backUrl: String?//支付方式背景图标
    var channelId: Int64?//支付渠道id
    var channelName: String?//支付渠道名
    var iconUrl: String?//支付方式标签图标
    var isBinding: Int64?//是否绑定(1.未绑定 2.已绑定)
    var payType: Int64?//支付类型 1.支付宝 (绑定支付方式判断需要)
    var remonnedStatus: Int64?//推荐状态(为2的时候为推荐支付方式)
    
    mutating func mapping(map: Map) {
        backUrl                       <- map["backUrl"]
        channelId                     <- map["channelId"]
        channelName                   <- map["channelName"]
        iconUrl                       <- map["iconUrl"]
        isBinding                     <- map["isBinding"]
        payType                       <- map["payType"]
        remonnedStatus                <- map["remonnedStatus"]
    }
}

public struct ObtainQRCodeResp: Mappable {
    init?(map: Map) {}
    
    var effectiveTime: Int64?
    var expireTime: Int64?
    var obtain: Bool?
    var qrCode: String?
    
    mutating func mapping(map: Map) {
        effectiveTime        <- map["effectiveTime"]
        expireTime           <- map["expireTime"]
        obtain               <- map["obtain"]
        qrCode               <- map["qrCode"]
    }
}
