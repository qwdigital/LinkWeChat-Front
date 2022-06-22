import request from '@/utils/request'
import config from '@/config'
const service = config.services.wecom

/**
 * 获取应用的jsapi_ticket
 * @param {*} url 页面url
 */
export function getAgentTicket(url, agentId) {
  return request({
    url: service + '/ticket/getAgentTicket',
    params: {
      url,
      agentId,
    },
  })
}

/**
 * 获取企业的jsapi_ticket
 * @param {*} url 页面url
 */
export function getAppTicket(url) {
  return request({
    url: service + '/ticket/getAppTicket',
    params: {
      url,
    },
  })
}

/**
 * 获取登录用户id
 * @param {*} code 授权码
 * @param {*} agentId 应用agentId
 */
export function getUserInfo(code, agentId) {
  return request({
    url: service + '/user/getUserInfo',
    params: {
      code,
      agentId,
    },
  })
}

/**
 * 获取授权用户openid
 * @param {*} code
 * @returns
 */
export function getUserOpenid(code) {
  return request({ url: `/weixin/auth/getToken?code=${code}` })
}

/**
 * 获取微信授权用户信息
 * @param {*} openId
 */
export function getWechatUserInfo(openId) {
  return request({
    url: `/weixin/auth/getUserInfo`,
    params: {
      openId,
      lang: 'zh_CN',
    },
  })
}
