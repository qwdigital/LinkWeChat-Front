<script>
import { getTree, getList } from '@/api/material'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

import { getCodeCategoryList } from '@/api/drainageCode/staff'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
export default {
  name: 'MaPage',
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
      // treeData: [{}], // 树
      // 树props
      // treeProps: {
      //   children: 'children',
      //   label: 'name',
      // },
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
      form: {}, // 素材表单
    }
  },
  watch: {},
  computed: {},
  created() {
    this.query.mediaType = this.type
    // this.getTree()
    // this.getList()
    // 开始
    this.getCodeCategoryListFn()
    // 结束
  },
  mounted() {
    this.mobForm[0].msgType = this.type
  },
  methods: {
    // 开始
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
    editGroup(group) {
      this.groupForm = JSON.parse(JSON.stringify(group))
      this.groupVisible = true
    },
    // 重置
    resetQuery() {
      this.query.materialName = ''
      this.search()
      // this.query.categoryId = 1
    },
    // 结束
    // 获取类目树
    // getTree() {
    //   getTree(this.type).then(({ data }) => {
    //     this.treeData = [
    //       {
    //         id: '',
    //         name: '全部',
    //         parentId: '0',
    //         hasParent: false,
    //         hasChildren: true,
    //         children: data || [],
    //       },
    //     ]
    //   })
    // },
    // 获取素材列表
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows.sort((a, b) => +new Date(b.updateTime) - +new Date(a.updateTime))
          this.total = +total
          this.loading = false
          this.$emit('listChange', this.list, this.type)
        })
        .catch(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <div class="page">
    <div style="margin-top: 16px">
      <el-row type="flex" justify="space-between">
        <el-col :span="5" class="left pad20" style="border-radius: 4px; background: var(--bg-white)">
          <div class="title">
            <div class="title-name">{{ typeTitle[type] }}分组</div>
          </div>
          <div class="item-list">
            <div
              class="item"
              :class="{ active: groupIndex == key }"
              v-for="(group, key) in groupList"
              :key="group.id"
              @click="switchGroup(key, group)">
              <div class="name">{{ group.name + ' (' + group.number + ')' }}</div>
            </div>
          </div>
        </el-col>

        <el-col :span="19" style="margin-top: 0px">
          <div class="g-card" style="padding-bottom: 0">
            <el-input
              v-model="query.materialName"
              :placeholder="'请输入' + typeTitle[type] + '标题'"
              clearable
              prefix-icon="el-icon-search"
              style="width: 300px"
              @keyup.enter="search()" />
            <el-button class="ml10" @click="getList(1)" type="primary">查询</el-button>
            <!-- v-hasPermi="['wecom:material:list']" -->
            <el-button @click="resetQuery">重置</el-button>
          </div>
          <div class="pad20">
            <div v-loading="loading">
              <slot v-bind:list="list"></slot>
            </div>
            <pagination
              v-show="total > 0"
              :total="total"
              v-model:page="query.pageNum"
              v-model:limit="query.pageSize"
              @pagination="getList()" />
          </div>
        </el-col>
      </el-row>
    </div>
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
      color: var(--font-black);
      font-size: 16px;
      font-weight: 600;
      // color: var(--font-black);
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
        color: var(--font-black);
        background: var(--bg-black-11);
        opacity: 0.8;
        border-radius: 2px;
        .dropdown {
          // display: block;
        }
      }
    }

    .active {
      // border-left: 2px solid var(--color);
      color: var(--font-black);
      background: var(--bg-black-11);
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
// .custom-tree-node {
//   flex: 1;
//   display: flex;
//   align-items: center;
//   justify-content: space-between;
//   font-size: 14px;
//   padding-right: 8px;
// }

.sub-des {
  // color: var(--font-black-7);
  color: var(--color);
  font-size: 12px;
}
::v-deep .ql-editor {
  height: 300px;
}
</style>
<style lang="scss" scoped>
::v-deep .ql-snow .ql-tooltip {
  left: 20px !important;
}
.ql-snow .ql-tooltip[data-mode='link']::before {
  content: '请输入链接地址:' !important;
  width: 200px !important;
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
