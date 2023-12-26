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
          <el-form-item label="链接标题" prop="title">
            <el-input v-model="form.title" maxlength="15" show-word-limit placeholder="请输入" clearable />
          </el-form-item>
          <el-form-item label="链接描述" prop="descrition">
            <el-input
              type="textarea"
              v-model="form.descrition"
              placeholder="请输入"
              maxlength="50"
              show-word-limit></el-input>
          </el-form-item>
        </el-form>
      </div>

      <div class="g-card">
        <div class="g-card-title fxbw">
          关键词
          <el-button type="primary" @click="add()">新建关键词</el-button>
        </div>
        <DragSortable v-model:data="form.keyWordGroupSubs">
          <el-table-column label="关键词" align="center" prop="keyword"></el-table-column>
          <el-table-column align="center" prop="codeName" label="群活码">
            <template #default="{ row }">
              <div>{{ row.codeName || '—' }}</div>
              <el-image :src="row.groupCodeUrl" class="code-image"></el-image>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center">
            <template #default="{ row }">
              <el-button text @click="add(row)">编辑</el-button>
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

  <div class="g-footer-sticky" style="z-index: 10" v-if="!isDetail">
    <el-button type="primary" @click="submit">保存</el-button>
    <el-button @click="cancel">取消</el-button>
  </div>

  <!-- 新建关键词弹窗 -->
  <el-dialog title="关键词" v-model="dialogVisible" width="600" append-to-body>
    <FormAutoCreateGroup
      v-loading="loading"
      ref="FormAutoCreateGroup"
      append-to-body
      :rules="rules"
      :isDetail="isDetail">
      <el-form-item label="关键词" prop="keyword">
        <el-input
          clearable
          v-model="formKeywords.keyword"
          placeholder="请输入"
          maxlength="15"
          show-word-limit></el-input>
      </el-form-item>
      <el-form-item label="群活码名称" prop="codeName">
        <el-input
          clearable
          v-model="formKeywords.codeName"
          placeholder="请输入"
          maxlength="15"
          show-word-limit></el-input>
      </el-form-item>
    </FormAutoCreateGroup>
    <template #footer>
      <div>
        <el-button type="primary" @click="submitFormKeywords">确定</el-button>
        <el-button @click="dialogVisible = false">取消</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script>
import { getDetail, addOrUpdate, addOrUpdateCancel, addOrUpdateKeyword } from './api'

export default {
  components: {
    Preview: defineAsyncComponent(() => import('./Preview')),
    DragSortable: defineAsyncComponent(() => import('@/components/DragSortable')),
    FormAutoCreateGroup: defineAsyncComponent(() => import('@/components/FormAutoCreateGroup.vue')),
  },
  data() {
    return {
      loading: false, // 遮罩层
      // 表单参数
      form: {},
      dialogVisible: false,
      formKeywords: {},
      rules: Object.freeze({
        title: [{ required: true, message: '必填项', trigger: 'blur' }],
        descrition: [{ required: true, message: '必填项', trigger: 'blur' }],
        keyWordGroupSubs: [{ required: true, message: '必填项', trigger: 'change' }],

        keyword: [{ required: true, message: '必填项', trigger: 'blur' }],
        codeName: [{ required: true, message: '必填项', trigger: 'blur' }],
      }),
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
  },
  created() {
    this.getDetail(this.$route.query.id)
  },
  methods: {
    /** 获取详情 */
    getDetail(id) {
      if (!id) return
      this.$stores.loading = true
      getDetail(id).then(({ data }) => {
        this.form = data
        this.$stores.loading = false
      })
    },
    add(row = {}) {
      this.formKeywords = Object.assign({}, row)
      this.dialogVisible = true
    },
    submitFormKeywords() {
      this.$refs.FormAutoCreateGroup.validate().then(() => {
        this.loading = true
        addOrUpdateKeyword(this.formKeywords)
          .then(() => {
            this.form.keyWordGroupSubs.push(this.formKeywords)
            this.dialogVisible = false
          })
          .finally(() => {
            this.loading = false
          })
      })
    },
    remove(id, index) {
      this.$confirm().then(() => {
        this.form.keywords.splice(index, 1)
      })
    },
    cancel() {
      addOrUpdateCancel(this.form)
      this.$router.back()
    },
    submit() {
      this.$refs.form.validate().then(() => {
        this.$stores.loading = true
        addOrUpdate(this.form)
          .then(() => {
            this.msgSuccess('更新成功')
            this.$router.back()
          })
          .finally(() => {
            this.$stores.loading = false
          })
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
