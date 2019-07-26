import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }
    
    var maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    ///设置圆角
    func setCornerRadius(_ size: CGFloat) {
        self.layer.cornerRadius = size
        self.layer.masksToBounds = true
    }
    ///去掉所有子视图
    func removeAllSubviews() {
        while self.subviews.count != 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    ///设置单边圆角
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat, frame: CGRect) {
        let maskPath = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = frame
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    ///添加圆角和阴影 radius:圆角半径 shadowOpacity: 阴影透明度 (0-1) shadowColor: 阴影颜色
    func addRoundedOrShadow(radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        let subLayer = CALayer()
        let fixframe = self.frame
        let newFrame = CGRect(x: fixframe.minX, y: fixframe.minY, width: fixframe.width, height: fixframe.height)
        subLayer.frame = newFrame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 2) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
    }
    ///圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.masksToBounds = (newValue > 0)
            layer.cornerRadius = newValue
        }
    }
    ///边线宽度
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    ///边线颜色
    @IBInspectable var borderColor: UIColor {
        get {
            return layer.borderUIColor
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
}
///设置边线颜色
extension CALayer {
    var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = borderUIColor.cgColor
        }
    }
}

extension UIViewController {
    ///屏幕整体上移
    func changeViewY(_ height: CGFloat) {
        if WIDTH > 320 {
            return
        }
        UIView.animate(withDuration: 0.25) {
            var frame = UIApplication.shared.keyWindow?.frame
            frame?.origin.y = UIApplication.shared.keyWindow?.frame.origin.y == 0 ? height : 0
            UIApplication.shared.keyWindow?.frame = frame!
        }
    }
    
    func addChildViewController(_ childVC: UIViewController, toView: UIView) {
        addChild(childVC)
        toView.addSubview(childVC.view)
        childVC.beginAppearanceTransition(true, animated: false)
        childVC.endAppearanceTransition()
    }
}

extension UIColor {
    /**
     hexString: 6位16进制字符串 如0xFFFFFF
     */
    convenience init(hexString: String) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "0X", with: "")
        if let hexInt = Int(hexString, radix: 16) {
            let r = CGFloat((hexInt & 0xff0000) >> (4*4))
            let g = CGFloat((hexInt & 0x00ff00) >> (4*2))
            let b = CGFloat((hexInt & 0x0000ff) >> (4*0))
            self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        } else {
            self.init()
        }
    }
    /**
     hexString: 6位16进制数字 如0xFFFFFF
     alpha: 透明度 0.0 ~ 1.0
     */
    convenience init(hexString: String, alpha: CGFloat) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "0X", with: "")
        if let hexInt = Int(hexString, radix: 16) {
            let r = CGFloat((hexInt & 0xff0000) >> (4*4))
            let g = CGFloat((hexInt & 0x00ff00) >> (4*2))
            let b = CGFloat((hexInt & 0x0000ff) >> (4*0))
            self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
        } else {
            self.init()
        }
    }
}

extension CAGradientLayer {
    ///渐变色
    func gradientLayer(_ start: String, _ end: String, _ isV: Bool) -> CAGradientLayer {
        //定义渐变的颜色
        let gradientColors = [UIColor.init(hexString: start).cgColor,
                              UIColor.init(hexString: end).cgColor]
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        //创建CAGradientLayer对象并设置参数
        self.colors = gradientColors
        self.locations = gradientLocations
        //设置渲染的起始结束位置
        self.startPoint = CGPoint(x: 0, y: 0)
        self.endPoint = isV ? CGPoint(x: 0, y: 1.0) : CGPoint(x: 1.0, y: 0)
        return self
    }
}

extension UIWindow {
    /// 获取UIWindow的最上层控制器
    // fixme: 考虑如果presented的是UIAlertController时该如何处理
    var topMostVC: UIViewController? {
        guard var findVC = self.rootViewController else {
            return nil
        }
        while true {
            if let nav = findVC as? UINavigationController, let topVC = nav.topViewController {
                findVC = topVC
            } else if let tab = findVC as? UITabBarController, let selVC = tab.selectedViewController {
                findVC = selVC
            } else if let pre = findVC.presentedViewController{
                findVC = pre
            } else {
                break
            }
        }
        return findVC
    }
}

extension UIStoryboard {
    public class func createControllerWithName(_ name: String, identifier id: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: id)
    }
}

extension UITextField {
    public func setLeftMode() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.height))
        self.leftView = view
        self.leftViewMode = .always
    }
    
    public func setRightMode(_ btn: UIButton) {
        self.rightView = btn
        self.rightViewMode = .whileEditing
    }
    
    public func setLeftMode(_ btn: UIButton) {
        self.leftView = btn
        self.leftViewMode = .always
    }
}

extension UIButton {
    ///快捷创建按钮
    public func createWith( title: String?, _ titleColor: UIColor, _ font: UIFont) {
        if let str = title {
            self.setTitle(str, for: .normal)
        }else {
            self.setTitle(" ", for: .normal)
        }
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.sizeToFit()
    }
}

extension UILabel {
    ///快捷创建标签
    public func createWith(text: String?, textColor: UIColor, font: UIFont) {
        if let str = text {
            self.text = str
        }else {
            self.text = " "
        }
        self.textColor = textColor
        self.font = font
    }
}
