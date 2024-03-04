<!-- 由透传属性，可直接使用 el-dialog 的所有props，
用法示例：<AddOrEditMaterialDialog v-model="dialogVisible" title="title"/> -->
<script>
import { getTree, add, update } from '@/api/material'

const validateHtml = (rule, value, callback) => {
  if (/\.html$/gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 .html 作为后缀'))
  }
}
const validateHttp = (rule, value, callback) => {
  if (/^https?:\/\//gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 http://或 https://开头'))
  }
}

export default {
  components: {
    PreviewInPhone: defineAsyncComponent(() => import('@/components/ContentCenter/PreviewInPhone')),
  },
  props: {
    modelValue: {
      type: Boolean,
      default: false,
    },
    // 0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)， 4 文本， 5 海报， 6 活码， 7 人群， 8 旅程，9 图文，10 链接，11 小程序
    type: {
      type: String,
      default: '0',
    },
    data: {
      type: Object,
      default: () => ({}),
    },
    // 是否为详情展示（不显示选择按钮）
    isDetail: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      form: {},
      treeData: [{}], // 树
      // 表单校验
      rules: Object.freeze({
        materialName: [{ required: true, message: '不能为空', trigger: 'change' }],
        categoryId: [{ required: true, message: '不能为空', trigger: 'change' }],
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        materialUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        weMaterialImgAoList: [{ type: 'array', required: true, message: '不能为空', trigger: 'change' }],
        digest: [{ required: true, message: '不能为空', trigger: 'blur' }],
        coverUrl: [{ required: true, message: '不能为空', trigger: 'blur' }],
        materialUrl: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: this.type == 11 ? validateHtml : validateHttp, trigger: 'blur' },
        ],
      }),
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
      loading: false,
      mobForm: [{}],
    }
  },
  computed: {},
  watch: {
    modelValue: {
      deep: true,
      immediate: true,
      handler(val) {
        val && this.getTree()
      },
    },
    data: {
      deep: true,
      immediate: true,
      handler(val) {
        this.mobForm = []
        let data = JSON.parse(JSON.stringify(val))
        this.form = data
        if (this.type != '0') {
          data.mediaType = this.type
          this.mobForm.push(data)
        } else {
          data.weMaterialImgAoList?.forEach((item) => {
            this.mobForm.push({ mediaType: '0', materialUrl: item.url })
          })
        }
      },
    },
  },
  created() {},
  mounted() {
    this.mobForm[0] && (this.mobForm[0].mediaType = this.type)
  },
  methods: {
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
    getPicUrl(val, data) {
      this.form['coverUrl'] = val
      this.form['width'] = data.width
      this.form['height'] = data.height
      this.form['memorySize'] = data.memorySize
      this.form['pixelSize'] = data.pixelSize
    },
    dealSize(form) {
      switch (form.mediaType) {
        case '0':
          // 图片 // 获取宽高和图片大小
          let list = form.weMaterialImgAoList
          if (list) {
            list.forEach((item, i) => {
              var img = new Image()
              img.src = item.url //图片链接
              form.weMaterialImgAoList[i].width = img.width
              form.weMaterialImgAoList[i].height = img.height
              form.weMaterialImgAoList[i].pixelSize = img.width * img.height
            })
          }
          return form
          break
        case '9':
        case '11':
          // 图文、小程序
          if (form.coverUrl) {
            let img = new Image()
            img.src = form.coverUrl //图片链接
            form.width = img.width
            form.height = img.height
            form.pixelSize = img.width * img.height
          }
          return form
          break
        default:
          break
      }
    },
    // 素材提交
    submit() {
      // this.$refs['form'].validateField
      if (!this.form.id && this.form.weMaterialImgAoList) {
        // 新增
        this.form.weMaterialImgAoList.forEach((item, index) => {
          item.materialUrl = item.url
          item.materialName = item.name
        })
      }
      this.form.tagIds = this.form.tags?.map((item, index) => item.tagId) + ''
      this.loading = true
      this.$refs['form'].validate((valid) => {
        if (valid) {
          // this.getVideoBase64(this.form.materialUrl)
          let form = JSON.parse(JSON.stringify(this.form))
          form.mediaType = this.type
          this.dealSize(form)
          ;(form.id ? update : add)(form)
            .then(() => {
              this.msgSuccess('操作成功')
              this.$emit('update:model-value', false)
              this.$emit('success')
              // this.picReset()
              this.$refs['form'].resetFields()
              this.loading = false
            })
            .catch(() => {
              this.loading = false
            })
        } else {
          this.loading = false
        }
      })
    },
  },
}
</script>

