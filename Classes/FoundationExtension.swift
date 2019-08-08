import Foundation
import UIKit
import CommonCrypto

public extension String {
    /// MD5加密
    /// - Returns: md5加密字符串
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String).localizedUppercase
    }
    
    func toUTF8String() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func toJSONDic() -> NSDictionary? {
        //let str = self.replacingOccurrences(of: "\\", with: "")
        var str = self
        str = self.replacingOccurrences(of: "\\", with: "")
        str = self.replacingOccurrences(of: "\\\\", with: "")
        str = self.replacingOccurrences(of: "\\\\\\", with: "")
        let jsonData:Data = str.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as? NSDictionary
        }
        return nil
    }
    
    func toJSONAry() -> NSArray? {
        //let str = self.replacingOccurrences(of: "\\", with: "")
        var str = self
        str = self.replacingOccurrences(of: "\\", with: "")
        str = self.replacingOccurrences(of: "\\\\", with: "")
        str = self.replacingOccurrences(of: "\\\\\\", with: "")
        let jsonData:Data = str.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as? NSArray
        }
        return nil
    }
    
    /**设置字符串中字符和数字的大小**/
    func modifyNumberFont(_ font:UIFont, _ numFont:UIFont) -> NSMutableAttributedString {
        do {
            let regular = try NSRegularExpression(pattern: "([0-9]\\d*\\.?\\d*)", options: .caseInsensitive)
            let result = regular.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count))
            let attributed = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.font:font])
            for index in 0 ..< result.count {
                attributed.setAttributes([NSAttributedString.Key.font:numFont], range: result[index].range)
            }
            return attributed
        } catch  {
            print(error)
            return NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.font:font])
        }
    }
    
    /**判断身份证**/
    func regularIDCard() -> Bool {
        //判断是否为空
        if self.count <= 0 {
            return false
        }
        //判断是否是18位，末尾是否是x
        let regex2: String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let identityCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex2)
        if !identityCardPredicate.evaluate(with: self) {
            return false
        }
        //判断生日是否合法
        let range = NSRange(location: 6, length: 8)
        let datestr: String = (self as NSString).substring(with: range)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if formatter.date(from: datestr) == nil {
            return false
        }
        //判断校验位
        if  self.count == 18 {
            let idCardWi: [String] = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"]
            //将前17位加权因子保存在数组里
            let idCardY: [String] = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            var idCardWiSum: Int = 0
            //用来保存前17位各自乖以加权因子后的总和
            for i in 0..<17 {
                idCardWiSum += Int((self as NSString).substring(with: NSRange(location: i, length: 1)))! * Int(idCardWi[i])!
            }
            let idCardMod: Int = idCardWiSum % 11
            //计算出校验码所在数组的位置
            let idCardLast: String = self.substring(from: self.index(self.endIndex, offsetBy: -1))
            //得到最后一位身份证号码
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if idCardMod == 2 {
                if idCardLast == "X" || idCardLast == "x" {
                    return true
                } else {
                    return false
                }
            } else {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if (idCardLast as NSString).integerValue == Int(idCardY[idCardMod]) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
}

public extension String {
    func toBase64() -> String {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func toString() -> String {
        if let decodedData = NSData.init(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            let decodedString = NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            delog(decodedString)
            return decodedString
        }
        return "解析失败"
    }
}

public extension Int64 {
    ///将整型转成价格
    var priceFormatterString: String? {
        return String(format: "%.2f", Double(self) / 100)
    }
}
