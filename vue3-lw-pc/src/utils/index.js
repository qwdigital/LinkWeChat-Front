import { parseTime } from './common'
import axios from 'axios'

// 日期时间格式化
export function dateFormat(dateString, fmt = 'YYYY-MM-DD HH:mm:ss') {
  if (!dateString) {
    return
  }
  var date = dateString
  if (Object.prototype.toString.call(dateString) !== '[object Date]') {
    date = new Date(dateString.replace(/-/g, '/'))
  }
  var o = {
    'M+': date.getMonth() + 1, //月份
    'D+': date.getDate(), //日
    'H+': date.getHours(), //小时
    'm+': date.getMinutes(), //分
    's+': date.getSeconds(), //秒
    'q+': Math.floor((date.getMonth() + 3) / 3), //季度
    'S+': date.getMilliseconds(), //毫秒
    'w+': '星期' + '日一二三四五六'.charAt(date.getDay()), //星期
  }

  if (/(y+)/i.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
  }

  for (var k in o) {
    if (new RegExp('(' + k + ')').test(fmt)) {
      fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 || String(o[k]).length > 1 ? o[k] : '0' + o[k])
    }
  }

  return fmt
}

/**
 * @param {number} time
 * @param {string} option
 * @returns {string}
 */
export function formatTime(time, option) {
  if (('' + time).length === 10) {
    time = parseInt(time) * 1000
  } else {
    time = +time
  }
  const d = new Date(time)
  const now = Date.now()

  const diff = (now - d) / 1000

  if (diff < 30) {
    return '刚刚'
  } else if (diff < 3600) {
    // less 1 hour
    return Math.ceil(diff / 60) + '分钟前'
  } else if (diff < 3600 * 24) {
    return Math.ceil(diff / 3600) + '小时前'
  } else if (diff < 3600 * 24 * 2) {
    return '1天前'
  }
  if (option) {
    return parseTime(time, option)
  } else {
    return d.getMonth() + 1 + '月' + d.getDate() + '日' + d.getHours() + '时' + d.getMinutes() + '分'
  }
}

// 时间差
export function diffDate(startDate, endDate) {
  if (!startDate || !endDate) {
    return
  }
  const start = new Date(startDate)
  const end = new Date(endDate)
  const diff = (end - start) / 1000
  console.log(diff)
  const days = parseInt(diff / 86400)
  const hours = parseInt(diff / 3600) - 24 * days
  const minutes = parseInt((diff % 3600) / 60)
  const seconds = parseInt(diff % 60)
  if (hours) {
    return hours + 'h' + minutes + 'm' + seconds + 's'
  }
  if (minutes) {
    return minutes + 'm' + seconds + 's'
  }
  return seconds + 's'
}

/**
 * @param {string} url
 * @returns {Object}
 */
