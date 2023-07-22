import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/product'

/**
 * 商品列表
 * @param {*} params
 * {
 *  beginTime,string,开始时间
    endTime,string,结束时间
    name,string,商品描述
    price,string,商品价格
 * }
 */
export function getList(params) {
  return request({
    url: service + '/page/list',
    params,
  })
}

/**
 * 商品列表同步
 * @param {*} params
 *
 */
export function sync() {
  return request({
    url: service + '/page/list/sync',
  })
}

/**
 * 商品详情
 * @param {*} params
 *
 */
export function getDetail(id) {
  return request({
    url: service + '/get/' + id,
  })
}

/**
 * 新增商品
 * @param {Object} data
{
 attachments: [
     String appID; 小程序appid（可以在微信公众平台上查询），必须是关联到企业的小程序应用
     String content *;
     String description *;
     String linkURL *;
     String mediaID *;
     String msgType *; 消息类型 文本:text, 图片:image, 语音:voice, 视频:video, 文件:file, 文本卡片:textcard, 图文:news, 图文消息:link,小程序：miniprogram
     String picURL *; 图文消息的图片链接，支持JPG、PNG格式，较好的效果为大图 1068*455，小图150*150。（文本卡片、图文 必传）
     String title *;
] ,
     String describe;
     String picture;
     String price;
}
 */
export function add(data) {
  return request({
    url: service + '/add',
    method: 'post',
    data,
  })
}

/**
 * 修改
 * @param {*} data 同新增
 */
export function update(data, id) {
  return request({
    url: service + '/update/' + id,
    method: 'put',
    data,
  })
}

/**
 * 删除
 * @param {*} ids
 */
export function remove(ids) {
  return request({
    url: service + '/delete/' + ids,
    method: 'DELETE',
  })
}

// 商品详情统计
export function getDetailTotal(id) {
  return request({
    url: service + '/statistics/' + id,
  })
}

// 商品详情折线图
export function getDetailChart(data) {
  return request({
    url: service + '/lineChart',
    data,
    method: 'post',
  })
}

// 商品详情top5
export function getDetailTable(id) {
  return request({
    url: service + '/top5/' + id,
  })
}

// 订单列表
export function getOrderTalbe(data) {
  return request({
    url: service + '/order/page/list',
    params: data,
  })
}

// 订单同步
export function setOrderSync() {
  return request({
    url: service + '/order/orderSync',
  })
}

// 订单导出
export function exportOrder(data) {
  return request({
    url: service + '/order/export',
    params: data,
    responseType: 'blob',
  })
}

// 订单交易状态
export function getOrderState(orderId) {
  return request({
    url: service + '/order/trading/status/' + orderId,
  })
}

// 订单退款状态
export function getRefundOrderState(orderNo) {
  return request({
    url: service + '/refund/refund/status/' + orderNo,
  })
}

// 商品分析 汇总
export function getGoodsTotal() {
  return request({
    url: service + '/analyze/statistics',
  })
}

// 商品分析 折线图
export function getLineChartTotal(data) {
  return request({
    url: service + '/analyze/lineChart',
    method: 'post',
    data,
  })
}

// 商品分析 商品top5
export function getGoodsTop5(data) {
  return request({
    url: service + '/analyze/top5',
    method: 'post',
    data,
  })
}

// 商品分析 员工top5
export function getMembersTop5(data) {
  return request({
    url: service + '/analyze/user/top5',
    method: 'post',
    data,
  })
}

// 商品分析 数据报表
export function getTableTotal(data) {
  return request({
    url: service + '/analyze/data/report',
    params: data,
  })
}

// 商品分析 数据报表 导出
export function getTableExport(data) {
  return request({
    url: service + '/analyze/data/report/export',
    method: 'post',
    responseType: 'blob',
    data,
  })
}
