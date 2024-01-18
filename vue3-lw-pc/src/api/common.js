// import { requestOpen } from '@/utils/request'
// const { get, post, put, del: _del } = requestOpen
// const serve = '/serve'

// /**
//  * 列表
//  * @param {*} data
// {
//   pageNum:
//   pageSize:
//   type:''
//  }
//  */
// export function getList(data) {
// return get(`${serve}/get`)
// }

// // 详情
// export function getDetail(id) {
//   return get(service + '/get/' + id)
// }

// // 删除
// export function del(id) {
// return _del(`${serve}/delete/${id}`)
// }

// /**
//  * 新增
//  * @param {*} data
//  * @returns
//  */
// export function add(data) {
// return post(`${serve}/add`, data)
// }

// // 修改
// export function update(data) {
// return put(`${serve}/update`, data)
// }

import { decryptAES } from '@/utils/jsencrypt'
import request from '@/utils/request'
import { dataURLtoFile } from '@/utils/common'

export function upload(data) {
  return request({
    url: '/file/upload',
    method: 'POST',
    data,
  })
}

// 获取cos配置
export function getCosConfig(params) {
  return request({
    url: '/file/get/config',
    params,
  }).then(({ data }) => {
    let res = {}
    Object.keys(data).forEach((key) => {
      res[key] = decryptAES(data[key])
    })
    return res
  })
}

// 获取视频第一帧
export function getVideoPic(params) {
  return request({
    url: '/file/getVideoFirstImg/',
    params,
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
  return window.lwConfig.BASE_API + `/common/download/url?url=${url}&name=${name}`
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
    url: '/file/upload',
    method: 'post',
    processData: false,
    data,
  })
}

// 省市区 级联数据
export function getProCityList(data) {
  return request({
    url: '/system/area/list',
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
export function wxLogin(code, openId) {
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
export function getWechatUserInfo() {
  return request({
    url: `/system/user/getWxInfo`,
  })
}

/**
 * 获取后端服务状态
 */
export function getServerState() {
  return request({
    url: `/serverState`,
  })
}
