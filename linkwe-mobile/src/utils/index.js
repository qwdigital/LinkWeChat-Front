import { getUserOpenid, getWechatUserInfo } from '@/api/common'
/**
 * query请求路径参数转为对象
 * @param {*} url
 */
export function param2Obj(url) {
  url = url == null ? window.location.href : url

  let search = decodeURIComponent(url).split('?')[1]
  search = search && search.split('#')[0]
  if (!search) {
    return {}
  }
  return JSON.parse(
    '{"' +
      search
        .replace(/"/g, '\\"')
        .replace(/&/g, '","')
        .replace(/=/g, '":"') +
      '"}'
  )
}

/**
 * Obj转为路径query请求参数
 * @param {*} obj
 */
export function obj2query(obj) {
  if (!obj) return ''
  return Object.keys(obj)
    .map((key) => {
      if (obj[key] === undefined) return ''
      return key + '=' + obj[key]
    })
    .filter((e) => !!e)
    .join('&')
}

/**
 * 获取query请求参数中name对应的值
 * @param string name
 */
export function getQueryValue(name) {
  let url = window.location.href
  let search = decodeURIComponent(url).split('?')[1]
  search = search && search.split('#')[0]
  if (!search) {
    return ''
  }

  let reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)')
  let r = search.match(reg)
  if (r != null) {
    return r[2]
  }
  return ''
}

export function getWxCode() {
  let userinfo = localStorage.getItem('userinfo')
  //取缓存中的用户信息
  if (userinfo) {
    try {
      userinfo = JSON.parse(userinfo)
    } catch (error) {
      alert(error)
    }
    return
  }

  //缓存中没有用户信息，进入授权流程
  let appid = 'wx863c031a74f589a0' // 公众号appid
  // let appid = 'wx8bfe6bc2ca5c45ae' // 公众号appid
  let code = getQueryValue('code') //是否存在code
  let local = window.location.origin.includes('localhost')
    ? 'http://h5.linkwechat.cn/test.html'
    : window.location.href
  // let local = 'http://h5.x*****o.com/'
  if (!code) {
    //不存在就打开上面的地址进行授权
    window.location.href = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(
      local
    )}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect`

    return false
    // window.location.href =
    //     `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(local)}&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect`;
  }
  // getUserOpenid(code)
  //   .then(({ data }) => {
  //     if (data && data.openId) {
  //       localStorage.setItem('userinfo', JSON.stringify(data))
  //       return getWechatUserInfo(data.openId)
  //     }
  //   })
  //   .then(({ data }) => {
  //     let unionId = data.unionId
  //   })
}

// 日期时间格式化
export function dateFormat(dateString, fmt = 'yyyy-MM-dd hh:mm:ss') {
  if (!dateString) {
    return
  }
  var date = new Date(dateString.replace(/-/g, '/'))
  var o = {
    'M+': date.getMonth() + 1, //月份
    'd+': date.getDate(), //日
    'h+': date.getHours(), //小时
    'm+': date.getMinutes(), //分
    's+': date.getSeconds(), //秒
    'q+': Math.floor((date.getMonth() + 3) / 3), //季度
    'S+': date.getMilliseconds(), //毫秒
    'w+': '星期' + '日一二三四五六'.charAt(date.getDay()), //星期
  }

  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
  }

  for (var k in o) {
    if (new RegExp('(' + k + ')').test(fmt)) {
      fmt = fmt.replace(
        RegExp.$1,
        RegExp.$1.length == 1 || String(o[k]).length > 1 ? o[k] : '0' + o[k]
      )
    }
  }

  return fmt
}
