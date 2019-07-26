import Foundation
import Alamofire
import MBProgressHUD

private let NetworkRequestShareInstance = Net()

class Net {
    var timeStamp = getTimestamp()
    var requestId = getRequestId()
    let channelNo = Joggle.default.channelNo ?? ""
    let version = "v1"//版本号
    
    class var share : Net {
        return NetworkRequestShareInstance
    }
    
    private func createHTTPHeader() -> HTTPHeaders? {
        timeStamp = getTimestamp()
        requestId = getRequestId()
        let hmac = "requestId=\(requestId)&channelNo=\(channelNo)&timeStamp=\(timeStamp)&version=\(version)\(Joggle.default.sign ?? "")".md5()
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "channelNo": channelNo,
            "timeStamp": timeStamp,
            "hmac": hmac,
            "requestId": requestId,
            "version": version
        ]
        if let token = Session.default.token {
            headers["token"] = token
        }
        return headers
    }
    
    private func signOutData() {
        Session.default.loginUser = nil
        Session.default.token = nil
    }
    
    func getRequest(urlString: String,
                    params : [String : Any]?,
                    view: UIView?,
                    success : @escaping (_ response : [String : AnyObject])->(),
                    failture : @escaping (_ error : Error)->()) {
        guard let header: HTTPHeaders = createHTTPHeader() else {
            return
        }
        ///拼接网络请求字符串
        var url = urlString + "?"
        if let par = params {
            for item in par.keys {
                url += "\(item)=\(par[item]!)&"
            }
        }
        url.removeLast()
        if view != nil {
            MBProgressHUD.showLoading(view, with: nil)
        }
        Alamofire.request(url.toUTF8String(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            if view != nil {
                MBProgressHUD.dismisHUD(view)
            }
            ///状态码判断
            guard let status = response.response?.statusCode else {
                delog("-***************************************************************-")
                delog(params)
                delog(urlString + "请求失败")
                if let err = response.error {
                    failture(err)
                }
                return
            }
            if let data = response.data as NSData?,
                let dic = dataToJSON(data: data as Data) as? [String: AnyObject] {
                switch status {
                case 200, 201, 203:
                    if let Status = dic["Status"] as? String, Status == "111111" {
                        self.signOutData()
                        MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                    } else {
                        success(dic)
                    }
                case 401:
                    self.signOutData()
                    MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                    break
                default:
                    if let msg = dic["message"] as? String {
                        MBProgressHUD.showFailure(nil, with: msg, complete: nil)
                    }
                    delog(status)
                    break
                }
            }
        }
    }
    
    func postRequest(urlString: String,
                     params : [String : Any]?,
                     view: UIView?,
                     success : @escaping (_ response : [String : AnyObject])->(),
                     failture : @escaping (_ error : Error)->()) {
        guard let header: HTTPHeaders = createHTTPHeader() else {
            return
        }
        ///拼接网络请求字符串
        var url = urlString + "?"
        if let par = params {
            for item in par.keys {
                url += "\(item)=\(par[item]!)&"
            }
        }
        url.removeLast()
        if view != nil {
            MBProgressHUD.showLoading(view, with: nil)
        }
        Alamofire.request(url.toUTF8String(), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            if view != nil {
                MBProgressHUD.dismisHUD(view)
            }
            ///状态码判断
            guard let status = response.response?.statusCode else {
                delog("-***************************************************************-")
                delog(params)
                delog(urlString + "请求失败")
                if let err = response.error {
                    failture(err)
                }
                return
            }
            if let data = response.data as NSData?,
                let dic = dataToJSON(data: data as Data) as? [String: AnyObject] {
                switch status {
                case 200, 201, 203:
                    if let Status = dic["Status"] as? String, Status == "111111" {
                        self.signOutData()
                        MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                    } else {
                        success(dic)
                    }
                case 401:
                    self.signOutData()
                    MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                    break
                default:
                    if let msg = dic["message"] as? String {
                        MBProgressHUD.showFailure(nil, with: msg, complete: nil)
                    }
                    delog(status)
                    break
                }
            }
        }
    }
    
    func Request(method: HTTPMethod,
                 urlString : String,
                 params : [String : Any],
                 view: UIView?,
                 success : @escaping (_ response : [String : AnyObject])->(),
                 failture : @escaping (_ error : Error)->()) {
        guard let header: HTTPHeaders = createHTTPHeader() else {
            return
        }
        if view != nil {
            MBProgressHUD.showLoading(view, with: nil)
        }
        Alamofire.request(urlString, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            delog(response)
            if view != nil {
                MBProgressHUD.dismisHUD(view)
            }
            guard let status = response.response?.statusCode else {
                delog("-***************************************************************-")
                delog(params)
                delog(urlString + "请求失败")
                if let err = response.error {
                    failture(err)
                }
                return
            }
            if let data = response.data as NSData?,
                let dic = dataToJSON(data: data as Data) as? [String: AnyObject] {
                delog(urlString)
                switch status {
                case 200, 201, 203:
                    success(dic) ///回调
                    break
                case 401:
                    self.signOutData()
                    MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                    break
                default:
                    if let msg = dic["message"] as? String {
                        MBProgressHUD.showFailure(nil, with: msg, complete: nil)
                    }
                    delog(status) ///失败回调
                    break
                }
            }
        }
        
    }
    
    func uploadPic(urlString : String,
                   params:[String: String]?,
                   view: UIView?,
                   data: [UIImage],
                   name: [String]?,
                   success : @escaping (_ response : [String : AnyObject])->(),
                   failture : @escaping (_ error : Error)->()){
        guard let header: HTTPHeaders = createHTTPHeader() else {
            return
        }
        if view != nil {
            MBProgressHUD.showLoading(view, with: nil)
        }
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            if let paramsDic = params {
                for (key, value) in paramsDic {
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }
            for i in 0 ..< data.count {
                var arc = String()
                for _ in 0...9 {
                    arc += "\(arc4random() % 9)"
                }
                multipartFormData.append(data[i].jpegData(compressionQuality: 0.3)!, withName: "files", fileName: "file\(arc).png", mimeType: "image/png")
            }
        }, to: urlString, headers: header, encodingCompletion: { encodingResult in
            MBProgressHUD.dismisHUD(view)
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let status = response.response?.statusCode else {
                        delog("-***************************************************************-")
                        delog(params)
                        delog(urlString + "请求失败")
                        if let err = response.error {
                            failture(err)
                        }
                        return
                    }
                    if let data = response.data as NSData?,
                        let dic = dataToJSON(data: data as Data) as? [String: AnyObject] {
                        delog(urlString)
                        switch status {
                        case 200, 201, 203:
                            if let Status = dic["Status"] as? String, Status == "111111" {
                                self.signOutData()
                                MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                            } else {
                                success(dic)
                            }
                        case 401:
                            self.signOutData()
                            MBProgressHUD.showFailure(nil, with: "请重新登录", complete: nil)
                            break
                        default:
                            if let msg = dic["message"] as? String {
                                MBProgressHUD.showFailure(nil, with: msg, complete: nil)
                            }
                            delog(status) ///失败回调
                            break
                        }
                    }
                }
            case .failure(let error):
                failture(error)
            }
        })
    }
}
