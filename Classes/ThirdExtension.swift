import Foundation
import MJRefresh
import MBProgressHUD

struct RefreshManager {
    
    static func header(_ refresh: (() -> Void)?) -> MJRefreshNormalHeader? {
        let mj_header = MJRefreshNormalHeader {
            refresh?()
        }
        mj_header?.stateLabel.font = UIFont.systemFont(ofSize: 12)
        mj_header?.stateLabel.textColor = UIColor.init(hexString: "000000", alpha: 0.6)
        mj_header?.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 12)
        mj_header?.lastUpdatedTimeLabel.textColor = UIColor.init(hexString: "000000", alpha: 0.6)
        return mj_header
    }
    
    static func footer(_ refresh: (() -> Void)?) -> MJRefreshAutoNormalFooter? {
        let mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            refresh?()
        })
        mj_footer?.setTitle("没有更多了", for: .noMoreData)
        mj_footer?.stateLabel.font = UIFont.systemFont(ofSize: 12)
        mj_footer?.stateLabel.textColor = UIColor.init(hexString: "000000", alpha: 0.6)
        return mj_footer
    }
}

extension MBProgressHUD {
    static func showLoading(_ view: UIView?, with title: String?) {
        let hud = MBProgressHUD.showAdded(to: rootView(view), animated: true)
        hud.contentColor = .white
        hud.minSize = CGSize(width: 100, height: 100)
        hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        hud.removeFromSuperViewOnHide = true
        if let text = title {
            hud.label.text = text
            hud.label.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    static func showSuccess(_ view: UIView?,
                            with title: String?,
                            complete handler: (() -> Void)?) {
        showHUD(view, with: UIImage(named: "state_right"), to: title, complete: handler)
    }
    
    static func showFailure(_ view: UIView?,
                            with title: String?,
                            complete handler: (() -> Void)?) {
        showHUD(view, with: UIImage(named: "state_cancel"), to: title, complete: handler)
    }
    
    static func showMessage(_ view: UIView?,
                            with title: String,
                            complete handler: (() -> Void)?) {
        let hud = MBProgressHUD.showAdded(to: rootView(view), animated: true)
        hud.contentColor = .white
        hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        hud.removeFromSuperViewOnHide = true
        hud.minSize = CGSize(width: 60, height: 60)
        hud.mode = .text
        hud.label.text = title
        hud.label.font = UIFont.systemFont(ofSize: 13)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            dismisHUD(view)
            handler?()
        }
    }
    
    private static func showHUD(_ view: UIView?,
                                with icon: UIImage?,
                                to title: String?,
                                complete handler: (() -> Void)?) {
        
        let hud = MBProgressHUD.showAdded(to: rootView(view), animated: true)
        hud.contentColor = .white
        hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        hud.removeFromSuperViewOnHide = true
        hud.minSize = CGSize(width: 40, height: 40)
        hud.mode = .customView
        let iconImgv = UIImageView(image: icon)
        hud.customView = iconImgv
        if let text = title {
            hud.label.text = text
            hud.label.numberOfLines = 0
            hud.label.font = UIFont.systemFont(ofSize: 13)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            dismisHUD(view)
            handler?()
        }
    }
    
    static func dismisHUD(_ view: UIView?) {
        MBProgressHUD(for: rootView(view))?.hide(animated: true)
    }
    
    static func rootView(_ view: UIView?) -> UIView {
        if let v = view {
            return v
        } else {
            return UIApplication.shared.keyWindow!
        }
    }
}

