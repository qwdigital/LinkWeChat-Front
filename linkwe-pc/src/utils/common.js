/**
 * 通用js方法封装处理，挂载到 Vue.prototype
 */

const baseURL = window.lwConfig.BASE_API
import { getToken } from '@/utils/auth'
import axios from 'axios'

// 日期格式化
export function parseTime(time, pattern) {
  if (arguments.length === 0 || !time) {
    return null
  }
  const format = pattern || '{y}-{m}-{d} {h}:{i}:{s}'
  let date
  if (typeof time === 'object') {
    date = time
  } else {
    if (typeof time === 'string' && /^[0-9]+$/.test(time)) {
      time = parseInt(time)
    } else if (typeof time === 'string') {
      time = time.replace(new RegExp(/-/gm), '/')
    }
    if (typeof time === 'number' && time.toString().length === 10) {
      time = time * 1000
    }
    date = new Date(time)
  }
  const formatObj = {
    y: date.getFullYear(),
    m: date.getMonth() + 1,
    d: date.getDate(),
    h: date.getHours(),
    i: date.getMinutes(),
    s: date.getSeconds(),
    a: date.getDay(),
  }
  const time_str = format.replace(/{(y|m|d|h|i|s|a)+}/g, (result, key) => {
    let value = formatObj[key]
    // Note: getDay() returns 0 on Sunday
    if (key === 'a') {
      return ['日', '一', '二', '三', '四', '五', '六'][value]
    }
    if (result.length > 0 && value < 10) {
      value = '0' + value
    }
    return value || 0
  })
  return time_str
}

// 表单重置
export function resetForm(refName) {
  if (this.$refs[refName]) {
    this.$refs[refName].resetFields()
  }
}

// 添加日期范围
export function addDateRange(params, dateRange) {
  var search = params
  search.beginTime = ''
  search.endTime = ''
  if (null != dateRange && '' != dateRange) {
    search.beginTime = this.dateRange[0]
    search.endTime = this.dateRange[1]
  }
  return search
}

// 回显数据字典
export function selectDictLabel(datas, value) {
  var actions = []
  Object.keys(datas).some((key) => {
    if (datas[key].dictValue == '' + value) {
      actions.push(datas[key].dictLabel)
      return true
    }
  })
  return actions.join('')
}

// 回显数据字典（字符串数组）
export function selectDictLabels(datas, value, separator) {
  var actions = []
  var currentSeparator = undefined === separator ? ',' : separator
  var temp = value.split(currentSeparator)
  Object.keys(value.split(currentSeparator)).some((val) => {
    Object.keys(datas).some((key) => {
      if (datas[key].dictValue == '' + temp[val]) {
        actions.push(datas[key].dictLabel + currentSeparator)
      }
    })
  })
  return actions.join('').substring(0, actions.join('').length - 1)
}

// 通用下载方法 系统内部
export function download(fileName) {
  axios({
    method: 'GET',
    url: baseURL + '/common/download?fileName=' + encodeURI(fileName) + '&delete=' + true,
    responseType: 'blob',
    headers: {
      Authorization: 'Bearer ' + getToken(),
    },
  }).then((res) => {
    const { data, headers } = res
    const blob = new Blob([data], { type: headers['content-type'] })
    let dom = document.createElement('a')
    let url = window.URL.createObjectURL(blob)
    dom.href = url
    dom.download = fileName
    dom.style.display = 'none'
    document.body.appendChild(dom)
    dom.click()
    dom.parentNode.removeChild(dom)
    window.URL.revokeObjectURL(url)
  })
}

// 通用下载方法 网络文件路径
export function downloadNet(url, fileName) {
  axios({
    method: 'GET',
    url: baseURL + '/common/download/url?url=' + url,
    responseType: 'blob',
    headers: {
      Authorization: 'Bearer ' + getToken(),
    },
  }).then((res) => {
    const { data, headers } = res
    const blob = new Blob([data], { type: headers['content-type'] })
    let dom = document.createElement('a')
    let url = window.URL.createObjectURL(blob)
    dom.href = url
    dom.download = fileName
    dom.style.display = 'none'
    document.body.appendChild(dom)
    dom.click()
    dom.parentNode.removeChild(dom)
    window.URL.revokeObjectURL(url)
  })
}

// 字符串格式化(%s )
export function sprintf(str) {
  var args = arguments,
    flag = true,
    i = 1
  str = str.replace(/%s/g, function () {
    var arg = args[i++]
    if (typeof arg === 'undefined') {
      flag = false
      return ''
    }
    return arg
  })
  return flag ? str : ''
}

// 转换字符串，undefined,null等转化为""
export function praseStrEmpty(str) {
  if (!str || str == 'undefined' || str == 'null') {
    return ''
  }
  return str
}

/**
 * 数组构造树型结构数据
 * @param {Array} data 数据源
 * @param {*} id id字段 默认 'id'
 * @param {*} parentId 父节点字段 默认 'parentId'
 * @param {*} children 孩子节点字段 默认 'children'
 */
export function handleTree(data, id, parentId, children) {
  id = id || 'id'
  parentId = parentId || 'parentId'
  children = children || 'children'
  let result = []
  data = JSON.parse(JSON.stringify(data))
  if (!Array.isArray(data)) {
    return result
  }
  data.forEach((item) => {
    delete item[children]
  })
  let map = {}
  data.forEach((item) => {
    map[item[id]] = item
  })
  data.forEach((item) => {
    let parent = map[item[parentId]]
    if (parent) {
      parent[children] || (parent[children] = [])
      parent[children].push(item)
    } else {
      result.push(item)
    }
  })
  return result
}

/**
 * 树转数组
 * @param {*} tree
 * @param {*} children 孩子节点字段 默认 'children'
 * @param {Function} callback 回调函数
 * @returns {Array}
 */
export function treeToArray(tree = [], children = 'children', callback) {
  let result = []
  let level = 0
  function dg(obj) {
    callback && callback(obj, result, level)
    ++level
    if (obj[children]) {
      result.push(...obj[children])
      obj[children].forEach((e) => {
        dg(e)
      })
      // delete obj.children
    }
    --level
  }
  if (Array.isArray(tree)) {
    result.push(...tree)
    tree.forEach((e) => dg(e))
  } else {
    result.push(tree)
    dg(tree)
  }
  return result
}

/**
 * dataURL转化为File对象
 * @param {*} dataURL 本地数据 base64
 */
export function dataURLtoFile(dataURL) {
  const arr = dataURL.split(',')
  const mime = arr[0].match(/:(.*?);/)[1]
  const bstr = atob(arr[1])
  let n = bstr.length
  const u8arr = new Uint8Array(n)
  while (n) {
    u8arr[n - 1] = bstr.charCodeAt(n - 1)
    n -= 1 // to make eslint happy
  }
  return new File([u8arr], '', { type: mime })
}

// FormData 格式转化
export function toFormData(val) {
  let formData = new FormData()
  for (let i in val) {
    isArray(val[i], i)
  }

  function isArray(array, key) {
    if (array == undefined || typeof array == 'function') {
      return false
    }
    if (typeof array != 'object') {
      formData.append(key, array)
    } else if (array instanceof Array) {
      if (array.length !== 0) {
        for (let i in array) {
          for (let j in array[i]) {
            isArray(array[i][j], `${key}[${i}].${j}`)
          }
        }
      }
    } else {
      let arr = Object.keys(array)
      if (arr.indexOf('uid') == -1) {
        for (let j in array) {
          isArray(array[j], `${key}.${j}`)
        }
      } else {
        formData.append(`${key}`, array)
      }
    }
  }
  return formData
}
