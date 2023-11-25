<template>
  <div>
    <!-- 新建欢迎语 -->
    <el-row type="flex" justify="space-between">
      <el-col :span="!showPhone ? 24 : 16" :class="!showPhone ? 'g-margin-t' : 'boxClass'" class="left radius">
        <div class="g-card" v-if="showModle">
          <el-button type="primary" @click="welcomVisible = true">从模板库中选择</el-button>
        </div>
        <div class="g-card" v-if="!detail">
          <div class="g-card-title g-margin-b" v-if="iswelcom || (moduleType === 4 && otherType !== 3)">
            {{ titleOne }}
            <el-popover trigger="hover" content="最多发送1条文字信息" placement="top-start">
              <template #reference>
                <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
              </template>
            </el-popover>
          </div>
          <el-form ref="talkform" :model="talkForm" :rules="talkRules" label-width="120px">
            <el-form-item prop="categoryId" label="选择分组" v-if="!iswelcom && moduleType !== 4">
              <el-cascader
                v-model="talkForm.categoryId"
                :options="treeData[0].children"
                :props="groupProps"></el-cascader>
            </el-form-item>
            <el-form-item label="话术标题" prop="talkTitle" v-if="moduleType !== 3 && moduleType !== 4">
              <el-input v-model="talkForm.talkTitle" placeholder="请输入标题" maxlength="30" show-word-limit></el-input>
            </el-form-item>
            <el-form-item label="使用员工" required v-if="iswelcom && tplType === '2'" :error="userInfo">
              <el-tag sizi="mini" v-for="(unit, key) in users" :key="key">{{ unit.name }}</el-tag>
              <div>
                <el-button type="primary" plain @click="onSelectUser" :error="userInfo">选择员工</el-button>
              </div>
              <div class="sub-des">员工被设置多个欢迎语时，以最新设置或修改的为准</div>
            </el-form-item>
            <el-form-item
              :label="lableOne"
              required
              style="margin-right: 200px !important"
              :error="templateInfo"
              v-if="[3, 4].includes(moduleType)">
              <div v-if="tips" class="tips">{{ tips }}</div>
              <TextareaExtend
                v-model="talkForm.templateInfo"
                :toolbar="['emoji', (iswelcom || [1, 4].includes(otherType)) && 'insertCustomerNickName']"
                maxlength="2000"
                show-word-limit
                placeholder="请输入"
                :autosize="{ minRows: 5, maxRows: 20 }"
                clearable
                :autofocus="true"
                @input="changeInfo"
                :nikeName="tplType === '3' ? '%NICKNAME%' : '#客户昵称#'" />
            </el-form-item>
          </el-form>
        </div>
        <div class="g-card" v-if="!detail">
          <div class="g-card-title" v-if="otherType !== 3">
            {{ titleTwo }}
            <el-popover trigger="hover" :content="'最多添加' + maxlength + '个素材'" placement="top-start">
              <template #reference>
                <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
              </template>
            </el-popover>
          </div>
          <div>
            <div style="text-align: left" class="mt20 flex">
              <el-popover
                trigger="hover"
                :content="'最多添加' + maxlength + '个' + fontType + '，如需修改请删除已有' + fontType + '后重新尝试'"
                placement="top-start"
                :disabled="talkList?.length < maxlength">
                <template #reference>
                  <el-dropdown
                    @command="moveGroup"
                    :disabled="talkList?.length > maxlength || talkList?.length === maxlength">
                    <el-button type="primary" v-show="!(moduleType === 4 && otherType === 3)">
                      + {{ '新建' + fontType }}
                    </el-button>
                    <template #dropdown>
                      <el-dropdown-menu trigger="click">
                        <el-dropdown-item :command="'4'" v-if="!this.templateType && this.moduleType !== 4">
                          <el-button text>文本</el-button>
                        </el-dropdown-item>
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
                        <el-dropdown-item :command="'19'">
                          <el-button text>外链</el-button>
                        </el-dropdown-item>
                      </el-dropdown-menu>
                    </template>
                  </el-dropdown>
                </template>
              </el-popover>
              <el-popover
                trigger="hover"
                :content="'最多添加' + maxlength + '个' + fontType + '，如需修改请删除已有' + fontType + '后重新尝试'"
                placement="top-start"
                :disabled="talkList?.length < maxlength">
                <template #reference>
                  <div class="ml20">
                    <el-button @click="choseCenter" :disabled="talkList?.length >= maxlength">从素材中心选择</el-button>
                  </div>
                </template>
              </el-popover>
            </div>
          </div>
        </div>
        <div class="g-card" v-if="talkList?.length">
          <DragTable
            :tableData2="talkList"
            @setData="setData"
            @getEdit="getEdit"
            :dargAble="[2].includes(moduleType)"
            :isDeatail="detail" />
        </div>
        <div
          class="g-card mt20 g-pad20"
          style="text-align: left"
          v-if="
            ((talkList?.length && moduleType === 2) ||
              (otherType !== 3 && moduleType !== 2) ||
              (otherType === 3 && moduleType !== 2)) &&
            !detail
          ">
          <!-- 话术中心，有列表才显示 -->
          <template v-if="talkList?.length && moduleType === 2">
            <el-button @click="getCancel">取消</el-button>
            <el-button type="primary" v-loading="talkLoading" @click="tackSubmit">确定</el-button>
          </template>
          <template v-else-if="otherType !== 3 && moduleType !== 2">
            <el-button @click="goBack" v-if="moduleType === 4">上一步</el-button>
            <el-button @click="getCancel" v-if="moduleType !== 4">取消</el-button>
            <el-button type="primary" v-loading="talkLoading" @click="tackSubmit">确定</el-button>
          </template>
          <template v-else-if="otherType === 3 && moduleType !== 2">
            <el-button @click="goBack">取消</el-button>
            <el-button type="primary" v-loading="talkLoading" @click="tackSubmit">确定</el-button>
          </template>
        </div>
      </el-col>
      <el-col :span="8" class="g-card" style="margin-top: 0; padding: 20px" v-if="showPhone">
        <PreviewInPhone :list="talkList" :templateInfo="talkForm.templateInfo" :liveUrl="liveUrl" />
      </el-col>
    </el-row>
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
      v-model="welcomVisible"
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
      :talkListLength="talkList?.length"
      @itemArry="getItemArry"
      :templateType="templateType"
      :tplType="tplType"
      :moduleType="moduleType"
      :maxlength="maxlength"
      :noApplets="otherType === 3"
      :isFriends="otherType === 3" />
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
import DragTable from '@/components/DragTable'
import MaterialCenter from '@/components/ContentCenter/MaterialCenter'
import { string } from 'clipboard'
import { getPosterInfo } from '@/api/material/poster'
import { getDetail } from '@/api/material/index'
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
      lableOne: '欢迎语',
      titleTwo: '欢迎语附件',
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
      maxlength: 9,
      libraryLoading: false,
      tips: null,
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
      default: undefined,
    },
    // 1:活码欢迎语;2:员工欢迎语;3:入群欢迎语
    tplType: {
      type: String,
      default: null,
    },
    // 模块类型 1:素材;2:话术;3:模板;4:其他模块
    moduleType: {
      type: Number,
      default: 1,
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
    // 是否为详情页面
    detail: {
      type: Boolean,
      default: false,
    },

    isTransData: Boolean,
  },
  watch: {
    baseData: {
      handler(val) {
        val = JSON.parse(JSON.stringify(val))
        if (val.templateInfo || val.attachments) {
          this.isTransData && (val.attachments = this.setEditList(val.attachments))
          this.form.templateInfo = val.templateInfo || ''
          this.form.attachments = val.attachments
          this.talkForm = val
          this.talkList = val.attachments
          // this.$forceUpdate()
          // if (this.otherType === 3 && this.detail) {
          //   this.talkForm = val
          //   this.talkList = val.attachments
          // }
        }
      },
      deep: true,
      immediate: true,
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
      }
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
    dealType() {
      if (this.moduleType === 4) {
        switch (this.otherType) {
          case 1:
          case 4:
            this.titleOne = '欢迎语'
            this.lableOne = '欢迎语'
            this.titleTwo = '欢迎语附件'
            break
          case 2:
            this.titleOne = '群发内容'
            this.lableOne = '内容'
            this.titleTwo = '群发附件'
            break
          case 3:
            this.titleOne = '动态内容'
            this.lableOne = '朋友圈内容：'
            this.tips = '文本或附件内容至少满足一种类型才可发表，附件类型仅支持添加一种类型'
            break
        }
      } else if (this.iswelcom) {
        this.titleOne = '欢迎语'
        this.lableOne = '欢迎语'
        this.titleTwo = '欢迎语附件'
      } else if (this.templateType === 2) {
        this.lableOne = '群发内容'
        this.titleTwo = '群发附件'
      } else if (this.templateType === 3) {
        this.lableOne = ' SOP内容'
        this.titleTwo = '群发附件'
      } else {
        this.titleOne = '欢迎语'
        this.lableOne = '消息内容'
        this.titleTwo = '话术素材'
      }
    },
    // 模板库点击确定
    selectModle() {
      this.libraryLoading = true
      if (this.selectObj) {
        this.talkForm = this.selectObj
        this.welcomVisible = false
        this.talkList = this.selectObj.weMaterialList
      } else {
        this.$message.error('请选择群发模板')
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
    },
    getItemArry(val, length) {
      this.talkList = this.talkList.concat(val)

      if (this.otherType === 3) {
        // 朋友圈模块需要控制只能选择最多9个图片或者1个其他类型的文件
        let img = 0
        let other = 0
        this.talkList.forEach((item) => {
          if (item.mediaType === '0') {
            img++
          } else {
            other++
          }
        })
        if (img > 1) {
          this.maxlength = 9
        } else if (other === 1) {
          this.maxlength = 1
        }
        if (this.maxlength === 9) {
          this.fontType = '图片类型的附件'
        } else {
          this.fontType = '其他类型的附件'
        }
      }

      // 当手机为非内嵌时
      this.$emit('phoneData', this.talkList)
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
      if ([3, 4].includes(this.moduleType) && !this.talkForm.templateInfo && this.otherType !== 3) {
        this.templateInfo = '请输入' + this.lableOne
        this.talkLoading = false
        return
      } else {
        this.templateInfo = ''
      }
      if (this.otherType === 3) {
        if (!this.talkForm.templateInfo && !this.talkList.length) {
          this.templateInfo = '文本或附件内容至少填写一种'
          this.talkLoading = false
          return
        } else {
          this.templateInfo = ''
        }
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
        // console.log(this.talkList)
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
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          let common = { id: dd.materialId, mediaType: dd.realType + '' }
          let obj = undefined
          if (dd.realType === 0) {
            obj = {
              materialUrl: dd.picUrl,
            }
          } else if (dd.realType === 2) {
            obj = {
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              digest: dd.description,
              materialName: dd.title,
            }
          } else if (dd.realType === 3) {
            obj = {
              materialUrl: dd.fileUrl,
              digest: dd.description,
              materialName: dd.title,
            }
          } else if (dd.realType === 4) {
            obj = {
              content: dd.content,
            }
          } else if ([9, 19].includes(dd.realType)) {
            obj = {
              content: dd.content,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
          } else if (dd.realType === 8) {
            obj = {
              materialName: dd.title,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
          } else if (dd.realType === 11) {
            obj = {
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.fileUrl,
            }
          } else if (dd.realType === 12) {
            obj = {
              digest: dd.description,
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              content: dd.content,
              materialName: dd.title,
            }
          } else if (dd.realType === 5) {
            obj = {
              materialUrl: dd.fileUrl,
              materialName: dd.title,
            }
          }
          obj && arr.push(Object.assign(common, obj))
        })
      }
      return arr
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
          case '19':
            // 外链
            attachments.linkUrl = item.materialUrl
            attachments.content = item.content
            attachments.picUrl = item.coverUrl
            attachments.msgType = 'murl'
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
          case '19':
            // 图文 外链
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
    // if (this.form.templateInfo) {
    //   // this.form.templateInfo = this.baseData.templateInfo
    //   this.talkForm = this.baseData
    //   this.talkList = this.baseData.attachments
    // }
    this.dealType()
    if (this.tplType == 3) {
      this.maxlength = 1
    } else {
      this.maxlength = 9
    }
    if ([3, 4].includes(this.moduleType)) {
      this.fontType = '附件'
    } else {
      this.fontType = '素材'
    }
    if (this.$route.query.posterId) {
      getDetail(this.$route.query.posterId).then((res) => {
        if (res.code == 200) {
          this.talkList.push(res.data)
        }
      })
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
  padding: 0 var(--card-margin) 0 0;
}
.tips {
  color: #aaa;
  font-size: 12px;
  line-height: 30px;
}
</style>
