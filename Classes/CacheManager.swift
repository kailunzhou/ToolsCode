import UIKit
import ObjectMapper

final class Persistence {
    
    //单例
    public static let `default` = Persistence()
    
    /// 缓存字典数据
    ///
    /// - Parameters:
    ///   - dict: 字典数据
    ///   - fileName: 文件名称
    func writeDict(_ dict: Dictionary<String, Any>, withName fileName: String) -> Bool {
        
        let result = (dict as NSDictionary).write(toFile: filePath(fileName), atomically: true)
        print(result)
        return result
    }
    
    func getDict(withName fileName: String) -> Dictionary<String, Any>? {
        
        let dict = NSDictionary(contentsOfFile: filePath(fileName))
        if dict != nil {
            return dict as? Dictionary
        } else {
            return nil
        }
        
    }
    
    /// 缓存数组数据
    ///
    /// - Parameters:
    ///   - arr: 数组数据 数组元素必须是基础类型
    ///   - fileName: 文件名称
    func writeArray(_ array: Array<Any>, withName fileName: String) -> Bool {
        
        let result = (array as NSArray).write(toFile: filePath(fileName), atomically: true)
        print(result)
        return result
    }
    
    func getArray(withName fileName: String) -> Array<Any>? {
        
        let array = NSArray(contentsOfFile: filePath(fileName))
        if array != nil {
            return array as? Array
        } else {
            return nil
        }
    }
    
    /// UserDefaults缓存
    ///
    /// - Parameters:
    ///   - obj: obj description
    ///   - key: key description
    func setObjForKey(_ obj: Any?, forKey key: String) {
        UserDefaults.standard.set(obj, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func objForKey(_ key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    /// 存储对象模型
    ///
    /// - Parameters:
    ///   - model: 模型(需要遵循Mappable协议)
    ///   - fileName: 存储文件名
    func writeModel(_ model: Mappable?, withName fileName: String) -> Bool {
        if let m = model {
            let jsonStr = m.toJSONString(prettyPrint: true)
            do {
                try jsonStr?.write(toFile: filePath(fileName), atomically: true, encoding: String.Encoding.utf8)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        else {
            try? FileManager.default.removeItem(atPath: filePath(fileName))
            return true
        }
    }
    /// 缓存模型数组
    ///
    /// - Parameters:
    ///   - models: 模型数组
    ///   - fileName: 存储文件名
    /// - Returns: 返回结果
    func writeModels<T: Mappable>(_ models: [T]?, withName fileName: String) -> Bool {
        if let arr = models {
            let jsonStr = arr.toJSONString(prettyPrint: true)
            do {
                try jsonStr?.write(toFile: filePath(fileName), atomically: true, encoding: String.Encoding.utf8)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        else {
            try? FileManager.default.removeItem(atPath: filePath(fileName))
            return true
        }
    }
    
    func getModel<T: Mappable>(_ meta: T.Type, withName fileName: String) -> T? {
        do {
            let jsonStr = try String(contentsOfFile: filePath(fileName), encoding: String.Encoding.utf8)
            return T(JSONString: jsonStr)
        } catch {
            delog(error.localizedDescription)
            return nil
        }
    }
    
    func getModels<T: Mappable>(_ meta: T.Type, withName fileName: String) -> [T]? {
        do {
            let jsonStr = try String(contentsOfFile: filePath(fileName), encoding: String.Encoding.utf8)
            return [T](JSONString: jsonStr)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func clearModels(_ fileName: String) -> Bool {
        do {
            try " ".write(toFile: filePath(fileName), atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// 文件全路径
    ///
    /// - Parameter fileName: 文件名称
    /// - Returns: 返回文件全路径
    public func filePath(_ fileName: String) -> String {
        return documentPath() + "/\(fileName)"
    }
    /// document路径
    ///
    /// - Returns: 返回document路径
    private func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
}
