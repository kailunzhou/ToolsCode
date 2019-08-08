import Foundation

public class Joggle: NSObject {
    public static let `default` = Joggle()
    
    /**** Other ****/
    let getUserInfo = "/user/getUserInfo"//获取用户基本信息
    let getRegistProtocol = "/userCenter/getRegistProtocol"//获取用户注册协议内容
    let getVer = "/userCenter/getVer"//获取版本号，返回给APP是否更新
    /**** Login ****/
    let checkMobile = "/user/checkMobile"//校验手机号
    let login = "/user/login"//登录
    let register = "/user/register"//用户注册
    let changePassword = "/user/changePassword"//更改密码
    let getCode = "/smsCode/getCode"//获取验证码
    let checkCode = "/smsCode/checkCode"//校验验证码
    /**** Home ****/
    let getHomeViews = "/index/getHomeViews"//获取首页所有展示信息
    let getHomeNewsOptionViewList = "/index/getHomeNewsOptionViewList"//获取首页新闻选项详细列表
    let cardOrderList = "/nfc/card/cardOrderList"///充值订单查询
    let doinvoice = "/invoice/doinvoice"///开发票
    let invoiceList = "/invoice/invoiceList"///发票开具记录查询
    let cardQuery = "/nfc/card/cardQuery"///卡号查询
    let lossCard = "/nfc/card/lossCard"///卡号挂失
    let cardLossOrderList = "/nfc/card/cardLossOrderList"///挂失记录查询
    /**** Mall ****/
    /**** Traffic ****/
    let upPayInfo = "/userPayMethod/upPayInfo"//用户绑定详细信息
    let unPayMethod = "/userPayMethod/unPayMethod"//解绑支付方式
    let authID = "/cards/authID"//验证身份证信息
    let verificationPhysicalCard = "/cards/verificationPhysicalCard"//验证实体卡信息
    let openUniversalCard = "/cards/openUniversalCard" //绑定一卡通账户
    let getPayChannelList = "/userPayMethod/getPayChannelList"//获取支付方式列表
    let bindingPayChannel = "/userPayMethod/bindingPayChannel"//获得绑定支付方式跳转地址
    let alipayOrderInfoList = "/order/list"//乘车记录
    let alipayOrderInfoDetail = "/order/detail"//乘车详情
    let alipayOrderInfoPayOrder = "/order/payOrder"//发起主动扣款
    /**** Life ****/
    /**** Mine ****/
    let updateMobile = "/user/updateMobile"//更改手机号
    let commonQuestions = "/userCenter/commonQuestions"//获取常见问题列表
    let messages = "/userCenter/messages"//获取我的信息列表
    let addFeedback = "/userCenter/addFeedback"//新增意见反馈
    let feedback = "/userCenter/feedback"//获取我的意见反馈列表
    
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
