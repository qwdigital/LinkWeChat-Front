<template>
  <div class="flex">
    <div class="fxauto g-margin-r">
      <div class="g-card">
        <div class="g-card-title fxbw">
          基础信息
          <el-tag class="cp" v-if="isDetail" size="large" effect="dark" @click="sync">同步</el-tag>
        </div>
        <el-form
          :model="form"
          ref="form"
          :rules="rules"
          label-width="100px"
          class="fxauto g-margin-r"
          :class="isDetail && 'form-detail'"
          :disabled="isDetail">
          <el-form-item label="链接标题" prop="taskName">
            <el-input v-model="form.taskName" maxlength="15" show-word-limit placeholder="请输入" clearable />
          </el-form-item>
          <el-form-item label="链接描述" prop="keywords">
            <el-input
              type="textarea"
              v-model="form.keywords"
              placeholder="请输入"
              maxlength="50"
              show-word-limit></el-input>
          </el-form-item>
        </el-form>
      </div>

      <div class="g-card">
        <div class="g-card-title fxbw">
          关键词
          <el-button type="primary" @click="submit">新建关键词</el-button>
        </div>
        <DragSortable v-model:data="form.keywords">
          <el-table-column label="关键词" align="center" prop="keywords"></el-table-column>
          <el-table-column align="center" prop="joinTime" label="群活码">
            <template #default="{ row }">
              {{ row.joinTime || '—' }}
              <br />
              <el-image :src="row.emplCodeUrl" class="code-image"></el-image>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center">
            <template #default="{ row }">
              <el-button text @click=";(formKeywords = Object.assign({}, row)), (dialogVisible = true)">编辑</el-button>
              <el-button text @click="remove(row.id, index)">删除</el-button>
            </template>
          </el-table-column>
        </DragSortable>
      </div>
    </div>

    <div class="preview-wrap g-card mt0" style="flex: 1 1 414px">
      <div class="g-card-title">链接预览</div>
      <!-- 预览 -->
      <Preview :data="form" />
    </div>
  </div>

  <el-dialog title="关键词" v-model="dialogVisible">
    <el-form :model="formKeywords" ref="form" :rules="rules" label-width="100px" class="fxauto mr20">
      <el-form-item label="关键词" prop="taskName">
        <el-input clearable v-model="formKeywords.taskName" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="群活码名称" prop="taskName">
        <el-input clearable v-model="formKeywords.taskName" placeholder="请输入"></el-input>
      </el-form-item>
    </el-form>
    <template #footer>
      <div>
        <el-button type="primary" @click="submit">确定</el-button>
        <el-button @click="dialogVisible = false">取消</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script>
import { getDetail, add, update } from './api'

export default {
  components: {
    Preview: defineAsyncComponent(() => import('./Preview')),
    DragSortable: defineAsyncComponent(() => import('@/components/DragSortable')),
  },
  data() {
    return {
      taskId: '',
      loading: false, // 遮罩层
      // 表单参数
      form: {
        taskName: '', // 任务名称
        groupCodeId: '', // 群活码ID
        welcomeMsg: '', // 欢迎语
        keywords: [{ keywords: 1 }, { keywords: 2 }, { keywords: 3 }], // 关键词
      },
      dialogVisible: false,
      formEidt: {
        taskName: '', // 任务名称
        groupCodeId: '', // 群活码ID
        welcomeMsg: '', // 欢迎语
      },
      codes: [],
      groupQrCode: {},
      rules: Object.freeze({
        taskName: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        welcomeMsg: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        keywords: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        groupCodeId: [{ required: true, message: '该项为必填项', trigger: 'change' }],
      }),
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
  },
  created() {
    this.taskId = this.$route.query.id
    // this.$route.meta.title = (this.taskId ? '编辑' : '新建') + '关键词拉群'
    this.taskId && this.getDetail(this.taskId)
  },
  methods: {
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id).then(({ data }) => {
        this.form.taskName = data.taskName
        this.form.welcomeMsg = data.welcomeMsg

        // const keywordList = data.keywordList || []
        // const keywords = keywordList.map((k) => k.keyword)
        // this.form.keywords = keywords.join(',')
        this.form.keywords = data.keywords

        if (data.groupCodeInfo && data.groupCodeInfo.id) {
          this.form.groupCodeId = data.groupCodeInfo.id
          this.codes = [data.groupCodeInfo]
          this.groupQrCode = data.groupCodeInfo
        } else {
          this.form.groupCodeId = ''
          this.codes = []
          this.groupQrCode = {}
        }

        this.loading = false
      })
    },
    submit() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.loading = true
          if (this.taskId) {
            update(this.taskId, this.form)
              .then(() => {
                this.msgSuccess('更新成功')
                this.loading = false
                this.$router.back()
              })
              .catch(() => {
                this.loading = false
              })
          } else {
            add(this.form)
              .then(() => {
                this.msgSuccess('添加成功')
                this.loading = false
                this.$router.back()
              })
              .catch(() => {
                this.loading = false
              })
          }
        }
      })
    },
    // 选择二维码确认按钮
    submitSelectQrCode(data) {
      this.groupQrCode = data
      this.form.groupCodeId = data.id
      this.$refs.form.validateField('groupCodeId')
    },
    remove(id, index) {
      this.$confirm().then(() => {
        this.form.keywords.splice(index, 1)
      })
    },
  },
}
</script>

<style lang="scss" scoped>
// ::v-deep .el-table__header {
//   width: auto !important;
// }
.el-form-item {
  width: 500px;
}
.preview-wrap {
  line-height: 26px;
}
.tip {
  color: var(--font-black-6);
}
.welcome-input {
  display: table;
  width: 80%;
  margin: 0 auto 20px;
}
.phone-dialog-image {
  border-radius: 6px;
  width: 100px;
}
</style>
