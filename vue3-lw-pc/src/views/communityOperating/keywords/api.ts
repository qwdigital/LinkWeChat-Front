import { pageParams } from 'env'
import { requestOpen } from '@/utils/request'
const { get, post, put, del: _del } = requestOpen
const service = '/communityKeywordGroup'

/** 获取关键词拉群列表
 * @param {*} params
 * {title}
 */
export const getList = (data: pageParams) => get(`${service}/findLists`, data)

/** 获取关键词拉群详情
 * @param {*} params
 */
export const getDetail = (id) => get(`${service}/getKeyWordGroupBaseInfo/${id}`)

/** 获取关键词拉群详情中关键词拉群列表
 * @param {*} params
 * {keywordGroupId}
 */
export const getDetailList = (data: pageParams) => get(`${service}/findWeKeyWordGroupSubs`, data)

/** 新增或更新关键词群
 * @param {Object} data
  {
    "id": 0, //主键id
    "title": "", //标题
    "descrition": "", //描述
    "keywordGroupUrl": "", //关键词
    "keywordGroupQrUrl": "", //关键词群链接二维码链接
    "delFlag": 0, //逻辑删除
    "keyWordGroupSubs": [ //关键词群
        {
            "id": 0, //主键
            "keyword": "", //关键词
            "codeName": "", //活码名称
            "keywordGroupId": 0, //关键词主表主键
            "chatIdList": "", //实际群id，多个使用逗号隔开
            "autoCreateRoom": 0, //当群满了后，是否自动新建群。0-否；1-是。 默认为0
            "roomBaseName": "", //自动建群的群名前缀，当auto_create_room为1时有效。最长40个utf8字符
            "roomBaseId": 0, //自动建群的群起始序号，当auto_create_room为1时有效
            "groupCodeConfigId": "", //群活码企微信的configId
            "groupCodeState": "", //群活码渠道标识
            "groupCodeUrl": "", //群活码图片地址
            "sort": 0, //排序
            "delFlag": 0, //0:正常;1:删除;
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
    ],
    "keyWordGroupNumber": 0, //关键词数量
    "totalViewNumber": 0, //总访问数量
    "totalJoinGroupNmber": 0, //总入群数量
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
export const addOrUpdate = (data) => post(`${service}/createOrUpdateBaseInfo`, data)

/** 删除关键词拉群
 * @param {*} ids
 */
export const remove = (ids) => _del(`${service}/batchRemoveKeyWordGroup/${ids}`)

/** 删除关键词拉群集合中的关键词群
 * @param {*} ids
 */
export const removeSub = (ids) => _del(`${service}/batchRemoveKeyWordGroupSub/${ids}`)

// 申请构建主键
export const getId = () => get(`${service}/applyToBuildPrimaryKey`)

/** 新增或更新关键词群点击取消时触发(避免还未新建,导致群活码创建过多占位)
 * @param {Object} data
{
  "taskName": "string",
  "groupCodeId": 0,
  "welcomeMsg": "string",
  "keywords": "string",
}
 */
export const addOrUpdateCancel = (data) => post(`${service}/cancelCreateBaseInfo`, data)

/** 新增或更新关键词群集合中的关键词群
 * @param {Object} data
{
    "id": 0, //主键
    "keyword": "", //关键词
    "codeName": "", //活码名称
    "keywordGroupId": 0, //关键词主表主键
    "chatIdList": "", //实际群id，多个使用逗号隔开
    "autoCreateRoom": 0, //当群满了后，是否自动新建群。0-否；1-是。 默认为0
    "roomBaseName": "", //自动建群的群名前缀，当auto_create_room为1时有效。最长40个utf8字符
    "roomBaseId": 0, //自动建群的群起始序号，当auto_create_room为1时有效
    "groupCodeConfigId": "", //群活码企微信的configId
    "groupCodeState": "", //群活码渠道标识
    "groupCodeUrl": "", //群活码图片地址
    "sort": 0, //排序
    "delFlag": 0, //0:正常;1:删除;
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
export const addOrUpdateKeyword = (data) =>
  post(`${service}/${data.id ? 'updateKeyWordGroupSub' : 'createKeyWordGroupSub'}`, data)

/** 批量更新关键词群(主要针对顺序的调整)
 * @param data
 * @returns
 */
export const batchUpdateKeyWordGroupSub = (data) => post(`${service}/batchUpdateKeyWordGroupSub`, data)

// ----------

/** 获取详情头部统计
 * @param id
 * @returns
 */
export const getStatistic = (id) => get(`${service}/countTab/${id}`)

/**数据趋势 折线图统计
 * @param data
 * @returns
 */
export const getDataTrend = (data) => get(`${service}/countTrend`, data)

/**数据明细
 * @param data
 * @returns
 */
export const getDataDetail = (data) => get(`${service}/findKeyWordGroupTable`, data)

/**关键词群数据明细导出
 * @param data
 * @returns
 */
export const getDataDetailExport = (data) => get(`${service}/exprotKeyWordGroupTable`, data, { responseType: 'blob' })

/**获取当前客户对应的群
 * @param data
 * @returns
 */
export const getCustomerToGroupList = (data) => get(`${service}/findWeKeyWordGroupChatTable`, data)
