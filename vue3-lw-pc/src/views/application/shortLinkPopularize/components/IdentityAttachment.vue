<template>
  <div>
    <el-form-item :label="lableOne" style="margin-right: 200px !important" :error="templateInfo">
      <div v-if="showModle && !isDetail" style="margin-bottom: 10px">
        <el-button type="primary" @click="welcomVisible = true">从模板库中选择</el-button>
      </div>
      <TextareaExtend
        :disabled="isDetail"
        v-model="talkForm.templateInfo"
        :toolbar="isDetail ? [] : ['emoji']"
        maxlength="2000"
        show-word-limit
        placeholder="请输入"
        :autosize="{ minRows: 5, maxRows: 20 }"
        clearable
        :autofocus="false"
        @input="changeInfo" />
    </el-form-item>
    <el-form-item>
      <template #label>
        <div class="title" v-if="otherType !== 3">
          {{ titleTwo }}
          <el-popover trigger="hover" :content="'最多添加' + maxlength + '个素材'" placement="top-start">
            <template #reference>
              <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
            </template>
          </el-popover>
        </div>
      </template>
      <div>
        <div>
          <div style="text-align: left" class="flex">
            <el-popover
              v-if="!isDetail"
              trigger="hover"
              :content="'最多添加' + maxlength + '个' + fontType + '，如需修改请删除已有' + fontType + '后重新尝试'"
              placement="top-start"
              :disabled="talkList.length < maxlength">
              <template #reference>
                <el-dropdown
                  @command="moveGroup"
                  :disabled="talkList.length > maxlength || talkList.length === maxlength">
                  <el-button type="primary">+ {{ '新建' + fontType }}</el-button>
                  <template #dropdown>
                    <el-dropdown-menu trigger="click">
                      <!-- <el-dropdown-item :command="'4'" v-if="!this.templateType && this.moduleType !== 4">
                  <el-button text>文本</el-button>
                </el-dropdown-item> -->
                      <el-dropdown-item :command="'0'">
                        <el-button text>图片</el-button>
                      </el-dropdown-item>
                      <el-dropdown-item :command="'9'">
                        <el-button text>图文</el-button>
                      </el-dropdown-item>
                      <el-dropdown-item :command="'11'" v-if="this.otherType != 3">
                        <el-button text>小程序</el-button>
                      </el-dropdown-item>
                      <el-dropdown-item :command="'12'">
                        <el-button text>文章</el-button>
                      </el-dropdown-item>
                      <el-dropdown-item :command="'2'" v-if="this.otherType != 3">
                        <el-button text>视频</el-button>
                      </el-dropdown-item>
                      <el-dropdown-item :command="'3'">
                        <el-button text>文件</el-button>
                      </el-dropdown-item>
                      <el-dropdown-item :command="'5'">
                        <el-button text>海报</el-button>
                      </el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </template>
            </el-popover>
            <el-popover
              v-if="!isDetail"
              trigger="hover"
              :content="'最多添加' + maxlength + '个' + fontType + '，如需修改请删除已有' + fontType + '后重新尝试'"
              placement="top-start"
              :disabled="talkList.length < maxlength">
              <template #reference>
                <div class="ml20">
                  <el-button
                    @click="choseCenter"
                    :disabled="talkList.length > maxlength || talkList.length === maxlength">
                    从素材中心选择
                  </el-button>
                </div>
              </template>
            </el-popover>
          </div>
        </div>
      </div>
    </el-form-item>
    <el-form-item>
      <div v-show="talkList.length">
        <DragTable
          :isDetail="isDetail"
          :tableData2="talkList"
          @setData="setData"
          @getEdit="getEdit"
          :dargAble="[2].includes(moduleType)" />
      </div>
    </el-form-item>

    <!-- <el-col :span="8" class="g-card" style="margin-top: 20px; padding: 20px;" v-if="showPhone">
        <PreviewInPhone :list="talkList" :templateInfo="talkForm.templateInfo" :liveUrl="liveUrl" />
      </el-col> -->
    <!-- 新建素材 -->
    <MessageContentForm
      :materialDialogVisible="dialogVisible"
      :materialForm="form"
      :materialType="type"
      :editMaterialForm="editMaterialForm"
      @dialogClose="dialogClose"
      :materialTalkList="talkList"
      :moduleType="moduleType"
      :maxlength="maxlength" />
    <!-- 模板库 -->
    <el-dialog
      :title="otherType === 2 ? '选择群发模板' : '选择欢迎语模板'"
      v-model:visible="welcomVisible"
      width="60%"
      append-to-body
      :close-on-click-modal="false"
      v-if="welcomVisible">
      <TemplateLibrary @changeObj="changeObj" :isGroup="otherType === 2" />
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="selectModle" :loading="libraryLoading">确 定</el-button>
          <el-button @click="welcomVisible = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
    <MaterialCenter
      v-model:choseDialog="choseDialog"
      :talkListLength="talkList.length"
      @itemArry="getItemArry"
      :templateType="templateType"
      :tplType="tplType"
      :moduleType="moduleType"
      :maxlength="maxlength"
      :noApplets="otherType === 3" />
    <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      @success="selectedUser"></SelectUser>
  </div>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getTree } from '@/api/material'
