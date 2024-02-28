import request from '@/utils/request'
import { dataURLtoFile } from '@/utils/common'
const service = window.lwConfig.services.wecom + '/form'

//查询省市区
// export function treelist(data) {
//   return request({
//     url: service + '/treelist' + data,
//     method: 'get',
//     data,
//   })
// }
//图片上传
// export function uploadFile(dataURL) {
//   const data = new window.FormData()
//   const f = dataURLtoFile(dataURL)
//   data.append('file', f)
//   // console.log('基础参数',f)
//   console.log('基础参数1', data)
//   return request({
//     url: service + '/common/uploadFile2Cos',
//     method: 'post',
//     processData: false,
//     data,
//   })
// }

// 新增表单
export function insertInfoToSurvey(data) {
  return request({
    url: service + '/survey/add',
    method: 'post',
    data,
  })
}

// 表单
export function surveyList(data) {
  return request({
    url: service + '/survey/list',
    method: 'GET',
    params: data,
  })
}

// 删除表单列表
export function deleteInfoToSurvey(ids) {
  return request({
    url: service + '/survey/delete/' + ids,
    method: 'DELETE',
  })
}

// 获取表单问卷列表/表单详情
export function selectInfoToSurvey(id, addr, dataSource) {
  if (addr) {
    return request({
      url: window.lwConfig.services.weChat + '/form/survey/getInfo',
      method: 'GET',
      params: {
        id, // 121212, 原有路径中带的主键id
        addr, // ip地址
        dataSource,
      },
    })
  } else {
    return request({
      url: service + '/survey/getInfo/' + id,
      method: 'GET',
    })
  }
}

// 提交问卷
export function submitForm(data) {
  return request({
    url: service + '/answer/add',
    method: 'post',
    data,
  })
}

// 判断用户是否填写表单
export function isCompleteSurvey(data) {
  return request({
    url: service + '/answer/isCompleteSurvey',
    method: 'post',
    data,
  })
}

//储存饼图信息
// export function insertPieValue(data) {
//   return request({
//     url: service + '/statistic/insertPieValue',
//     method: 'post',
//     data,
//   })
// }

// 更改表单状态
export function updateSurveyStatus(data) {
  return request({
    url: service + '/survey/updateStatus',
    method: 'put',
    data,
  })
}

//获取微信用户信息
export function getAccessToken(data) {
  return request({
    url: service + '/Statistics/getAccessToken' + data,
    method: 'get',
    data,
  })
}

//转移分组
export function updateSurveyGroup(data) {
  return request({
    url: service + '/updateSurveyGroup',
    method: 'post',
    data,
  })
}

////////统计

//获取统计基本信息
export function selectStatistics(data) {
  return request({
    url: service + '/statistic/getStatistics',
    method: 'get',
    params: data,
  })
}

//折现统计图
export function lineChart(data) {
  return request({
    url: service + '/statistic/lineChart',
    method: 'get',
    params: data,
  })
}

//数据报表
export function StatisticsDataList(data) {
  data.beginTime ??= data.startDate
  data.endTime ??= data.endDate
  return request({
    url: service + '/statistic/dataList',
    method: 'get',
    params: data,
  })
}

//更改表单
export function updateInfoToSurvey(data) {
  return request({
    url: service + '/survey/update',
    method: 'put',
    data,
  })
}

//数据统计数据
export function selectAnswerInfo(data) {
  return request({
    url: service + '/answer/getAnswerList',
    method: 'post',
    data,
  })
}

//扇形统计图
export function pieChart(data) {
  return request({
    url: service + '/statistic/pieChart',
    method: 'post',
    data,
  })
}

/**
 * 数据报表导出
 * @param {*} data
{
    "belongId": "25",
    "type": "",
    "dataSource": "cillum consectetur",
    "startTime": "1992-07-12",
    "endTime": "2012-02-24"
}
 * @returns
 */
export function overviewExport(data) {
  return request({
    url: service + '/statistic/dataListExport',
    method: 'get',
    params: data,
    responseType: 'blob',
  })
}

//智能表单答案统计 参数同上
export function answerExport(data) {
  return request({
    url: service + '/statistic/answer/export',
    method: 'get',
    params: data,
    responseType: 'blob',
  })
}

//用户统计报表导出 参数同上
export function userExport(data) {
  return request({
    url: service + '/statistic/user/export',
    method: 'post',
    data,
    responseType: 'blob',
  })
}

//用户统计
export function statisticsCustomer(data) {
  return request({
    url: service + '/statistic/customer',
    method: 'post',
    data,
  })
}

//省市联动统计
export function areaStatistic(data) {
  return request({
    url: service + '/statistic/areaStatistic',
    method: 'post',
    data,
  })
}

/**
 * 智能表单站点统计（废弃）
 * @param {*} data
 * {
 * belongId: this.formId,
        dataSource: this.dataSource,
 * }
 * @returns
 */
export function siteStas(data) {
  return request({
    url: service + '/statistic/siteStas',
    method: 'post',
    data,
  })
}

export function statisticAdd(data) {
  return request({
    url: service + '/statistic/add',
    method: 'post',
    data,
  })
}
