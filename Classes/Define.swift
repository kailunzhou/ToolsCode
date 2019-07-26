import Foundation
import UIKit

public let swiftDefaults = UserDefaults(suiteName: "\(Joggle.default.channelNo ?? "")Bus" )!///数据持久化框架

public let WIDTH = UIScreen.main.bounds.size.width///屏幕宽
public let HEIGHT = UIScreen.main.bounds.size.height///屏幕高
///iphone X-88||64
public let NaviHeight = HEIGHT >= 812 ? 88 : 64
///iphone X-44||20
public let NaviBarHeight = HEIGHT >= 812 ? 44 : 20
///iphone X-34||0
public let BottomSafeHeight = HEIGHT >= 812 ? 34 : 0

public struct Define {
    public static var isCanInternetPower: Bool = false///是否可以联网
    
    public static let phoneNumLength = 11///手机号码长度
    
    public static let vcodeNumLength = 6///验证码长度
    
    public static let passwordMinLength = 6///密码最小长度
    
    public static let passwordMaxLength = 16///密码最大长度
    
    public static let resendMessageTime = 60///发送短信间隔时间
}
