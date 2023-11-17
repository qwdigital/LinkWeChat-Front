<template>
  <div>
    <!-- 新建文章 -->
    <el-form ref="form" :model="form" :rules="rules" label-width="80px">
      <el-row type="flex" justify="space-between">
        <el-col :span="18" class="g-card" style="margin-right: 16px; margin-top: 10px">
          <el-form-item label-width="0px">
            <!-- 富文本content -->
            <QuillEditor v-model="form.content" ref="myQuillEditor"></QuillEditor>
            <!-- <DefineQuillEditor :value="form.content" @change="getContent" ref="myQuillEditor"></DefineQuillEditor> -->
          </el-form-item>
        </el-col>
        <el-col :span="6" class="g-card">
          <el-form-item label="选择分组" prop="categoryId">
            <el-cascader v-model="form.categoryId" :options="treeData[0].children" :props="groupProps"></el-cascader>
          </el-form-item>
          <el-form-item label="文章标题" prop="materialName">
            <el-input
              v-model="form.materialName"
              placeholder="请输入文章标题"
              :maxlength="30"
              show-word-limit></el-input>
          </el-form-item>

          <el-form-item label="文章描述">
            <el-input
              v-model="form.digest"
              type="textarea"
              placeholder="请输入文章描述"
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
          <el-form-item label="文章封面">
            <upload v-model:fileUrl="form.coverUrl" v-model:imgSize="form.memorySize" type="0">
              <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
            </upload>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <div class="dialog-footer fr mt20">
      <el-button @click="goList">取 消</el-button>
      <el-button @click="preview">预览</el-button>
      <el-button type="primary" v-loading="submitLoading" @click="submit">确 定</el-button>
    </div>
    <el-dialog title="文章预览" v-model="dialogVisible" width="50%">
      <div style="display: flex; justify-content: space-around">
        <PreviewInPhone :list="mobForm" />
        <PreviewInPhone :name="form.materialName" :article="form.content" />
      </div>
    </el-dialog>
  </div>
</template>

<script>
import QuillEditor from '@/components/common/QuillEditor.vue'
import { getTree, add, update, getList } from '@/api/material'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
// import * as Quill from 'quill'
export default {
  components: { QuillEditor, PreviewInPhone },
  data() {
    return {
      form: {}, // 素材表单
      mobForm: [],
      dialogVisible: false,
      // 表单校验
      rules: Object.freeze({
        categoryId: [{ required: true, message: '不能为空', trigger: 'change' }],
        materialName: [{ required: true, message: '不能为空', trigger: 'change' }],
      }),
      submitLoading: false,
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

      dialogVisibleSelectTag: false,
      selectedTagList: [],
    }
  },
  created() {
    this.getTree()
    if (this.$route.query.id) {
      this.getDeatil()
    }
    if (this.$route.query.categoryId) {
      this.form.categoryId = this.$route.query.categoryId
    }
  },
  mounted() {
    // var fontSizeStyle = Quill.import('attributors/style/size')
    // fontSizeStyle.whitelist = ['10px', '14px', '18px', '32px']
    // Quill.register(fontSizeStyle, true)
    // 修改居中方法
    // var Align = Quill.import('attributors/style/align')
    // Align.whitelist = ['right', 'center', 'justify']
    // Quill.register(Align, true)
  },
  methods: {
    preview() {
      this.dialogVisible = true
      this.mobForm = []
      this.form.mediaType = '12'
      this.mobForm.push(this.form)
    },
    // 获取类目树
    getTree() {
      getTree(12).then(({ data }) => {
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
    // 素材提交
    submit() {
      this.submitLoading = true
      if (this.times) {
        clearTimeout(this.times)
      }
      this.$refs['form'].validate((valid) => {
        if (valid) {
          this.times = setTimeout(() => {
            let form = JSON.parse(JSON.stringify(this.form))
            form.tagIds = form.tags?.map((item, index) => item.tagId) + ''
            form.mediaType = 12
            if (form.coverUrl) {
              let img = new Image()
              img.src = form.coverUrl //图片链接
              form.width = img.width
              form.height = img.height
              form.pixelSize = img.width * img.height
            }

            ;(form.id ? update : add)(form)
              .then(() => {
                this.msgSuccess('操作成功')
                this.$refs['form'].resetFields()
                this.submitLoading = false
                this.$router.push('list')
              })
              .catch(() => {
                this.submitLoading = false
              })
          }, 300)
        } else {
          this.submitLoading = false
        }
      })
    },
    // 获取详情
    getDeatil() {
      this.loading = true
      let form = {}
      form.mediaType = this.$route.query.type
      form.materialId = this.$route.query.id

      getList(form)
        .then(({ rows, total }) => {
          this.form = rows[0]
          let tagNames = this.form.tagNames?.split(',')
          this.form.tags = this.form.tagIds?.split(',').map((e, i) => ({ tagId: e, name: tagNames?.[i] }))
          // 此处需要后端返回详情的值
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    goList() {
      this.$router.push('list')
    },
  },
}
</script>

<style lang="scss" scoped>
::v-deep .ql-editor {
  min-height: 400px;
  .ql-container {
    .ql-snow {
      .ql-tooltip {
        left: 0px !important;
      }
    }
  }
}
</style>
