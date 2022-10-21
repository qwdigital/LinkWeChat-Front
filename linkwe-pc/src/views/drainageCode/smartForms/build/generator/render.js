import { makeMap } from '@/utils/index'
import { getProvinceCityTree } from '@/utils/index'

// 参考https://github.com/vuejs/vue/blob/v2.6.10/src/platforms/web/server/util.js
const isAttr = makeMap(
  'accept,accept-charset,accesskey,action,align,alt,async,autocomplete,' +
    'autofocus,autoplay,autosave,bgcolor,border,buffered,challenge,charset,' +
    'checked,cite,class,code,codebase,color,cols,colspan,content,http-equiv,' +
    'name,contenteditable,contextmenu,controls,coords,data,datetime,default,' +
    'defer,dir,dirname,disabled,download,draggable,dropzone,enctype,method,for,' +
    'form,formaction,headers,height,hidden,high,href,hreflang,http-equiv,' +
    'icon,id,ismap,itemprop,keytype,kind,label,lang,language,list,loop,low,' +
    'manifest,max,maxlength,media,method,GET,POST,min,multiple,email,file,' +
    'muted,name,novalidate,open,optimum,pattern,ping,placeholder,poster,' +
    'preload,radiogroup,readonly,rel,required,reversed,rows,rowspan,sandbox,' +
    'scope,scoped,seamless,selected,shape,size,type,text,password,sizes,span,' +
    'spellcheck,src,srcdoc,srclang,srcset,start,step,style,summary,tabindex,' +
    'target,title,type,usemap,value,width,wrap'
)

function vModel(self, dataObject, defaultValue) {
  console.log('defaultValue111', defaultValue)
  console.log('dataObject', dataObject)
  console.log('self', self)
  if (dataObject.props.formCodeId == 5 || dataObject.props.formCodeId == 625) {
    if (defaultValue) {
      console.log('(/(^[1-9]d*$)/.test(defaultValue))', /(^[1-9]\d*$)/.test(defaultValue))
      if (/(^[1-9]\d*$)/.test(defaultValue)) {
      } else {
        defaultValue = defaultValue.replace(/[^\d]/g, '')
      }
    }
  }
  if (dataObject.props.precision) {
    var pointIndex = String(defaultValue).indexOf('.')
    if (pointIndex > 0 && defaultValue.length - pointIndex > dataObject.props.precision + 1) {
      defaultValue = Number(defaultValue).toFixed(dataObject.props.precision)
    }
  }
  // if(defaultValue>dataObject.attrs.max){
  //   dataObject.props.value = dataObject.attrs.max
  // }else if(defaultValue<dataObject.attrs.min){
  //   dataObject.props.value = dataObject.attrs.min
  // }else{
  //   dataObject.props.value = defaultValue
  // }
  console.log('dataObject.props', dataObject.props)
  dataObject.props.value = defaultValue
  dataObject.on.input = (val) => {
    self.$emit('input', val)
  }
}

const componentChild = {
  'el-input': {
    prepend(h, conf, key) {
      return <template slot='prepend'>{conf[key]}</template>
    },
    append(h, conf, key) {
      return <template slot='append'>{conf[key]}</template>
    },
  },
  'el-select': {
    options(h, conf, key) {
      const list = []
      conf.options.forEach((item) => {
        list.push(
          <el-option label={item.label} value={item.value} disabled={item.disabled}></el-option>
        )
      })
      return list
    },
  },
  'el-radio-group': {
    options(h, conf, key) {
      const list = []
      conf.options.forEach((item) => {
        if (conf.optionType === 'button')
          list.push(<el-radio-button label={item.value}>{item.label}</el-radio-button>)
        else
          list.push(
            <el-radio label={item.value} border={conf.border}>
              {item.label}
            </el-radio>
          )
      })
      return list
    },
  },
  'el-checkbox-group': {
    options(h, conf, key) {
      const list = []
      conf.options.forEach((item) => {
        if (conf.optionType === 'button') {
          list.push(<el-checkbox-button label={item.value}>{item.label}</el-checkbox-button>)
        } else {
          list.push(
            <el-checkbox label={item.value} border={conf.border}>
              {item.label}
            </el-checkbox>
          )
        }
      })
      return list
    },
  },
  'el-upload': {
    'list-type': (h, conf, key) => {
      const list = []
      if (conf['list-type'] === 'picture-card') {
        list.push(<i class='el-icon-plus'></i>)
      } else {
        list.push(
          <el-button size='small' type='primary' icon='el-icon-upload'>
            {conf.buttonText}
          </el-button>
        )
      }
      if (conf.showTip) {
        list.push(
          <div slot='tip' class='el-upload__tip'>
            只能上传不超过 {conf.fileSize}
            {conf.sizeUnit} 的{conf.accept}文件
          </div>
        )
      }
      return list
    },
  },
}

export default {
  render(h) {
    const dataObject = {
      attrs: {},
      props: {},
      on: {},
      style: {},
    }
    const confClone = JSON.parse(JSON.stringify(this.conf))
    const children = []

    const childObjs = componentChild[confClone.tag]
    if (childObjs) {
      Object.keys(childObjs).forEach((key) => {
        const childFunc = childObjs[key]
        if (confClone[key]) {
          children.push(childFunc(h, confClone, key))
        }
      })
    }
    console.log('confClone', confClone.formCodeId)
    Object.keys(confClone).forEach((key) => {
      const val = confClone[key]
      if (confClone.layout != 'rowFormItem') {
        vModel(this, dataObject, confClone.defaultValue)
      }
      if (key === 'style') {
        Object.assign(dataObject[key], val)
      } else if (!isAttr(key)) {
        dataObject.props[key] = val
      } else {
        dataObject.attrs[key] = val
      }
    })

    // 配置省市区数据首次懒加载
    if (confClone.formCodeId == 9) {
      dataObject.props.props = {
        value: 'id',
        label: 'name',
        lazy: true,
        lazyLoad(node, resolve) {
          if (node.level == 0) {
            getProvinceCityTree().then((data) => {
              resolve(data)
            })
          } else {
            if (node.level == 2) {
              node.data.children.forEach((e) => (e.leaf = true))
            }
            resolve([])
          }
        },
      }
    }

    return h(this.conf.tag, dataObject, children)
  },
  props: ['conf'],
}
