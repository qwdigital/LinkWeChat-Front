<script>
import { getTree, getList, add, update, remove } from '@/api/material'
import AddOrEditMaterialDialog from './AddOrEditMaterialDialog'

import { addCodeCategory, updateCodeCategory } from '@/api/drainageCode/staff'
import { delAndRemoves } from '@/api/contentCenter/common'
import { importTemplate, importData } from '@/api/contentCenter/basicMaterials'
import { toFormData } from '@/utils/common'
import { dateFormat } from '@/utils/index'

export default {
  name: 'MaPage',
  components: {
    // QuillEditor,
    AddOrEditMaterialDialog,
    // AddOrEditMaterialDialog: defineAsyncComponent(() => import('./AddOrEditMaterialDialog')),
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
      form: {
        weMaterialImgAoList: [],
      }, // 素材表单
      dialogVisible: false, // 素材表格对话框显隐

      treeFormRules: {
        name: [{ required: true, message: '不能为空', trigger: 'blur' }],
      },
    }
  },
  watch: {},
  computed: {},
  created() {
    this.query.mediaType = this.type
    this.getTree(true)
    // this.getCodeCategoryListFn()
  },
  mounted() {},
  methods: {
    reUploade() {
      this.$refs.upload.clearFiles()
      this.reUp = true
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
          a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_文本模板.xlsx' //指定下载文件名
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
    switchGroup(index, data) {
      this.groupIndex = index
      this.query.categoryId = data.id
      this.getList(1)
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
            // this.getCodeCategoryListFn()
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
            // this.getCodeCategoryListFn()
            this.getTree(true)
          })
        })
        .catch(() => {})
    },
    // 重置
    resetQuery() {
      this.query.materialName = ''
      delete this.query.type
      this.getList(1)
    },
    // 获取类目树
    getTree(refresh) {
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
        this.groupList = data
        if (refresh) {
          this.query.categoryId = data[0].id
          this.groupIndex = 0
          this.getList(1)
        }
      })
    },
    // 获取素材列表
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          rows.forEach((element) => {
            if (element.tagIds && element.tagNames) {
              element.tagIds = element.tagIds.split(',')
              element.tagNames = element.tagNames.split(',')
              element.tags = []
              element.tagIds.forEach((unit, index) => {
                element.tags.push({
                  tagId: unit,
                  name: element.tagNames[index],
                })
              })
            }
          })
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
    edit(data) {
      let type = this.type
      if (type == 5 || type == 12) {
        // 海报 、文章  的新增或编辑
        this.$router.push({
          path: type == 5 ? 'posterAdd' : 'articleAdd',
          query: {
            type,
            id: data && data.id,
            categoryId: this.query.categoryId,
          },
        })
      } else {
        this.form = Object.assign({}, data || { categoryId: this.query.categoryId })
        this.dialogVisible = true
      }
    },
    // 素材删除
    remove(id) {
      const ids = id || this.selected + ''
      this.$confirm('是否确认删除当前素材？该操作不可撤销，请谨慎操作。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(function () {
          return remove(ids)
        })
        .then(() => {
          this.getTree()
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    detail(row) {
      this.$router.push({
        path: 'detail',
        query: {
          type: this.type,
          id: row.id,
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
          // this.getCodeCategoryListFn()
          this.groupDialogVisible = false
          this.getTree()
          this.getList(1)
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
          this.getTree()
          this.getList(1)
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
  },
}
</script>

<template>
  <div class="">
    <div class="g-left-right" style="height: calc(100vh - 182px)">
      <div class="left g-card">
        <div class="title">
          <div class="title-name">素材分组</div>
          <div class="title-btn" @click="addGroup">添加</div>
        </div>
        <div class="item-list">
          <div
            class="item"
            :class="{ active: groupIndex == index }"
            v-for="(group, index) in groupList"
            :key="group.id"
            @click="switchGroup(index, group)">
            <div class="name">{{ group.name + ' (' + group.number + ')' }}</div>
            <el-dropdown v-if="group.flag === 0" class="dropdown" @command="onGroupCommand($event, group)">
              <span class="dot">
                <el-icon-MoreFilled class="el-icon-MoreFilled content-icon"></el-icon-MoreFilled>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="groupEdit">修改分组</el-dropdown-item>
                  <el-dropdown-item command="groupRemove">删除分组</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>
      </div>

      <div class="right">
        <div class="g-card fxnone">
          <el-input
            v-model="query.materialName"
            :placeholder="'请输入素材标题'"
            clearable
            prefix-icon="el-icon-search"
            style="width: 240px"
            @keyup.enter="getList(1)" />
          <el-select
            v-model="query.type"
            style="width: 240px"
            placeholder="请选择海报类型"
            class="ml10"
            v-if="type === '5'">
            <el-option v-for="item in posterType" :key="item.value" :label="item.label" :value="item.value"></el-option>
          </el-select>
          <el-button class="ml10" type="primary" @click="getList(1)">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
        </div>
        <div class="mt20 g-card pad20">
          <div v-loading="loading">
            <div class="mid-action">
              <div class="">
                <!-- v-hasPermi="['wechat:material:add']" -->
                <el-button type="primary" @click="edit()">新建{{ $dictMaterialType[type]?.name }}</el-button>
                <el-button @click="importText" plain v-if="type === '4'">导入文本</el-button>
              </div>
              <div class="">
                <el-popover placement="top" width="260" :visible="groupDialogVisible">
                  <div>选择分组</div>
                  <div style="position: relative; margin: 10px 0">
                    <el-cascader v-model="group" :options="treeData[0].children" :props="groupProps"></el-cascader>
                  </div>
                  <div style="text-align: right">
                    <el-button @click="groupDialogVisible = false">取消</el-button>
                    <el-button type="primary" @click="moveGroup">确定</el-button>
                  </div>
                  <template #reference>
                    <el-button
                      @click="groupDialogVisible = true"
                      style="margin-right: 10px"
                      :disabled="selected.length === 0"
                      type="primary">
                      批量分组
                    </el-button>
                  </template>
                </el-popover>
                <el-button @click="remove()" :disabled="selected.length === 0">批量删除</el-button>
              </div>
            </div>
          </div>
          <slot v-bind:list="list"></slot>
          <pagination
            v-show="total > 0"
            :total="total"
            v-model:page="query.pageNum"
            v-model:limit="query.pageSize"
            @pagination="getList()" />
        </div>
      </div>
    </div>

    <!-- 分组弹框 -->
    <el-dialog :title="`${groupForm.id ? '修改' : '新建'}分组`" v-model="groupVisible" width="30%" v-if="groupVisible">
      <el-form :model="groupForm" :rules="groupRules" ref="groupForm">
        <el-form-item label="分组名称" prop="name" label-width="80px">
          <el-input v-model="groupForm.name" clearable autocomplete="off" maxlength="15" show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="groupVisible = false">取 消</el-button>
          <el-button type="primary" @click="onAddOrUpdateGroup">确 定</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 添加或修改素材对话框 -->
    <AddOrEditMaterialDialog
      :type="type"
      :data="form"
      :title="(form.id ? '编辑' : '新建') + $dictMaterialType[type]?.name"
      v-model="dialogVisible"
      @success="getTree(), getList(1)"></AddOrEditMaterialDialog>
    <!-- 导入文本弹框 -->
    <el-dialog title="导入文本" width="30%" v-model="textVisible" v-if="textVisible">
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
              :auto-upload="false"
              :on-remove="removeFileData">
              <!-- <el-icon-upload class="el-icon-upload"></el-icon-upload> -->
              <div style="font-size: 12px">
                <!-- 将文件拖拽到此区域 -->
                <el-button type="primary" plain :disabled="!reUp">上传文件</el-button>
                <p style="margin: 3px 0" v-if="reUp">仅支持xls、xlsx格式文件</p>
              </div>
            </el-upload>
            <div>
              <el-button style="margin-left: 10px" text plain @click="downloadFn" v-if="reUp">下载模板</el-button>
              <el-button plain text @click="reUploade" v-else>重新上传</el-button>
            </div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="textVisible = false">取 消</el-button>
          <el-button type="primary" @click="submitImport">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style lang="scss" scoped>
::v-deep .ql-editor {
  height: 300px;
}
</style>
<style>
/* .ql-snow .ql-tooltip[data-mode='link']::before {
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
} */
</style>
