import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom

// 客户群、客群画像、标签

const service = wecom + '/groupchat'

/**
 * 客户群列表
 * @param {Object} params
 * {
 * beginTime string 否 开始时间
 * chatId string 否 群聊Id
 * endTime string 否 结束时间
 * groupName string 否 群名
 * id string 否 主键Id
 * owner string 否 群主userId
 * }
 * @returns
 */
export function getList(params) {
  return request({
    url: service + '/page/list',
    params,
  })
}

/**
 * 客户群详情
 * @param {string} chatId
 * @returns
 * {
 * addTime string date-time群创建时间
 * adminUserId string 群管理员id
 * allocateState integer int32分配状态:0-被接替成功;1-待接替;2-接替失败;3-正常状态
 * chatId string 群聊id
 * customerNum integer int32客户数量
 * delFlag integer int32删除标识 0 正常 1 删除
 * groupLeaderName string 管理员名称
 * groupName string 群名
 * id integer int64主键ID
 * memberNum integer int32群成员数量
 * notice string 群公告
 * owner string 群主userId
 * status integer int32跟进状态 0-正常;1-跟进人离职;2-离职继承中;3-离职继承完成
 * tagId string 标签id
 * tagIds string
 * tags string 标签名，使用逗号隔开
 * tenantId integer int32租户ID
 * toDayMemberNum integer int32今日进群数
 * toDayExitMemberNum integer 今日退群人数
 * }
 */
export function getDetail(chatId) {
  return request({
    url: service + '/get/' + chatId,
  })
}

/**
 * 客户群成员列表
 * @param {*} params
  {
    chatId string false "群id,移动应用必传参数",
    delFlag string false 删除标识 0 正常 1 删除,
    groupNickName string false 在群里的昵称,
    id string false 主键ID,
    invitorUserId string false 邀请人userId,
    joinScene string false 加入方式,
    joinTime string false 加群时间,
    name string false 名字,
    tenantId string false 租户ID,
    type string false 成员类型:1 - 企业成员;2 - 外部联系人,
    unionId string false 外部联系人在微信开放平台的唯一身份标识,
    userId string false 群成员id,
    pageNum string false "当前页,移动应用必传参数",
    pageSize string false "当前每页显示条数,移动应用必传参数",
  }
 * @returns
  {
    code integer int32
    msg string
    rows [object]
      [{ userId string 成员id
        avatar string 头像
        name string 名称
        invitorUserId string 邀请人id
        invitorUserName string 邀请人姓名
        joinTime string 入群时间
        joinScene integer 加入方式 1 - 由群成员邀请入群（直接邀请入群) 2 - 由群成员邀请入群（通过邀请链接入群） 3 - 通过扫描群二维码入群
        type integer 成员类型:1 - 成员;2 - 客户 3:群主
        customerType integer 1:微信客户;2:企业微信客户
      }]
    total integer int64
  }
 */
export function getMemberList(params) {
  return request({
    url: service + '/member/page/list',
    params,
  })
}

/**
 * 编辑群标签
 * @param {*} data
 * {
 * chatId string 群聊ID
 * tagIds array[string] 标签Id列表
 * }
 * @returns
 */
export function markTag(data) {
  return request({
    url: service + '/makeGroupTag',
    method: 'post',
    data,
  })
}

// 同步客户群
export function sync() {
  return request({
    url: service + '/synch',
  })
}

/**
 * 获取轨迹信息
 * @param {*}
  {
    pageNum:
    pageSize:
    chatId: chatId
  }
 * @returns
 */
export function findTrajectory({ pageNum, pageSize, chatId }) {
  return request({
    url: service + '/findGroupTrajectory/' + chatId,
    params: { pageNum, pageSize },
  })
}

/**
 * 标签列表获取
 * @param {Object} params
 * {
    "pageNum": "当前页",
    "pageSize": "每页显示条数",
    "groupName": "标签组名"
    "groupTagType": "标签分组类型(1:客户标签;2:群标签)"
}
 */
export function getTagList(params) {
  return request({
    url: wecom + '/tag/list',
    params,
  })
}

export function getDataList(params) {
  return request({
    url: wecom + '/customer/findWeCustomerListByApp',
    params,
  })
}

export function getGroupList(params) {
  return request({
    url: wecom + '/groupchat/page/listByApp',
    params,
  })
}
