import { findCustomerAddWay } from '@/api/customer'

let _dictAddType = undefined
export let dictAddType = async function () {
  if (!_dictAddType) {
    let { data } = await findCustomerAddWay()
    _dictAddType = {}
    data.forEach((element) => {
      _dictAddType[element.code] = element.value
    })
  }
  return _dictAddType
}

// export default {
//   get dictAddType() {
//     return findCustomerAddWay().then(({ data }) => {
//       data.forEach((element) => {
//         this.dictAddType[element.code] = element.value
//       })
//     })
//   },
// }

export const dictJoinGroupType = Object.freeze({
  1: '由成员邀请入群（直接邀请入群)',
  2: '由成员邀请入群（通过邀请链接入群）',
  3: '通过扫描群二维码入群',
})

export const dictTrackState = Object.freeze({
  1: { name: '待跟进', color: '' },
  2: { name: '跟进中', color: 'warning' },
  3: { name: '已成交', color: 'success' },
  4: { name: '无意向', color: 'info' },
  5: { name: '已流失', color: 'danger' },
})

// 素材类型
export const dictMaterialType = Object.freeze({
  0: { name: '图片' },
  1: { name: '语音' },
  2: { name: '视频' },
  3: { name: '文件' },
  4: { name: '文本' },
  5: { name: '海报' },
  6: { name: '活码' },
  7: { name: '人群' },
  8: { name: '旅程' },
  9: { name: '图文' },
  10: { name: '链接' },
  11: { name: '小程序' },
  12: { name: '文章' },
  13: { name: '企业话术' },
  14: { name: '客服话术' },
  15: { name: '智能表单' },
  16: { name: 'SOP模板' },
  17: { name: '群发模板' },
  18: { name: '收集表' },
  19: { name: '外链' },
})
