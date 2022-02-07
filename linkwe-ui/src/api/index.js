import request from '@/utils/request'
const service = window.CONFIG.services.system

export const indexTable = () => {
  return request({
    url: service + '/wecom/page/getCorpBasicData',
    method: 'get'
  })
}

export const indexEchart = () => {
  return request({
    url: service + '/wecom/page/getCorpRealTimeData',
    method: 'get'
  })
}

export const refresh = () => {
  return request({
    url: service + '/wecom/page/refresh',
    method: 'get'
  })
}
