import Foundation

typealias handle = () -> Void

public func delog(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    print(fileName + "      " + "/\(rowCount)行" + "\n")
    #endif
}

public func delog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    print(fileName + "      " + "/\(rowCount)行" + "      \(message)" + "\n")
    #endif
}
