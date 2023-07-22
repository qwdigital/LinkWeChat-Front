import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom

export const indexTable = () => {
  return request({
    url: '/page/getCorpBasicData',
    method: 'get',
  })
}

export const indexEchart = () => {
  return request({
    url: '/page/getCorpRealTimeData',
    method: 'get',
  })
}

export const refresh = () => {
  return request({
    url: '/page/refresh',
    method: 'get',
  })
}

// 获取企业轨迹
export const getCompanyDynamicsData = (params) => {
  return request({
    url: '/open/trajectory/findCompanyDynamics',
    params,
  })
}
/**
 * 客户数据-实时数据
 * @params {*}
* deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export const getRealCnt = (params) => {
  return request({
    url: wecom + '/operation/customer/getCustomerRealPageCnt',
    params,
  })
}
/**
 * 客户数据分析
 */
export function getAnalysis() {
  return request({
    url: wecom + '/operation/customer/getAnalysis',
  })
}

/**
 * 客群数据分析
 */
export function getGroupAnalysis() {
  return request({
    url: wecom + '/operation/group/getAnalysis',
  })
}
/**
 * 客群数据-客群成员实时数据
 * @param {*}
* chatIds	否[]群聊id
ownerIds	否[]群主id
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRealCntMember(params) {
  return request({
    url: wecom + '/operation/group/member/getGroupMemberRealPageCnt',
    params,
  })
}

//   首页接口
export const indexInfo = () => {
  return request({
    url: wecom + '/getWeIndex',
    method: 'get',
  })
}
