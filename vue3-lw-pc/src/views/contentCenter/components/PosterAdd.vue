<template>
  <div>
    <!-- 新建海报 -->
    <el-row type="flex" justify="space-between">
      <el-col :span="10" class="left pad20" style="border-radius: 4px">
        <div class="g-card fxbw">
          <div style="width: 100%">
            <el-form ref="form" :rules="rules" :model="form" label-width="100px">
              <el-form-item label="选择分组" prop="categoryId" v-if="!moduleType">
                <el-cascader
                  v-model="form.categoryId"
                  :options="treeData[0].children"
                  :props="groupProps"></el-cascader>
              </el-form-item>
              <el-form-item label="海报标题" prop="materialName">
                <el-input v-model="form.materialName" placeholder="海报标题" :maxlength="60" show-word-limit></el-input>
              </el-form-item>
              <el-form-item label="海报描述">
                <el-input
                  v-model="form.digest"
                  type="textarea"
                  placeholder="请输入海报描述"
                  :maxlength="100"
                  show-word-limit></el-input>
              </el-form-item>
              <el-form-item label="客户标签">
                <TagEllipsis :list="form.tags" limit="4"></TagEllipsis>
                <div>
                  <el-button type="primary" @click="dialogVisibleSelectTag = true">选择标签</el-button>
                  <!-- 选择标签弹窗 -->
                  <SelectTag
                    v-model:visible="dialogVisibleSelectTag"
                    :selected="form.tags"
                    @success="(data) => (form.tags = data)"></SelectTag>
                </div>
                <div class="g-tip">素材打开后，该客户将会自动设置以上选择标签</div>
              </el-form-item>
              <el-form-item label="海报类型" prop="type" v-if="!moduleType">
                <el-radio-group v-model="form.type" @change="radioChange">
                  <el-radio label="1">通用海报</el-radio>
                  <el-radio label="2">裂变海报</el-radio>
                </el-radio-group>
                <div class="tips">
                  <span v-if="form.type === '1'">通用海报可用于素材、话术或群发等多种场景</span>
                  <span v-else>裂变海报主要用于全能营销裂变模块</span>
                </div>
              </el-form-item>
              <el-form-item label="上传海报" :required="true" :error="rangeErrorMsg">
                <!-- <div v-if="form.backgroundImgPath">
                  <el-image
                    style="width: 100px; height: 100px; cursor: pointer; border-radius: 6px"
                    :src="form.backgroundImgPath"
                    fit="fill"></el-image>
                </div> -->
                <div class="up-style">
                  <!-- <div class="tips upload">
                    <el-icon-plus class="el-icon-plus"></el-icon-plus><span> 本地上传</span>
                  </div> -->
                  <Upload
                    v-model:fileUrl="form.backgroundImgPath"
                    :maxSize="20"
                    type="0"
                    @upSuccess="upSuccess"></Upload>
                  <el-button
                    text
                    style="margin-left: 10px"
                    @click="flage = isBackgroundImage = dialogVisibleSelectMaterial = true">
                    从素材库中选取
                  </el-button>
                </div>
                <div class="tips">支持jpg/jpeg/png格式，图片大小不超过20M</div>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-col>
      <el-col :span="14" style="margin-top: 20px">
        <div class="g-card" style="display: flex">
          <div id="tbody-containerui-image-editor-controls">
            <div class="basic">
              <div class="title">基础组件</div>
              <ul class="menu menu-content">
                <li class="menu-item" id="btn-text" @click="addObj('text')">
                  <div class="menu-item-content">
                    <svg-icon class="icon-style" icon="words"></svg-icon>
                    <span>文字</span>
                  </div>
                </li>
                <li class="menu-item" id="btn-image" @click="picShow">
                  <div class="menu-item-content">
                    <svg-icon class="icon-style" icon="picIcon"></svg-icon>
                    <span>图片</span>
                  </div>
                </li>
                <!-- <li class="menu-item" id="btn-nickName">添加客户昵称</li> -->
              </ul>
              <div class="sub-menu-container">
                <ul class="menu" v-show="activeObject && activeObject.type == 'textbox'">
                  <li class="menu-item">
                    <!-- <div>
                      <div class="btn-text-style" data-style-type="b">Bold</div>
                      <div class="btn-text-style" data-style-type="i">Italic</div>
                      <div class="btn-text-style" data-style-type="u">Underline</div>
                    </div> -->
                    <!-- <div> -->
                    <div>
                      <div class="btn-text-style" @click="setAttr('textAlign', 'left')">左对齐</div>
                      <div class="btn-text-style" @click="setAttr('textAlign', 'center')">居中</div>
                      <div class="btn-text-style" @click="setAttr('textAlign', 'right')">右对齐</div>
                    </div>
                  </li>
                  <li class="menu-item">
                    <el-color-picker v-model="fontColor" color-format="hex"></el-color-picker>
                  </li>
                </ul>
              </div>
            </div>
            <div class="basic">
              <div class="title">二维码组件</div>
              <ul class="menu menu-content">
                <li
                  class="menu-item"
                  :class="['qrcode', null].includes(activeLiveCodeType) ? '' : 'disableClass'"
                  id="btn-qrCode"
                  @click="addObj('qrcode')">
                  <div class="menu-item-content">
                    <svg-icon
                      class="icon-style"
                      :icon="['qrcode', null].includes(activeLiveCodeType) ? 'placeholder' : 'placeholder2'"></svg-icon>
                    <span>占位码</span>
                  </div>
                </li>
                <li
                  class="menu-item"
                  :class="['ygcode', null].includes(activeLiveCodeType) ? '' : 'disableClass'"
                  id="btn-qrCode"
                  @click="addLiveCode('ygcode')">
                  <div class="menu-item-content">
                    <svg-icon
                      class="icon-style"
                      :icon="['ygcode', null].includes(activeLiveCodeType) ? 'employee' : 'employee2'"></svg-icon>
                    <span>员工活码</span>
                  </div>
                </li>
                <!-- <li class="menu-item" id="btn-nickName">添加客户昵称</li> -->
              </ul>
              <ul class="menu menu-content">
                <li
                  class="menu-item"
                  id="btn-qrCode"
                  @click="addLiveCode('skcode')"
                  :class="['skcode', null].includes(activeLiveCodeType) ? '' : 'disableClass'">
                  <div class="menu-item-content">
                    <svg-icon
                      class="icon-style"
                      :icon="
                        ['skcode', null].includes(activeLiveCodeType) ? 'identification' : 'identification2'
                      "></svg-icon>
                    <span>识客活码</span>
                  </div>
                </li>
                <li
                  class="menu-item"
                  id="btn-qrCode"
                  @click="addLiveCode('lxcode')"
                  :class="['lxcode', null].includes(activeLiveCodeType) ? '' : 'disableClass'">
                  <div class="menu-item-content">
                    <svg-icon
                      class="icon-style"
                      :icon="['lxcode', null].includes(activeLiveCodeType) ? 'pullNew' : 'pullNew2'"></svg-icon>
                    <span>拉新活码</span>
                  </div>
                </li>
              </ul>
              <ul class="menu menu-content">
                <li
                  class="menu-item"
                  id="btn-qrCode"
                  @click="addLiveCode('kqcode')"
                  :class="['kqcode', null].includes(activeLiveCodeType) ? '' : 'disableClass'">
                  <div class="menu-item-content">
                    <svg-icon
                      class="icon-style"
                      :icon="
                        ['kqcode', null].includes(activeLiveCodeType) ? 'customerGroup' : 'customerGroup2'
                      "></svg-icon>
                    <span>客群活码</span>
                  </div>
                </li>
                <!-- <li
                  class="menu-item"
                  id="btn-qrCode"
                  :class="['mdcoed', null].includes(activeLiveCodeType) ? '' : 'disableClass'"
                  @click="addLiveCode('mdcoed')"
                >
                  <div class="menu-item-content">
                    <svg-icon
                      class="icon-style"
                      :icon="
                        ['mdcoed', null].includes(activeLiveCodeType) ? 'store' : 'store2'
                      "
                    ></svg-icon>
                    <span>门店活码</span>
                  </div>
                </li> -->
              </ul>
            </div>
          </div>
          <div id="canvas-wrap">
            <el-icon-CircleCloseFilled class="el-icon-CircleCloseFilled" id="deleteBtn"></el-icon-CircleCloseFilled>
            <canvas id="canvas" width="375" height="667" style="border: 1px solid #ddd"></canvas>
          </div>
        </div>
      </el-col>
    </el-row>
    <div class="fr mt20">
      <el-button type="primary" @click="save(1)">确定</el-button>
      <el-button @click="cancel">取消</el-button>
    </div>
    <!-- 选择素材弹窗 -->
    <SelectMaterial
      v-model:visible="dialogVisibleSelectMaterial"
      type="0"
      @success="submitSelectMaterial"></SelectMaterial>
    <!-- 点击图片按钮弹出弹框 -->
    <el-dialog title="添加图片" v-model="dialogVisible" width="30%" :before-close="imgCancel">
      <el-form :model="formDate" ref="picValidateForm" label-width="120px">
        <el-form-item label="添加图片" :required="true" :error="picErrorMsg">
          <div v-if="formDate.imgUrl">
            <el-image
              style="width: 100px; height: 100px; cursor: pointer; border-radius: 6px"
              :src="formDate.imgUrl"
              fit="fill"></el-image>
          </div>
          <div class="up-style" v-else>
            <Upload v-model:fileUrl="formDate.imgUrl" :maxSize="20" type="0"></Upload>
            <el-button text style="margin-left: 10px" @click="addObj('imageShow')">从素材库中选取</el-button>
          </div>
        </el-form-item>
        <div class="tips" style="margin-left: 120px">支持jpg/jpeg/png格式，图片大小不超过20M</div>
      </el-form>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="imgCancel">取 消</el-button>
          <el-button type="primary" @click="imgSubmit">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <!-- 点击二维码组件弹出弹框 -->
    <live-code-table
      v-if="dialogVisibleLiveCode"
      :type="liveCodeType"
      v-model:twoVisible="dialogVisibleLiveCode"
      @selectLiveCode="selectLiveCode" />
  </div>
