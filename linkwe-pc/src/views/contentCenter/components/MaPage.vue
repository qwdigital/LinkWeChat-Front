<script>
import { getTree, getList, add, update, remove } from '@/api/material'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

import { quillEditor } from 'vue-quill-editor'
import Voice from '@/components/Voice'

import { getCodeCategoryList, addCodeCategory, updateCodeCategory } from '@/api/drainageCode/staff'
import { delAndRemoves } from '@/api/contentCenter/common'
import { importTemplate, importData } from '@/api/contentCenter/basicMaterials'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { download, toFormData } from '@/utils/common'
import UploadToCos from '@/components/UploadToCos'
import { dateFormat } from '@/utils/index'

var validateHtml = (rule, value, callback) => {
  if (/\.html$/gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 .html 作为后缀'))
  }
}
var validateHttp = (rule, value, callback) => {
  if (/^https?:\/\//gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 http://或 https://开头'))
  }
}
export default {
  name: 'MaPage',
  components: {
    quillEditor,
    Voice,
    PreviewInPhone,
    UploadToCos,
  },
  props: {
    // 0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)， 4 文本， 5 海报， 6 活码， 7 人群， 8 旅程，9 图文，10 链接，11 小程序
    type: {
      type: String,
      default: '0',
    },
    // 选中的素材ids
    selected: {
      type: [Array, String],
      default: '',
    },
  },
  data() {
    return {
      posterType: [
        { value: '1', label: '通用海报' },
        { value: '2', label: '裂变海报' },
      ],
      flag: false,
      reUp: true, // 重新上传
      textVisible: false,
      actionUrl: '',
      headers: window.lwConfig.headers,
      mobForm: [{}],
      groupList: [],
      groupVisible: false,
      groupForm: {
        mediaType: this.type,
        name: '',
      },
      groupRules: {
        name: [
          {
            required: true,
            message: '请输入分组名称',
            trigger: 'blur',
          },
          {
            min: 1,
            max: 15,
            message: '长度在 1 到 15 个字符',
            trigger: 'blur',
          },
        ],
      },
      groupIndex: 0,
      delObj: { updateOrDel: 1, moduleType: 1, ids: [] },

      times: null,
      submitLoading: false,
      audioType: ['amr'],
      loading: true, // 遮罩层
      // 查询条件
      query: {
        pageNum: 1,
        pageSize: 10,
        materialName: '',
        mediaType: '0',
        categoryId: '',
      },
      list: [], // 列表
      total: 0, // 总条数
      treeData: [{}], // 树
      // 树props
      treeProps: {
        children: 'children',
        label: 'name',
      },
      treeForm: {}, // 树表格
      treeDialogVisible: false, // 树表格对话框显隐

      group: '', // 选择的分组
      groupDialogVisible: false, // 移动分组对话框
      // 分组props
      groupProps: {
        expandTrigger: 'hover',
        checkStrictly: true,
        children: 'children',
        label: 'name',
        value: 'id',
        emitPath: false,
      },
      // 0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)， 4 文本， 5 海报， 6 活码， 7 人群， 8 旅程，9 图文，10 链接，11 小程序
      typeTitle: [
        '图片',
        '语音',
        '视频',
        '文件',
        '文本',
        '海报',
        '活码',
        '人群',
        '旅程',
        '图文',
        '链接',
        '小程序',
        '文章',
        '企业话术',
        '客服话术',
      ],
      form: {
        weMaterialImgAoList: [],
      }, // 素材表单
      dialogVisible: false, // 素材表格对话框显隐
      // 表单校验
      rules: Object.freeze({
        materialName: [{ required: true, message: '不能为空', trigger: 'change' }],
        categoryId: [{ required: true, message: '不能为空', trigger: 'change' }],
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        materialUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        weMaterialImgAoList: [{ type: 'array', required: true, message: '不能为空', trigger: 'change' }],
        digest: [{ required: true, message: '不能为空', trigger: 'blur' }],
        coverUrl: [{ required: true, message: '不能为空', trigger: 'blur' }],
        html: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHtml, trigger: 'blur' },
        ],
        http: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHttp, trigger: 'blur' },
        ],
        materialUrl: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHttp, trigger: 'blur' },
        ],
      }),
      treeFormRules: {
        name: [{ required: true, message: '不能为空', trigger: 'blur' }],
      },
    }
  },
  watch: {
    'form.weMaterialImgAoList'(value) {
      this.mobForm = []
      value &&
        value.forEach((item) => {
          this.mobForm.push({ mediaType: '0', materialUrl: item.url })
        })
    },
    form: {
      handler(val) {
        if (this.type != '0') {
          this.mobForm = []
          val.mediaType = this.type
          this.mobForm.push(val)
        }
      },
      deep: true,
    },
  },
  computed: {},
  created() {
    this.query.mediaType = this.type
    this.getTree()
    this.getCodeCategoryListFn()
  },
  mounted() {
    this.mobForm[0].mediaType = this.type
  },
  methods: {
    reUploade() {
      this.$refs.upload.clearFiles()
      this.reUp = true
    },
    handleFileSuccess() {
      // this.reUp = true
    },
    downloadFn() {
      importTemplate().then((res) => {
        // download(res.data)
        if (!res) return
        const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型

        if (window.navigator.msSaveOrOpenBlob) {
          //兼容IE10
          navigator.msSaveBlob(blob, '咨询记录')
        } else {
          const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
          const a = document.createElement('a') //创建a标签
          a.style.display = 'none'
          a.href = href // 指定下载链接
          a.download = dateFormat(new Date(), 'yyyy-MM-dd') + '_文本模板.xlsx' //指定下载文件名
          a.click() //触发下载
          URL.revokeObjectURL(a.href) //释放URL对象
        }
      })
    },
    importText() {
      this.textVisible = true
      this.reUp = true
    },
    addGroup() {
      this.groupForm = {
        mediaType: this.type,
        name: '',
      }
      this.groupVisible = true
    },
    getCodeCategoryListFn() {
      getCodeCategoryList({ mediaType: this.type }).then((res) => {
        if (res.code == 200) {
          this.groupList = res.data
          this.query.categoryId = this.groupList[0].id
          this.groupIndex = 0
          this.query.pageNum = 1
          this.getList()
        }
      })
    },
    switchGroup(index, data) {
      this.groupIndex = index
      this.query.categoryId = data.id
      this.search()
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    // 新增分组
    onAddOrUpdateGroup() {
      this.$refs.groupForm.validate((validate) => {
        if (this.groupForm.id) {
          let obj = {
            id: this.groupForm.id,
            name: this.groupForm.name,
            mediaType: this.type,
          }
          this.groupForm = obj
        }
        if (validate) {
          ;(this.groupForm.id ? updateCodeCategory : addCodeCategory)(this.groupForm).then((res) => {
            this.groupVisible = false
            this.groupForm = {
              name: '',
              mediaType: this.type,
            }
            this.$refs.groupForm.clearValidate()
            this.getCodeCategoryListFn()
            this.getTree()
          })
        }
      })
    },
    onGroupCommand(e, group) {
      if (group.id === '1') {
        this.msgInfo('默认分组不可操作！')
        return
      }
      if (e == 'groupEdit') {
        this.editGroup(group)
      } else if (e == 'groupRemove') {
        this.removeGroup(group.id)
      }
    },
    editGroup(group) {
      this.groupForm = JSON.parse(JSON.stringify(group))
      this.groupVisible = true
    },
    removeGroup(id) {
      this.$confirm('是否确认删除当前分组？删除后该分组下素材移动到默认分组中，该操作不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.delObj.ids = []
          this.delObj.ids.push(id)
          delAndRemoves(this.delObj).then((res) => {
            this.getCodeCategoryListFn()
            this.getTree()
          })
        })
        .catch(() => {})
    },
    // 重置
    resetQuery() {
      this.query.materialName = ''
      delete this.query.type
      this.search()
    },
    // 结束
    // 获取类目树
    getTree() {
      getTree(this.type).then(({ data }) => {
        // 删除每一项的children属性
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
    // 获取素材列表
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows.sort((a, b) => +new Date(b.updateTime) - +new Date(a.updateTime))
          this.total = +total
          this.loading = false
          this.$emit('listChange', this.list)
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 素材添加/编辑
    edit(data, type) {
      if (!type && this.type == 5) {
        type = 5
      }
      switch (type) {
        case 5:
          if (data && data !== 0) {
            // 海报编辑
            this.$router.push({
              path: 'posterAdd',
              query: {
                type: this.type,
                id: data.id,
              },
            })
          } else {
            this.$router.push({
              path: 'posterAdd',
              query: {
                type: this.type,
                categoryId: this.query.categoryId,
              },
            })
          }
          break
        case 12:
          if (data && data !== 0) {
            // 编辑
            this.$router.push({
              path: 'articleAdd',
              query: {
                type: this.type,
                id: data.id,
              },
            })
          } else {
            // 文章新增
            this.$router.push({
              path: 'articleAdd',
              query: {
                type: this.type,
                categoryId: this.query.categoryId,
              },
            })
          }
          break
        case 13:
          this.$router.push({
            path: 'add',
            query: {
              type: this.type,
              categoryId: this.query.categoryId,
            },
          })
          break
        default:
          // this.mobForm.welcomeMsg = ''
          this.form = Object.assign({}, data || { categoryId: this.query.categoryId })
          this.dialogVisible = true
          this.$nextTick(() => {
            this.$refs['form'].clearValidate()
          })
          break
      }
    },
    // 素材提交
    submit() {
      // this.$refs['form'].validateField
      this.flag = true
      this.submitLoading = true
      if (this.times) {
        clearTimeout(this.times)
      }
      if (!this.form.id && this.form.weMaterialImgAoList) {
        // 新增
        this.form.weMaterialImgAoList.forEach((item, index) => {
          item.materialUrl = item.url
          item.materialName = item.name
        })
      }
      this.$refs['form'].validate((valid) => {
        if (valid) {
          this.times = setTimeout(() => {
            // this.getVideoBase64(this.form.materialUrl)
            let form = JSON.parse(JSON.stringify(this.form))
            form.mediaType = this.type
            ;(form.id ? update : add)(form)
              .then(() => {
                this.msgSuccess('操作成功')
                this.dialogVisible = false
                this.getList()
                // this.picReset()
                this.$refs['form'].resetFields()
                this.submitLoading = false
                setTimeout(() => {
                  this.flag = false
                }, 1000)
              })
              .catch(() => {
                this.dialogVisible = false
                this.submitLoading = false
                this.flag = false
              })
          }, 300)
        } else {
          this.submitLoading = false
          this.flag = false
        }
      })
    },
    // 素材弹框点击取消
    cancel() {
      this.dialogVisible = false
    },
    // 素材删除
    remove(id) {
      const Ids = id || this.selected + ''
      this.$confirm('是否确认删除当前' + this.typeTitle[this.type] + '？该操作不可撤销，请谨慎操作。', '警告', {
        type: 'warning',
      })
        .then(function () {
          return remove(Ids)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    detail(row) {
      this.$router.push({
        path: 'detail',
        query: {
          type: this.type,
          obj: encodeURIComponent(JSON.stringify(row)),
        },
      })
    },
    // 移动分组
    moveGroup() {
      let form = {}
      form.cateGoreId = this.group
      form.moduleType = 1
      form.updateOrDel = 0
      form.ids = this.selected
      delAndRemoves(form).then((res) => {
        if (res.code === 200) {
          this.$message.success(res.msg)
          this.getCodeCategoryListFn()
          this.getTree()
          this.group = ''
        }
      })
    },
    // 下载
    download(data) {
      window.open(data.materialUrl)
    },
    // 导入文本
    submitImport() {
      if (!this.file) {
        this.msgInfo('请先上传文件！')
        return false
      }
      importData(toFormData({ file: this.file }), this.query.categoryId, this.type).then((res) => {
        if (res.code === 200) {
          this.msgSuccess(res.data)
          this.textVisible = false
          // this.$emit('update')
          this.getList()
        }
      })
    },
    setFileData(f, fl) {
      this.file = f.raw
      this.reUp = false
    },
    removeFileData(f, fl) {
      this.file = null
      this.reUp = true
    },
    getPicUrl(val) {
      this.$set(this.form, 'coverUrl', val)
    },
  },
}
</script>

<template>
  <div class="">
    <div class="g-left-right" style="height: calc(100vh - 182px)">
      <div class="left g-card">
        <!-- <div> -->
        <!-- v-hasPermi="['wechat:category:add']" -->
        <!-- <el-button slot="reference" type="primary" @click="treeEdit({}, 0)">添加分类</el-button> -->
        <!-- </div> -->
        <div class="title">
          <div class="title-name">{{ typeTitle[type] }}分组</div>
          <div class="title-btn" @click="addGroup">添加</div>
        </div>
        <div class="item-list">
          <div
            class="item"
            :class="{ active: groupIndex == key }"
            v-for="(group, key) in groupList"
            :key="group.id"
            @click="switchGroup(key, group)">
            <div class="name">{{ group.name + ' (' + group.number + ')' }}</div>
            <el-dropdown v-if="group.flag === 0" class="dropdown" @command="onGroupCommand($event, group)">
              <span class="dot">
                <!-- <img style="height: 15px;width: 15px;" :src="require('@/assets/drainageCode/more.png')" alt=""> -->
                <i class="el-icon-more content-icon"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="groupEdit">修改分组</el-dropdown-item>
                <el-dropdown-item command="groupRemove">删除分组</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </div>

      <div class="right">
        <div class="g-card fxnone">
          <el-input
            v-model="query.materialName"
            :placeholder="'请输入' + typeTitle[type] + '标题'"
            clearable
            prefix-icon="el-icon-search"
            style="width: 300px"
            @keyup.enter.native="search()" />
          <el-select v-model="query.type" placeholder="请选择海报类型" class="ml20" v-if="type === '5'">
            <el-option v-for="item in posterType" :key="item.value" :label="item.label" :value="item.value"></el-option>
          </el-select>
          <el-button style="margin-left: 10px" type="primary" @click="getList(1)">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
        </div>
        <div class="mt20 g-card pad20">
          <div v-loading="loading">
            <div class="mid-action">
              <div class="">
                <!-- v-hasPermi="['wechat:material:add']" -->
                <el-button type="primary" @click="edit(0, ~~type)">新建{{ typeTitle[type] }}</el-button>
                <el-button @click="importText" plain v-if="type === '4'">导入文本</el-button>
              </div>
              <div class="">
                <el-popover placement="top" width="260" v-model="groupDialogVisible">
                  <div>选择分组</div>
                  <div style="position: relative; margin: 10px 0">
                    <el-cascader v-model="group" :options="treeData[0].children" :props="groupProps"></el-cascader>
                  </div>
                  <div style="text-align: right">
                    <el-button size="mini" @click="groupDialogVisible = false">取消</el-button>
                    <el-button type="primary" size="mini" @click="moveGroup">确定</el-button>
                  </div>
                  <el-button
                    slot="reference"
                    style="margin-right: 10px"
                    :disabled="selected.length === 0"
                    type="primary">
                    批量分组
                  </el-button>
                </el-popover>
                <el-button @click="remove()" :disabled="selected.length === 0">批量删除</el-button>
              </div>
            </div>
          </div>
          <slot v-bind:list="list"></slot>
          <pagination
            v-show="total > 0"
            :total="total"
            :page.sync="query.pageNum"
            :limit.sync="query.pageSize"
            @pagination="getList()" />
        </div>
      </div>
    </div>
    <!-- 分组弹框 -->
    <el-dialog
      :title="`${groupForm.id ? '修改' : '新建'}分组`"
      :visible.sync="groupVisible"
      width="30%"
      v-if="groupVisible">
      <el-form :model="groupForm" :rules="groupRules" ref="groupForm">
        <el-form-item label="分组名称" prop="name" label-width="80px">
          <el-input v-model="groupForm.name" clearable autocomplete="off" maxlength="15" show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="groupVisible = false">取 消</el-button>
        <el-button type="primary" @click="onAddOrUpdateGroup">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 添加或修改素材对话框 -->
    <el-dialog
      :title="(form.id ? '编辑' : '新建') + typeTitle[type]"
      :visible.sync="dialogVisible"
      width="60%"
      append-to-body
      :close-on-click-modal="false">
      <el-alert type="warning" show-icon v-if="type === '11'">
        <template slot="title">
          <div style="display: flex">
            <div style="color: #333">小程序必须已经绑定关联到企业微信，否则将无法在欢迎语、群发、话术中正常发送。</div>
            <a href="https://www.yuque.com/linkwechat/help/gy4ghv" target="_blank" style="color: var(--color)">
              如何关联绑定?
            </a>
          </div>
        </template>
      </el-alert>
      <el-row style="margin-top: 20px">
        <el-col :span="14">
          <el-form ref="form" :model="form" :rules="rules" label-width="100px">
            <el-form-item label="选择分组" prop="categoryId">
              <el-cascader v-model="form.categoryId" :options="treeData[0].children" :props="groupProps"></el-cascader>
            </el-form-item>

            <!-- 文本 -->
            <el-form-item :label="typeTitle[type] + '标题'" prop="materialName" v-if="type === '4'">
              <el-input v-model="form.materialName" placeholder="请输入标题" maxlength="50" show-word-limit></el-input>
              <div class="tip">标题对客户不可见，仅用于查询场景</div>
            </el-form-item>
            <el-form-item label="文本内容" prop="content" v-if="type === '4'">
              <TextareaExtend
                v-model="form.content"
                :autosize="{ minRows: 2, maxRows: 50 }"
                placeholder="请输入内容"
                maxlength="1000"
                show-word-limit></TextareaExtend>
            </el-form-item>

            <!-- 图片 -->
            <template v-else-if="type === '0'">
              <el-form-item label="图片" prop="weMaterialImgAoList" v-if="!form.id">
                <UploadToCos
                  v-if="dialogVisible"
                  :fileList.sync="form.weMaterialImgAoList"
                  :maxSize="20"
                  type="0"
                  :multiple="true"
                  :limit="10">
                  <div slot="tip">支持jpg/jpeg/png格式，图片大小不超过20M，支持最多10张批量上传</div>
                </UploadToCos>
              </el-form-item>
              <el-form-item label="图片标题" prop="materialName" v-else>
                <el-input
                  v-model="form.materialName"
                  placeholder="请输入"
                  :maxlength="50"
                  show-word-limit
                  :disabled="true"></el-input>
                <div class="tip">标题对客户不可见，仅用于查询场景</div>
              </el-form-item>
            </template>
            <!-- 图文 -->
            <template v-else-if="type === '9'">
              <el-form-item label="图文地址" prop="materialUrl">
                <el-input
                  v-model="form.materialUrl"
                  type="text"
                  placeholder="请输入图文地址，以http://或https://开头"></el-input>
              </el-form-item>
              <el-form-item label="图文标题" prop="materialName">
                <el-input
                  v-model="form.materialName"
                  type="text"
                  :maxlength="32"
                  show-word-limit
                  placeholder="请输入图文标题"></el-input>
              </el-form-item>
              <el-form-item label="图文描述">
                <el-input
                  v-model="form.content"
                  type="textarea"
                  :maxlength="128"
                  show-word-limit
                  :autosize="{ minRows: 3, maxRows: 50 }"
                  placeholder="请输入图文描述"></el-input>
              </el-form-item>
              <el-form-item label="图文封面">
                <UploadToCos :fileUrl.sync="form.coverUrl" type="0" v-if="dialogVisible">
                  <div slot="tip">支持jpg/jpeg/png格式，建议200*200</div>
                </UploadToCos>
              </el-form-item>
              <!-- <el-form-item label="内容">
                富文本content
                <quill-editor v-model="form.content" ref="myQuillEditor"> </quill-editor>
              </el-form-item> -->
            </template>

            <!-- 链接 -->
            <template v-else-if="type === '8'">
              <el-form-item label="链接标题" prop="materialName">
                <el-input
                  v-model="form.materialName"
                  type="text"
                  :maxlength="64"
                  show-word-limit
                  placeholder="请输入链接标题"></el-input>
              </el-form-item>
              <el-form-item label="链接" prop="materialUrl" :rules="rules.http">
                <el-input v-model="form.materialUrl" placeholder="请输入链接"></el-input>
                <div class="sub-des">必须以 http://或 https://开头</div>
              </el-form-item>
            </template>

            <!-- 小程序标题 -->
            <template v-else-if="type === '11'">
              <el-form-item label="小程序标题" prop="materialName">
                <el-input
                  v-model="form.materialName"
                  placeholder="请输入小程序标题"
                  :maxlength="16"
                  show-word-limit></el-input>
              </el-form-item>
              <el-form-item label="小程序ID" prop="digest">
                <el-input v-model="form.digest" placeholder="小程序AppID"></el-input>
                <div class="sub-des">
                  <a href="https://www.yuque.com/linkwechat/help/gy4ghv#cAwOh" target="_blank">如何查询小程序ID?</a>
                </div>
              </el-form-item>
              <el-form-item label="页面路径" prop="materialUrl" :rules="rules.html">
                <el-input v-model="form.materialUrl" placeholder="请输入小程序路径，必须以 .html 作为后缀"></el-input>
                <div class="sub-des">
                  <a href="https://www.yuque.com/linkwechat/help/gy4ghv#a1bXG" target="_blank">
                    如何添加小程序页面路径?
                  </a>
                </div>
              </el-form-item>
              <el-form-item label="封面" prop="coverUrl">
                <UploadToCos :fileUrl.sync="form.coverUrl" type="0" v-if="dialogVisible">
                  <div slot="tip">支持jpg/jpeg/png格式，建议520*416</div>
                </UploadToCos>
              </el-form-item>
            </template>

            <template v-else-if="type === '1'">
              <el-form-item label="语音" prop="materialUrl">
                <Voice v-if="form.materialUrl" :amrUrl="form.materialUrl"></Voice>
                <UploadToCos
                  :fileUrl.sync="form.materialUrl"
                  :fileName.sync="form.materialName || '点击上传'"
                  :type="type"
                  :format="audioType">
                  <div slot="tip">只能上传amr格式的语音文件。单个文件大小不超过2M，时长不超过1分钟</div>
                </UploadToCos>
              </el-form-item>
              <el-form-item label="名称" prop="materialName">
                <el-input v-model="form.materialName" placeholder="请输入"></el-input>
              </el-form-item>
            </template>
            <!-- 视频 -->
            <template v-else-if="type === '2'">
              <el-form-item label="视频标题" prop="materialName">
                <el-input
                  v-model="form.materialName"
                  placeholder="请输入视频标题"
                  :maxlength="32"
                  show-word-limit></el-input>
              </el-form-item>
              <el-form-item label="视频描述">
                <el-input
                  v-model="form.digest"
                  type="textarea"
                  placeholder="请输入视频描述"
                  :autosize="{ minRows: 3, maxRows: 10 }"
                  :maxlength="128"
                  show-word-limit></el-input>
              </el-form-item>
              <el-form-item label="上传视频" prop="materialUrl" v-if="!form.id">
                <UploadToCos
                  v-if="dialogVisible"
                  :fileUrl.sync="form.materialUrl"
                  :fileName.sync="form.materialName"
                  :format="['mp4', 'mov']"
                  @getPicUrl="getPicUrl"
                  :type="type">
                  <div slot="tip">支持mp4/mov格式，视频大小不超过100M</div>
                </UploadToCos>
              </el-form-item>
              <!-- <el-form-item label="封面">
                <upload :fileUrl.sync="form.coverUrl" type="0">
                  <div slot="tip">建议尺寸：1068*455</div>
                </upload>
              </el-form-item> -->
            </template>

            <!-- 文件 -->
            <template v-else-if="type === '3'">
              <el-form-item label="文件标题" prop="materialName">
                <el-input
                  v-model="form.materialName"
                  placeholder="请输入文件标题"
                  :maxlength="32"
                  show-word-limit></el-input>
              </el-form-item>
              <el-form-item label="文件描述">
                <el-input
                  v-model="form.digest"
                  type="textarea"
                  placeholder="请输入文件描述"
                  :maxlength="100"
                  show-word-limit
                  :autosize="{ minRows: 3, maxRows: 10 }"></el-input>
              </el-form-item>
              <el-form-item label="上传文件" prop="materialUrl" v-if="!form.id">
                <UploadToCos
                  v-if="dialogVisible"
                  :fileUrl.sync="form.materialUrl"
                  :fileName.sync="form.materialName"
                  :type="type"
                  :format="['doc', 'docx', 'pdf', 'ppt', 'pptx', 'pps', 'pptsx']">
                  <div slot="tip">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
                </UploadToCos>
              </el-form-item>
            </template>
          </el-form>
        </el-col>
        <el-col :span="10" v-if="!(type === '0' && form.id)">
          <PreviewInPhone :list="mobForm" />
        </el-col>
      </el-row>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" v-loading="submitLoading" :disabled="flag" @click="submit">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
    <!-- 导入文本弹框 -->
    <el-dialog title="导入文本" width="30%" :visible.sync="textVisible" v-if="textVisible">
      <el-form :model="groupForm" :rules="groupRules" ref="groupForm">
        <el-form-item label="选择表格" prop="name" label-width="80px">
          <div style="display: flex">
            <el-upload
              accept=".xls, .xlsx"
              :action="actionUrl"
              :limit="1"
              :headers="headers"
              ref="upload"
              :on-change="setFileData"
              :on-success="handleFileSuccess"
              :auto-upload="false"
              :on-remove="removeFileData">
              <!-- <i class="el-icon-upload"></i> -->
              <div style="font-size: 12px">
                <!-- 将文件拖拽到此区域 -->
                <el-button size="mini" type="primary" plain :disabled="!reUp">上传文件</el-button>
                <p style="margin: 3px 0" v-if="reUp">仅支持xls、xlsx格式文件</p>
              </div>
            </el-upload>
            <div>
              <el-button style="margin-left: 10px" size="mini" type="text" plain @click="downloadFn" v-if="reUp">
                下载模板
              </el-button>
              <el-button size="mini" plain type="text" @click="reUploade" v-else>重新上传</el-button>
            </div>
          </div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="textVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitImport">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style lang="scss" scoped>
.tip {
  color: #999;
  font-size: 12px;
}

.custom-tree-node {
  overflow: hidden;
  flex-shrink: 1;
  flex-grow: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding-right: 8px;
}

.custom-tree-node .label {
  flex-shrink: 1;
  overflow: hidden;
  text-overflow: ellipsis;
}

.custom-tree-node .button {
  flex-grow: 0;
  flex-shrink: 0;
}
.nameFlex {
  width: 100%;
  display: flex;
  justify-content: space-between;
}
.text-word {
  // width: 215px;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.sub-des {
  // color: #aaa;
  color: var(--color);
  font-size: 12px;
}

::v-deep .ql-editor {
  height: 300px;
}
</style>
<style>
.ql-snow .ql-tooltip[data-mode='link']::before {
  content: '请输入链接地址:' !important;
}
.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
  border-right: 0px !important;
  content: '保存' !important;
  padding-right: 0px !important;
}

.ql-snow .ql-tooltip[data-mode='video']::before {
  content: '请输入视频地址:' !important;
}

.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
  content: '14px' !important;
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value='small']::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value='small']::before {
  content: '10px' !important;
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value='large']::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value='large']::before {
  content: '18px' !important;
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value='huge']::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value='huge']::before {
  content: '32px' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label::before,
.ql-snow .ql-picker.ql-header .ql-picker-item::before {
  content: '文本' !important;
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='1']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='1']::before {
  content: '标题1' !important;
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='2']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='2']::before {
  content: '标题2' !important;
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='3']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='3']::before {
  content: '标题3' !important;
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='4']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='4']::before {
  content: '标题4' !important;
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='5']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='5']::before {
  content: '标题5' !important;
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='6']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='6']::before {
  content: '标题6' !important;
}

.ql-snow .ql-picker.ql-font .ql-picker-label::before,
.ql-snow .ql-picker.ql-font .ql-picker-item::before {
  content: '标准字体' !important;
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value='serif']::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value='serif']::before {
  content: '衬线字体' !important;
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value='monospace']::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value='monospace']::before {
  content: '等宽字体' !important;
}
</style>
