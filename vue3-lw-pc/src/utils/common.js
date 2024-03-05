/**
 * 通用js方法封装处理，挂载到 vueApp.config.globalProperties
 */

const baseURL = window.lwConfig.BASE_API
import { getToken } from '@/utils/auth'
import { dateFormat } from '@/utils/index'
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

/**
 * 下载bolb文件
 * @param {*} blob bolo源数据 必需
 * @param {*} downloadName 下载文件名，需含文件后缀名 必需
 * @param {*} type 文件类型 enum: excel,zip,image
 * @param {*} callback 成功回调
 */
export function downloadBlob(blob, downloadName, type, callback) {
  if (!blob || !downloadName) {
    this?.msgError?.('文件或文件名不存在，请联系系统管理员')
    throw '文件或文件名不存在，请联系系统管理员'
  }
  if (blob instanceof Blob) {
    const typeDict = {
      excel: 'application/vnd.ms-excel',
      zip: 'application/zip',
      image: 'application/image',
    }
    type && (blob = new Blob([blob], { type: typeDict[type] || type }))
    let url = window.URL.createObjectURL(blob)
    const a = document.createElement('a') // 创建a标签
    a.href = url
    a.download = dateFormat(new Date(), 'YYMMDD-HHmmss-') + downloadName // 下载文件名，不能包含英文 : 冒号
    a.click()
    a.remove()
    URL.revokeObjectURL(url) // 释放内存
    callback && callback()
    this?.msgSuccess?.('正在下载，请稍后至浏览器下载栏查看')
  } else if (/^(http|data:image)/.test(blob) && type === 'image') {
    let image = new Image()
    image.setAttribute('crossOrigin', 'anonymous')
    image.src = blob
    image.onload = () => {
      let canvas = document.createElement('canvas')
      canvas.width = image.width
      canvas.height = image.height
      let ctx = canvas.getContext('2d')
      ctx.drawImage(image, 0, 0, image.width, image.height)
      canvas.toBlob((blob) => {
        downloadBlob(blob, downloadName, callback)
      })
    }
  } else {
    this?.msgError?.('blob：文件类型错误')
    throw 'blob：文件类型错误'
  }
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
    downloadBlob(data, fileName, headers['content-type'])

    // const blob = new Blob([data], { type: headers['content-type'] })
    // let dom = document.createElement('a')
    // let url = window.URL.createObjectURL(blob)
    // dom.href = url
    // dom.download = fileName
    // dom.style.display = 'none'
    // document.body.appendChild(dom)
    // dom.click()
    // dom.parentNode.removeChild(dom)
    // window.URL.revokeObjectURL(url)
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
    downloadBlob(data, fileName, headers['content-type'])

    // const blob = new Blob([data], { type: headers['content-type'] })
    // let dom = document.createElement('a')
    // let url = window.URL.createObjectURL(blob)
    // dom.href = url
    // dom.download = fileName
    // dom.style.display = 'none'
    // document.body.appendChild(dom)
    // dom.click()
    // dom.parentNode.removeChild(dom)
    // window.URL.revokeObjectURL(url)
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

// 判断ppt,word,excel
export function filType(file) {
  let filecontent = JSON.parse(JSON.stringify(file))
  filecontent = filecontent.split('.')
  let type = filecontent[filecontent.length - 1]
  if (type === 'pdf') {
    return 'pdf'
  } else if (['doc', 'docx'].includes(type)) {
    return 'word'
  } else if (['ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
    return 'ppt'
  } else {
    return ''
  }
}

/**
 * 通用删除
 * @param {*} remove 删除接口
 * @param {*} callback 成功回调
 */
export function $delConfirm(remove, callback) {
  this.$confirm('是否确认删除?', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      return remove()
    })
    .then(() => {
      callback && callback()
      // this.getList && this.getList()
      this.msgSuccess()
    })
    .catch((error) => {
      console.error(error)
    })
}

// 复制文字
// import ClipboardJS from 'clipboard'
export function $copyText(txt) {
  if (!txt) {
    this?.msgError?.('内容为空，请联系系统管理员')
    return
  }
  if (navigator.clipboard) {
    navigator.clipboard
      .writeText(txt)
      .then(() => this.msgSuccess('复制成功'))
      .catch(() => this.msgError('复制失败'))
  } else {
    try {
      const input = document.createElement('input')
      input.style.cssText = 'opacity: 0;'
      input.type = 'text'
      input.value = text // 修改文本框的内容
      document.body.appendChild(input)
      input.select() // 选中文本
      document.execCommand('copy') // 执行浏览器复制命令
      this?.msgSuccess?.('复制成功')
      input.remove()
    } catch (error) {
      this?.msgError?.('复制失败')
    }
  }

  // 复杂情况下发现了莫名的bug，弃用 -- 2023.12.07 xinla
  // let clipboard = new ClipboardJS(event.currentTarget.localName, {
  //   target: function (trigger) {
  //     return trigger
  //   },
  //   text: function (trigger) {
  //     return txt
  //   },
  // })
  // setTimeout(() => {
  //   clipboard.destroy()
  // }, 0)
}

/**
 * 通用导出
 * @param {*} requestExport 导出接口 必需
 * @param {*} exportFileName 导出文件名 需含文件后缀名 必需
 * @param {*} type 文件类型 enum: excel,zip,image
 * @param {*} callback 成功回调
 */
export function $exportData(requestExport, exportFileName = '导出.xlsx', type, callback) {
  this.$confirm('是否确认导出吗?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      // debugger
      return new Promise((resolve, reject) => {
        this.$alert('正在导出，请稍等...', '提示', {
          confirmButtonText: '取消导出',
          confirmButtonClass: 'exportData',
          showClose: false,
        }).then(() => {
          reject()
        })
        requestExport().then((resBlob) => {
          resolve(resBlob)
        })
      })
    })
    .then((resBlob) => {
      downloadBlob(resBlob, exportFileName, type, () => {
        document.querySelector('.el-message-box__btns .exportData').click()
        this.msgSuccess('导出成功，请至浏览器下载栏中查看')
      })
    })
    .catch((error) => {
      console.error(error)
    })
}

// 文件预览路径处理
export function $previewFile(url) {
  if (!url) return

  return window.lwConfig.PRIVIEW_URL ? window.lwConfig.PRIVIEW_URL + encodeURIComponent(base64Encode(url)) : url

  function base64Encode(url) {
    return btoa(
      encodeURIComponent(url).replace(/%([0-9A-F]{2})/g, function toSolidBytes(match, p1) {
        return String.fromCharCode('0x' + p1)
      }),
    )
  }
}

/**
 * 通用js方法封装处理，挂载到 vueApp.config.globalProperties
 */
