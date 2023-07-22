import request from '@/utils/request'
let getway = window.lwConfig.services.wecom
const service = getway + '/material'
// 基础素材-添加
export function add(params) {
  return request({
    url: service,
    params,
  })
}
// 基础素材-编辑
export function update(params) {
  return request({
    url: service,
    params,
  })
}
// 下载导入模板
export function importTemplate(params) {
  return request({
    url: service + '/importTemplate',
    responseType: 'blob',
    params,
  })
}
// 文本导入
export function importData(data, categoryId, mediaType) {
  return request({
    url: service + '/importData',
    method: 'post',
    params: {
      categoryId,
      mediaType,
    },
    data,
  })
}
// 批量删除
export function lexicalRemove(ids) {
  return request({
    url: service + '/' + ids,
    method: 'DELETE',
  })
}
// 获取视频第一帧
export function getVideoPic(params) {
  return request({
    url: '/file/getVideoFirstImg/',
    params,
  })
}
