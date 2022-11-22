import request from '@/utils/request'
const service = window.lwConfig.services.wecom
const weChat = window.lwConfig.services.weChat

/**
 * 获取应用的jsapi_ticket
 * @param {*} url 页面url
 */
export function getAgentTicket (url) {
  return request({
    url: service + '/ticket/getAgentTicket',
    params: {
      url,
      appType: 1,
    },
  })
}

export function getWxTicket (data) {
  return request({
    url: weChat + '/ticket/getWxTicket',
    params: {
      url: data,
    },
  })
}


// /**
//  * 获取企业的jsapi_ticket
//  * @param {*} url 页面url
//  */
// export function getAppTicket(url) {
//   return request({
//     url: service + '/ticket/getAppTicket',
//     params: {
//       url,
//       appType: 1,
//     },
//   })
// }

/**
 * 企业微信端登录 / 获取token接口
 * @param {*} auth_code
 */
export function login (auth_code) {
  return request({
    url: '/auth/linkLogin',
    method: 'get',
    params: {
      auth_code,
    },
  })
}

/**
 * 企微端获取登录用户信息
 */
export function getUserInfo () {
  return request({
    url: '/system/user/getInfo',
  })
}

/**
 * 获取微信授权链接
 * @param {*} redirectUrl 回调跳转地址
 * @returns
 */
export function getWxRedirect (redirectUrl = location.href) {
  return request({
    url: '/auth/wxRedirect',
    method: 'get',
    params: {
      redirectUrl,
    },
  })
}

/**
 * 微信获取token接口
 * @param {*} code 是 code码 必填
 * @param {*} openId 否 微信用户ID 非必填
 * @returns
 */
export function wxLogin (code, openId) {
  return request({
    url: '/auth/wxLogin',
    method: 'get',
    params: {
      code,
      openId,
    },
  })
}

/**
 * 获取微信授权用户信息
 * @param {*} openId
 */
export function getWechatUserInfo () {
  return request({
    url: `/system/user/getWxInfo`,
  })
}

/**
 * 行政区划
 * @param {*} param
 {
  id,integer,false,,区域ID,
parentId,integer,false,,父ID,
name,string,false,,区域名称,
ePrefix,string,false,,拼音首字母,
 }
 * @returns
 */
export function getAreaList (params) {
  return request({
    url: `/system/area/list`,
    params,
  })
}
