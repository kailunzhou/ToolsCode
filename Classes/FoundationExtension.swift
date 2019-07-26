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
