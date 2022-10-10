import request from '@/utils/request'
import { dataURLtoFile } from '@/utils/common'

const service = window.CONFIG.services.system

export function upload (data) {
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
export function download (url, name) {
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
export function uploadDataURL (dataURL) {
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
export function getProCityList (data) {
  return request({
    url: service + '/system/area/list',
    params: data
  })
}
