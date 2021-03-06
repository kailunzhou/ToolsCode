import Foundation

public extension Notification.Name {
    struct App {
        ///网络状态已经变更
        public static let NetworkingDidChange = Notification.Name("NetworkingDidChange")
        ///点击底部弹窗
        public static let ChangeTabbarSelected = Notification.Name("ChangeTabbarSelected")
        ///推送通知工作是否正常
        public static let DidChannelConnectedSuccess = Notification.Name("DidChannelConnectedSuccess")
        ///推送通知工作是否正常
        public static let EBBannerViewDidClickNotification = Notification.Name("EBBannerViewDidClickNotification")
        ///是否修改推送权限
        public static let IsChangePushController = Notification.Name("IsChangePushController")
    }
}

public extension NotificationCenter {
    static func addNotification(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?) {
        self.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
    }
    
    static func removeNotification(_ observer: Any, name aName: NSNotification.Name? = nil) {
        if aName != nil {
            self.default.removeObserver(self, name: aName, object: nil)
        } else{
            self.default.removeObserver(self)
        }
    }
    
    static func postNotification(name: NSNotification.Name, userInfo: [AnyHashable : Any]?) {
        self.default.post(name: name, object: nil, userInfo: userInfo)
    }
}
