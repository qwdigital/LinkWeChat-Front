// import { NativeEventSource, EventSourcePolyfill } from 'event-source-polyfill'
// // const EventSource = NativeEventSource || EventSourcePolyfill
// window.EventSource = NativeEventSource || EventSourcePolyfill

import { requestAi } from '@/utils/request'
const { get, post, put, del: _del } = requestAi
const serve = '/assistant'

/**
 * 创建连接
 */
export function createConnect(sessionId = '') {
  return get(serve + '/create/connect', { sessionId })
  // return new EventSource(serve + '/create/connect?sessionId=' + sessionId, {
  //   headers: { Authorization: window.lwConfig.headers.Authorization },
  // })
}

export function closeConnect(sessionId) {
  return sessionId && get(serve + '/close/connect/' + sessionId)
}

/**
 * 发送消息
 * @param {*} data
 * {
    "msg": {
        "content": "string", // 内容
        "role": "string" // 角色
    },
    "sessionId": "string" // 会话ID
}
 * @returns
 */
export function sendMsg(data, callback) {
  const xhr = new XMLHttpRequest()
  xhr.open('POST', window.lwConfig.BASE_API + window.lwConfig.services.ai + '/assistant/send/msg')

  xhr.setRequestHeader('Authorization', window.lwConfig.headers.Authorization)
  xhr.setRequestHeader('Content-type', 'application/json')
  xhr.setRequestHeader('Accept', 'text/event-stream')

  xhr.onreadystatechange = () => {
    // console.log(xhr.responseText)
    // console.log('readyState', xhr.readyState)
    // if (xhr.readyState === XMLHttpRequest.LOADING) {

    // } else
    if (xhr.readyState === XMLHttpRequest.DONE || xhr.readyState === XMLHttpRequest.LOADING) {
      // console.log('status', xhr.status)
      if (xhr.status !== 200) {
        callback?.({ code: xhr.status, data: null, msg: `服务端 ${xhr.status} 错误` })
      } else if (xhr.responseText.includes('\n')) {
        // 处理 Event Stream数据
        const events = xhr.responseText.split('\n\n').filter((e) => !!e)
        // console.log(events)

        const list = events.map((eventData) => {
          const lines = eventData.split('\n')
          const event = {}
          lines.forEach((line) => {
            if (line.startsWith('data:{')) {
              event.data = JSON.parse(line.slice(line.indexOf('{')))
            } else {
              const [key, value] = line.split(':')
              event[key] = value
            }
          })
          return event
        })

        // console.log(list)
        if (xhr.readyState === XMLHttpRequest.DONE && list?.length == 1) {
          callback?.({ data: list, msg: '无有效回复，请检查接口是否欠费或超额等问题' })
        } else {
          callback?.({ code: 200, data: list })
        }
      } else {
        try {
          let resData = JSON.parse(xhr.responseText)
          resData.code != 200 && callback?.(resData)
        } catch (error) {
          throw error
        }
      }
    }
  }

  xhr.send(JSON.stringify(data))

  // return new EventSourcePolyfill(serve + '/send/msg', {
  //   headers: { Authorization: window.lwConfig.headers.Authorization },
  // })
  // return post(serve + '/send/msg', data, { headers: { Accept: 'text/event-stream' } })
}

/**
 * 会话列表
 * {
 * pageNum,pageSize
 * keywords
 * sessionId
 * }
 */
export function getList(data) {
  return post(serve + '/msg/list', {
    msg: {
      content: data.keywords,
      // role: 'string',
    },
    content: data.keywords,
    ...data,
  })
}

/**
 * 会话详情 （会话中消息列表）
 */
export function getDetail(params) {
  return get(serve + '/msg/get/' + params.sessionId, params).then((res) => {
    res.data?.forEach((element) => {
      element.text = element.content
    })
    return res
  })
}

// 会话删除
export function remove(sessionId) {
  return post(serve + '/msg/del/', { sessionId })
}

/**
 * 收藏会话中某条消息
 * @param {*} data
{
  "msgId": "string",
  "status": 0  // 收藏状态 0-未收藏 1-已收藏
}
 * @returns
 */
export function collect(data) {
  return post(serve + '/msg/collection', data)
}

/**
 * 收藏列表
 * {
 * pageNum,pageSize
 * keywords
 * sessionId
 * }
 */
export function getCollectList(data) {
  return post(serve + '/msg/collection/list', {
    msg: {
      content: data.keywords,
      // role: 'string',
    },
    content: data.keywords,
    ...data,
  }).then((res) => {
    let arr = []
    res?.rows?.forEach((element) => {
      arr.push(...element.contentList)
    })
    arr?.forEach((element) => {
      element.text = element.content
    })
    res.rows = arr
    return res
  })
}
