import Foundation
import IQKeyboardManagerSwift
import Reachability

class APP: NSObject {
    static let `default` = APP()
    let reachability = Reachability()
    
    public func setup() {
        setNetWork()
        setupIQKeyboard()
        NetMethod.share.getUserInfo {}
    }
    
    ///设置键盘弹出第三方
    func setupIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    private func setNetWork() {
        //1.设置网络状态消息监听
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        reachability.startNotifier()//3.开启网络状态消息监听
    }
    
    @objc private func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        if reachability.currentReachabilityStatus() != .NotReachable {// 判断网络连接状态
            delog("网络连接：可用")
            if reachability.currentReachabilityStatus() == .ReachableViaWiFi {// 判断网络连接类型
                delog("连接类型：WiFi")
            } else {
                delog("连接类型：移动网络")
            }
            Define.isCanInternetPower = true
        } else {
            delog("网络连接：不可用")
            Define.isCanInternetPower = false
        }
        NotificationCenter.postNotification(name: NSNotification.Name.App.NetworkingDidChange, userInfo: nil)
    }
}
