import request from '@/utils/request'

// 登录方法
export function login(username, password, code, uuid) {
  const data = {
    username,
    password,
    code,
    uuid,
  }
  return request({
    url: '/auth/accountLogin',
    method: 'post',
    data: data,
  })
}

// 获取企微二维码和登录二维码
export function getCodeInSyetem() {
  return request({
    url: '/auth/findLoginParam',
  })
}

// 获取用户详细信息
export function getInfo() {
  return request({
    url: '/system/user/getInfo',
    method: 'get',
  })
}

// 退出方法
export function logout() {
  return request({
    url: '/logout',
    method: 'post',
  })
}

// 获取验证码
export function getCodeImg() {
  return request({
    url: '/code',
    method: 'get',
  })
}

// 获取应用待开发授权码
export function getRegisterQrCode() {
  return request({
    url: '/auth/getRegisterQrCode',
    method: 'get',
  })
}

/**
 * 企业微信扫码回调接口(登录)
 * @param {*} auth_code
 */
export function wxQrLogin(auth_code) {
  return request({
    url: '/auth/qrLogin',
    method: 'get',
    params: {
      authCode: auth_code,
    },
  })
}

/**
 * 获取扫码登陆回调地址
 */
export function findWxQrLoginInfo() {
  return request({
    url: '/auth/qrLoginUrl',
    method: 'get',
  })
}

/**
 * 企业微信推广注册链接
 */
export function getExtensionRegisterUrl() {
  return request({
    url: '/auth/weExtensionRegisterUrl',
    method: 'get',
  })
}

/**
 * 获取应用安装授权链接
 */
export function getInstallThirdAppUrl() {
  return request({
    url: '/auth/3rd_install',
    method: 'get',
    params: {
      authType: window.lwConfig.ENV === 'production' ? 0 : 1,
    },
  })
}

/**
 * 获取客服二维码
 */
export function getCustomerServiceQrUrl() {
  return request({
    url: '/auth/kfQrUrl',
    method: 'get',
  })
}

/**
 * 获取新手引导页用户信息
 */
export function noviceGuideInfo() {
  return request({
    url: '/open/config/findWeSideBar',
    method: 'get',
  })
}

// 试用手机号密码登录
export function probationLogin(params) {
  return request({
    url: '/auth/sysTrialAccount/applyLogin',
    method: 'post',
    data: params,
  })
}

// 图形验证码
export function getImageCode() {
  return request({
    url: '/auth/sysTrialAccount/captchaImage',
  })
}

// 获取短信验证码
export function getCodeInPhone(params) {
  return request({
    url: '/auth/sysTrialAccount/findVerifyCode',
    params,
  })
}

// 申请试用
export function applyFn(data) {
  return request({
    url: '/auth/sysTrialAccount/apply',
    method: 'post',
    data: data,
  })
}

// 重置密码
export function resetPwd(data) {
  return request({
    url: '/auth/sysTrialAccount/resetPwd',
    method: 'post',
    data,
  })
}
