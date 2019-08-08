import Foundation
import UIKit
import MBProgressHUD

private let NetworkMethodShareInstance = NetMethod()

public class NetMethod {
    public class var share : NetMethod {
        return NetworkMethodShareInstance
    }
}

public extension NetMethod {
    /**** Other ****/
    ///获取用户基本信息
    func getUserInfo(okAction : @escaping ()->()) {
        ///用户信息失效
        if Session.default.token == nil {
            Session.default.loginUser = nil
            return
        }
        Net.share.getRequest(urlString: Joggle.default.getUserInfo.netUrl(), params: nil, view: nil, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let Data = result["Data"] as? [String: Any], let model = UserInfo(JSON: Data) {
                        Session.default.loginUser = model
                        okAction()
                    }
                default:
                    if let message = result["Message"] as? String {
                        delog(message)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获取协议内容
    func getProtocol(_ type: String?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let types = type else {
            return
        }
        let param: [String: Any] = ["type": types]
        Net.share.getRequest(urlString: Joggle.default.getRegistProtocol.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    /**** Login ****/
    ///校验手机号
    func checkMobile(_ mobile: String?, _ view: UIView?, loginAction : @escaping ()->(), registerAction : @escaping ()->()) {
        guard let phone = mobile, phone.count == 11 else {
            MBProgressHUD.showMessage(view, with: "请输入正确的手机号", complete: nil)
            return
        }
        let param: [String: Any] = ["mobile": phone]
        Net.share.getRequest(urlString: Joggle.default.checkMobile.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let data = result["Data"] as? [String: Any], let ExistType = data["ExistType"] as? Int {
                        switch ExistType {
                        case 1:
                            loginAction()
                        case 2:
                            delog("该手机号未注册")
                            registerAction()
                        default:
                            break
                        }
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///验证密码
    func isPasswordValid(_ string: String) -> Bool {
        let numberRegex: NSPredicate = NSPredicate(format:"SELF MATCHES %@","[0-9]*")
        let letterRegex: NSPredicate = NSPredicate(format:"SELF MATCHES %@","[a-zA-Z]*")
        var haveNum = false
        var haveLetter = false
        var haveOther = false
        for x in string {
            let str = String(x)
            if numberRegex.evaluate(with: str) {//数字
                haveNum = true
            } else if letterRegex.evaluate(with: str) {//字母
                haveLetter = true
            } else {//符号
                haveOther = true
            }
        }
        var typeCount: Int = 0
        if haveNum {
            typeCount += 1
        }
        if haveLetter {
            typeCount += 1
        }
        if haveOther {
            typeCount += 1
        }
        if typeCount >= 2 {
            return true
        } else {
            return false
        }
    }
    ///登录
    func login(_ mobile: String?, _ password: String?, _ view: UIView?, okAction: @escaping ()->()) {
        guard let phone = mobile, let psw = password, psw.count >= 6 && psw.count <= 16 && isPasswordValid(psw) else {
            MBProgressHUD.showFailure(view, with: "请输入有效的密码", complete: nil)
            return
        }
        let param: [String: Any] = ["mobile": phone,
                                    "password": "\(psw)123456\(phone)".md5()]
        Net.share.postRequest(urlString: Joggle.default.login.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    delog("登录成功")
                    if let Data = result["Data"] as? [String: Any], let token = Data["token"] as? String {
                        ///缓存账号
                        Session.default.phone = mobile
                        ///缓存密码
                        Session.default.password = password
                        //缓存token
                        Session.default.token = token
                        NetMethod.share.getUserInfo {}
                        okAction()
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///用户注册
    func register(_ mobile: String?, _ password: String?, _ view: UIView?, okAction: @escaping ()->()) {
        guard let phone = mobile, let psw = password, psw.count >= 6 && psw.count <= 16 && isPasswordValid(psw) else {
            MBProgressHUD.showFailure(view, with: "请设置有效的密码", complete: nil)
            return
        }
        let param: [String: Any] = ["mobile": phone,
                                    "password": "\(psw)123456\(phone)".md5()]
        delog(param)
        Net.share.postRequest(urlString: Joggle.default.register.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    delog("注册成功")
                    if let Data = result["Data"] as? [String: Any], let token = Data["token"] as? String {
                        ///缓存账号
                        Session.default.phone = mobile
                        ///缓存密码
                        Session.default.password = password
                        //缓存token
                        Session.default.token = token
                        NetMethod.share.getUserInfo {}
                        okAction()
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///更改密码
    func changePassword(_ mobile: String?, _ password: String?, _ view: UIView?, okAction: @escaping ()->()) {
        guard let phone = mobile, let psw = password, psw.count >= 6 && psw.count <= 16 && isPasswordValid(psw) else {
            MBProgressHUD.showFailure(view, with: "请设置有效的密码", complete: nil)
            return
        }
        let param: [String: Any] = ["mobile": phone,
                                    "password": "\(psw)123456\(phone)".md5()]
        delog(param)
        Net.share.postRequest(urlString: Joggle.default.changePassword.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    okAction()
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获取验证码
    func getSMSCode(_ mobile: String?, _ type: String?, _ view: UIView?, okAction : @escaping ()->()) {
        guard let smsType = type, let phone = mobile else {
            return
        }
        let param: [String: Any] = ["mobile": phone,
                                    "smsType": smsType]//1.注册,2.重置密码,3.更换手机号
        delog(param)
        Net.share.postRequest(urlString: Joggle.default.getCode.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    delog("短信验证码发送成功")
                    okAction()
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///校验验证码
    func checkSMSCode(_ mobile: String?, _ type: String?, _ view: UIView?, _ vcode: String?, okAction: @escaping ()->()) {
        guard let phone = mobile, let smsType = type, let smsCode = vcode, smsCode.count == 6 else {
            return
        }
        let param: [String: Any] = ["mobile": phone,
                                    "smsType": smsType,
                                    "smsCode": smsCode]//1.注册,2.重置密码,3.更换手机号
        delog(param)
        Net.share.getRequest(urlString: Joggle.default.checkCode.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    okAction()
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    /**** Home ****/
    ///获取首页所有展示信息
    func getHomeViews(_ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        Net.share.getRequest(urlString: Joggle.default.getHomeViews.netUrl(), params: nil, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获取首页新闻选项详细列表
    func getHomeNewsOptionViewList(_ newsOptionId: String?, _ page: String?, _ view: UIView?, endAction : @escaping ()->(), okAction : @escaping (_ dataList: [[String: Any]]?)->()) {
        guard let newsOptionIds = newsOptionId, let pages = page else {
            return
        }
        let param: [String: Any] = ["newsOptionId": newsOptionIds,
                                    "page": pages]
        Net.share.getRequest(urlString: Joggle.default.getHomeNewsOptionViewList.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            endAction()
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let Data = result["Data"] as? [String: Any], let dataList = Data["homeNewsOptionViewDetailRespList"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///充值订单查询
    func cardOrderList(_ cardNo: String?, _ queryDate: String?, _ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        guard let cardNos = cardNo, let queryDates = queryDate else {
            return
        }
        let param: [String: Any] = ["cardNo": cardNos,
                                    "queryDate": queryDates]
        Net.share.postRequest(urlString: Joggle.default.cardOrderList.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///开发票
    func doinvoice(_ amt: String?, _ cardNo: String?, _ orderIds: [String]?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let amts = amt, let cardNos = cardNo else {
            return
        }
        guard let orderIdss = orderIds, orderIdss.count > 0 else {
            MBProgressHUD.showFailure(view, with: "请勾选至少一个充值记录进行开票", complete: nil)
            return
        }
        let param: [String: Any] = ["amt": amts,
                                    "cardNo": cardNos,
                                    "orderIds": orderIdss]
        Net.share.postRequest(urlString: Joggle.default.doinvoice.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog()
        }
    }
    func invoiceList(_ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        Net.share.postRequest(urlString: Joggle.default.invoiceList.netUrl(), params: nil, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]] {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///卡号查询
    func cardQuery(_ IDNo: String?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let IDNos = IDNo, IDNos.regularIDCard() else {
            MBProgressHUD.showFailure(view, with: "请输入正确的身份证号", complete: nil)
            return
        }
        let param: [String: Any] = ["IDNo": IDNos]
        Net.share.postRequest(urlString: Joggle.default.cardQuery.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///卡号挂失
    func lossCard(_ IDNo: String?, _ cardNo: String?, _ view: UIView?, okAction: @escaping ()->()) {
        guard let IDNos = IDNo, let cardNos = cardNo else {
            return
        }
        let param: [String: Any] = ["IDNo": IDNos,
                                    "cardNo": cardNos]
        Net.share.postRequest(urlString: Joggle.default.lossCard.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    okAction()
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///挂失记录查询
    func cardLossOrderList(_ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        Net.share.postRequest(urlString: Joggle.default.cardLossOrderList.netUrl(), params: nil, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    /**** Mall ****/
    /**** Traffic ****/
    ///用户绑定详细信息
    func upPayInfo(_ channelId: Int64?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let channelIds = channelId else {
            return
        }
        let param: [String: Any] = ["channelId": channelIds]
        Net.share.getRequest(urlString: Joggle.default.upPayInfo.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///解绑支付方式
    func unPayMethod(_ channelId: Int64?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let channelIds = channelId else {
            return
        }
        let param: [String: Any] = ["channelId": channelIds]
        Net.share.postRequest(urlString: Joggle.default.unPayMethod.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///验证身份证信息
    func authID(_ cardID: String?, _ idCard: String?, _ view: UIView?, verifyAction: @escaping (_ isSuccess: Bool)->()) {
        guard let cardIDs = cardID, cardIDs.count > 0 else {
            MBProgressHUD.showFailure(view, with: "请先验证实体卡号", complete: nil)
            return
        }
        guard let idCards = idCard, idCards.count > 0 else {
            MBProgressHUD.showFailure(view, with: "请输入身份证号码", complete: nil)
            return
        }
        let param: [String: Any] = ["cardID": cardIDs,
                                    "idCard": idCards]
        Net.share.postRequest(urlString: Joggle.default.authID.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String, Status == "000000" {//验证成功
                verifyAction(true)
            } else {//验证失败
                verifyAction(false)
            }
        }) { (err) in
            delog(err)
        }
    }
    ///验证实体卡信息
    func verificationPhysicalCard(_ cardID: String?, _ view: UIView?, verifyAction: @escaping (_ isSuccess: Bool)->()) {
        guard let cardIDs = cardID else {
            MBProgressHUD.showFailure(view, with: "请输入实体卡号", complete: nil)
            return
        }
        let param: [String: Any] = ["cardID": cardIDs]
        Net.share.getRequest(urlString: Joggle.default.verificationPhysicalCard.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String, Status == "000000" {//验证成功
                verifyAction(true)
            } else {//验证失败
                verifyAction(false)
            }
        }, failture: { (err) in
            delog(err)
        })
    }
    ///绑定一卡通账户
    func openUniversalCard(_ cardID: String?, _ idCard: String?, _ view: UIView?, okAction: @escaping ()->()) {
        guard let cardIDs = cardID else {
            MBProgressHUD.showFailure(view, with: "请先验证实体卡号", complete: nil)
            return
        }
        guard let idCards = idCard else {
            MBProgressHUD.showFailure(view, with: "请先验证身份证号", complete: nil)
            return
        }
        if Session.default.loginUser?.payChannelList == nil {//未绑定支付方式
            MBProgressHUD.showFailure(view, with: "请先绑定支付方式", complete: nil)
            return
        }
        let param: [String: Any] = ["cardID": cardIDs,
                                    "idCard": idCards]
        Net.share.postRequest(urlString: Joggle.default.openUniversalCard.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    delog("开通成功")
                    okAction()
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获取支付方式列表
    func getPayChannelList(_ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        Net.share.getRequest(urlString: Joggle.default.getPayChannelList.netUrl(), params: nil, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获得绑定支付方式跳转地址
    func bindingPayChannel(_ channelId: Int64?, _ payType: Int64?, _ returnUrl: String?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let channelIds = channelId, let payTypes = payType, let returnUrls = returnUrl else {
            return
        }
        let param: [String: Any] = ["channelId": "\(channelIds)",
            "payType": "\(payTypes)",
            "returnUrl": returnUrls]
        Net.share.getRequest(urlString: Joggle.default.bindingPayChannel.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///乘车记录
    func alipayOrderInfoList(_ page: String?, _ pageEntry: String?, _ qtype: String?, _ view: UIView?, endAction: @escaping ()->(), okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        guard let pages = page, let pageEntrys = pageEntry, let qtypes = qtype else {
            return
        }
        let param: [String: Any] = ["page": pages,
                                    "pageEntry": pageEntrys,
                                    "qtype": qtypes]
        Net.share.getRequest(urlString: Joggle.default.alipayOrderInfoList.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            endAction()
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///乘车详情
    func alipayOrderInfoDetail(_ outTradeNo: String?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let outTradeNos = outTradeNo else {
            return
        }
        let param: [String: Any] = ["outTradeNo": outTradeNos]
        Net.share.getRequest(urlString: Joggle.default.alipayOrderInfoDetail.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
        
    }
    ///发起主动扣款
    func alipayOrderInfoPayOrder(_ outTradeNo: String?, _ view: UIView?, okAction: @escaping (_ dataDic: [String: Any]?)->()) {
        guard let outTradeNos = outTradeNo else {
            return
        }
        let param: [String: Any] = ["outTradeNo": outTradeNos]
        Net.share.postRequest(urlString: Joggle.default.alipayOrderInfoPayOrder.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataDic = result["Data"] as? [String: Any] {
                        okAction(dataDic)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    /**** Life ****/
    /**** Mine ****/
    ///获取常见问题列表
    func commonQuestions(_ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        Net.share.getRequest(urlString: Joggle.default.commonQuestions.netUrl(), params: nil, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获取我的信息列表
    func messages(_ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        Net.share.getRequest(urlString: Joggle.default.messages.netUrl(), params: nil, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///新增意见反馈
    func addFeedback(_ content: String?, _ type: String?, _ img: UIImage?, _ view: UIView?, okAction: @escaping ()->()) {
        guard let contents = content , contents != "您的问题与意见，我们会悉心聆听…" else {
            MBProgressHUD.showFailure(view, with: "反馈内容不能为空", complete: nil)
            return
        }
        guard let mobile = Session.default.phone else {
            return
        }
        guard let types = type else {
            return
        }
        let param: [String: String] = ["content": contents,
                                       "mobile": mobile,
                                       "type": types]
        var imgAry: [UIImage] = []
        if let uploadImg = img {
            imgAry.append(uploadImg)
        }
        Net.share.uploadPic(urlString: Joggle.default.addFeedback.netUrl(), params: param, view: view, data: imgAry, name: nil, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    delog("添加反馈成功")
                    okAction()
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
    ///获取我的意见反馈列表
    func feedback(_ view: UIView?, okAction: @escaping (_ dataList: [[String: Any]]?)->()) {
        guard let mobile = Session.default.phone else {
            return
        }
        let param: [String: Any] = ["mobile": mobile]
        Net.share.getRequest(urlString: Joggle.default.feedback.netUrl(), params: param, view: view, success: { (result) in
            delog(result)
            if let Status = result["Status"] as? String {
                switch Status {
                case "000000":
                    if let dataList = result["Data"] as? [[String: Any]], dataList.count > 0 {
                        okAction(dataList)
                    } else {
                        okAction(nil)
                    }
                default:
                    if let message = result["Message"] as? String {
                        MBProgressHUD.showFailure(view, with: message, complete: nil)
                    }
                }
            }
        }) { (err) in
            delog(err)
        }
    }
}
