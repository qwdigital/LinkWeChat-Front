<template>
  <div class="flex">
    <div class="fxauto g-margin-r">
      <div class="g-card">
        <div class="g-card-title fxbw">
          基础信息
          <el-tag class="cp" v-if="isDetail" size="large" effect="dark" @click="getDetail">同步</el-tag>
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
          <el-button type="primary" v-if="!isDetail" @click="addOrUpdate()">新建关键词</el-button>
        </div>
        <DragSortable :data="form.keyWordGroupSubs" @update:data="sort" :disabled="isDetail">
          <el-table-column label="关键词" align="center" prop="keyword"></el-table-column>
          <el-table-column align="center" prop="codeName" label="群活码">
            <template #default="{ row }">
              <div class="blod">{{ row.codeName || '—' }}</div>
              <el-image :src="row.groupCodeUrl" class="code-image"></el-image>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" v-if="!isDetail">
            <template #default="{ row, $index }">
              <el-button text @click="addOrUpdate(row)">编辑</el-button>
              <el-button text @click="remove(row.id, $index)">删除</el-button>
            </template>
          </el-table-column>
        </DragSortable>
      </div>
    </div>

    <div class="preview-wrap g-card mt0" style="flex: 1 1 414px">
      <div class="g-card-title">链接预览</div>
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
      v-model:form="formKeywords"
      append-to-body
      :rules="rules"
      :isDetail="isDetail">
      <template #="{ form: _form }">
        <el-form-item label="关键词" prop="keyword">
          <el-input clearable v-model="_form.keyword" placeholder="请输入" maxlength="15" show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="群活码名称" prop="codeName">
          <el-input clearable v-model="_form.codeName" placeholder="请输入" maxlength="15" show-word-limit></el-input>
        </el-form-item>
      </template>
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
import {
  getId,
  getDetail,
  getDetailList,
  addOrUpdate,
  addOrUpdateCancel,
  addOrUpdateKeyword,
  removeSub,
  batchUpdateKeyWordGroupSub,
} from './api'

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
      form: { keyWordGroupSubs: [] },
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
    this.form.id ??= this.$route.query.id
    this.getDetail()
  },
  methods: {
    /** 获取详情 */
    getDetail() {
      let id = this.$route.query.id
      this.$store.loading = true
      Promise.resolve()
        .then(() => {
          if (!id) {
            return getId().then(({ data }) => {
              this.form.id = data
            })
          }
          return getDetail(id).then(({ data }) => {
            this.form = data
            return this.getDetailList()
          })
        })
        .finally(() => (this.$store.loading = false))
    },
    getDetailList() {
      this.$store.loading = true
      return getDetailList({ pageNum: 1, pageSize: 1000, keywordGroupId: this.form.id })
        .then(({ rows }) => {
          // 回显适配关键词客群数据结构
          ;(rows ??= []).forEach((element) => {
            let chatIdList = element.chatIdList?.split(',')
            element.groups = element.groupCodeName?.split(',')?.map((e, i) => ({
              chatId: chatIdList[i],
              groupName: e,
            }))
          })
          this.form.keyWordGroupSubs = rows
        })
        .finally(() => (this.$store.loading = false))
    },
    addOrUpdate(row = {}) {
      this.formKeywords = Object.assign({}, row)
      this.dialogVisible = true
    },
    sort(data) {
      this.$store.loading = true
      this.form.keyWordGroupSubs = data
      batchUpdateKeyWordGroupSub(this.form)
        .then(() => {
          this.msgSuccess()
          return this.getDetailList()
        })
        .finally(() => {
          this.$store.loading = false
        })
    },
    // 新增或更新关键词群集合中的关键词群
    submitFormKeywords() {
      this.$refs.FormAutoCreateGroup.validate().then(() => {
        this.loading = true
        let form = JSON.parse(JSON.stringify(this.formKeywords))
        form.chatIdList = form.groups?.map((e) => e.chatId)?.join(',')
        delete form.groups
        form.keywordGroupId ??= this.form.id
        addOrUpdateKeyword(form)
          .then(({ data }) => {
            if (form.id) {
              this.form.keyWordGroupSubs.some((e, i, arr) => {
                return e.id === form.id && (arr[i] = data)
              })
            } else {
              this.form.keyWordGroupSubs.push(data)
            }
            this.dialogVisible = false
          })
          .finally(() => {
            this.loading = false
          })
      })
    },

    remove(id, index) {
      this.$confirm().then(() => {
        this.$store.loading = true
        removeSub(id)
          .then(() => {
            this.msgSuccess()
            return this.getDetailList()
          })
          .finally(() => {
            this.$store.loading = false
          })
        // this.form.keyWordGroupSubs.splice(index, 1)
      })
    },
    cancel() {
      addOrUpdateCancel(this.form)
      this.$router.back()
    },
    // 新增或更新关键词群
    submit() {
      this.$refs.form.validate().then(() => {
        this.$store.loading = true
        let form = JSON.parse(JSON.stringify(this.form))
        form.keyWordGroupSubs?.forEach((element, index) => {
          element.chatIdList = element.groups?.map((e) => e.chatId)?.join(',')
          delete element.groups
          element.sort = index
        })
        addOrUpdate(this.form)
          .then(() => {
            this.msgSuccess('更新成功')
            this.$router.back()
          })
          .finally(() => {
            this.$store.loading = false
          })
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.code-image {
  width: 80px;
}
</style>
