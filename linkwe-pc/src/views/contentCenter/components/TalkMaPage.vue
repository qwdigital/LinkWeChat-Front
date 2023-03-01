<script>
import { getTree } from '@/api/material'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

import { getCodeCategoryList, addCodeCategory, updateCodeCategory } from '@/api/drainageCode/staff'
import { delAndRemoves } from '@/api/contentCenter/common'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getLexicalList, scriptRemove } from '@/api/contentCenter/scriptCenter'
import { getList, remove } from '@/api/drainageCode/welcome'
import { templateDetail } from '@/api/contentCenter/modleCenter'
export default {
  name: 'TalkMaPage',
  components: { PreviewInPhone },
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
      showPreviewDialog: false, // 素材表格对话框显隐
      previewList: [],
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
      delObj: { updateOrDel: 1, moduleType: 2, ids: [] },

      times: null,
      submitLoading: false,
      audioType: ['amr'],
      loading: true, // 遮罩层
      // 查询条件
      query: {
        pageNum: 1,
        pageSize: 10,
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
        '',
        'SOP模板',
        '群发模板',
      ],
      form: {}, // 素材表单
      dialogVisible: false, // 素材表格对话框显隐
      templateInfo: '',
    }
  },
  watch: {},
  computed: {},
  created() {
    this.query.mediaType = this.type
    this.getTree()
    this.getCodeCategoryListFn()
  },
  mounted() {},
  methods: {
    // 预览
    showPreview(data) {
      this.templateInfo = data.templateInfo
      this.getDeatil(data.id)
      this.showPreviewDialog = true
    },
    getDeatil(id) {
      this.loading = true
      templateDetail(id)
        .then((res) => {
          this.previewList = res.data.weMaterialList
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 开始
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
      this.$confirm('是否确认删除当前分组？删除后该分组下数据移动到默认分组中，该操作不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.delObj.ids = []
          this.delObj.ids.push(id)
          if (['13', '14'].includes(this.type)) {
            this.delObj.moduleType = 2
          } else if (['16', '17'].includes(this.type)) {
            this.delObj.moduleType = 3
          }
          delAndRemoves(this.delObj).then((res) => {
            if (res.code === 200) {
              this.$message.success(res.msg)
              this.getCodeCategoryListFn()
              this.getTree()
              this.group = ''
            }
          })
        })
        .catch(() => {})
    },
    // 重置
    resetQuery() {
      if (['13', '14'].includes(this.type)) {
        this.query.talkTitle = ''
      } else if (['16', '17'].includes(this.type)) {
        this.query.templateInfo = ''
      }
      this.search()
    },
    // 结束
    // 获取类目树
    getTree() {
      getTree(this.type).then(({ data }) => {
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
      if (['13', '14'].includes(this.type)) {
        if (this.query.mediaType === '13') {
          this.query.talkType = 0
        } else if (this.query.mediaType === '14') {
          this.query.talkType = 1
        }
        getLexicalList(this.query)
          .then(({ rows, total }) => {
            this.list = rows.sort((a, b) => +new Date(b.updateTime) - +new Date(a.updateTime))
            this.total = +total
            this.loading = false
            this.$emit('listChange', this.list)
          })
          .catch(() => {
            this.loading = false
          })
      } else if (['16', '17'].includes(this.type)) {
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
      }
    },
    // 素材添加/编辑
    edit(data, type) {
      // console.log(data, type)
      switch (type) {
        case 13:
        case 14:
          if (data != 1 && data) {
            // 企业话术，客服话术编辑
            this.$router.push({
              path: 'add',
              query: {
                type: this.type,
                id: data,
              },
            })
          } else {
            // 企业话术，客服话术新增
            this.$router.push({
              path: 'add',
              query: {
                type: this.type,
                categoryId: this.query.categoryId,
              },
            })
          }
          break
        case 16:
        case 17:
          if (data && data !== 1) {
            // sop、群发模板编辑
            this.$router.push({
              path: 'add',
              query: {
                tplType: this.type,
                id: data,
              },
            })
          } else {
            // sop、群发模板新增
            this.$router.push({
              path: 'add',
              query: {
                tplType: this.type,
                categoryId: this.query.categoryId,
              },
            })
          }
          break
      }
    },
    // 素材删除
    remove(id) {
      const Ids = id || this.selected + ''
      let _this = this
      this.$confirm('是否确认删除当前' + this.typeTitle[this.type] + '？该操作不可撤销，请谨慎操作。', '警告', {
        type: 'warning',
      })
        .then(function () {
          if (['13', '14'].includes(_this.type)) {
            return scriptRemove(Ids)
          } else if (['16', '17'].includes(_this.type)) {
            return remove(Ids)
          }
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    detail(id) {
      this.$router.push({
        path: 'detail',
        query: {
          talkId: id,
        },
      })
    },
    // 移动分组
    moveGroup() {
      let form = {}
      form.cateGoreId = this.group
      if (['13', '14'].includes(this.type)) {
        form.moduleType = 2
      } else if (['16', '17'].includes(this.type)) {
        form.moduleType = 3
      }
      form.updateOrDel = 0
      form.ids = this.selected
      delAndRemoves(form).then((res) => {
        this.getCodeCategoryListFn()
        this.getTree()
      })
    },
  },
}
</script>

<template>
  <div class="page">
    <div style="margin-top: 16px">
      <el-row type="flex" justify="space-between">
        <el-col :span="5" class="left g-pad20" style="border-radius: 4px; background: #fff">
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
        </el-col>

        <el-col :span="19" style="margin-top: 0px">
          <div class="g-card">
            <el-input
              v-model="query.talkTitle"
              :placeholder="'请输入' + typeTitle[type] + '标题'"
              clearable
              prefix-icon="el-icon-search"
              style="width: 300px"
              @keyup.enter.native="search()"
              v-if="['13', '14'].includes(type)" />
            <el-input
              v-model="query.templateInfo"
              :placeholder="'请输入' + typeTitle[type] + '标题'"
              clearable
              prefix-icon="el-icon-search"
              style="width: 300px"
              @keyup.enter.native="search()"
              v-else />

            <el-button class="ml10" @click="getList(1)">查询</el-button>
            <!-- v-hasPermi="['wecom:material:list']" -->
            <el-button @click="resetQuery">重置</el-button>
          </div>
          <div class="mt20 g-card pad20">
            <div v-loading="loading">
              <div style="height: 80px">
                <div class="fl g-pad20">
                  <!-- v-hasPermi="['wechat:material:add']" -->
                  <el-button type="primary" @click="edit(1, ~~type)">新建{{ typeTitle[type] }}</el-button>
                </div>
                <div class="fr g-pad20">
                  <el-popover placement="top" width="260" v-model="groupDialogVisible">
                    <div>选择分组</div>
                    <div style="position: relative; margin: 10px 0">
                      <el-cascader v-model="group" :options="treeData[0].children" :props="groupProps"></el-cascader>
                    </div>
                    <div style="text-align: right">
                      <el-button size="mini" @click="groupDialogVisible = false">取消</el-button>
                      <el-button type="primary" size="mini" @click="moveGroup">确定</el-button>
                    </div>
                    <!-- v-hasPermi="['wechat:material:resetCategory']" -->
                    <el-button slot="reference" class="mr10" :disabled="selected.length === 0" type="primary">
                      批量分组
                    </el-button>
                  </el-popover>
                  <el-button @click="remove()" :disabled="selected.length === 0">批量删除</el-button>
                  <!-- v-hasPermi="['wechat:material:remove']" -->
                </div>
              </div>
              <slot v-bind:list="list"></slot>
            </div>
            <pagination
              v-show="total > 0"
              :total="total"
              :page.sync="query.pageNum"
              :limit.sync="query.pageSize"
              @pagination="getList()" />
          </div>
        </el-col>
      </el-row>
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
    <!-- 预览弹框 -->
    <el-dialog title="预览" :visible.sync="showPreviewDialog" width="50%">
      <div>
        <PreviewInPhone :list="previewList" :templateInfo="templateInfo"></PreviewInPhone>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="showPreviewDialog = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<style lang="scss" scoped>
.left {
  margin-right: 16px;
  .title {
    color: var(--color);
    display: flex;
    justify-content: space-between;
    align-items: center;
    .title-name {
      color: rgba(0, 0, 0, 0.9);
      font-size: 16px;
      font-weight: 600;
      // color: #333333;
      display: flex;
      align-items: center;
    }
    .title-btn {
      cursor: pointer;
      display: flex;
      align-items: center;
      font-size: 14px;
      font-weight: normal;
      color: var(--color);
      &:hover {
        opacity: 0.8;
      }
    }
  }

  .item-list {
    max-height: 700px;
    padding-top: 15px;
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow-x: hidden;
    overflow-y: auto;
    .item {
      cursor: pointer;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 14px;
      color: rgba(0, 0, 0, 0.6);
      height: 40px;
      line-height: 40px;
      width: 100%;
      padding-left: 20px;
      .name {
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
      }
      .dropdown {
        // display: none;
        .dot {
          cursor: pointer;
          width: 15px;
          height: 15px;
          line-height: 15px;
          font-size: 14px;
          font-family: JMT-Font, JMT;
          font-weight: normal;
          color: rgba(0, 0, 0, 0.6);
          margin-right: 10px;
          margin-left: 5px;
          font-weight: 500;
          .content-icon {
            color: rgba(0, 0, 0, 0.6);
            font-size: 12px;
            transform: rotate(90deg);
          }
        }
      }
      &:hover {
        color: rgba(0, 0, 0, 0.9);
        background: #f5f8fe;
        opacity: 0.8;
        border-radius: 2px;
        .dropdown {
          // display: block;
        }
      }
    }

    .active {
      // border-left: 2px solid var(--color);
      color: rgba(0, 0, 0, 0.9);
      background: #f5f8fe;
      border-radius: 2px;
    }
  }
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
