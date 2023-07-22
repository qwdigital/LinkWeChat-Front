import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/strategic/journey'

// import { get, post } from '@/plugins/axios'

export function getCrowdPackList(params) {
  return request.post('/ae.api.cdp.audience.front.page', params)
  return request.get('/wecome.crowdPack.findCrowdPackList', params)
}

export function createTagCrowdPack(params) {
  return request.post('/wecome/crowdPack/createTagCrowdPack', params)
}

// 查询人群包详情、获取数据集
export function getCrowdPackDetail(id) {
  return request.get('/ae.api.cdp.audience.front.detail', { query: { id } })
}

// 计划列表查询接口
// name	任务名称	String		支持模糊查询
// startDate	开始日期	String		yyyy-MM-dd
// endDate	结束日期	String		yyyy-MM-dd
// status	状态	number		0:待完善,1:未开始,2:待运行,3:运行中,4:已暂停,5:已停止,6：正常结束,7:异常结束
// pageNum	页码	number
// pageSize	页大小	number
export function getAutoPlanList(params) {
  return request.post('/wecome.autoplan.list', params)
}

// 计划详情查询接口
// id	计划id	Number		计划id
export function getAutoPlanDetail(id) {
  return request.get('/wecome.autoplan.detail', { query: { id } })
}

/**
 * 保存计划
 * @param {*} params
 * @returns
 */
export function createPlan(params) {
  return request.post('/wecome.autoplan.createPlan', params)
}

// 保存并开始计划
export function createStartPlan(params) {
  return request.post('/wecome.autoplan.createStartPlan', params)
}
// 修改计划
export function modifyPlan(params) {
  return request.post('/wecome.autoplan.modifyPlan', params)
}
// 修改并执行计划
export function modifyStartPlan(params) {
  return request.post('/wecome.autoplan.modifyStartPlan', params)
}

// 暂停计划
// id	计划id	Number		计划id
export function pausePlan(id) {
  return request.get('/wecome.autoplan.pausePlan', { query: { id } })
}

// 开始计划
// id	计划id	Number		计划id
export function resumePlan(id) {
  return request.get('/wecome.autoplan.resumePlan', { query: { id } })
}

// 计划删除接口
// id	计划id	Number		计划id
export function delPlan(id) {
  return request.get('/wecome.autoplan.delPlan', { query: { id } })
}

// 短信模板列表
export function getSmsTemplateList(templateType) {
  return request.get('/cdpsmspre.sms.api.template.quclouds.template', {
    query: { templateType },
  })
}

// 短信模板详情
export function getSmsTemplateDetail(templateId) {
  return request.get('/cdpsmspre.sms.api.template.quclouds.template.detail', {
    query: { templateId },
  })
}

// 短信配额查询接口
export function getSmsNum() {
  return request.get('/cdpsmspre.sms.api.resource.remain', {})
  // return request.get('/cdpsms.sms.api.resource.remain', {
  //   query: { templateId }
  // })
}

// 短信任务效果指标查询接口
// bussinessIds 业务ID string 是 多个ID使用逗号分隔
// taskSource 任务来源 String 是 自动化营销 auto,
export function getSmsSendResult(businessIds) {
  return request.get('/cdpsmspre.sms.api.task.effect', {
    query: { businessIds, taskSource: 'quyun' },
  })
  // return request.get('/cdpsms.sms.api.resource.remain', {
  //   query: { templateId }
  // })
}
// 短信任务详情查询接口
export function getSmsSendDetail(businessId) {
  return request.get('/cdpsmspre.sms.api.task.detail', {
    query: { businessId, taskSource: 'quyun' },
  })
}

// 获取账号列表 (platform_id 1腾讯 2头条)
export function getAccountList(platform_id) {
  let query = {
    status: 1,
    get_all: 0,
    page: 1,
    page_size: 99999,
    platform_id: platform_id,
  }
  return request.get('/qmediaapi.qymedia.listaccount', { query })
}

// 人群推送任务新增 头条巨量引擎
export function addaudiencesToutiaoAd(data) {
  return request.post('/crowdtoutiao.toutiao.audiences.addaudiences', data)
}
// 人群推送任务新增 腾讯广告
export function addaudiencesTencentAd(data) {
  return request.post('/crowdgdt.gdt.audiences.addaudiences', data)
}

// 巨量引擎 人群推送任务修改
export function updateaudiencesToutiaoAd(data) {
  return request.post('/crowdtoutiao.toutiao.audiences.updateaudiences', data)
}

// 腾讯广告 人群推送任务修改
export function updateaudiencesTencentAd(data) {
  return request.post('/crowdgdt.gdt.audiences.updateaudiences', data)
}

// 新增策略旅程
export function add(data) {
  return request({
    url: service + '/add',
    method: 'post',
    data,
  })
}
// 暂存策略旅程
export function tempSave(data) {
  return request({
    url: service + '/tempSave',
    method: 'post',
    data,
  })
}

// 删除策略旅程
export function remove(ids) {
  return request({
    url: service + '/del/' + ids,
    method: 'DELETE',
  })
}
// 获取策略旅程详情
export function getDetail(id) {
  return request.get(service + '/get/' + id)
}

// 获取策略旅程列表
export function getList(data) {
  return request({ url: service + '/list', params: data })
}
// 修改策略旅程
export function update(data) {
  return request.put(service + '/update', data)
}

/**
 * 策略旅程状态变更
 * @param {*} data
 * {
 *  Ids
    status {number} 状态 0、未发布 1、待执行 2、执行中 3、已完成 4、已暂定 5、已停用
 * }
 * @returns
 */
export function updateStatus(data) {
  return request.put(service + '/update/status', data)
}

// 删除策略旅程分组
export function removeJourneyGroup(groupId) {
  return request.get(service + '/group/del', { params: { groupId } })
}
// 获取触达明细
export function contactDetails(id) {
  return request.get(service + '/reach/get/' + id)
}
// 获取触达内容
export function reachContent(nodeId) {
  return request.get(service + '/reach/content/get/' + nodeId)
}
//  获取触达人群明细
export function popDetails(nodeId) {
  return request.get(service + '/reach/crowd/get/' + nodeId)
}
