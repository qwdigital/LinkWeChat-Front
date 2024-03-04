<template>
  <div>
    <!-- 新建素材弹框 -->
    <!-- 新建素材 -->
    <el-dialog
      v-if="dialogVisible"
      :title="(form.id ? '编辑' : '新建') + $dictMaterialType[type]?.name"
      v-model="dialogVisible"
      width="90%"
      append-to-body
      :close-on-click-modal="false"
      :before-close="mediaClose">
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
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item :label="$dictMaterialType[type]?.name + '标题'" prop="materialName" v-if="type === '4'">
          <el-input v-model="form.materialName" placeholder="请输入标题" maxlength="50" show-word-limit></el-input>
          <div class="tip">标题对客户不可见，仅用于查询场景</div>
        </el-form-item>
        <el-form-item label="文本内容" prop="content" v-if="type === '4'">
          <el-input
            v-model="form.content"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 50 }"
            placeholder="请输入内容"
            maxlength="1000"
            show-word-limit></el-input>
        </el-form-item>

        <!-- 图片 -->
        <template v-else-if="type === '0'">
          <el-form-item label="图片" prop="weMaterialImgAoList" v-if="!isedit">
            <Upload
              v-if="dialogVisible"
              v-model:fileList="form.weMaterialImgAoList"
              :maxSize="20"
              type="0"
              :multiple="true"
              :limit="picMaxlength">
              <template #tip>
                <div>支持jpg/jpeg/png格式，图片大小不超过20M，支持最多{{ picMaxlength }}张批量上传</div>
              </template>
            </Upload>
          </el-form-item>
          <el-form-item label="图片" prop="materialUrl" v-else>
            <Upload
              v-model:fileUrl="form.materialUrl"
              v-model:fileName="form.materialName"
              :maxSize="20"
              type="0"
              v-if="dialogVisible">
              <template #tip><div>支持jpg/jpeg/png格式，图片大小不超过20M</div></template>
            </Upload>
          </el-form-item>
        </template>

        <!-- 图文 -->
        <template v-else-if="type === '9'">
          <el-form-item label="图文地址" prop="materialUrl" :rules="rules.http">
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
            <Upload v-model:fileUrl="form.coverUrl" type="0" v-if="dialogVisible">
              <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
            </Upload>
          </el-form-item>
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
        <!-- 外链 -->
        <template v-else-if="type === '19'">
          <el-form-item label="外链地址" prop="materialUrl" :rules="rules.http">
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
            <Upload v-model:fileUrl="form.coverUrl" v-model:imgSize="form.memorySize" type="0" v-if="dialogVisible">
              <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
            </Upload>
          </el-form-item>
          <el-form-item label="外链预览">
            <iframe class="iframe" v-if="form.materialUrl" :src="form.materialUrl" :key="form.materialUrl"></iframe>
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
            <el-input v-model="form.materialUrl" placeholder="请输入小程序路径，必须以 .htmld 作为后缀"></el-input>
            <div class="sub-des">
              <a href="https://www.yuque.com/linkwechat/help/gy4ghv#a1bXG" target="_blank">如何添加小程序页面路径?</a>
            </div>
          </el-form-item>
          <el-form-item label="封面" prop="coverUrl">
            <Upload v-model:fileUrl="form.coverUrl" type="0" v-if="dialogVisible">
              <template #tip><div>支持jpg/jpeg/png格式，建议520*416</div></template>
            </Upload>
          </el-form-item>
        </template>

        <!-- <template v-else-if="type === '1'">
          <el-form-item label="语音" prop="materialUrl">
            <Voice v-if="form.materialUrl" :amrUrl="form.materialUrl"></Voice>
            <Upload
              v-model:fileUrl="form.materialUrl"
              v-model:fileName="form.materialName"
              :type="type"
              :format="audioType">
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
              :rows="3"
              :maxlength="128"
              show-word-limit></el-input>
          </el-form-item>
          <el-form-item label="上传视频" prop="materialUrl">
            <Upload
              v-model:fileUrl="form.materialUrl"
              v-model:fileName="form.materialName"
              :type="type"
              @getPicUrl="getPicUrl"
              v-if="dialogVisible">
              <template #tip><div>支持mp4/mov格式，视频大小不超过100M</div></template>
            </Upload>
          </el-form-item>
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
              :autosize="{ minRows: 2, maxRows: 10 }"></el-input>
          </el-form-item>
          <el-form-item label="上传文件" prop="materialUrl">
            <Upload
              v-model:fileUrl="form.materialUrl"
              v-model:fileName="form.materialName"
              :type="type"
              v-if="dialogVisible">
              <template #tip><div>支持pdf/ppt/word文件，单个文件大小不超过50M</div></template>
            </Upload>
          </el-form-item>
        </template>
        <!-- 文章 -->
        <template v-else-if="type === '12'">
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
          <!-- 富文本content -->
          <QuillEditor style="margin: 10px 10px 0" v-model="form.content" ref="myQuillEditor"></QuillEditor>
        </template>
        <!-- 海报 -->
        <template v-else-if="type === '5'">
          <PosterAdd v-if="dialogVisible" :moduleType="moduleType" @getPosterForm="getPosterForm" :posId="posterId" />
        </template>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" v-loading="submitLoading" @click="submit" v-if="type !== '5'">确 定</el-button>
          <el-button @click="cancel" v-if="type !== '5'">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import PosterAdd from '@/views/contentCenter/components/PosterAdd.vue'