<template>
  <!-- 添加或修改素材对话框 -->
  <el-dialog
    width="1000px"
    :modelValue="modelValue"
    @update:modelValue="(val) => $emit('update:modelValue', val)"
    destroy-on-close
    append-to-body
    :close-on-click-modal="false">
    <el-alert type="warning" show-icon v-if="type === '11'">
      <template #title>
        <div style="display: flex">
          <div style="color: var(--font-black)">
            小程序必须已经绑定关联到企业微信，否则将无法在欢迎语、群发、话术中正常发送。
          </div>
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

          <el-form-item label="客户标签" v-if="[2, 3, 8, 13, 19].includes(+type)">
            <TagEllipsis :list="form.tags" limit="4"></TagEllipsis>
            <div>
              <el-button type="primary" @click="dialogVisibleSelectTag = true">选择标签</el-button>
              <!-- 选择标签弹窗 -->
              <SelectTag
                v-model:visible="dialogVisibleSelectTag"
                :selected="form.tags"
                @success="
                  (data) => {
                    form.tags = data.map((d) => ({
                      tagId: d.tagId,
                      name: d.name,
                    }))
                  }
                "></SelectTag>
            </div>
            <div class="sub-des">素材打开后，该客户将会自动设置以上选择标签</div>
          </el-form-item>

          <!-- 文本 -->
          <template v-if="type === '4'">
            <el-form-item label="文本标题" prop="materialName">
              <el-input v-model="form.materialName" placeholder="请输入标题" maxlength="50" show-word-limit></el-input>
              <div class="g-tip">标题对客户不可见，仅用于查询场景</div>
            </el-form-item>
            <el-form-item label="文本内容" prop="content">
              <TextareaExtend
                v-model="form.content"
                :autosize="{ minRows: 2, maxRows: 50 }"
                placeholder="请输入内容"
                maxlength="1000"
                show-word-limit></TextareaExtend>
            </el-form-item>
          </template>

          <!-- 图片 -->
          <template v-else-if="type === '0'">
            <!-- 仅新增时显示 -->
            <el-form-item label="图片" prop="weMaterialImgAoList" v-if="!form.id">
              <Upload v-model:fileList="form.weMaterialImgAoList" :maxSize="20" type="0" :multiple="true" :limit="10">
                <template #tip><div>支持jpg/jpeg/png格式，图片大小不超过20M，支持最多10张批量上传</div></template>
              </Upload>
            </el-form-item>
            <!-- 仅编辑时显示 -->
            <el-form-item label="图片标题" prop="materialName" v-else>
              <el-input
                v-model="form.materialName"
                placeholder="请输入"
                :maxlength="50"
                show-word-limit
                :disabled="true"></el-input>
              <div class="g-tip">标题对客户不可见，仅用于查询场景</div>
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
              <Upload v-model:fileUrl="form.coverUrl" v-model:imgSize="form.memorySize" type="0">
                <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
              </Upload>
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
            <el-form-item label="链接" prop="materialUrl">
              <el-input v-model="form.materialUrl" placeholder="请输入链接"></el-input>
              <div class="sub-des">必须以 http://或 https://开头</div>
            </el-form-item>
          </template>

          <!-- 外链 -->
          <template v-else-if="type === '19'">
            <el-form-item label="外链地址" prop="materialUrl">
              <el-input
                v-model="form.materialUrl"
                type="text"
                placeholder="请输入外链地址，以http://或https://开头"></el-input>
              <div class="sub-des">若下方 外链预览 项未正常显示出页面，则该链可能开启了防盗功能，请勿使用</div>
            </el-form-item>

            <el-form-item label="外链标题" prop="materialName">
              <el-input
                v-model="form.materialName"
                type="text"
                :maxlength="32"
                show-word-limit
                placeholder="请输入外链标题"></el-input>
            </el-form-item>
            <el-form-item label="外链描述">
              <el-input
                v-model="form.content"
                type="textarea"
                :maxlength="128"
                show-word-limit
                :autosize="{ minRows: 3, maxRows: 50 }"
                placeholder="请输入外链描述"></el-input>
            </el-form-item>
            <el-form-item label="外链封面">
              <Upload v-model:fileUrl="form.coverUrl" v-model:imgSize="form.memorySize" type="0">
                <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
              </Upload>
            </el-form-item>
            <el-form-item label="外链预览">
              <iframe class="iframe" v-if="form.materialUrl" :src="form.materialUrl" :key="form.materialUrl"></iframe>
            </el-form-item>
          </template>

          <!-- 小程序 -->
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
            <el-form-item label="页面路径" prop="materialUrl">
              <el-input v-model="form.materialUrl" placeholder="请输入小程序路径，必须以 .html 作为后缀"></el-input>
              <div class="sub-des">
                <a href="https://www.yuque.com/linkwechat/help/gy4ghv#a1bXG" target="_blank">如何添加小程序页面路径?</a>
              </div>
            </el-form-item>
            <el-form-item label="封面" prop="coverUrl">
              <Upload v-model:fileUrl="form.coverUrl" v-model:imgSize="form.memorySize" type="0">
                <template #tip><div>支持jpg/jpeg/png格式，建议520*416</div></template>
              </Upload>
            </el-form-item>
          </template>

          <!-- 语音 -->
          <!-- <template v-else-if="type === '1'">
            <el-form-item label="语音" prop="materialUrl">
              <Voice v-if="form.materialUrl" :amrUrl="form.materialUrl"></Voice>
              <Upload v-model:fileUrl="form.materialUrl" :type="type" :format="['amr']">
                <template #tip><div>只能上传amr格式的语音文件。单个文件大小不超过2M，时长不超过1分钟</div></template>
              </Upload>
            </el-form-item>
            <el-form-item label="名称" prop="materialName">
              <el-input v-model="form.materialName" placeholder="请输入"></el-input>
            </el-form-item>
          </template> -->
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
              <Upload v-model:fileUrl="form.materialUrl" :format="['mp4', 'mov']" @getPicUrl="getPicUrl" :type="type">
                <template #tip><div>支持mp4/mov格式，视频大小不超过100M</div></template>
              </Upload>
            </el-form-item>
            <!-- <el-form-item label="封面">
                <upload  v-model:fileUrl="form.coverUrl" type="0">
                  <template #tip><div>建议尺寸：1068*455</div></template>
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
              <Upload
                v-model:fileUrl="form.materialUrl"
                :type="type"
                :format="['doc', 'docx', 'pdf', 'ppt', 'pptx', 'pps', 'pptsx']">
                <template #tip><div>支持pdf/ppt/word文件，单个文件大小不超过50M</div></template>
              </Upload>
            </el-form-item>
          </template>
        </el-form>
      </el-col>
      <el-col class="ml10" :span="10" v-if="!(type === '0' && form.id)">
        <PreviewInPhone :list="mobForm" />
      </el-col>
    </el-row>

    <template #footer>
      <div class="dialog-footer">
        <el-button type="primary" v-loading="loading" :disabled="loading" @click="submit">确 定</el-button>
        <el-button @click="$emit('update:model-value', false)">取 消</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<style lang="scss" scoped>
.sub-des {
  color: var(--color);
  font-size: 12px;
  line-height: 1.5;
  margin-top: 5px;
}
.iframe {
  width: 100%;
  height: 255px;
  border: 1px solid var(--border-black-9);
  border-radius: var(--border-radius-small);
}
</style>
