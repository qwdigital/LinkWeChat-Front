import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/seas'

export function getTypeList(data) {
  return request({
    url: service + '/findEmployeeCustomer',
    params: data,
  })
}

export function setState(data) {
  return request({
    url: service + '/setState',
    method: 'post',
    data: data,
  })
}