</template>

<script>
import SelectMaterial from '@/components/SelectMaterial'
import { getTree } from '@/api/material'
import { fabric } from 'fabric'
import { getPosterInfo, addPoster, updatePoster, removePoster } from '@/api/material/poster.js'
import LiveCodeTable from './liveCodeTable.vue'
let positionAdd = 50
let times = 0
// let time = 0
export default {
  name: 'PosterAddorEdit',
  components: {
    SelectMaterial,
    LiveCodeTable,
  },
  data() {
    return {
      dialogVisibleLiveCode: false,
      liveCodeType: 'ygcode',
      activeLiveCodeType: null,
      imgWidth: null,
      time: 0,
      form: {
        type: 1,
        posterJSON: {},
      },
      formDate: {
        imgUrl: '',
      },
      dateRules: {
        imgUrl: {
          required: true,
          message: '请添加图片',
          trigger: 'blur',
        },
      },
      rules: {
        materialName: {
          required: true,
          message: '请输入海报名称',
          trigger: 'blur',
        },
        categoryId: {
          required: true,
          message: '请选择分类',
        },
        type: {
          required: true,
          message: '请选择海报类型',
        },
        // status: {
        //   required: true,
        //   message: '请选择是否启用',
        // },
      },
      rangeErrorMsg: '',
      picErrorMsg: '',
      activeObject: {},
      fontColor: '',
      dialogVisibleSelectMaterial: false,
      treeData: [{}], // 树
      // 分组props
      groupProps: {
        expandTrigger: 'hover',
        checkStrictly: true,
        children: 'children',
        label: 'name',
        value: 'id',
        emitPath: false,
      },
      dialogVisible: false,
      flage: false, // 判断是否点击上传海报按钮

      dialogVisibleSelectTag: false,
      selectedTagList: [],
    }
  },
  props: {
    // 模块类型
    moduleType: {
      type: Number,
      default: undefined,
    },
    // 模板模块的Id
    posId: {
      type: String,
      default: null,
    },
    // ismodel: {
    //   type: Boolean,
    //   default: false,
    // },
  },
  watch: {
    fontColor(hex) {
      this.setAttr('fill', hex)
    },
    posId: {
      handler(val) {
        if ([2, 3, 4].includes(this.moduleType)) {
          this.edit(val)
        }
      },
      immediate: true,
      deep: true,
    },
  },
  methods: {
    radioChange(val) {
      this.flage = true
      if (val === '2' && this.form.backgroundImgPath) {
        let items = this.canvas.getObjects()
        items.forEach((item, i) => {
          this.canvas.setActiveObject(items[i])
          let activeObject = this.canvas.getActiveObject()
          if (activeObject) {
            this.canvas.remove(activeObject)
            this.activeObject = null
            deleteBtn.style.display = 'none'
          }
        })
        this.activeLiveCodeType = null
        this.addObj('qrcode')
      }
    },
    selectLiveCode(val) {
      this.addObj(this.liveCodeType, val)
      this.activeLiveCodeType = this.liveCodeType
    },
    addLiveCode(val) {
      if (!this.form.backgroundImgPath) {
        this.msgError('请先点击上传海报')
        return
      } else {
        if (this.form.type === '2') {
          this.msgError('裂变海报只能添加占位码')
          return
        } else {
          if (this.activeLiveCodeType === null || this.activeLiveCodeType === val) {
            this.liveCodeType = val
            this.dialogVisibleLiveCode = true
          } else {
            this.msgError('仅可添加一种二维码组件')
          }
        }
      }
    },
    imgSubmit() {
      if (this.formDate.imgUrl !== '') {
        this.addObj('image', this.formDate.imgUrl)
        this.dialogVisible = false
        this.picErrorMsg = ''
      } else {
        this.picErrorMsg = '请添加图片'
      }
    },
    imgCancel() {
      this.dialogVisible = false
      this.formDate.imgUrl = ''
      this.picErrorMsg = ''
    },
    picShow() {
      if (!this.form.backgroundImgPath) {
        this.msgError('请先点击上传海报')
        return
      } else {
        this.dialogVisible = true
      }
    },
    upSuccess(val) {
      this.flage = true
      this.form.backgroundImgPath = val
      this.setPosterBackgroundImage()
    },
    async edit(item) {
      positionAdd = 50
      times = 0
      try {
        if (item) {
          // 编辑
          const res = await getPosterInfo(item)
          const data = res.data || {}
          // // console.log('getPosterInfo', data)
          let tagNames = data.tagNames?.split(',')
          this.form = {
            id: data.id,
            title: data.title,
            categoryId: data.categoryId,
            type: data.type,
            // status: data.status,
            materialName: data.materialName,
            digest: data.digest,
            backgroundImgPath: data.backgroundImgPath,
            posterJSON: JSON.parse(data.otherField),
            width: data.width,
            height: data.height,
            tags: data.tagIds?.split(',').map((e, i) => ({ tagId: e, name: tagNames?.[i] })),
          }
          this.posterSubassemblyList = data.posterSubassemblyList || []
          let items = JSON.parse(JSON.stringify(JSON.parse(data.otherField).objects))
          this.dealList(items)
        } else {
          // 新增，清除编辑的数据
          this.form = {
            title: '', // 海报名称
            categoryId: '', // 所属分类
            type: '1', // 海报类型
            // status: 0, // 是否启用  0 启用 1 不启用
            materialName: '',
            digest: '',
            backgroundImgPath: '', // 图片url
            mediaId: '', // 图片id
          }
          this.posterSubassemblyList = []
        }
        this.initPoster()
      } catch (error) {
        console.log(error)
      }
    },
    dealList(items) {
      let i = 0
      if (items.length) {
        items.forEach((item) => {
          let obj = {
            3: 'qrcode',
            4: 'ygcode',
            5: 'kqcode',
            6: 'mdcoed',
            7: 'skcode',
            8: 'lxcode',
          }
          if ([3, 4, 5, 6, 7, 8].includes(item.customType)) {
            this.activeLiveCodeType = obj[item.customType]
            i++
          } else {
            if (items.length === 1) {
              this.activeLiveCodeType = null
            } else if (!i) {
              this.activeLiveCodeType = null
            }
          }
        })
      } else {
        this.activeLiveCodeType = null
      }
    },
    // 获取类目树
    getTree() {
      getTree(5).then(({ data }) => {
        data.forEach((item) => {
          item.children = null
        })
        this.treeData = [
          {
            id: '',
            name: '全部',
            parentId: '0',
            hasParent: false,
            hasChildren: true,
            children: data || [],
          },
        ]
      })
    },
    // 初始化海报画布
    initPoster() {
      this.$nextTick(() => {
        // 避免重复初始化
        if (this.canvas) {
          return
        }
        let canvas = (this.canvas = new fabric.Canvas('canvas'))

        if (this.form.posterJSON) {
          // 加载画布信息
          canvas.loadFromJSON(this.form.posterJSON, () => {
            canvas.renderAll()
          })
        }
        this.setPosterBackgroundImage()

        // 删除图层按钮
        let deleteBtn = document.getElementById('deleteBtn')

        function addDeleteBtn(x, y) {
          // deleteBtn.style.display = 'none'
          deleteBtn.style.left = x - 10 + 'px'
          deleteBtn.style.top = y - 30 + 'px'
          deleteBtn.style.display = 'block'
        }

        canvas.on('selection:created', function (e) {
          addDeleteBtn(e.selected[0].lineCoords.tr.x, e.selected[0].lineCoords.tr.y)
        })
        canvas.on('selection:updated', function (e) {
          let activeObject = canvas.getActiveObject()
          if (activeObject._objects?.length > 1) {
            deleteBtn.style.display = 'none'
          } else {
            addDeleteBtn(e.selected[0].lineCoords.tr.x, e.selected[0].lineCoords.tr.y)
          }
        })

        //通用事件另外写法
        canvas.on({
          'mouse:down': (e) => {
            if (e.target != undefined) {
              let ob = (this.activeObject = canvas.getActiveObject())
              if (ob) {
                // var i = e.transform.corner
                // if (i == 'tr') {
                //   this.del()
                // }
                ob.set({
                  transparentCorners: false,
                  cornerColor: 'white',
                  cornerStrokeColor: 'blue',
                  borderColor: 'blue',
                  cornerSize: 12,
                  // rotatingPointOffset: 15,
                  padding: 10,
                  cornerStyle: 'circle',
                  borderDashArray: [3, 3],
                  snapAngle: 45, //在45度时自动保持到45的倍数
                  snapThreshold: 5,
                  centeredRotation: true,
                })
                setTimeout(() => {
                  if (!ob.hasControls) {
                    deleteBtn.style.display = 'none'
                  }
                }, 100)
              }
            } else {
              deleteBtn.style.display = 'none'
            }
          },
        })

        //是否拖动
        // let panning = false
        // canvas.on('mouse:down', (e) => {
        //   this.activeObject = canvas.getActiveObject()
        //   if (!this.activeObject) {
        //     deleteBtn.style.display = 'none'
        //   }
        //   //按住alt键可拖动画布
        //   if (e.e.altKey) {
        //     panning = true
        //     canvas.selection = false
        //   }
        // })

        // //鼠标抬起
        // canvas.on('mouse:up', function(e) {
        //   panning = false
        //   canvas.selection = true
        // })

        // //鼠标移动
        // canvas.on('mouse:move', function(e) {
        //   if (panning && e && e.e) {
        //     let delta = new fabric.Point(e.e.movementX, e.e.movementY)
        //     canvas.relativePan(delta)
        //     console.log(e)
        //   }
        // })

        canvas.on('object:modified', function (e) {
          addDeleteBtn(e.target.lineCoords.tr.x, e.target.lineCoords.tr.y)
        })
        canvas.on('object:scaling', function (e) {
          deleteBtn.style.display = 'none'
        })
        canvas.on('object:moving', function (e) {
          deleteBtn.style.display = 'none'
        })
        canvas.on('object:rotating', function (e) {
          deleteBtn.style.display = 'none'
        })
        canvas.on('mouse:wheel', function (e) {
          deleteBtn.style.display = 'none'
        })

        // alt键缩放
        // document.getElementById('canvas-wrap').addEventListener('wheel', (e) => {
        //   // e.stopPropagation()
        //   if (e.altKey) {
        //     e.preventDefault()
        //     console.log(e)
        //     let zoom = (e.deltaY > 0 ? 0.1 : -0.1) + canvas.getZoom()
        //     zoom = Math.max(0.1, zoom) //最小为原来的1/10
        //     zoom = Math.min(5, zoom) //最大是原来的5倍
        //     let zoomPoint = new fabric.Point(e.offsetX, e.offsetY)
        //     canvas.zoomToPoint(zoomPoint, zoom)
        //   }
        // })

        deleteBtn.addEventListener('click', () => {
          let activeObject = canvas.getActiveObject()
          if (activeObject) {
            this.$confirm('是否确认删除吗?', '警告', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning',
            }).then(() => {
              canvas.remove(activeObject)
              this.activeObject = null
              deleteBtn.style.display = 'none'
              let items = canvas.getObjects()
              this.dealList(items)
            })
          }
        })
      })
    },
    // 设置海报背景
    setPosterBackgroundImage() {
      if (!this.form.backgroundImgPath) {
        return
      }
      let canvas = this.canvas
      canvas.width = 375
      new fabric.Image.fromURL(this.form.backgroundImgPath, (img) => {
        // img.set({
        //   // 通过scale来设置图片大小，这里设置和画布一样大
        //   scaleX: canvas.width / img.width/2,
        //   scaleY: canvas.height / img.height/2
        // })
        // console.log(597, this.imgWidth)
        // if (img.width > 375) {
        //   img.set({
        //     // 通过scale来设置图片大小，这里设置和画布一样大
        //     scaleX: canvas.width / img.width,
        //     scaleY: canvas.width / img.width,
        //   })
        //   canvas.setWidth(375)
        //   let height = img.height * (canvas.width / img.width)
        //   canvas.setHeight(height)
        //   this.form.width = 375
        //   this.form.height = height
        // } else {
        // }
        canvas.setWidth(img.width)
        canvas.setHeight(img.height)
        this.form.width = img.width
        this.form.height = img.height

        canvas.setBackgroundImage(img, canvas.renderAll.bind(canvas))
        canvas.renderAll()
        this.imgWidth = img.width
        if (this.form.type === '2' && this.flage) {
          // 裂变海报
          var items = canvas.getObjects()
          if (items.length) {
            canvas.setActiveObject(items[0])
            let activeObject = canvas.getActiveObject()
            if (activeObject) {
              canvas.remove(activeObject)
              this.activeObject = null
              deleteBtn.style.display = 'none'
            }
          }
          this.time = 0
          this.addObj('qrcode')
        }
      })
    },
    // 设置文本对齐方式
    setAttr(attr, type) {
      this.activeObject.set(attr, type)
      this.canvas.requestRenderAll()
      // this.activeObject.set({
      //   textAlign: type
      // })
    },
    addObj(type, obj) {
      if (!this.form.backgroundImgPath) {
        this.msgError('请先点击上传海报')
        return
      }
      let options = {
        fill: '#333333',
        left: positionAdd + times * 20,
        top: positionAdd,
        borderDashArray: [3, 3],
        customType: {
          text: 1,
          image: 2,
          qrcode: 3,
          ygcode: 4,
          kqcode: 5,
          mdcoed: 6,
          skcode: 7,
          lxcode: 8,
        }[type], // 自定义类型 1 固定文本 2 固定图片 3 二维码图片
      }
      switch (type) {
        case 'text':
          let text = new fabric.Textbox('请输入', options)
          this.canvas.add(text).setActiveObject(text)
          break
        case 'imageShow':
          this.dialogVisibleSelectMaterial = true
          this.isBackgroundImage = false
          break
        case 'image':
        case 'qrcode':
          if (type === 'qrcode') {
            options.type = 'image'
          } else {
            options.type = type
          }

          if (type == 'qrcode' && this.activeLiveCodeType !== 'qrcode' && this.activeLiveCodeType !== null) {
            this.msgError('仅可添加一种二维码组件')
            return
          } else if (type == 'qrcode') {
            this.activeLiveCodeType = 'qrcode'
          }
          if (type == 'qrcode' && this.form.type === '2') {
            // 自定义裂变海报二维码位置排列方式
            options.left =
              this.imgWidth > 375
                ? 107.5 + this.time * 20
                : this.imgWidth / 2 > 80
                ? this.imgWidth / 2 - 80 + this.time * 20
                : 20 + this.time * 20
            options.top = this.canvas.height > 200 ? this.canvas.height - 200 : 20

            this.time++
          }
          new fabric.Image.fromURL(type == 'image' ? obj : window.lwConfig.POST_QRCODE, (img) => {
            img.set(options)
            // img.scale(this.canvas.width / img.width / 2)
            // img.scaleToWidth(200)
            img.scaleToWidth(160)
            this.canvas.add(img).setActiveObject(img)
          })
          this.formDate.imgUrl = ''
          break
        case 'ygcode':
        case 'kqcode':
        case 'mdcoed':
        case 'skcode':
        case 'lxcode':
          new fabric.Image.fromURL(obj, (img) => {
            img.set(options)
            img.scaleToWidth(160)
            this.canvas.add(img).setActiveObject(img)
          })
          break
        default:
          break
      }
      positionAdd += 20
      if (positionAdd > 150) {
        times++
        positionAdd = 50
      }
      this.activeObject = this.canvas.getActiveObject()
    },
    save(isBack) {
      if (!this.form.backgroundImgPath) {
        this.rangeErrorMsg = '请先点击上传海报'
        return
      } else {
        this.rangeErrorMsg = ''
      }
      this.$refs.form.validate((valid) => {
        if (valid) {
          let laoding = this.$loading()
          const form = this.form
          form.tagIds = form.tags?.map((item, index) => item.tagId) + ''
          form.posterJSON = this.canvas.toJSON(['customType'])
          let list = form.posterJSON.objects
          form.otherField = JSON.stringify(form.posterJSON)
          delete form.posterJSON
          let posterSubList = []
          let vo = null
          let i = 0
          let len = list.length
          if (this.form.type === '2') {
            let res = list.filter((item) => {
              return item.customType === 3
            })
            if (!res.length) {
              this.msgError('裂变海报中必须添加二维码')
              laoding.close()
              return
            }
          }

          while (i < len) {
            vo = list[i]

            let isText = vo.type == 'textbox'
            let align = (vo.textAlign && (vo.textAlign === 'left' ? 1 : vo.textAlign === 'center' ? 2 : 3)) || 1
            let posData = {
              id: null, // 修改的时候后端默认没增删，沟通后让先传null
              content: vo.text || '', // 文本内容
              // status: 0, // 1 启动  0 删除       暂时写死
              fontColor: vo.fill || '#000000',
              fontId: null, // TODO 后端让传NULL  isText ? i : null,   // 字体ID   与imgPath互斥
              fontSize: parseInt(vo.fontSize),
              fontTextAlign: align, // 1 2 3  left center right
              left: parseInt(vo.left), // - (isText ? 0 : vo.width >> 1), // 显示偏移了
              top: parseInt(vo.top), // - (isText ? 0 : vo.height >> 1),
              width: parseInt(vo.width * vo.scaleX + (isText ? vo.fontSize / 2 : 0)),
              height: parseInt(vo.height * vo.scaleY),
              imgPath: vo.src || '',
              posterId: null,
              type: vo.customType, // 1 固定文本 2 固定图片 3 占位码 4 员工活码 5 客群活码 6 门店活码 7 识客活码 8 拉新活码
              // alpha: vo.opacity,                   // 后端暂时不支持
              fontStyle: vo.italic && vo.bold ? 3 : vo.italic ? 2 : vo.bold ? 1 : 0, // 0 通常 1 粗体 2 斜体 3 粗 + 斜
              rotate: vo.angle,
              order: i, // 层级
              // categoryId: 0,                       // 分类ID (不需要传了)
              verticalType: 2, // 居中方式后端让写死2
            }
            posterSubList.push(posData)
            i++
          }
          form.moduleType = this.moduleType
          if (this.activeLiveCodeType) {
            let customType = {
              text: 1,
              image: 2,
              qrcode: 3,
              ygcode: 4,
              kqcode: 5,
              mdcoed: 6,
              skcode: 7,
              lxcode: 8,
            }[this.activeLiveCodeType]
            form.posterQrType = customType
          }

          ;(form.id ? updatePoster : addPoster)(
            Object.assign(
              {
                posterSubassemblyList: posterSubList,
              },
              form,
            ),
          )
            .then((res) => {
              laoding.close()
              this.msgSuccess(res.msg)
              if (this.moduleType) {
                // 点击确定的时候
                // this.$refs.form.resetFields()
                this.$emit('getPosterForm', res)
              } else {
                if (this.$route.query.detail) {
                  // 跳回详情页
                  this.$router.go(-1)
                } else {
                  // 跳回海报列表
                  this.$router.push({
                    path: 'list',
                    query: { activeName: 'poster' },
                  })
                }
              }

              if (isBack) {
                this.$refs.page?.getList(1)
              }
            })
            .catch(() => {
              laoding.close()
            })
        }
      })
    },
    submitSelectMaterial(image) {
      if (this.isBackgroundImage) {
        this.form.mediaId = image.id
        this.form.backgroundImgPath = image.materialUrl
        this.setPosterBackgroundImage()
        this.dialogVisibleSelectMaterial = false
      } else {
        this.formDate.imgUrl = image.materialUrl
      }
    },
    cancel() {
      if (this.moduleType) {
        this.$refs.form.resetFields()
        this.$emit('getPosterForm', null)
      } else {
        this.$router.go(-1)
      }
    },
  },
  created() {
    this.getTree()
    let detailId = null
    if ([2, 3, 4].includes(this.moduleType)) {
      // 如果是模板中心
      detailId = this.posId
    } else {
      detailId = this.$route.query.id
    }
    this.edit(detailId)
    if (this.$route.query.categoryId) {
      let form = { categoryId: this.$route.query.categoryId }
      this.form = Object.assign(this.form, form)
    }
  },
}
</script>

