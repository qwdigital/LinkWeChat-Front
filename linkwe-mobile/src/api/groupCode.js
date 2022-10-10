import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom
const service = wecom + '/groupCode'

// 通过群活码UUID获取群活码详情及可用的实际群码
export function getDetail (uuid) {
  return request({
    url: service + '/getActualCode/' + uuid,
  })
}

// 门店活码获取   storeCodeType： 1：门店导购码  2：门店群活码
export function getCodeInStore (params) {
  return request({
    url: wecom + '/storeCode/findStoreCode',
    params
  })
}

// 门店活码基础数据   storeCodeType： 1：门店导购码  2：门店群活码
export function getCodeBase (params) {
  return request({
    url: wecom + '/storeCode/findWeStoreCodeConfig',
    params
  })
}

export function recordCode (data) {
  return request({
    url: wecom + '/storeCode/countUserBehavior',
    method: 'post',
    data
  })
}