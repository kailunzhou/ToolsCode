import Foundation

public class Joggle: NSObject {
    public static let `default` = Joggle()
    
    /**** Other ****/
    ///获取用户基本信息
    let getUserInfo = "/user/getUserInfo"
    ///获取版本号，返回给APP是否更新
    let getVer = "/userCenter/getVer"
    ///获取用户注册协议内容
    let getRegistProtocol = "/userCenter/getRegistProtocol"
    
    /**** Login ****/
    ///校验手机号
    let checkMobile = "/user/checkMobile"
    ///登录
    let login = "/user/login"
    ///用户注册
    let register = "/user/register"
    ///更改密码
    let changePassword = "/user/changePassword"
    ///更改手机号
    let updateMobile = "/user/updateMobile"
    ///获取验证码
    let getCode = "/smsCode/getCode"
    ///校验验证码
    let checkCode = "/smsCode/checkCode"
    
    /**** Feedback ****/
    ///新增意见反馈
    let addFeedback = "/userCenter/addFeedback"
    ///获取我的意见反馈列表
    let feedback = "/userCenter/feedback"
    
    /**** CommonQuestions ****/
    ///获取常见问题列表
    let commonQuestions = "/userCenter/commonQuestions"
    
    /**** 支付方式管理 ****/
    ///获取支付方式列表
    let getPayChannelList = "/userPayMethod/getPayChannelList"
    ///获得绑定支付方式跳转地址
    let bindingPayChannel = "/userPayMethod/bindingPayChannel"
    ///用户绑定详细信息
    let upPayInfo = "/userPayMethod/upPayInfo"
    ///解绑支付方式
    let unPayMethod = "/userPayMethod/unPayMethod"
    
    /**** Home ****/
    ///获取首页所有展示信息
    let getHomeViews = "/index/getHomeViews"
    ///获取首页新闻选项详细列表
    let getHomeNewsOptionViewList = "/index/getHomeNewsOptionViewList"
    
    /**** 乘车详情 ****/
    ///乘车记录
    let alipayOrderInfoList = "/order/list"
    ///乘车详情
    let alipayOrderInfoDetail = "/order/detail"
    ///发起主动扣款
    let alipayOrderInfoPayOrder = "/order/payOrder"
    
    /**** 开通扫码乘车 ****/
    ///验证身份证信息
    let authID = "/cards/authID"
    ///验证实体卡信息
    let verificationPhysicalCard = "/cards/verificationPhysicalCard"
    ///绑定一卡通账户
    let openUniversalCard = "/cards/openUniversalCard"
    
    /******** 夏都通部分 ********/
    ///获取我的信息列表
    let messages = "/userCenter/messages"
    
    /**** Report ****/
    ///卡号查询
    let cardQuery = "/nfc/card/cardQuery"
    ///卡号挂失
    let lossCard = "/nfc/card/lossCard"
    ///挂失记录查询
    let cardLossOrderList = "/nfc/card/cardLossOrderList"
    /**** Invoice ****/
    ///充值订单查询
    let cardOrderList = "/nfc/card/cardOrderList"
    ///开发票
    let doinvoice = "/invoice/doinvoice"
    ///发票开具记录查询
    let invoiceList = "/invoice/invoiceList"
    
    public var joggle: String?//服务器地址
    public var channelNo: String?//渠道号
    public var sign: String?//签名
    
    public func initParam(_ joggle: String?, _ channelNo: String?, _ sign: String?) {
        self.joggle = joggle
        self.channelNo = channelNo
        self.sign = sign
    }
}

public extension String {
    func netUrl() -> String {
        return (Joggle.default.joggle ?? "") + self
    }
}
