import request from '@/utils/request'
const base = window.lwConfig.services.wecom

// 基础数据枚举值
/**
CorpAddStateEnum //渠道标签
WeCorpTagEnum //企业标签
CustomerAttributesEnum //客户属性
CustomerBehaviorEnum //客户行为
CustomerBehaviorTimeEnum //客户行为时间
RelationEnum, StrategicCrowdEnum //策略人群
CustomerAddWay // 企微渠道 渠道来源
 */
export function getBaseData(data) {
  return request({
    url: base + '/strategic/crowd/getDownOptions',
    method: 'post',
    data: data,
  })
}

export function getList(data) {
  return request({
    url: base + '/strategic/crowd/list',
    params: data,
  })
}

export function remove(ids) {
  return request({
    url: base + '/strategic/crowd/del/' + ids,
    method: 'delete',
  })
}

export function add(data) {
  return request({
    url: base + '/strategic/crowd/add',
    method: 'post',
    data,
  })
}

export function update(data) {
  return request({
    url: base + '/strategic/crowd/update',
    method: 'put',
    data,
  })
}

export function detail(id) {
  return request({
    url: base + '/strategic/crowd/get/' + id,
  })
}

export function getChannelDetail(data) {
  return request({
    url: base + '/strategic/crowd/getCorpStateTagSource',
    params: data,
  })
}

// 更新
export function renew(data) {
  return request({
    url: base + '/strategic/crowd/renew',
    method: 'put',
    data,
  })
}

export function customerInCrowd(data) {
  return request({
    url: base + '/strategic/crowd/customer/list',
    params: data,
  })
}

export function crowdAnalyse(data) {
  return request({
    url: base + '/strategic/crowd/analyze',
    params: data,
  })
}

export function deleteCategory(ids) {
  return request({
    url: base + '/strategic/crowd/categoryDel/' + ids,
    method: 'delete',
  })
}
