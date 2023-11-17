import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/communityPresTagGroup'

/**
 * 获取老客标签建群列表
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
 * 获取老客标签建群详情
 * @param {*} params
 * id: 老客标签建群任务ID
 */
export function getDetail(id) {
  return request({
    url: service + '/' + id,
    method: 'get',
  }).then(({ data }) => {
    // 统一处理数据结构
    // weCustomersQuery 为null 转为 undefined 便于前端组件统一赋默认值
    let ranges = (data.weCustomersQuery = data.weCustomersQuery || undefined)

    if (ranges) {
      let userNames = ranges.userNames?.split(',')
      let tagNames = ranges.tagNames?.split(',')
      Object.assign(ranges, {
        isContain: ranges.isContain + '',
        genders: ranges.genders?.split(','),
        customerTypes: ranges.customerTypes?.split(','),
        users: ranges.userIds?.split(',')?.map((e, i) => ({ userId: e, name: userNames?.[i] })),
        tags: ranges.tagIds?.split(',')?.map((e, i) => ({ tagId: e, name: tagNames?.[i] })),
        dateRange: [ranges.beginTime, ranges.endTime],
      })
    }

    let names = data.groupNames?.split(',')
    data.groups = data.chatIdList?.split(',').map((e, i) => ({ chatId: e, groupName: names?.[i] }))
    data.sendScope += ''

    return { data }
  })
}

/**
 * 新增老客标签建群
 * @param {Object} data
{
    "id": 0, //主键
    "taskName": "", //任务名
    "welcomeMsg": "", //加群引导语
    "chatIdList": "", //实际群id，多个实用逗号隔开
    "autoCreateRoom": 0, //当群满了后，是否自动新建群。0-否；1-是。 默认为0
    "roomBaseName": "", //自动建群的群名前缀，当auto_create_room为1时有效。最长40个utf8字符
    "roomBaseId": 0, //自动建群的群起始序号，当auto_create_room为1时有效
    "groupCodeConfigId": "", //群活码企微信的configId
    "groupCodeState": "", //群活码渠道标识
    "groupCodeUrl": "", //群活码图片地址
    "linkTitle": "", //链接标题
    "linkDesc": "", //链接描述
    "linkCoverUrl": "", //链接封面
    "delFlag": 0, //0 未删除 1 已删除
    "sendScope": 0, //发送范围 0: 全部客户 1：部分客户
    "isAll": false, //是否全部发送 true全部发送,false非全部发送
    "weCustomersQuery": { //客户查询条件
        "genders": 0, //0-未知 1-男性 2-女性
        "trackState": 0, //跟踪状态 1:待跟进;2:跟进中;3:已成交;4:无意向;5:已流失
        "addMethod": 0, //添加方式
        "customerTypes": 0, //客户类型 1:微信用户，2:企业用户
        "externalUserid": "", //客户id
        "firstUserId": "", //跟进人id
        "delFlag": 0, //0正常；1:删除;
        "name": "", //查询条件客户姓名
        "tagIds": "", //查询标签id(企业标签id)
        "userIds": "", //查询条件
        "deptIds": "", //部门查询条件
        "beginTime": "", //查询开始时间
        "endTime": "", //查询结束时间
        "excludeTagIds": "", //不包含的标签id
        "dataScope": false, //个人数据:false 全部数据(相对于角色定义的数据权限):true
        "stateList": [ //渠道值
            ""
        ],
        "noTagCheck": false, //是否按照无标签查询 true:是 false:不是
        "noRepeat": false, //是否去重客户 true:去重  false:不去重
        "isFilterLossCustomer": false,
        "phone": "", //手机号码
        "customerIds": "", //客户id，多个使用逗号隔开
        "isJoinBlacklist": 0, //0:加入黑名单;1:不加入黑名单;
        "isContain": 0 //1:包含全部选中标签 2:包含其中一个标签 3:不包含选中标签
    },
    "senderList": [ //指定接收消息的成员及对应客户列表
        {
            "userId": "",
            "customerList": [
                ""
            ],
            "chatList": [
                ""
            ]
        }
    ],
    "groupNames": "", //群名，多个使用逗号隔开
    "touchWeCustomerNumber": 0, //触发客户数
    "joinGroupCustomerNumber": 0, //进群客户数
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
  data = JSON.parse(JSON.stringify(data))

  Object.assign(data, {
    chatIdList: data.groups?.map((e) => e.chatId)?.join(','),
    groupNames: data.groups?.map((e) => e.groupName)?.join(','),
  })

  let ranges = data.weCustomersQuery
  ranges &&
    Object.assign(ranges, {
      genders: ranges.genders?.join(','),
      customerTypes: ranges.customerTypes?.join(','),
      tagIds: ranges.tags?.map((e) => e.tagId)?.join(','),
      tagNames: ranges.tags?.map((e) => e.name)?.join(','),
      userIds: ranges.users?.map((e) => e.userId)?.join(','),
      userNames: ranges.users?.map((e) => e.name)?.join(','),
      beginTime: ranges.dateRange?.[0],
      endTime: ranges.dateRange?.[1],
    })

  return request({
    url: service + '/add',
    method: 'post',
    data,
  })
}

/**
 * 修改老客标签建群
 * @param {*} data
 */
export function update(data) {
  data = JSON.parse(JSON.stringify(data))

  Object.assign(data, {
    chatIdList: data.groups?.map((e) => e.chatId)?.join(','),
    groupNames: data.groups?.map((e) => e.groupName)?.join(','),
  })

  let ranges = data.weCustomersQuery
  ranges &&
    Object.assign(ranges, {
      genders: ranges.genders?.join(','),
      customerTypes: ranges.customerTypes?.join(','),
      tagIds: ranges.tags?.map((e) => e.tagId)?.join(','),
      tagNames: ranges.tags?.map((e) => e.name)?.join(','),
      userIds: ranges.users?.map((e) => e.userId)?.join(','),
      userNames: ranges.users?.map((e) => e.name)?.join(','),
      beginTime: ranges.dateRange?.[0],
      endTime: ranges.dateRange?.[1],
    })
  return request({
    url: service + '/edit',
    method: 'put',
    data,
  })
}

/**
 * 删除老客标签建群
 * @param {*} ids
 */
export function remove(ids) {
  return request({
    url: service + '/batchRemove/' + ids,
    method: 'DELETE',
  })
}

/**
 * 同步发送结果
 * @param {*} id
 */
export function sync(id) {
  return request({
    url: service + '/synchExecuteResult/' + id,
  })
}

/**
 * 获取头部统计
 * @param {*} id
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
{
  chatId  // 群id
  customerName  // 客户名称
    endAddTime  // 添加客户结束时间
  endJoinTime  // 入群结束时间
  isJoinGroup  // 是否进群，1:是 0:否
  startAddTime  // 添加客户开始时间
  startJoinTime  // 入群开始时间
}
 */
export function getDataDetail(params) {
  return request({
    url: service + '/findWePresTagGroupTaskTable',
    params,
  })
}

/**
 * 数据明细导出
 */
export function getDataDetailExport(params) {
  return request({
    url: service + '/exprotWePresTagGroupTaskTable',
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