import QuillEditor from '@/components/common/QuillEditor.vue'
import { add, update } from '@/api/material'
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
  name: 'message-content-form',
  components: {
    PosterAdd,
    QuillEditor,
  },
  data() {
    return {
      picMaxlength: 9,
      form: {
        weMaterialImgAoList: [],
      },
      editForm: {}, // 点击编辑时存储的详情
      editList: {}, // 点击编辑时存储的talkList
      posterId: undefined, // 海报id
      dialogVisible: false,
      isedit: false, // 是否为图片编辑
      materialIds: [], //素材id
      // 表单校验
      rules: Object.freeze({
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        materialUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        materialName: [{ required: true, message: '不能为空', trigger: 'blur' }],
        digest: [{ required: true, message: '不能为空', trigger: 'blur' }],
        coverUrl: [{ required: true, message: '不能为空', trigger: 'blur' }],
        weMaterialImgAoList: [{ required: true, message: '不能为空', trigger: 'blur' }],
        html: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHtml, trigger: 'blur' },
        ],
        http: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHttp, trigger: 'blur' },
        ],
      }),
      submitLoading: false,
    }
  },
  props: {
    materialForm: {
      type: Object,
      default: {},
    },
    // 弹框的显示与隐藏
    materialDialogVisible: {
      type: Boolean,
      default: false,
    },
    // 素材类型
    materialType: {
      type: String,
      default: null,
    },
    // 编辑时传入的数据
    editMaterialForm: {
      type: Object,
      default: {},
    },
    // 列表的内容
    materialTalkList: {
      type: Array,
      default: [],
    },
    // 模块类型
    moduleType: {
      type: Number,
      default: 1,
    },
    // 最多可以新建多少个
    maxlength: {
      type: Number,
      default: 9,
    },
  },
  watch: {
    materialTalkList: {
      handler(val) {
        this.talkList = JSON.parse(JSON.stringify(val))
      },
      immediate: true,
      deep: true,
    },
    materialForm: {
      handler(val) {
        if (val) {
          Object.assign(this.form, val)
        }
      },
      immediate: true,
      deep: true,
    },
    editMaterialForm: {
      handler(val) {
        if (val) {
          this.posterId = val.id
          this.type = val.mediaType
          this.dialogVisible = true
          this.form = val
          this.isedit = true
          this.editForm = JSON.parse(JSON.stringify(val))
          this.editList = JSON.parse(JSON.stringify(this.talkList))
        }
      },
    },
    materialType: {
      handler(val) {
        this.posterId = ''
        this.type = val
        this.isedit = false
        this.materialIds = []
        if (this.talkList && this.talkList.length)
          this.talkList.forEach((item) => {
            this.materialIds.push(item.id)
          })
      },
    },
    materialDialogVisible: {
      handler(val) {
        this.dialogVisible = val
        this.picMaxlength = this.maxlength - this.talkList.length
      },
    },
  },
  methods: {
    getPicUrl(val) {
      this.form.coverUrl = val
    },
    mediaClose() {
      this.dialogVisible = false
      this.$emit('dialogClose', false)
      this.form = {}
    },
    getPosterForm(val) {
      if (val) {
        if (this.posterId) {
          // 编辑
          let talkList = JSON.parse(JSON.stringify(this.talkList))
          talkList.forEach((item, index) => {
            if (item.id === this.posterId) {
              // item = val.data
              val.data.mediaType = '5'
              this.talkList.splice(index, 1, val.data)
            }
          })
        } else {
          // 新增
          // unshift
          this.talkList.push(val.data)
        }
        this.$emit('dialogClose', false, this.talkList)
      } else if (val === null) {
        // 点击取消
        this.$emit('dialogClose', false)
      }
      this.dialogVisible = false
    },
    // 新建素材
    submit() {
      this.submitLoading = true
      if (this.times) {
        clearTimeout(this.times)
      }
      if (!this.form.id && this.form.weMaterialImgAoList) {
        // 新增图片
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
            form.moduleType = this.moduleType
            let talkList = form
            let talkList2 = JSON.parse(JSON.stringify(this.talkList))
            //
            if (talkList.mediaType === '0' && talkList.moduleType != 1 && !form.id) {
              // 当类型为新建的图片时
              talkList.weMaterialImgAoList.forEach((item, index) => {
                let picobj = JSON.parse(JSON.stringify(talkList))
                picobj.materialName = item.materialName
                picobj.materialUrl = item.materialUrl
                talkList2.push(picobj)
              })

              if (talkList2.length > this.maxlength) {
                this.$message.error('创建的个数不能超过' + this.maxlength + '个')
                this.submitLoading = false
                return
              } else {
                ;(form.id ? update : add)(form)
                  .then((res) => {
                    this.msgSuccess('操作成功')
                    this.talkList = talkList2
                    this.dialogVisible = false
                    this.materialIds = this.materialIds.concat(res.data)
                    // let ids = JSON.parse(JSON.stringify(res.data))
                    this.talkList.forEach((item, i) => {
                      item.id = this.materialIds[i]
                    })
                    this.dialogVisible = false
                    this.$emit('dialogClose', false, this.talkList)
                    this.picReset()
                    this.$refs['form'].resetFields()
                    this.submitLoading = false
                  })
                  .catch(() => {
                    this.dialogVisible = false
                    this.$emit('dialogClose', false)
                    this.submitLoading = false
                  })
              }
            } else {
              ;(form.id ? update : add)(form)
                .then((res) => {
                  this.msgSuccess('操作成功')
                  this.dialogVisible = false
                  let ids = JSON.parse(JSON.stringify(res.data))
                  if (typeof ids !== 'string') {
                    ids.forEach((item) => {
                      talkList.id = item
                      this.talkList.push(talkList)
                    })
                  }
                  if (form.id) {
                    // 如果是编辑的话
                    this.talkList.forEach((item, index) => {
                      if (item.id === form.id) {
                        this.talkList.splice(index, 1, form)
                      }
                    })
                  }
                  this.$emit('dialogClose', false, this.talkList)
                  this.dialogVisible = false
                  this.$refs['form'].resetFields()
                  this.picReset()
                  this.submitLoading = false
                })
                .catch(() => {
                  this.dialogVisible = false
                  this.$emit('dialogClose', false)
                  this.submitLoading = false
                })
            }
            //
          }, 300)
        } else {
          this.submitLoading = false
        }
      })
    },
    // 图片清空
    picReset() {
      this.form = {} // 素材表单
      this.mobForm = [{}]
      this.editList = []
      this.editForm = {}
    },
    cancel() {
      // 点击编辑的时候取消
      if (this.editForm.id) {
        this.talkList = this.editList
      }
      this.$emit('dialogClose', false)
      this.dialogVisible = false
      this.picReset()
    },
  },
}
</script>

<style lang="scss" scoped>
.tip {
  color: var(--font-black-6);
  font-size: 12px;
}
::v-deep .ql-editor {
  min-height: 380px;
  .ql-container {
    .ql-snow {
      .ql-tooltip {
        left: 0px !important;
      }
    }
  }
}
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