<style lang="scss" scoped>
.menu-item-content {
  display: flex;
  flex-direction: column;
  // margin: 20px;
  align-items: center;
  width: 60px;
  span {
    margin-top: 16px;
    margin-bottom: 10px;
  }
}
.basic {
  .title {
    display: in;
    margin-bottom: 20px;
  }
}
.menu-content {
  display: flex;
  justify-content: space-between;
  padding: 0 10px !important;
  // padding-right: 20px !important;
}
.icon-style {
  font-size: 30px;
}
.tips {
  font-size: 12px;
  color: var(--font-black-7);
  line-height: 32px;
}
.up-style {
  display: flex;
  align-items: flex-end;
  el-button {
    height: 30px;
    margin-left: 20px;
  }
}
.upload {
  cursor: pointer;
  width: 120px;
  height: 120px;
  border: 1px dashed var(--border-black-7);
  line-height: 120px;
  text-align: center;
  margin-right: 20px;
}
.el-icon-CircleCloseFilled {
  position: absolute;
  top: 0px;
  left: 0px;
  cursor: pointer;
  z-index: 9;
  font-size: 24px;
  color: var(--font-white, #fff);
  display: none;
  background: #0279de;
  width: 24px;
  height: 24px;
  padding: 6px;
  background-clip: content-box;
  &:before {
    position: absolute;
    top: 0;
    left: 0;
  }
}
.img-wrap {
  position: relative;
  height: 0;
  padding: 70% 0 0 0;
  border-bottom: 1px solid var(--border-black-9);
  &:hover .actions {
    opacity: 1;
  }
}
.actions {
  position: absolute;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-end;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  padding: 10px;
  opacity: 0;
  transition: opacity 0.3s;
  .actions-btn {
    display: inline-block;
    cursor: pointer;
    margin: 10px 0 0 0;
    // & + .actions-btn {
    //   margin: 10px;
    // }
  }
}
.poster-img {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
}
.preview-img {
  width: 100%;
}
#canvas-wrap {
  margin-right: 20px;
  display: inline-block;
  position: relative;
  vertical-align: top;
  overflow: auto;
  max-width: 450px;
  // max-height: 700px;
}
#tbody-containerui-image-editor-controls {
  display: inline-block;
  position: relative;
  // width: 230px;
  width: 200px;
}

.border {
  border: 1px solid black;
}
.menu {
  padding: 0;
  margin-bottom: 5px;
  text-align: center;
  color: var(--font-black-4);
  font-weight: 400;
  list-style-type: none;
  user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  -webkit-user-select: none;
}
.menu-item {
  padding: 10px;
  display: inline-block;
  cursor: pointer;
  vertical-align: middle;
}
.menu-item a {
  text-decoration: none;
}
.menu-item.no-pointer {
  cursor: default;
}
.menu-item.active,
.menu-item:hover {
  background-color: var(--bg-black-10);
}
.menu-item.disabled {
  cursor: default;
  color: var(--font-black-7);
}
.sub-menu-container {
  font-size: 14px;
  margin-bottom: 1em;
}

.btn-text-style {
  display: inline-block;
  padding: 5px;
  margin: 0 2px;
  border: 1px solid var(--border-black-7);
  border-radius: var(--border-radius-small);
  background-color: var(--bg-black-9);
  // background: var(--color);
  // color: var(--font-white);
  cursor: pointer;
}
.disableClass {
  cursor: default;
  color: var(--font-black-7);
}
</style>
