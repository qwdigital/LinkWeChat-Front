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
