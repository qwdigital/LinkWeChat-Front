export const typeDict = Object.freeze({
  1: {
    name: '公众号',
    touchType: {
      0: {
        name: '文章',
        allName: '跳入微信-公众号-文章',
        tip: '跳转进入微信后，打开一篇公众号文章',
        previewMobileTitle: '公众号标题',
      },
      1: {
        name: '二维码',
        allName: '跳入微信-公众号-二维码',
        tip: '跳转进入微信后，展示一张公众号二维码，长按引导关注',
        previewMobileTitle: '添加公众号',
      },
    },
  },
  2: {
    name: '个人微信',
    touchType: {
      2: {
        name: '个人二维码',
        allName: '跳入微信-个人微信-个人二维码',
        tip: '跳转进入微信后，展示一张个人二维码，长按扫码添加好友',
        previewMobileTitle: '添加微信',
      },
      3: {
        name: '群二维码',
        allName: '跳入微信-个人微信-群二维码',
        tip: '跳转进入微信后，展示一张微信群二维码，长按扫码入群',
        previewMobileTitle: '添加微信群',
      },
    },
  },
  3: {
    name: '企业微信',
    touchType: {
      4: {
        name: '员工活码',
        allName: '跳入微信-企业微信-员工活码',
        tip: '跳转进入微信后，展示一张企微员工活码，长按扫码添加企业员工',
        previewMobileTitle: '添加企业员工',
      },
      5: {
        name: '客群活码',
        allName: '跳入微信-企业微信-客群活码',
        tip: '跳转进入微信后，展示一张企微客群活码，长按扫码入群',
        previewMobileTitle: '添加企业客群',
      },
      6: {
        name: '门店导购活码',
        allName: '跳入微信-企业微信-门店导购码',
        tip: '跳转进入微信后，展示一张门店导购码，长按扫码添加附近门店的导购',
        previewMobileTitle: '添加门店导购',
      },
      8: {
        name: '门店群活码',
        allName: '跳入微信-企业微信-门店群活码',
        tip: '跳转进入微信后，展示一张门店群活码，长按扫码进入附近的门店群',
        previewMobileTitle: '添加门店群',
      },
    },
  },
  4: {
    name: '小程序',
    touchType: {
      7: {
        name: '个人小程序',
        allName: '跳入微信-小程序-个人小程序',
        tip: '跳转进入微信后，直接打开一个个人小程序',
        previewMobileTitle: '打开小程序',
      },
      9: {
        name: '企业小程序',
        allName: '跳入微信-小程序-企业小程序',
        tip: '跳转进入微信后，直接打开一个企业小程序',
        previewMobileTitle: '打开小程序',
      },
      10: {
        name: '小程序二维码',
        allName: '跳入微信-小程序-小程序二维码',
        tip: '跳转进入微信后，展示一张小程序二维码，长按扫码打开小程序',
        previewMobileTitle: '打开小程序',
      },
    },
  },
})

const touchTypeDict = {}
Object.values(typeDict).forEach((element) => Object.assign(touchTypeDict, element.touchType))
export { touchTypeDict }
