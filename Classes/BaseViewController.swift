import UIKit
import IQKeyboardManagerSwift

public class BaseViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "F5F5FA")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor(hexString: "1F2D3D")]
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    ///点击结束编辑
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    ///导航栏背景透明
    public func setNaviBarAlpha() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    public func unsetNaviBatAlpha() {
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = true
    }
    
    ///iqkeyboard库隐藏
    public func openIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    ///iqkeyboard库隐藏
    public func closeIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
