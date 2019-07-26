import UIKit

public func getRequestId() -> String {
    let date = Date()
    let formart = DateFormatter()
    formart.dateFormat = "yyyyMMddHHmmss"
    let timeStamp = formart.string(from: date)
    return timeStamp + returnARCString(8)
}

public func returnARCString(_ count: Int) -> String {///返回一个随机字符串
    let charArr = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"]
    var arc4 = ""
    for _ in 0 ..< count {
        arc4 += charArr[Int(arc4random() % UInt32(charArr.count))]
    }
    return arc4
}

public func getTimestamp() -> String {
    let date = Int64(Date().timeIntervalSince1970)
    return "\(date)"
}

public func controllerFromString(_ className: String) -> UIViewController? {
    ///1.获取命名空间
    guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
        return UIViewController.init()
    }
    ///2.通过命名空间和类名转换成类
    let cls: AnyClass? = NSClassFromString((clsName as! String) + "." + className)
    
    ///swift中通过Class创建一个对象，必须告诉系统Class的类型
    guard let clsType = cls as? UIViewController.Type else {
        return UIViewController.init()
    }
    ///3.通过Class创建对象
    return clsType.init()
}

public func getWidthOrHeight(_ str: String?, _ font: UIFont, _ isW: Bool, _ length: CGFloat) -> CGFloat {
    let label = UILabel()
    label.text = str
    label.numberOfLines = 0
    let size: CGSize = isW ? CGSize(width: length, height: CGFloat(MAXFLOAT)) : CGSize(width: CGFloat(MAXFLOAT), height: length)
    let text: NSString = NSString(string: (str ?? ""))
    let rect: CGRect = text.boundingRect(with: size, options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil)
    return isW ? rect.size.height : rect.size.width
}

public func dataToJSON(data: Data) -> AnyObject? {
    do {
        return try JSONSerialization.jsonObject(with: data , options: .mutableContainers) as AnyObject
    } catch {
        print(error)
    }
    return nil
}
/*
 * 获得纯色背景图片
 */
public func createColorImage(_ frame: CGRect, color: UIColor) -> UIImage {
    
    UIGraphicsBeginImageContext(frame.size)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(frame)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
/*
 * 获得宽度的尺寸
 */
public func getSizeOnLabel(_ labelStr: UILabel, _ width: CGFloat) -> CGSize {
    
    let content = labelStr.text! as NSString
    let attributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): labelStr.font] as [NSAttributedString.Key: Any]
    var size = CGRect()
    size = content.boundingRect(with: CGSize(width: width,
                                             height: CGFloat(MAXFLOAT)),
                                options: .usesLineFragmentOrigin,
                                attributes: attributes,
                                context: nil)
    return size.size
}

// MARK: - 清除缓存
public func fileSizeOfCache() -> Int {
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    //缓存目录路径
    delog(cachePath)
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    //快速枚举出所有文件名 计算文件大小
    var size = 0
    for file in fileArr! {
        // 把文件名拼接到路径中
        let path = cachePath?.appending("/\(file)")
        // 取出文件属性
        let floder = try! FileManager.default.attributesOfItem(atPath: path!)
        // 用元组取出文件大小属性
        for (abc, bcd) in floder {
            // 累加文件大小
            if abc == FileAttributeKey.size {
                size += (bcd as AnyObject).integerValue
            }
        }
    }
    let mm = size / 1024 / 1024
    return mm
}

public func clearCache() {
    
    delog("清除中...")
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    // 遍历删除
    for file in fileArr! {
        let path = cachePath?.appending("/\(file)")
        if FileManager.default.fileExists(atPath: path!) {
            do {
                try FileManager.default.removeItem(atPath: path!)
            } catch {
                
            }
        }
    }
}

// MARK: - 提示弹窗
public func showAlert(_ message: String, _ cancelTitle: String) {
    let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
    alertVC.addAction(cancelAction)
    UIApplication.shared.keyWindow?.topMostVC?.present(alertVC, animated: true, completion: nil)
}

public func showAlert(_ message: String, _ confirmTitle: String, _ cancelTitle: String, _ confirmHandler: @escaping handle, _ cancelHandler: @escaping handle) {
    let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (_) in
        confirmHandler()
    }
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
        cancelHandler()
    }
    alertVC.addAction(confirmAction)
    alertVC.addAction(cancelAction)
    UIApplication.shared.keyWindow?.topMostVC?.present(alertVC, animated: true, completion: nil)
}

/*
 * 添加一个公共参数时间戳
 */
public func getTimeLine() -> String {
    //
    let date = Date()
    let formart = DateFormatter()
    formart.dateFormat = "yyyyMMddHHmmssSSS"
    let timeStamp = formart.string(from: date)
    return timeStamp
}

/*
 * 通过时间戳获得时间
 */
public func getTimeLineFromUNIX(_ time: UInt64, formate: String?) -> String {
    //
    let timeInterval:TimeInterval = TimeInterval(time)
    let date = Date(timeIntervalSince1970: timeInterval)
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = formate ?? "YYYY/MM/dd HH:mm"
    let time = dateformatter.string(from: date)
    return time
}

/*
 * 通过时间获得时间戳
 */
public func getUNIXFromTimeLine(_ time: String) -> UInt64 {
    //
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let time = dateformatter.date(from: time) {
        let timestamp = time.timeIntervalSince1970
        return UInt64(timestamp)
    } else {
        return 0
    }
}


/*
 * 在视图控制器中移除当前页面
 */
public func removeThisVC(_ vc: UIViewController) {
    
    if var arr = vc.navigationController?.viewControllers, arr.count > 1 {
        
        for (index, item) in arr.enumerated() {
            if vc.self == item.self {
                arr.remove(at: index)
                vc.navigationController?.viewControllers = arr
            }
        }
    }
}

/*
 * 获得仿朋友圈倒计时
 */
public func getShowFormat(requestDate:Date) -> String {
    
    //获取当前时间
    let calendar = Calendar.current
    //判断是否是今天
    if calendar.isDateInToday(requestDate as Date) {
        //获取当前时间和系统时间的差距(单位是秒)
        //强制转换为Int
        let since = Int(Date().timeIntervalSince(requestDate as Date))
        //  是否是刚刚
        if since < 60 {
            return "刚刚"
        }
        //  是否是多少分钟内
        if since < 60 * 60 {
            return "\(since/60)分钟前"
        }
        //  是否是多少小时内
        return "\(since / (60 * 60))小时前"
    }
    
    //判断是否是昨天
    var formatterString = " HH:mm"
    if calendar.isDateInYesterday(requestDate as Date) {
        formatterString = "昨天" + formatterString
    } else {
        //判断是否是一年内
        formatterString = "MM-dd" + formatterString
        //判断是否是更早期
        
        let comps = calendar.dateComponents([Calendar.Component.year], from: requestDate, to: Date())
        
        if comps.year! >= 1 {
            formatterString = "yyyy-" + formatterString
        }
    }
    
    //按照指定的格式将日期转换为字符串
    //创建formatter
    let formatter = DateFormatter()
    //设置时间格式
    formatter.dateFormat = formatterString
    //设置时间区域
    formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
    
    let str = formatter.string(from: requestDate as Date)
    //格式化
    return str
}
