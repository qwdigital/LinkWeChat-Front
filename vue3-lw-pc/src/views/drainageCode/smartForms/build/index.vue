<template>
  <div class="container">
    <div class="left-board">
      <!--  <div class="logo-wrapper">
        <div class="logo">
          <img :src="logo" alt="logo"> Form Generator
        </div>
      </div> -->
      <el-scrollbar class="left-scrollbar">
        <div class="components-list">
          <div class="components-title">
            <svg-icon icon="component" class="mr5" />
            表单控件
          </div>
          <draggable
            class="components-draggable"
            :list="inputComponents"
            item-key="formCodeId"
            :group="{ name: 'componentsGroup', pull: 'clone', put: false }"
            :clone="cloneComponent"
            :draggable="false"
            :sort="false"
            @end="onEnd">
            <template #item="{ element, index }">
              <div class="components-item" @click="addComponent(element)" style="width: 98%">
                <div class="components-body">
                  <svg-icon :icon="element.tagIcon" />
                  {{ element.label }}
                </div>
              </div>
            </template>
          </draggable>
          <div style="display: flex; justify-content: center; color: var(--font-black-7)">更多控件持续上线中...</div>
        </div>
      </el-scrollbar>
    </div>
    <div class="center-board">
      <div style="padding: 24px 24px 5px 24px">
        <div style="" class="smartForms_build_index_ul">
          <div
            style="position: relative"
            @click="toPage(index)"
            v-for="(item, index) in pageData"
            :key="index"
            :class="
              index + 1 == page
                ? 'smartForms_build_index_lix smartForms_build_index_liBtn'
                : 'smartForms_build_index_lix'
            ">
            <div
              class="smartForms_build_index_ul_liX_hover"
              style="
                cursor: hand;
                position: relative;
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
              ">
              第{{ index + 1 }}页
            </div>
            <div
              @click.stop="deletePage(index)"
              class="smartForms_build_index_ul_liY_hover"
              style="position: absolute; right: 2px; top: 9px">
              <el-icon-close class="el-icon-close"></el-icon-close>
            </div>
          </div>
          <div @click="addPage()" class="smartForms_build_index_li" style="width: 30px; border-left: none">
            <div>+</div>
          </div>
        </div>
      </div>
      <el-scrollbar class="center-scrollbar">
        <el-row class="center-board-row" :gutter="formConf.gutter">
          <el-col>
            <el-form
              style="width: 100%"
              :size="formConf.size"
              :label-position="formConf.labelPosition"
              :disabled="formConf.disabled"
              :label-width="formConf.labelWidth + 'px'">
              <draggable
                class="drawing-board"
                :list="drawingList"
                :animation="340"
                group="componentsGroup"
                item-key="renderKey">
                <template #item="{ element, index }">
                  <draggable-item
                    :drawing-list="drawingList"
                    :element="element"
                    :index="index"
                    :active-id="activeId"
                    :form-conf="formConf"
                    @activeItem="activeFormItem"
                    @copyItem="drawingItemCopy"
                    @deleteItem="drawingItemDelete" />
                </template>
              </draggable>
              <div v-show="!drawingList.length" class="empty-info">从左侧点选组件进行表单设计</div>
            </el-form>
          </el-col>
        </el-row>
      </el-scrollbar>
    </div>

    <right-panel
      :active-data="activeData"
      :form-conf="formConf"
      :show-field="!!drawingList.length"
      @tag-change="tagChange" />

    <code-type-dialog
      v-model:visible="dialogVisible"
      title="选择生成类型"
      :show-file-name="showFileName"
      @confirm="generate" />
    <input id="copyNode" type="hidden" />
  </div>
</template>

<script>
import draggable from 'vuedraggable'
import { saveAs } from 'file-saver'
import beautifier from 'js-beautify'
// import render from './generator/render'
import RightPanel from './RightPanel'
import { inputComponents, formConf } from './generator/config'
import { exportDefault, beautifierConf, isNumberStr, titleCase, uuid } from '@/utils/index'
import { makeUpHtml, vueTemplate, vueScript, cssStyle } from './generator/html'
import { makeUpJs } from './generator/js'
import { makeUpCss } from './generator/css'
import drawingDefalutInit from './generator/drawingDefalut'
import CodeTypeDialog from './CodeTypeDialog'
import DraggableItem from './DraggableItem'

let drawingDefalut = []

