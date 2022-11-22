/**
 * query请求路径参数转为对象
 * @param {*} url
 */
export function param2Obj (url) {
  try {
    url = url == null ? window.location.href : url
    let search = decodeURIComponent(url)
      .split('?')
      .slice(1)
    if (!search[0]) {
      return
    }
    search = search.filter((e) => e.includes('=')).map((e) => e.split('#')[0])
    search = search.join('&')
    return JSON.parse(
      '{"' +
      search
        .replace(/"/g, '\\"')
        .replace(/&/g, '","')
        .replace(/=/g, '":"') +
      '"}'
    )
  } catch (error) {
    alert(error)
  }

  // 更完善的方案
  // url = url == null ? window.location.href : url
  // const search = url.substring(url.lastIndexOf('?') + 1)
  // search = search && search.split('#')[0]
  // if (!search) {
  //   return {}
  // }
  // const obj = {}
  // const reg = /([^?&=]+)=([^?&=]*)/g
  // search.replace(reg, (rs, $1, $2) => {
  //   const name = decodeURIComponent($1)
  //   let val = decodeURIComponent($2)
  //   val = String(val)
  //   obj[name] = val
  //   return rs
  // })
  // return obj
}

/**
 * Obj转为路径query请求参数
 * @param {*} obj
 */
export function obj2query (obj) {
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
export function getQueryValue (name, str) {
  try {
    let url = str || window.location.href
    // let search = url.split('?')[1]
    // search = search && search.split('#')[0]
    // if (!search) {
    //   return ''
    // }
    let reg = new RegExp('(^|&|\\?)' + name + '=([^&#]*)(&|#|$)')
    let r = url.match(reg)
    if (r != null) {
      return decodeURIComponent(r[2])
    }
    return ''
  } catch (error) {
    alert(error)
  }
}

export function urlReplaceFirstHistory (url) {
  window.history.go(-(window.history.length - 1))
  window.location.replace(url)
}

import { getUserOpenid, getWechatUserInfo, getWxRedirect, wxLogin } from '@/api/common'

// 微信端授权登录
export async function getWxCode () {
 let userinfo = sessionStorage.getItem('userinfo')
 //取缓存中的用户信息
 if (userinfo) {
  try {
   userinfo = JSON.parse(userinfo)
  } catch (error) {
  // alert(error)
 }
 return userinfo
 }
 let code = getQueryValue('code') //是否存在code
 if (!code) {
    let url = (await getWxRedirect()).data
    let id = getQueryValue('appid', url)
    sessionStorage.setItem('weAppId', id)
    window.location.href = url
 }
 try {
  if (code) {
    let { data: dataLogin } = await wxLogin(code)
    sessionStorage.setItem('token', dataLogin.access_token)
    let { data: dataUser } = await getWechatUserInfo()
    sessionStorage.setItem('userinfo', JSON.stringify(dataUser))
    return dataUser
  }
} catch (error) {
  return Promise.reject()
}
}
  

// 日期时间格式化
export function dateFormat (dateString, fmt = 'yyyy-MM-dd hh:mm:ss') {
  if (!dateString) {
    return
  }
  var date = dateString
  if (Object.prototype.toString.call(dateString) !== '[object Date]') {
    if (!dateString.includes('T')) {
      dateString = dateString.replace(/-/g, '/')
    }
    date = new Date(dateString)
  }
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

export function stringifyError () {
  Error.prototype.toJSON = function () {
    return this.toString()
  }
}

export function baiduMapError (type) {
  let arr = [
    { code: 0, value: '检索成功' },
    { code: 1, value: '城市列表' },
    { code: 2, value: '位置结果未知' },
    { code: 3, value: '导航结果未知' },
    { code: 4, value: '非法密钥AK' },
    { code: 5, value: '非法请求' },
    { code: 6, value: '没有权限, 请确认手机是否打开定位服务！' },
    { code: 7, value: '服务不可用' },
    { code: 8, value: '超时' },
  ]
  let str
  arr.forEach(dd => {
    if (dd.code === type) {
      str = dd.value
    }
  })
  return str
}

export function splitName (str) {
  if (str) {
    let area = {}
    let index11 = 0
    let index1 = str.indexOf("省")
    if (index1 == -1) {
      index11 = str.indexOf("自治区")
      if (index11 != -1) {
        area.Province = str.substring(0, index11 + 3)
      } else {
        area.Province = str.substring(0, 0)
      }
    } else {
      area.Province = str.substring(0, index1 + 1)
    }

    let index2 = str.indexOf("市")
    if (index11 == -1) {
      area.City = str.substring(index11 + 1, index2 + 1)
    } else {
      if (index11 == 0) {
        area.City = str.substring(index1 + 1, index2 + 1)
      } else {
        area.City = str.substring(index11 + 3, index2 + 1)
      }
    }
    let index3 = str.indexOf("区")
    if (index3 == -1) {
      index3 = str.indexOf("县")
      if (index3 == -1) {
        index3 = str.indexOf('旗')
        area.Country = str.substring(index2 + 1, index3 + 1)
      } else {
        area.Country = str.substring(index2 + 1, index3 + 1)
      }
    } else {
      area.Country = str.substring(index2 + 1, index3 + 1)
    }
    return [area.Province, area.City, area.Country]
  } else {
    return ''
  }
}