export function query2Obj(url) {
  url = url == null ? window.location.href : url
  let search = url.substring(url.indexOf('?') + 1)
  let obj = {}
  let reg = /([^?&#=]+)=([^?&#=]*)/g
  search?.replace(reg, (rs, $1, $2) => {
    const name = decodeURIComponent($1)
    let val = decodeURIComponent($2)
    val = String(val)
    obj[name] = val
    return rs
  })
  return obj
}

/**
 * 获取query请求参数中name对应的值
 * @param string name
 */
export function getQueryValue(name) {
  let url = window.location.href

  let reg = new RegExp('(^|&|\\?)' + name + '=([^&#]*)(&|#|$)')
  let r = url.match(reg)
  if (r != null) {
    return decodeURIComponent(r[2])
  }
  return ''
}

/**
 * @param {string} input value
 * @returns {number} output value
 */
export function byteLength(str) {
  // returns the byte length of an utf8 string
  let s = str.length
  for (var i = str.length - 1; i >= 0; i--) {
    const code = str.charCodeAt(i)
    if (code > 0x7f && code <= 0x7ff) s++
    else if (code > 0x7ff && code <= 0xffff) s += 2
    if (code >= 0xdc00 && code <= 0xdfff) i--
  }
  return s
}

/**
 * @param {Array} actual
 * @returns {Array}
 */
export function cleanArray(actual) {
  const newArray = []
  for (let i = 0; i < actual.length; i++) {
    if (actual[i]) {
      newArray.push(actual[i])
    }
  }
  return newArray
}

/**
 * @param {Object} json
 * @returns {Array}
 */
export function param(json) {
  if (!json) return ''
  return cleanArray(
    Object.keys(json).map((key) => {
      if (json[key] === undefined) return ''
      return encodeURIComponent(key) + '=' + encodeURIComponent(json[key])
    }),
  ).join('&')
}

// /**
//  * @param {string} url
//  * @returns {Object}
//  */
// export function param2Obj(url) {
//   const search = decodeURIComponent(url.split('?')[1]).replace(/\+/g, ' ')
//   if (!search) {
//     return {}
//   }
//   const obj = {}
//   const searchArr = search.split('&')
//   searchArr.forEach((v) => {
//     const index = v.indexOf('=')
//     if (index !== -1) {
//       const name = v.substring(0, index)
//       const val = v.substring(index + 1, v.length)
//       obj[name] = val
//     }
//   })
//   return obj
// }

/**
 * @param {string} val
 * @returns {string}
 */
export function html2Text(val) {
  const div = document.createElement('div')
  div.innerHTML = val
  return div.textContent || div.innerText
}

/**
 * Merges two objects, giving the last one precedence
 * @param {Object} target
 * @param {(Object|Array)} source
 * @returns {Object}
 */
export function objectMerge(target, source) {
  if (typeof target !== 'object') {
    target = {}
  }
  if (Array.isArray(source)) {
    return source.slice()
  }
  Object.keys(source).forEach((property) => {
    const sourceProperty = source[property]
    if (typeof sourceProperty === 'object') {
      target[property] = objectMerge(target[property], sourceProperty)
    } else {
      target[property] = sourceProperty
    }
  })
  return target
}

/**
 * @param {HTMLElement} element
 * @param {string} className
 */
export function toggleClass(element, className) {
  if (!element || !className) {
    return
  }
  let classString = element.className
  const nameIndex = classString.indexOf(className)
  if (nameIndex === -1) {
    classString += '' + className
  } else {
    classString = classString.substr(0, nameIndex) + classString.substr(nameIndex + className.length)
  }
  element.className = classString
}

/**
 * @param {string} type
 * @returns {Date}
 */
export function getTime(type) {
  if (type === 'start') {
    return new Date().getTime() - 3600 * 1000 * 24 * 90
  } else {
    return new Date(new Date().toDateString())
  }
}

/**
 * @param {Function} func
 * @param {number} wait
 * @param {boolean} immediate
 * @return {*}
 */
export function debounce(func, wait, immediate) {
  let timeout, args, context, timestamp, result

  const later = function () {
    // 据上一次触发时间间隔
    const last = +new Date() - timestamp

    // 上次被包装函数被调用时间间隔 last 小于设定时间间隔 wait
    if (last < wait && last > 0) {
      timeout = setTimeout(later, wait - last)
    } else {
      timeout = null
      // 如果设定为immediate===true，因为开始边界已经调用过了此处无需调用
      if (!immediate) {
        result = func.apply(context, args)
        if (!timeout) context = args = null
      }
    }
  }

  return function (...args) {
    context = this
    timestamp = +new Date()
    const callNow = immediate && !timeout
    // 如果延时不存在，重新设定延时
    if (!timeout) timeout = setTimeout(later, wait)
    if (callNow) {
      result = func.apply(context, args)
      context = args = null
    }

    return result
  }
}

/**
 * This is just a simple version of deep copy
 * Has a lot of edge cases bug
 * If you want to use a perfect deep copy, use lodash's _.cloneDeep
 * @param {Object} source
 * @returns {Object}
 */
export function deepClone(source) {
  if (!source && typeof source !== 'object') {
    throw new Error('error arguments', 'deepClone')
  }
  const targetObj = source.constructor === Array ? [] : {}
  Object.keys(source).forEach((keys) => {
    if (source[keys] && typeof source[keys] === 'object') {
      targetObj[keys] = deepClone(source[keys])
    } else {
      targetObj[keys] = source[keys]
    }
  })
  return targetObj
}

/**
 * @param {Array} arr
 * @returns {Array}
 */
export function uniqueArr(arr) {
  return Array.from(new Set(arr))
}

/**
 * @returns {string}
 */
export function createUniqueString() {
  const timestamp = +new Date() + ''
  const randomNum = parseInt((1 + Math.random()) * 65536) + ''
  return (+(randomNum + timestamp)).toString(32)
}

/**
 * Check if an element has a class
 * @param {HTMLElement} elm
 * @param {string} cls
 * @returns {boolean}
 */
export function hasClass(ele, cls) {
  return !!ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'))
}

/**
 * Add class to element
 * @param {HTMLElement} elm
 * @param {string} cls
 */
export function addClass(ele, cls) {
  if (!hasClass(ele, cls)) ele.className += ' ' + cls
}

/**
 * Remove class from element
 * @param {HTMLElement} elm
 * @param {string} cls
 */
export function removeClass(ele, cls) {
  if (hasClass(ele, cls)) {
    const reg = new RegExp('(\\s|^)' + cls + '(\\s|$)')
    ele.className = ele.className.replace(reg, ' ')
  }
}

export function makeMap(str, expectsLowerCase) {
  const map = Object.create(null)
  const list = str.split(',')
  for (let i = 0; i < list.length; i++) {
    map[list[i]] = true
  }
  return expectsLowerCase ? (val) => map[val.toLowerCase()] : (val) => map[val]
}

export const exportDefault = 'export default '

export const beautifierConf = {
  html: {
    indent_size: '2',
    indent_char: ' ',
    max_preserve_newlines: '-1',
    preserve_newlines: false,
    keep_array_indentation: false,
    break_chained_methods: false,
    indent_scripts: 'separate',
    brace_style: 'end-expand',
    space_before_conditional: true,
    unescape_strings: false,
    jslint_happy: false,
    end_with_newline: true,
    wrap_line_length: '110',
    indent_inner_html: true,
    comma_first: false,
    e4x: true,
    indent_empty_lines: true,
  },
  js: {
    indent_size: '2',
    indent_char: ' ',
    max_preserve_newlines: '-1',
    preserve_newlines: false,
    keep_array_indentation: false,
    break_chained_methods: false,
    indent_scripts: 'normal',
    brace_style: 'end-expand',
    space_before_conditional: true,
    unescape_strings: false,
    jslint_happy: true,
    end_with_newline: true,
    wrap_line_length: '110',
    indent_inner_html: true,
    comma_first: false,
    e4x: true,
    indent_empty_lines: true,
  },
}

// 首字母大小
export function titleCase(str) {
  return str.replace(/( |^)[a-z]/g, (L) => L.toUpperCase())
}

// 下划转驼峰
export function camelCase(str) {
  return str.replace(/-[a-z]/g, (str1) => str1.substr(-1).toUpperCase())
}

export function isNumberStr(str) {
  return /^[+-]?(0|([1-9]\d*))(\.\d+)?$/g.test(str)
}

// 日期快捷选项
export const pickerOptions = {
  disabledDate(time) {
    return time.getTime() > Date.now()
  },
  shortcuts: [
    {
      text: '最近一周',
      value() {
        const end = new Date()
        const start = new Date()
        start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
        return [start, end]
      },
    },
    {
      text: '最近一个月',
      value() {
        const end = new Date()
        const start = new Date()
        start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
        return [start, end]
      },
    },
    {
      text: '最近三个月',
      value() {
        const end = new Date()
        const start = new Date()
        start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
        return [start, end]
      },
    },
  ],
}

// echart图表配色规范
export const echartColors = [
  '#0F68FF',
  '#34D7C3',
  '#FFBF49',
  '#FF5954',
  '#52DDFF',
  '#34D781',
  '#FFE85F',
  '#7F47FF',
  '#A47D79',
  '#7796D7',
  '#89C369',
  '#B595D4',
  '#E4CBCB',
  '#7D889B',
  '#AAAFB7',
  '#DCD7B0',
  '#749E84',
  '#B0BBDC',
]

export function uuid(before = '', after = '') {
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('')
  const charsLen = chars.length
  let uuid = []
  const len = 16
  for (let i = 0; i < len; i++) {
    uuid[i] = chars[0 | (Math.random() * charsLen)]
  }
  return before + uuid.join('') + after
}

// 微信表情包匹配
export const emotion = [
  '[微笑]',
  '[撇嘴]',
  '[色]',
  '[发呆]',
  '[得意]',
  '[流泪]',
  '[害羞]',
  '[闭嘴]',
  '[睡]',
  '[大哭]',
  '[尴尬]',
  '[发怒]',
  '[调皮]',
  '[呲牙]',
  '[惊讶]',
  '[难过]',
  '[酷]',
  '[冷汗]',
  '[抓狂]',
  '[吐]',
  '[偷笑]',
  '[可爱]',
  '[白眼]',
  '[傲慢]',
  '[饥饿]',
  '[困]',
  '[惊恐]',
  '[流汗]',
  '[憨笑]',
  '[大兵]',
  '[奋斗]',
  '[咒骂]',
  '[疑问]',
  '[嘘]',
  '[晕]',
  '[折磨]',
  '[衰]',
  '[骷髅]',
  '[敲打]',
  '[再见]',
  '[擦汗]',
  '[抠鼻]',
  '[鼓掌]',
  '[糗大了]',
  '[坏笑]',
  '[左哼哼]',
  '[右哼哼]',
  '[哈欠]',
  '[鄙视]',
  '[委屈]',
  '[快哭了]',
  '[阴险]',
  '[亲亲]',
  '[吓]',
  '[可怜]',
  '[菜刀]',
  '[西瓜]',
  '[啤酒]',
  '[篮球]',
  '[乒乓]',
  '[咖啡]',
  '[饭]',
  '[猪头]',
  '[玫瑰]',
  '[凋谢]',
  '[示爱]',
  '[爱心]',
  '[心碎]',
  '[蛋糕]',
  '[闪电]',
  '[炸弹]',
  '[刀]',
  '[足球]',
  '[瓢虫]',
  '[便便]',
  '[月亮]',
  '[太阳]',
  '[礼物]',
  '[拥抱]',
  '[强]',
  '[弱]',
  '[握手]',
  '[胜利]',
  '[抱拳]',
  '[勾引]',
  '[拳头]',
  '[差劲]',
  '[爱你]',
  '[NO]',
  '[OK]',
  '[爱情]',
  '[飞吻]',
  '[跳跳]',
  '[发抖]',
  '[怄火]',
  '[转圈]',
  '[磕头]',
  '[回头]',
  '[跳绳]',
  '[挥手]',
  '[激动]',
  '[街舞]',
  '[献吻]',
  '[左太极]',
  '[右太极]',
]

// 获取微信用户授权登录用户信息
import { wxLogin, getWechatUserInfo, getWxRedirect } from '@/api/common'
import { setToken, removeToken } from '@/utils/auth'
export async function getWechatAuthUserInfo(appId) {
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

  //缓存中没有用户信息，进入授权流程
  // let appId = 'wxa57479bcd3f15461'
  // let appId = window.lwConfig.WX_APPID // 微信公众号id
  // let appId = 'wxa57479bcd3f15461' // 公众号appid
  let code = getQueryValue('code') //是否存在code
  // let query = param2Obj() //
  // let { code, appId, secret } = query
  let local = window.location.href
  if (!code) {
    //不存在就打开上面的地址进行授权
    let url = ''
    if (appId) {
      url = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appId}&redirect_uri=${encodeURIComponent(
        local,
      )}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect`
    } else {
      url = (await getWxRedirect()).data
    }
    window.location.href = url
    // return new Promise(() => { })
    // window.location.href =
    //     `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(local)}&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect`;
  }
  try {
    // let { data } = await getUserOpenid({ code, appId, secret })
    if (code) {
      let { data: dataLogin } = await wxLogin(code)
      setToken(dataLogin.access_token)
      let { data: dataUser } = await getWechatUserInfo()
      removeToken()
      sessionStorage.setItem('userinfo', JSON.stringify(dataUser))
      return dataUser
    }
  } catch (error) {
    // alert(JSON.stringify(error))
    return Promise.reject()
  }
}

// stime 开始时间 etime 结束时间  currentTime指定日期
export function compareTime(stime, etime, currentTime) {
  if (!stime || !etime) {
    return
  }
  let thisDate = ''
  if (currentTime) {
    thisDate = new Date(currentTime)
  } else {
    thisDate = new Date()
  }
  let startTime = tranDate(stime)
  let endTime = tranDate(etime)
  let time =
    thisDate.getFullYear() +
    '-' +
    (thisDate.getMonth() + 1) +
    '-' +
    thisDate.getDate() +
    ' ' +
    thisDate.getHours() +
    ':' +
    thisDate.getMinutes()
  let nowTime = tranDate(time)
  if (nowTime < startTime) {
    return 'before'
  } else if (nowTime > endTime) {
    return 'after'
  } else {
    return 'middle'
  }
}
function tranDate(time) {
  return new Date(time.replace(/-/g, '/')).getTime()
}

// 获取本机公网ip
export function getIP() {
  // return new Promise(function (resolve, reject) {
  //   let script = document.createElement('script')
  //   script.setAttribute('charset', 'utf-8')
  //   script.setAttribute('type', 'text/javascript')
  //   script.setAttribute('src', 'https://pv.sohu.com/cityjson?ie=utf-8')
  //   document.getElementsByTagName('head')[0].appendChild(script)
  //   script.onload = function () {
  //     document.getElementsByTagName('head')[0].removeChild(script)
  //     resolve(returnCitySN['cip'])
  //   }
  //   script.onerror = function () {
  //     document.getElementsByTagName('head')[0].removeChild(script)
  //     reject('')
  //   }
  // })

  return axios({
    url: 'https://api.ipify.org/?format=json',
  }).then(({ data }) => data.ip || Promise.reject())
}

import { getProCityList } from '@/api/common'
// import { treeToArray } from './common'
// 获取省市区树形数据
export async function getProvinceCityTree() {
  let area = window.sessionStorage.getItem('provinceCityTree')
  if (area) {
    area = JSON.parse(area)
  } else {
    area = (await getProCityList()).data
    window.sessionStorage.setItem('provinceCityTree', JSON.stringify(area))
  }
  return area
}

// 判断是否为移动端
export function isMobile() {
  let flag = navigator.userAgent.match(
    /(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i,
  )
  return flag
}

export function setAttachments(list) {
  let arr = []
  if (list && list.length) {
    list.forEach((dd) => {
      if (dd.msgType === 'image') {
        let obj = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '0',
          materialUrl: dd.picUrl,
        }
        arr.push(obj)
      } else if (dd.msgType === 'video') {
        let obj = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '2',
          materialUrl: dd.fileUrl,
          coverUrl: dd.picUrl,
          digest: dd.description,
          materialName: dd.title,
        }
        arr.push(obj)
      } else if (dd.msgType === 'file') {
        let obj = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '3',
          materialUrl: dd.fileUrl,
          digest: dd.description,
          materialName: dd.title,
        }
        arr.push(obj)
      } else if (dd.msgType === 'text') {
        let obj = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '4',
          content: dd.content,
        }
        arr.push(obj)
      } else if (dd.msgType === 'link') {
        let obj = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '9',
          content: dd.content,
          coverUrl: dd.picUrl,
          materialUrl: dd.linkUrl,
          materialName: dd.title,
        }
        arr.push(obj)
      } else if (dd.msgType === 'miniprogram') {
        let ff = {
          mediaType: '11',
          materialName: dd.title,
          id: dd.materialId,
          digest: dd.appId,
          materialName: dd.title,
          coverUrl: dd.picUrl,
          materialUrl: dd.fileUrl,
        }
        arr.push(ff)
      } else if (dd.msgType === 'news') {
        let ff = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '12',
          digest: dd.description,
          materialUrl: dd.fileUrl,
          coverUrl: dd.picUrl,
          content: dd.content,
          materialName: dd.title,
        }
        arr.push(ff)
      } else if (dd.msgType === 'posters') {
        let obj = {
          materialName: dd.title,
          id: dd.materialId,
          mediaType: '5',
          materialUrl: dd.fileUrl,
          materialName: dd.title,
        }
        arr.push(obj)
      }
    })
  }
  return arr
}

// 递归删除树形对象中的某些字段
export function delTreeKeys(obj, keyArray) {
  for (const key in obj) {
    const element = obj[key]
    if (element && typeof element == 'object') {
      delTreeKeys(element, keyArray)
    }
    keyArray.includes(key) && delete obj[key]
  }
}
