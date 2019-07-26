import Foundation

public class Joggle: NSObject {
    public static let `default` = Joggle()
    
    /**** Other ****/
    let getUserInfo = "/member/getUserInfo"//获取用户基本信息
    let getRegistProtocol = "/my/getRegistProtocol"//获取用户注册协议内容
    /**** Login ****/
    let checkMobile = "/member/checkMobile"//校验手机号
    let login = "/member/login"//登录
    let register = "/member/register"//用户注册
    let changePassword = "/member/changePassword"//更改密码
    let getCode = "/smsCode/getCode"//获取验证码
    let checkCode = "/smsCode/checkCode"//校验验证码
    /**** Home ****/
    let getHomeViews = "/xn/getHomeViews"//获取首页所有展示信息
    let getHomeNewsOptionViewList = "/xn/getHomeNewsOptionViewList"//获取首页新闻选项详细列表
    /**** Mall ****/
    /**** Traffic ****/
    let upPayInfo = "/member/upPayInfo"//用户绑定详细信息
    let unPayMethod = "/member/unPayMethod"//解绑支付方式
    let authID = "/cards/authID"//验证身份证信息
    let verificationPhysicalCard = "/cards/verificationPhysicalCard"//验证实体卡信息
    let openUniversalCard = "/cards/openUniversalCard" //绑定一卡通账户
    let getPayChannelList = "/channels/getPayChannelList"//获取支付方式列表
    let bindingPayChannel = "/channels/bindingPayChannel"//获得绑定支付方式跳转地址
    let alipayOrderInfoList = "/alipayOrderInfo/list"//乘车记录
    let alipayOrderInfoDetail = "/alipayOrderInfo/detail"//乘车详情
    let alipayOrderInfoPayOrder = "/alipayOrderInfo/payOrder"//发起主动扣款
    /**** Life ****/
    /**** Mine ****/
    let updateMobile = "/member/updateMobile"//更改手机号
    let commonQuestions = "/my/commonQuestions"//获取常见问题列表
    let messages = "/my/messages"//获取我的信息列表
    let addFeedback = "/my/addFeedback"//新增意见反馈
    let feedback = "/my/feedback"//获取我的意见反馈列表
    
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
