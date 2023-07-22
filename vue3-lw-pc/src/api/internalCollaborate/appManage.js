import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/agent'
const serviceMsg = service + '/msg'

// 应用管理
/**
 * 列表
 * @param {*} params
 */
export function getList() {
  return request({
    url: service + '/list',
  })
}

/**
 * 同步应用信息
 * @param {*} params
 */
export function sync(id) {
  return request({
    url: service + `/pull/${id}`,
    method: 'get',
  })
}

/**
 * 删除
 * @param {*} params
 */
export function remove(id) {
  return request({
    url: service + `/delete/${id}`,
    method: 'delete',
  })
}

/**
 * 添加应用
 * @param {*} data
{
    "agentId": "应用ID",
    "secret": "应用密钥"
}
 * @returns
 */
export function add(data) {
  return request({
    url: service + '/add',
    method: 'post',
    data,
  })
}

/**
 * 编辑应用信息
 * @param {*} data
{
  description:'', // string 企业应用详情
homeUrl:'', // string 应用主页url
logoUrl:'', // string 企业应用头像
name:'', // string 企业应用名称
redirectDomain:'', // string 企业应用可信域名
}
 * @returns
 */
export function update(data) {
  return request({
    url: service + `/update/${data.id}`,
    method: 'PUT',
    data,
  })
}

// 应用消息

export const appMsg = {
  /**
   * 获取历史消息列表
   * @param {*} params
   {
    endTime:'', // string date-time 发送结束时间
    startTime:'', // string date-time 发送开始时间
    status:'',// integer int32状态
    title:'', // string 标题
  }
  */
  getList(params) {
    return request({
      url: serviceMsg + '/list',
      params,
    })
  },

  /**
   * 应用消息详情
   * @param {*} id
   */
  getDetail(id) {
    return request({
      url: serviceMsg + `/get/${id}`,
    })
  },

  /**
   * 撤销应用消息
   * @param {*} id
   */
  revoke(id) {
    return request({
      url: serviceMsg + `/revoke/${id}`,
    })
  },

  /**
 * 新增应用消息
 * @param {*} data
    {
      agentId:'', // integer int32 应用ID
      planSendTime: '', // string date-time 计划时间
      scopeType:'', // integer int32 范围类型 1-全部 2-自定义
      sendTime: '', // string date-time 发送时间
      sendType:'', // integer int32 发送方式 1-立即发送 2-定时发送
      title: '', // string 消息标题
      toParty: '', // string 示例值 接收消息的部门
      toTag: '', // string 示例值 接收消息的标签
      toUser: '', // string 示例值 接收消息的成员
      WeMessageTemplate:{
        appId: '', // string 小程序appid（可以在微信公众平台上查询），必须是关联到企业的小程序应用
        content: '', // string 文本内容（文本消息必传）
        description: '', // string 消息的描述（视频、文本卡片、图文 必传）
        linkUrl: '', // string 点击后跳转的链接。最长2048字节，请确保包含了协议头(http/https) （文本卡片、图文 必传）
        msgType: '', // string 消息类型 文本:text, 图片:image, 语音:voice, 视频:video, 文件:file, 文本卡片:textcard, 图文:news, 图文消息:link, 小程序：miniprogram
        picUrl: '', // string 图文消息的图片链接，支持JPG、PNG格式，较好的效果为大图 1068*455，小图150*150。（文本卡片、图文 必传）
        title: '', // string 消息的标题（视频、文本卡片、图文 必传）
      }
    }
 */
  add(data) {
    return request({
      url: serviceMsg + '/add',
      method: 'post',
      data,
    })
  },

  // 修改应用消息 data同上
  update(data) {
    return request({
      url: serviceMsg + `/update/${data.id}`,
      method: 'PUT',
      data,
    })
  },

  /**
   * 删除
   * @param {*} id
   */
  remove(id) {
    return request({
      url: serviceMsg + `/delete/${id}`,
      method: 'delete',
    })
  },
}