import { lexicalAdd, lexicalDetail } from '@/api/contentCenter/scriptCenter'
import { templateAdd, templateDetail } from '@/api/contentCenter/modleCenter'
import DragTable from './DragTable'
import MaterialCenter from '@/components/ContentCenter/MaterialCenter'
import { string } from 'clipboard'
import { getPosterInfo } from '@/api/material/poster'
import TemplateLibrary from '@/components/ContentCenter/TemplateLibrary'
import MessageContentForm from '@/components/MessageContentForm'
export default {
  name: 'add-material',
  components: {
    PreviewInPhone,
    DragTable,
    MaterialCenter,
    getPosterInfo,
    TemplateLibrary,
    MessageContentForm,
  },
  data() {
    return {
      titleOne: '欢迎语',
      lableOne: '推广语',
      titleTwo: '推广语附件',
      templateInfo: '',
      userInfo: '',
      editMaterialForm: {},
      choseDialog: false,
      ids: [],
      // materialIds: [], //素材id
      // 分组props
      groupProps: {
        expandTrigger: 'hover',
        checkStrictly: true,
        children: 'children',
        label: 'name',
        value: 'id',
        emitPath: false,
      },
      mobForm: {
        welcomeMsg: '',
        materialMsgList: [],
        userIds: '',
        userNames: '',
      },
      form: {
        weMaterialImgAoList: [],
      },
      talkForm: {}, // 话术表单
      treeData: [{}], // 树
      talkRules: Object.freeze({
        categoryId: [{ required: true, message: '不能为空', trigger: 'change' }],
        talkTitle: [{ required: true, message: '不能为空', trigger: 'blur' }],
      }),
      type: undefined,
      dialogVisible: false, // 新建素材表格对话框显隐
      talkLoading: false,
      talkList: [],
      users: [],
      selectedUserList: [],
      dialogVisibleSelectUser: false,
      isedit: false, // 是否为图片编辑
      welcomVisible: false,
      fontType: '',
      maxlength: 8,
      libraryLoading: false,
    }
  },
  props: {
    baseData: {
      type: Object,
      default: () => {
        return {
          templateInfo: '',
          attachments: [],
        }
      },
    },

    // 查询会话详情的id
    talkId: {
      type: string,
      default: null,
    },
    // 查询模板中心详情的id
    modelId: {
      type: string,
      default: null,
    },
    // 话术类形 0企业话术1客服话术
    talkType: {
      type: string,
      default: null,
    },
    // 1欢迎语 2群发 3sop
    templateType: {
      type: Number,
      default: 1,
    },
    // 1:活码欢迎语;2:员工欢迎语;3:入群欢迎语
    tplType: {
      type: String,
      default: null,
    },
    // 模块类型 1:素材;2:话术;3:模板;4:其他模块
    moduleType: {
      type: Number,
      default: 4,
    },
    // 是否为欢迎语模板
    iswelcom: {
      type: Boolean,
      default: false,
    },
    // 是否显示模板库
    showModle: {
      type: Boolean,
      default: false,
    },
    // 1.员工活码;2:企微营销;3:企业动态;4:门店活码
    otherType: {
      type: Number,
      default: null,
    },
    // 是否显示手机
    showPhone: {
      type: Boolean,
      default: true,
    },
    // 直播链接
    liveUrl: {
      type: String,
      default: null,
    },
    // 是否显示提交取消按钮
    showFooter: {
      type: Boolean,
      default: true,
    },
    isDetail: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    baseData(val) {
      if (val.templateInfo) {
        this.form.templateInfo = val.templateInfo
        this.form.attachments = val.attachments
        // if (this.form.templateInfo) {
        // this.form.templateInfo = this.baseData.templateInfo
        this.talkForm = this.form
        this.talkList = this.form.attachments
        // }
        // this.$forceUpdate()
      }
    },
    talkId: {
      handler(val) {
        if (val) {
          this.getDeatil(val)
        }
      },
      immediate: true,
    },
    modelId: {
      handler(val) {
        if (val) {
          this.getTelDeatil(val)
        }
      },
      immediate: true,
    },
  },
  methods: {
    changeInfo(val) {
      this.$emit('changeInfo', val)
    },
    dialogClose(val, list) {
      this.dialogVisible = val
      if (list) {
        this.talkList = [...list]
        this.$emit('phoneData', this.talkList)
        this.$emit('success', this.setResult())
      }
    },
    setResult() {
      let arr = []
      this.talkList.forEach((item) => {
        let attachments = {}
        attachments.title = item.materialName
        attachments.realType = +item.mediaType
        attachments.materialId = item.id //素材
        switch (item.mediaType) {
          case '0':
            // 图片
            attachments.picUrl = item.materialUrl
            attachments.msgType = 'image'
            break
          case '2':
            // 视频
            attachments.picUrl = item.coverUrl
            attachments.fileUrl = item.materialUrl
            attachments.description = item.digest
            attachments.msgType = 'video'
            break
          case '3':
            // 文件
            attachments.picUrl = this.filPicType(item.materialUrl)
            attachments.fileUrl = item.materialUrl
            attachments.description = item.digest
            attachments.msgType = 'file'
            break
          case '4':
            // 文本
            attachments.content = item.content
            attachments.msgType = 'text'
            break
          case '5':
            // 海报
            attachments.fileUrl = item.materialUrl
            attachments.msgType = 'posters'
            break
          case '9':
            // 图文
            attachments.content = item.content
            attachments.picUrl = item.coverUrl
            attachments.linkUrl = item.materialUrl
            attachments.msgType = 'link'
            if (this.otherType === 3) {
              attachments.materialName = item.materialName
            }
            break
          case '11':
            // 小程序
            attachments.picUrl = item.coverUrl
            attachments.fileUrl = item.materialUrl
            attachments.appId = item.digest
            attachments.msgType = 'miniprogram'
            break
          case '12':
            // 文章
            attachments.fileUrl = item.materialUrl
            attachments.description = item.digest
            attachments.content = item.content
            attachments.picUrl = item.coverUrl
            attachments.msgType = 'news'
            break
        }
        arr.push(attachments)
      })
      return arr
    },
    filPicType(file) {
      let filecontent = JSON.parse(JSON.stringify(file))
      filecontent = filecontent.split('.')
      let type = filecontent[filecontent.length - 1]
      if (type === 'pdf') {
        return window.lwConfig.DEFAULT_H5_PDF
      } else if (['doc', 'docx'].includes(type)) {
        return window.lwConfig.DEFAULT_H5_WORDE
      } else if (['ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
        return window.lwConfig.DEFAULT_H5_PPT
      } else {
        return ''
      }
    },
    // 模板库点击确定
    selectModle() {
      this.libraryLoading = true
      if (this.selectObj) {
        this.talkForm = this.selectObj
        this.welcomVisible = false
        this.talkList = [...this.selectObj.weMaterialList]
        this.$emit('phoneData', [...this.selectObj.weMaterialList])
        this.$emit('changeInfo', this.selectObj.templateInfo)
        this.$emit('success', this.setResult())
      } else {
        this.$message.error('请选择模板')
      }
      this.libraryLoading = false
    },
    changeObj(id) {
      if (id) {
        templateDetail(id).then((res) => {
          this.selectObj = res.data
        })
      }
    },
    setUserData() {
      this.selectedUserList = []
      let arr = []
      if (this.talkForm.userIds) {
        arr = this.talkForm.userIds.split(',').map((dd, index) => {
          return {
            userId: dd,
            name: this.talkForm.userNames.split(',')[index],
          }
        })
      }
      this.users = arr
    },
    onSelectUser() {
      this.selectedUserList = []
      let arr = []
      if (this.talkForm.userIds) {
        arr = this.talkForm.userIds.split(',').map((dd, index) => {
          return {
            userId: dd,
            name: this.talkForm.userNames.split(',')[index],
          }
        })
      }
      this.selectedUserList = arr
      this.dialogVisibleSelectUser = true
    },
    selectedUser(users) {
      let ids = []
      let names = []
      const selectedUserList = users.map((d) => {
        ids.push(d.userId)
        names.push(d.name)
        return {
          userId: d.userId,
          name: d.name,
        }
      })
      this.users = selectedUserList
      this.talkForm.userIds = ids.join(',')
      this.talkForm.userNames = names.join(',')
    },
    // 获取详情
    getDeatil(id) {
      lexicalDetail(id)
        .then((res) => {
          this.talkForm = res.data
          this.talkList = res.data.weMaterialList
        })
        .catch(() => {})
    },
    // 获取模板中心详情
    getTelDeatil(id) {
      templateDetail(id)
        .then((res) => {
          this.talkForm = res.data
          this.talkList = res.data.weMaterialList
          this.setUserData()
        })
        .catch(() => {})
    },
    getEdit(val) {
      this.type = val.mediaType
      this.editMaterialForm = JSON.parse(JSON.stringify(val))
    },
    setData(val) {
      this.talkList = val
      this.$emit('phoneData', this.talkList)
      this.$emit('success', this.setResult())
    },
    getItemArry(val) {
      this.talkList = this.talkList.concat(val)
      // 当手机为非内嵌时
      this.$emit('phoneData', this.talkList)
      this.$emit('success', this.setResult())
    },
    centerSubmit() {},
    selectCenter() {},
    choseCenter() {
      this.choseDialog = true
    },
    getIds(value) {
      this.ids = value
    },
    moveGroup(type) {
      this.type = ''
      this.type = type
      if (this.otherType === 3 && type == '2') {
        this.choseDialog = true
      } else {
        this.dialogVisible = true
      }
    },
    // 获取类目树
    getTree() {
      var mediaType = null
      if (this.talkType == 0) {
        mediaType = 13
      } else if (this.talkType == 1) {
        mediaType = 14
      }
      if (this.templateType == 2) {
        mediaType = 17
      } else if (this.templateType == 3) {
        mediaType = 16
      }
      getTree(mediaType).then(({ data }) => {
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
    // 新建话术
    tackSubmit() {
      this.talkLoading = true
      if ([3, 4].includes(this.moduleType) && !this.talkForm.templateInfo) {
        this.templateInfo = '请输入' + this.lableOne
        this.talkLoading = false
        return
      } else {
        this.templateInfo = ''
      }
      if (!this.talkForm.userIds && this.tplType == 2) {
        this.userInfo = '请选择员工'
        this.talkLoading = false
        return
      } else {
        this.userInfo = ''
      }
      if (this.talkType === '0') {
        this.talkForm.talkType = 0
      } else if (this.talkType === '1') {
        this.talkForm.talkType = 1
      }
      if (!this.templateType) {
        this.talkForm.talkMaterialList = []
        this.talkList.forEach((item, index) => {
          this.talkForm.talkMaterialList.push({ materialId: item.id, sort: index })
        })
      }
      this.$refs['talkform'].validate((valid) => {
        if (valid) {
          let talkForm = JSON.parse(JSON.stringify(this.talkForm))
          // 如果是关联模块
          if (this.moduleType === 4) {
            this.talkLoading = true
            talkForm.attachments = []
            if (this.talkList.length !== 0) {
              this.dealOtherModleType(talkForm)
            }
            this.$emit('submit', talkForm)
            // this.$refs['talkForm'].resetFields()
            // this.talkForm = {}
            setTimeout(() => {
              this.talkLoading = false
            }, 5000)
          } else {
            talkForm.attachmentList = []
            talkForm.weTlpMaterialList = []
            this.talkId ? (talkForm.talkId = this.talkId) : ''
            this.modelId ? (talkForm.modelId = this.modelId) : ''
            if (this.templateType) {
              // 如果是模板中心
              this.talkForm.weTlpMaterialList = []
              this.dealTemplateType(talkForm)
            }
            ;(this.templateType ? templateAdd : lexicalAdd)(talkForm)
              .then(() => {
                this.msgSuccess('操作成功')
                // this.getList()
                this.$router.push('list')
                this.$refs['talkForm'].resetFields()
                this.talkForm = {}
                this.talkLoading = false
              })
              .catch(() => {
                this.talkLoading = false
              })
          }
        } else {
          this.talkLoading = false
        }
      })
    },
    dealOtherModleType(talkForm) {
      this.talkList.forEach((item) => {
        let attachments = {}
        attachments.title = item.materialName
        attachments.realType = +item.mediaType
        attachments.materialId = item.id //素材
        switch (item.mediaType) {
          case '0':
            // 图片
            attachments.picUrl = item.materialUrl
            attachments.msgType = 'image'
            break
          case '2':
            // 视频
            attachments.picUrl = item.coverUrl
            attachments.fileUrl = item.materialUrl
            attachments.description = item.digest
            attachments.msgType = 'video'
            break
          case '3':
            // 文件
            attachments.picUrl = this.filPicType(item.materialUrl)
            attachments.fileUrl = item.materialUrl
            attachments.description = item.digest
            attachments.msgType = 'file'
            break
          case '4':
            // 文本
            attachments.content = item.content
            attachments.msgType = 'text'
            break
          case '5':
            // 海报
            attachments.fileUrl = item.materialUrl
            attachments.msgType = 'posters'
            break
          case '9':
            // 图文
            attachments.content = item.content
            attachments.picUrl = item.coverUrl
            attachments.linkUrl = item.materialUrl
            attachments.msgType = 'link'
            if (this.otherType === 3) {
              attachments.materialName = item.materialName
            }
            break
          case '11':
            // 小程序
            attachments.picUrl = item.coverUrl
            attachments.fileUrl = item.materialUrl
            attachments.appId = item.digest
            attachments.msgType = 'miniprogram'
            break
          case '12':
            // 文章
            attachments.fileUrl = item.materialUrl
            attachments.description = item.digest
            attachments.content = item.content
            attachments.picUrl = item.coverUrl
            attachments.msgType = 'news'
            break
        }
        talkForm.attachments.push(attachments)
      })
    },
    dealTemplateType(talkForm) {
      this.talkList.forEach((item) => {
        let attachmentFrom = {}
        attachmentFrom.msgType = item.mediaType
        attachmentFrom.mediaId = item.id
        if (item.mediaType != '0') {
          attachmentFrom.title = item.materialName
        }
        switch (item.mediaType) {
          case '0':
          case '5':
            // 图片
            attachmentFrom.picUrl = item.materialUrl
            break
          case '2':
            // 视频
            attachmentFrom.picUrl = item.coverUrl
            attachmentFrom.fileUrl = item.materialUrl
            attachmentFrom.description = item.digest
            break
          case '3':
            // 文件
            attachmentFrom.fileUrl = item.materialUrl
            attachmentFrom.description = item.digest
            break
          case '4':
            // 文本
            attachmentFrom.content = item.content
            break
          case '4':
            // 海报
            break
          case '9':
            // 图文
            attachmentFrom.content = item.content
            attachmentFrom.picUrl = item.coverUrl
            attachmentFrom.linkUrl = item.materialUrl
            break
          case '11':
            // 小程序
            attachmentFrom.picUrl = item.coverUrl
            attachmentFrom.fileUrl = item.materialUrl
            attachmentFrom.appId = item.digest
            break
          case '12':
            // 文章
            attachmentFrom.fileUrl = item.materialUrl
            attachmentFrom.description = item.digest
            attachmentFrom.content = item.content
            attachmentFrom.picUrl = item.coverUrl
            break
        }
        talkForm.attachmentList.push(attachmentFrom)
        talkForm.weTlpMaterialList.push({ materialId: item.id })
      })
      talkForm.templateType = this.templateType
      talkForm.tplType = this.tplType
    },
    getCancel() {
      this.$router.back()
    },
    goBack() {
      let talkForm = JSON.parse(JSON.stringify(this.talkForm))
      talkForm.attachments = []
      if (this.talkList.length !== 0) {
        this.dealOtherModleType(talkForm)
      }
      this.$emit('update', talkForm)
    },
  },
  mounted() {
    if (this.$route.query.categoryId) {
      let form = { categoryId: this.$route.query.categoryId }
      this.talkForm = { ...form }
    }
    if (this.templateType != 1 && this.moduleType != 4) {
      this.getTree()
    }
    if (this.baseData.templateInfo) {
      // this.form.templateInfo = this.baseData.templateInfo
      this.talkForm = this.baseData
      this.talkList = this.baseData.attachments
    }
    // this.dealType()
    if (this.otherType === 3 || this.tplType == 3) {
      this.maxlength = 1
    } else {
      this.maxlength = 8
    }
    if ([3, 4].includes(this.moduleType)) {
      this.fontType = '附件'
    } else {
      this.fontType = '素材'
    }
  },
}
</script>

<style lang="scss" scoped>
::v-deep .ql-editor {
  min-height: 200px;
  .ql-container {
    .ql-snow {
      .ql-tooltip {
        left: 0px !important;
      }
    }
  }
}
::v-deep .el-button.is-disabled {
  color: var(--font-white, #fff);
  background-color: var(--bg-black-8);
  border-color: var(--border-black-8);
}
::v-deep.el-dropdown [disabled] {
  color: var(--font-white, #fff);
  background-color: var(--bg-black-8);
  border-color: var(--border-black-8);
}
.footer {
  display: flex;
  justify-content: space-between;
}
.footerColor {
  font-weight: 500;
  font-size: 18px;
  color: var(--color);
  margin: 0 4px;
}
.radius {
  border-radius: 4px;
}
.boxClass {
  padding: 20px 10px 0 0;
}
</style>
