import request from '@/utils/request'
import { dataURLtoFile } from '@/utils/common'

const service = window.CONFIG.services.system

export function upload(data) {
  return request({
    url: service + '/file/upload',
    method: 'POST',
    data,
  })
}

/**
 * 下载网络连接文件
 * @param {*} params
{
  url=文件路径&
  name=文件名称，带后缀
}
 */
export function download(url, name) {
  return (
    window.lwConfig.DOMAIN +
    window.CONFIG.services.system +
    `/common/download/url?url=${url}&name=${name}`
  )
}

/**
 * 上传文件
 * @param {*} data
{
  "dataURL": 本地文件(base64)
}
 */
export function uploadDataURL(dataURL) {
  const data = new window.FormData()
  const f = dataURLtoFile(dataURL)
  data.append('file', f)

  return request({
    url: window.CONFIG.services.system + '/file/upload',
    method: 'post',
    processData: false,
    data,
  })
}

// 省市区 级联数据
export function getProCityList(data) {
  return request({
    url: service + '/system/area/list',
    params: data,
  })
}

/**
 * 获取微信授权链接
 * @param {*} redirectUrl 回调跳转地址
 * @returns
 */
export function getWxRedirect(redirectUrl = location.href) {
  return request({
    url: service + '/auth/wxRedirect',
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
export function wxLogin(code, openId) {
  return request({
    url: service + '/auth/wxLogin',
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
export function getWechatUserInfo() {
  return request({
    url: service + `/system/user/getWxInfo`,
  })
}
