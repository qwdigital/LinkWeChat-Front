import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/communityNewGroup'

/**
 * 获取新客自动拉群列表
 * @param {*} params
 *
 */
export function getList(params) {
  return request({
    url: service + '/list',
    method: 'get',
    params,
  })
}

/**
 * 获取新客自动拉群详情
 * @param {*} params
 *
 */
export function getDetail(id) {
  return request({
    url: service + '/' + id,
    method: 'get',
  }).then(({ data }) => {
    // 统一处理数据结构
    if (data.emplList && data.emplNames) {
      let names = data.emplNames?.split(',')
      data.users = data.emplList?.split(',').map((e, i) => ({ userId: e, name: names?.[i] }))
    }
    if (data.tagList && data.tagNames) {
      let names = data.tagNames?.split(',')
      data.tags = data.tagList?.split(',').map((e, i) => ({ tagId: e, name: names?.[i] }))
    }
    if (data.chatIdList && data.groupNames) {
      let names = data.groupNames?.split(',')
      data.groups = data.chatIdList?.split(',').map((e, i) => ({ chatId: e, groupName: names?.[i] }))
    }
    return { data }
  })
}

/**
 * 新增新客自动拉群
 * @param {Object} data
{
    "id": 0, //主键ID
    "codeName": "", //活码名称
    "emplList": "", //多个员工id，使用逗号隔开。
    "tagList": "", //标签id，多个使用逗号隔开
    "skipVerify": false, //是否跳过验证自动加好友
    "emplCodeUrl": "", //员工活码图片地址
    "emplCodeState": "", //员工活码渠道标识
    "emplCodeConfigId": "", //员工活码configId
    "welcomeMsg": "", //加群引导语
    "chatIdList": "", //实际群id，多个实用逗号隔开
    "autoCreateRoom": 0, //当群满了后，是否自动新建群。0-否；1-是。 默认为0
    "roomBaseName": "", //自动建群的群名前缀，当auto_create_room为1时有效。最长40个utf8字符
    "roomBaseId": 0, //自动建群的群起始序号，当auto_create_room为1时有效
    "groupCodeConfigId": "", //群活码企微信的configId
    "groupCodeState": "", //群活码渠道标识
    "groupCodeUrl": "", //群活码图片地址
    "delFlag": 0, //0 未删除 1 已删除
    "linkTitle": "", //链接标题
    "linkDesc": "", //链接描述
    "linkCoverUrl": "", //链接封面
    "tagNames": "", //标签名，多个使用逗号隔开
    "groupNames": "", //群名，多个使用逗号隔开
    "addCustomerNumber": 0, //添加客户数
    "joinGroupNumber": 0, //进群客户数
    "searchValue": "", //搜索值
    "createBy": "", //创建者
    "createById": 0, //创建者ID
    "createTime": "", //创建时间
    "updateBy": "", //更新者
    "updateById": 0, //更新者ID
    "updateTime": "", //更新时间
    "remark": "", //备注
    "params": { //请求参数
        "key": {}
    }
}
 */
export function add(data) {
  data = Object.assign({}, data, {
    emplList: data.users?.map((e) => e.userId)?.join(','),
    emplNames: data.users?.map((e) => e.name)?.join(','),
    tagList: data.tags?.map((e) => e.tagId)?.join(','),
    tagNames: data.tags?.map((e) => e.name)?.join(','),
    chatIdList: data.groups?.map((e) => e.chatId)?.join(','),
    groupNames: data.groups?.map((e) => e.groupName)?.join(','),
  })
  return request({
    url: service + '/add',
    method: 'post',
    data,
  })
}

/**
   * 修改新客自动拉群
   * @param {*} data
{
  "codeName": "string",
  "groupCodeId": 'string',
  "skipVerify": true,
  "tagList": [],
  "emplList": [],
  "welcomeMsg": "string"
}
   */
export function update(data) {
  data = Object.assign({}, data, {
    emplList: data.users?.map((e) => e.userId)?.join(','),
    emplNames: data.users?.map((e) => e.name)?.join(','),
    tagList: data.tags?.map((e) => e.tagId)?.join(','),
    tagNames: data.tags?.map((e) => e.name)?.join(','),
    chatIdList: data.groups?.map((e) => e.chatId)?.join(','),
    groupNames: data.groups?.map((e) => e.groupName)?.join(','),
  })
  return request({
    url: service + '/edit',
    method: 'put',
    data,
  })
}

/**
 * 删除新客自动拉群
 * @param {*} ids
 */
export function remove(ids) {
  return request({
    url: service + '/' + ids,
    method: 'DELETE',
  })
}

/**
 * 批量下载
 * @param {*} 	员工活码ids,多个逗号隔开
 */
export function downloadBatch(ids) {
  return request({
    url: service + '/downloadBatch',
    params: {
      ids,
    },
    responseType: 'blob',
  })
}

export function download(id) {
  return request({
    url: service + '/download',
    params: {
      id,
    },
    responseType: 'blob',
  })
}

/**
 * 获取头部统计
 * @param {*} ids
 */
export function getStatistic(id) {
  return request({
    url: service + '/countTab/' + id,
  })
}

/**
 * 数据趋势
 */
export function getDataTrend(params) {
  return request({
    url: service + '/findTrendCountVo',
    params,
  })
}

/**
 * 数据明细
 */
export function getDataDetail(params) {
  return request({
    url: service + '/findWeCommunityNewGroupTable',
    params,
  })
}

/**
 * 数据明细导出
 */
export function getDataDetailExport(params) {
  return request({
    url: service + '/exprotWeCommunityNewGroupTable',
    params,
    responseType: 'blob',
  })
}

/**
 * 获取当前客户对应的群
{
  id,string,false,,,新客拉群主键
externalUserid,string,false,,,当前客户的id
pageNum,integer,false,,,当前记录起始索引
pageSize,integer,false,,,每页显示记录数
}
 */
export function getCustomerToGroupList(params) {
  return request({
    url: service + '/findWeCommunityNewGroupChatTable',
    params,
  })
}