const emptyActiveData = { style: {}, autosize: {} }
let oldActiveId
let tempActiveData
let id = 0
export default {
  components: {
    draggable,
    // render,
    RightPanel,
    CodeTypeDialog,
    DraggableItem,
  },
  props: {
    pageDataAll: {
      type: Array,
    },
  },

  data() {
    return {
      ifNew: true,
      drawingListOld: '',
      logo: this.lwConfig.LOGO_DARK,
      idGlobal: '',
      formConf,
      inputComponents,
      labelWidth: 100,
      drawingList: [],
      drawingData: {},
      activeId: 0,
      drawerVisible: false,
      formData: {},
      dialogVisible: false,
      generateConf: null,
      showFileName: false,
      activeData: drawingDefalut[0],
      //页数总数据
      pageData: [],
      page: 1,
    }
  },
  computed: {},
  watch: {
    // eslint-disable-next-line func-names
    'activeData.label': function (val, oldVal) {
      if (this.activeData.placeholder === undefined || !this.activeData.tag || oldActiveId !== this.activeId) {
        return
      }
      // this.activeData.placeholder = this.activeData.placeholder.replace(oldVal, '')
    },
    pageDataAll: {
      handler(val) {
        console.log('pageDataAllpageDataAll', val)
        // if(this.pageDataAll){
        this.pageData = val
        this.drawingList = this.pageData[this.page - 1]
        // }
      },
      deep: true,
    },
    activeId: {
      handler(val) {
        oldActiveId = val
      },
      immediate: true,
    },
    drawingList: {
      handler(val) {
        console.log('drawingList改变1', val, this.drawingListOld)
        if (val.length != this.drawingListOld.length) {
          this.Updates()
        }
        console.log('this.pageDat1a', this.pageData)
        for (let i = 0; i < this.pageData.length; i++) {
          for (let q = 0; q < this.pageData[i].length; q++) {
            console.log('this.pageData[i][q].formCodeId', this.pageData[i][q].formCodeId)
            if (this.pageData[i][q].formCodeId == '625' || this.pageData[i][q].formCodeId == '626') {
              this.pageData[i].splice(q, 1)
            }
          }
        }
        if (this.page - 1 == -1) {
          this.pageData.styles = []
          this.$emit('toStyles', JSON.stringify(this.pageData))
          return
        }
        this.pageData[this.page - 1] = val

        // this.toPage(this.page);
        try {
          localStorage.setItem('pageData', this.pageData)
        } catch (e) {
          //TODO handle the exception
        }
        this.drawingListOld = []

        for (let q = 0; q < val.length; q++) {
          this.drawingListOld.push(val[q])
        }
        console.log('this.pageData', this.pageData)
        this.$emit('toStyles', this.pageData)
      },
      deep: true,
    },
  },
  created() {
    drawingDefalut = JSON.parse(JSON.stringify(drawingDefalutInit))

    if (this.pageDataAll) {
      this.pageData = this.pageDataAll
    }
  },
  mounted() {
    // if (this.ifNew) {
    //   drawingDefalut = []
    //   for (let i = 0; i < drawingDefalut.length; i++) {
    //     drawingDefalut.push(drawingDefalut[i])
    //   }

    //   if (drawingDefalut.length == 1 && drawingDefalut[0].formCodeId == '5') {
    //     drawingDefalut[0] = {
    //       formCodeId: 5,
    //       layout: 'colFormItem',
    //       tagIcon: 'phone',
    //       label: '手机号',
    //       //文字说明
    //       captions: '',
    //       vModel: 'mobile',

    //       formId: 6,
    //       tag: 'el-input',
    //       placeholder: '请输入手机号',
    //       defaultValue: '',
    //       span: 24,
    //       style: { width: '100%' },
    //       clearable: true,
    //       prepend: '',
    //       append: '',
    //       'prefix-icon': '',
    //       'suffix-icon': '',
    //       maxlength: 11,
    //       'show-word-limit': true,
    //       change: 'change',
    //       readonly: false,
    //       disabled: false,
    //       required: true,
    //       changeTag: true,
    //       regList: [
    //         {
    //           pattern: /^1(3|4|5|7|8|9)\d{9}$/,
    //           message: '手机号格式错误',
    //         },
    //       ],
    //     }
    //   }
    // }
    let that = this
    console.log('this.pageData11111111111111', this.pageData)
    if (this.pageDataAll) {
      this.drawingList = this.pageDataAll[0]
    } else {
      this.drawingList = drawingDefalut
    }
    if (drawingDefalut[0]) {
      drawingDefalut.forEach((e) => {
        e.formId = uuid()
      })
      this.activeId = drawingDefalut[0].formId
    }

    this.pageData[this.page - 1] = this.drawingList
    for (let i = 0; i < this.pageData.length; i++) {
      for (let q = 0; q < this.pageData[i].length; q++) {
        this.pageData[i][q].page = i + 1
        this.pageData[i][q].pageNo = q + 1
      }
    }
    console.log('14', this.pageData)
    // const clipboard = new this.ClipboardJS('#copyNode', {
    //   text: (trigger) => {
    //     return this.generateCode()
    //   },
    // })
    this.Updates()
    // this.$forceUpdate()
  },

  methods: {
    //更新标题
    Updates() {
      let that = this
      let t = 0
      for (let i = 0; i < this.pageData.length; i++) {
        for (let q = 0; q < this.pageData[i].length; q++) {
          if (this.pageData[i][q].formCodeId != 0 && this.pageData[i][q].formCodeId != 1) {
            t++
            this.pageData[i][q].page = i + 1
            this.pageData[i][q].pageNo = q + 1
            if (this.pageData[i][q].label.indexOf('.') != -1) {
              console.log('this.pageData[i][q].label.indexOf(".")', this.pageData[i][q].label.length)
              // let a=this.pageData[i][q].label.slice(this.pageData[i][q].label.indexOf("."),this.pageData[i][q].label.length);
              // this.pageData[i][q].label=t+a;
              this.pageData[i][q].TitleNumber = t
            } else {
              // this.pageData[i][q].label=t+'.'+this.pageData[i][q].label
              this.pageData[i][q].TitleNumber = t
            }
            if (this.pageData[i][q].formCodeId == '625' && this.pageData[i][q].formCodeId == '626') {
              this.pageData[i].splice(q, 1)
              that.toPage(this.page)
            }
          } else {
            this.pageData[i][q].page = i + 1
            this.pageData[i][q].label = ''
          }
        }
      }
    },
    //删除表单页面
    deletePage(index) {
      // if(this.page==index+1&&this.page==this.pageData.length){
      //   let x=this.page-2;
      //   if(x<0){
      //     x=1;
      //   }
      if (this.pageData.length == 1) {
        this.msgError('最后一页不能删除！')
        return
      }
      if (this.page != 1) {
        this.toPage(this.page - 2)
      } else {
        this.toPage(this.page - 1)
      }
      this.pageData.splice(index, 1)
      // this.$forceUpdate()
      // }
    },
    //翻页
    toPage(index) {
      console.log('index', index)
      this.page = index + 1
      console.log('this.pageData', this.pageData)
      console.log('sadasfd', index)
      if (this.page == 0) {
        this.drawingList = []
      } else {
        this.drawingList = this.pageData[index]
      }
      this.Updates()
    },
    //添加页数
    addPage() {
      let a = []
      this.pageData.push(a)
      console.log('this.pageData', this.pageData)
    },
    activeFormItem(element) {
      this.activeData = element
      this.activeId = element.formId
      this.$forceUpdate()
    },
    onEnd(obj, a) {
      if (obj.from !== obj.to) {
        this.activeData = tempActiveData
        this.activeId = this.idGlobal
      }
    },
    addComponent(item) {
      const clone = this.cloneComponent(item)
      this.drawingList.push(clone)
      this.activeFormItem(clone)
    },
    cloneComponent(origin) {
      const clone = JSON.parse(JSON.stringify(origin))
      clone.formId = this.idGlobal = uuid()
      clone.span = formConf.span
      clone.renderKey = +new Date() // 改变renderKey后可以实现强制更新组件
      if (!clone.layout) clone.layout = 'colFormItem'
      // if (clone.layout === 'colFormItem') {
      //   clone.vModel = `field${this.idGlobal}`
      //   var timestamp = new Date().valueOf()
      //   clone.vModel = clone.vModel + timestamp
      //   clone.placeholder !== undefined && clone.placeholder
      // } else
      if (clone.layout === 'rowFormItem') {
        delete clone.label
        clone.componentName = `row${this.idGlobal}`
        clone.gutter = this.formConf.gutter
      }
      tempActiveData = clone
      return tempActiveData
    },
    AssembleFormData() {
      console.log('5')
      this.formData = {
        fields: JSON.parse(JSON.stringify(this.drawingList)),
        ...this.formConf,
      }
    },
    generate(data) {
      console.log('6')
      const func = this[`exec${titleCase(this.operationType)}`]
      this.generateConf = data
      func && func(data)
    },
    execRun(data) {
      console.log('7')
      this.AssembleFormData()
      this.drawerVisible = true
    },
    execDownload(data) {
      console.log('8')
      const codeStr = this.generateCode()
      const blob = new Blob([codeStr], { type: 'text/plain;charset=utf-8' })
      saveAs(blob, data.fileName)
    },
    execCopy(data) {
      console.log('9')
      document.getElementById('copyNode').click()
    },
    empty() {
      this.$confirm('确定要清空所有组件吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        this.drawingList = []
      })
    },
    drawingItemCopy(item, parent) {
      console.log('10')
      let clone = JSON.parse(JSON.stringify(item))
      clone = this.createIdAndKey(clone)
      parent.push(clone)
      this.activeFormItem(clone)
    },
    createIdAndKey(item) {
      item.formId = this.idGlobal = uuid()
      item.renderKey = +new Date()
      if (item.layout === 'colFormItem') {
        item.vModel = `field${this.idGlobal}`
      } else if (item.layout === 'rowFormItem') {
        item.componentName = `row${this.idGlobal}`
      }
      if (Array.isArray(item.children)) {
        item.children = item.children.map((childItem) => this.createIdAndKey(childItem))
      }
      return item
    },
    drawingItemDelete(index, parent) {
      console.log('12')
      parent.splice(index, 1)
      this.$nextTick(() => {
        const len = this.drawingList.length
        if (len) {
          this.activeFormItem(this.drawingList[len - 1])
        }
        this.Updates()
      })
    },
    //代码生成
    generateCode() {
      console.log('13')
      const { type } = this.generateConf
      this.AssembleFormData()
      const script = vueScript(makeUpJs(this.formData, type))
      const html = vueTemplate(makeUpHtml(this.formData, type))
      console.log('html', html)
      const css = cssStyle(makeUpCss(this.formData))
      return beautifier.html(html + script + css, beautifierConf.html)
    },
    download() {
      this.dialogVisible = true
      this.showFileName = true
      this.operationType = 'download'
    },
    run() {
      this.dialogVisible = true
      this.showFileName = false
      this.operationType = 'run'
    },
    copy() {
      this.dialogVisible = true
      this.showFileName = false
      this.operationType = 'copy'
    },
    tagChange(newTag) {
      newTag = this.cloneComponent(newTag)
      newTag.vModel = this.activeData.vModel
      newTag.formId = this.activeId
      newTag.span = this.activeData.span
      delete this.activeData.tag
      delete this.activeData.tagIcon
      delete this.activeData.document
      Object.keys(newTag).forEach((key) => {
        if (this.activeData[key] !== undefined && typeof this.activeData[key] === typeof newTag[key]) {
          newTag[key] = this.activeData[key]
        }
      })
      this.activeData = newTag
      this.updateDrawingList(newTag, this.drawingList)
    },
    updateDrawingList(newTag, list) {
      console.log('18')
      const index = list.findIndex((item) => item.formId === this.activeId)
      if (index > -1) {
        list.splice(index, 1, newTag)
      } else {
        list.forEach((item) => {
          if (Array.isArray(item.children)) this.updateDrawingList(newTag, item.children)
        })
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.editor-tabs {
  background: var(--bg-black);
  .el-tabs__header {
    margin: 0;
    border-bottom-color: var(--border-black-1);
    .el-tabs__nav {
      border-color: var(--border-black-1);
    }
  }
  .el-tabs__item {
    height: 32px;
    line-height: 32px;
    color: var(--font-black-5);
    border-left: 1px solid var(--border-black-1) !important;
    background: var(--bg-black-2);
    margin-right: 5px;
    user-select: none;
  }
  .el-tabs__item.is-active {
    background: var(--bg-black-1);
    border-bottom-color: var(--border-black-1) !important;
    color: var(--font-white, #fff);
  }
  .el-icon-EditPen {
    color: #f1fa8c;
  }
  .el-icon-document {
    color: #a95812;
  }
}

// home
.right-scrollbar {
  .el-scrollbar__view {
    padding: 12px 18px 15px 15px;
  }
}
.left-scrollbar .el-scrollbar__wrap {
  box-sizing: border-box;
  overflow-x: hidden !important;
  margin-bottom: 0 !important;
}
.center-tabs {
  .el-tabs__header {
    margin-bottom: 0 !important;
  }
  .el-tabs__item {
    width: 50%;
    text-align: center;
  }
  .el-tabs__nav {
    width: 100%;
  }
}
.reg-item {
  padding: 12px 6px;
  background: var(--bg-black-11);
  position: relative;
  border-radius: 4px;
  .close-btn {
    position: absolute;
    right: -6px;
    top: -6px;
    display: block;
    width: 16px;
    height: 16px;
    line-height: 16px;
    background: var(--bg-black-8);
    border-radius: 50%;
    color: var(--font-white, #fff);
    text-align: center;
    z-index: 1;
    cursor: pointer;
    font-size: 12px;
    &:hover {
      background: rgba(210, 23, 23, 0.5);
    }
  }
  & + .reg-item {
    margin-top: 18px;
  }
}
.action-bar {
  & .el-button + .el-button {
    margin-left: 15px;
  }
  & i {
    font-size: 20px;
    vertical-align: middle;
    position: relative;
    top: -1px;
  }
}

.custom-tree-node {
  width: 100%;
  font-size: 14px;
  .node-operation {
    float: right;
  }
  i[class*='el-icon'] + i[class*='el-icon'] {
    margin-left: 6px;
  }
  .el-icon-plus {
    color: var(--color);
  }
  .el-icon-delete {
    color: #157a0c;
  }
}

.left-scrollbar .el-scrollbar__view {
  overflow-x: hidden;
}

.el-rate {
  display: inline-block;
  vertical-align: text-top;
}
.el-upload__tip {
  line-height: 1.2;
}

$selectedColor: var(--bg-black-11);

.container {
  position: relative;
  height: calc(100% - 32px);
  overflow: hidden;
  display: flex;
}

.components-list {
  padding: 8px;
  box-sizing: border-box;
  height: 100%;
  .components-item {
    display: inline-block;
    width: 98%;
    margin: 1%;
    transition: transform 0ms !important;
  }
}
.components-draggable {
  padding-bottom: 20px;
}
.components-title {
  font-size: 14px;
  color: var(--font-black);
  margin: 6px 2px;
  .svg-icon {
    color: var(--font-black-4);
    font-size: 18px;
  }
}

.components-body {
  padding: 8px 10px;
  background: $selectedColor;
  font-size: 12px;
  cursor: pointer;
  border: 1px dashed $selectedColor;
  border-radius: 3px;
  .svg-icon {
    color: var(--font-black-5);
    font-size: 15px;
  }
  &:hover {
    border: 1px dashed var(--color);
    color: var(--color);
    .svg-icon {
      color: var(--color);
    }
  }
}

.elementCaptions {
  margin-top: -15px;
  color: var(--font-black-7);
}
.left-board {
  width: 260px;
  overflow: auto;
  flex: none;
}
// .left-scrollbar {
//   height: calc(100vh - 42px);
//   overflow: hidden;
// }
.center-scrollbar {
  height: calc(100% - 42px);
  overflow: hidden;
  border-left: 1px solid var(--border-black-9);
  border-right: 1px solid var(--border-black-9);
  box-sizing: border-box;
}
.center-board {
  flex: auto;
  height: 100%;
}
.empty-info {
  position: absolute;
  top: 46%;
  left: 0;
  right: 0;
  text-align: center;
  font-size: 18px;
  color: #ccb1ea;
  letter-spacing: 4px;
}
.action-bar {
  position: relative;
  height: 42px;
  text-align: right;
  padding: 0 15px;
  box-sizing: border-box;
  border: 1px solid var(--border-black-9);
  border-top: none;
  border-left: none;
  .delete-btn {
    color: #f56c6c;
  }
}
.logo-wrapper {
  position: relative;
  height: 42px;
  background: var(--bg-white);
  border-bottom: 1px solid var(--border-black-9);
  box-sizing: border-box;
}
.logo {
  position: absolute;
  left: 12px;
  top: 6px;
  line-height: 30px;
  color: var(--color);
  font-weight: 600;
  font-size: 17px;
  white-space: nowrap;
  > img {
    width: 30px;
    height: 30px;
    vertical-align: top;
  }
  .github {
    display: inline-block;
    vertical-align: sub;
    margin-left: 15px;
    > img {
      height: 22px;
    }
  }
}

.center-board-row {
  padding: 12px 12px 15px 12px;
  box-sizing: border-box;
}
.drawing-board {
  height: 100%;
  position: relative;
  .components-body {
    padding: 0;
    margin: 0;
    font-size: 0;
  }
  .sortable-ghost {
    position: relative;
    display: block;
    overflow: hidden;
    &::before {
      content: ' ';
      position: absolute;
      left: 0;
      right: 0;
      top: 0;
      height: 3px;
      background: rgb(89, 89, 223);
      z-index: 2;
    }
  }
  .components-item.sortable-ghost {
    width: 100%;
    height: 60px;
    background-color: $selectedColor;
  }
  .active-from-item {
    & > .el-form-item {
      background: $selectedColor;
      border-radius: 6px;
    }
    & > .drawing-item-copy,
    & > .drawing-item-delete {
      display: initial;
    }
    & > .component-name {
      color: var(--color);
    }
  }
  .el-form-item {
    margin-bottom: 15px;
  }
}
.drawing-item {
  position: relative;
  cursor: move;
  &.unfocus-bordered:not(.activeFromItem) > div:first-child {
    border: 1px dashed var(--border-black-8);
  }
  .el-form-item {
    padding: 12px 10px;
  }
}
.drawing-row-item {
  position: relative;
  cursor: move;
  box-sizing: border-box;
  border: 1px dashed var(--border-black-8);
  border-radius: 3px;
  padding: 0 2px;
  margin-bottom: 15px;
  .drawing-row-item {
    margin-bottom: 2px;
  }
  .el-col {
    margin-top: 22px;
  }
  .el-form-item {
    margin-bottom: 0;
  }
  .drag-wrapper {
    min-height: 80px;
  }
  &.active-from-item {
    border: 1px dashed var(--color);
  }
  .component-name {
    position: absolute;
    top: 0;
    left: 0;
    font-size: 12px;
    color: var(--font-black-7);
    display: inline-block;
    padding: 0 6px;
  }
}
.drawing-item,
.drawing-row-item {
  &:hover {
    & > .el-form-item {
      background: $selectedColor;
      border-radius: 6px;
    }
    & > .drawing-item-copy,
    & > .drawing-item-delete {
      display: initial;
    }
  }
  & > .drawing-item-copy,
  & > .drawing-item-delete {
    display: none;
    position: absolute;
    top: -10px;
    width: 22px;
    height: 22px;
    line-height: 22px;
    text-align: center;
    border-radius: 50%;
    font-size: 12px;
    border: 1px solid;
    cursor: pointer;
    z-index: 1;
  }
  & > .drawing-item-copy {
    right: 56px;
    border-color: var(--color);
    color: var(--color);
    background: var(--bg-white);
    &:hover {
      background: var(--color);
      color: var(--font-white, #fff);
    }
  }
  & > .drawing-item-delete {
    right: 24px;
    border-color: #f56c6c;
    color: #f56c6c;
    background: var(--bg-white);
    &:hover {
      background: #f56c6c;
      color: var(--font-white, #fff);
    }
  }
}

.flexC {
  display: flex;
}

.nullC {
  display: none;
}
.right10 {
  margin-right: 10px;
}
.width200 {
  width: 200px;
}
.el-form-item__label {
  font-size: 14px !important;
}
.el-form-item__content {
  font-size: 12px !important;
}
.smartForms_build_index_ul {
  display: flex;
  align-items: center;
  width: 100%;
  overflow-x: auto;
  .smartForms_build_index_lix {
    font-size: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;
    width: 70px;
    height: 30px;
    border: 1px solid var(--border-black-8);
    border-top: 0px solid var(--border-black-8);
    border-left: 0px solid var(--border-black-8);
    cursor: pointer;
  }
  .smartForms_build_index_li {
    flex-shrink: 0;
    font-size: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 70px;
    height: 30px;
    border: 1px solid var(--border-black-8);
    border-top: 0px solid var(--border-black-8);
    border-left: 0px solid var(--border-black-8);
    cursor: pointer;
  }
  .smartForms_build_index_li:hover {
    background-color: var(--bg-black-11);
  }
  .smartForms_build_index_ul_liX_hover:hover {
    background-color: var(--bg-black-11);
  }
  .smartForms_build_index_li:nth-of-type(1) {
    border-left: 1px solid var(--border-black-8);
  }
  .smartForms_build_index_liBtn {
    background: var(--bg-white);
    border-left: 0px solid #d7d7d7 !important;
    border-bottom: none;
  }
}
.drawing-item {
  background: var(--bg-white) !important;
  overflow: inherit !important;
}
.sortable-ghost .ssc {
  display: none !important;
}
</style>
