<template>
  <div>
    <el-form
      :class="firendId && 'formDetail'"
      :disabled="!!firendId"
      label-width="110px"
      label-position="right"
      :model="form"
      :rules="rules"
      ref="ruleForm">
      <div class="g-card">
        <el-form-item label="任务名称" prop="name" v-if="![2, 3].includes(firendType)">
          <el-input v-model="form.name" placeholder="请输入任务名称" maxlength="20" show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="发送方式" prop="sendType">
          <span v-if="firendType === 3">个人发送</span>
          <el-radio-group v-model="form.sendType" v-else>
            <el-radio :label="0">
              企微群发
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div class="question">
                    <div class="question-content" v-if="!firendId">?</div>
                  </div>
                </template>
                <div>员工可一键执行，但同一条朋友圈对相同客户仅会展示第一位成员发送的朋友圈</div>
              </el-popover>
            </el-radio>
            <el-radio :label="2">
              成员群发
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div class="question">
                    <div class="question-content" v-if="!firendId">?</div>
                  </div>
                </template>
                <div>需要成员手动发送，但同一条朋友圈对相同客户会展示每个成员发送的朋友圈</div>
              </el-popover>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="发送范围" required>
          <el-radio-group v-model="form.scopeType" @change="(val) => val == 0 && getNumMoments(form)">
            <el-radio :label="0">全部客户</el-radio>
            <el-radio :label="1">按条件筛选</el-radio>
          </el-radio-group>
          <div class="customer-num" v-if="form.sendType != 2">
            <span>朋友圈预计可见客户数（不去重）</span>
            <span>{{ form.customerNum }}</span>
          </div>
          <template v-if="form.scopeType == 1">
            <CustomerRangeForm
              class="mt15"
              isTrans
              :data="form.weCustomersQuery"
              @update:data="customerRangeFormChange"
              :isDetail="!!firendId"
              :disabled="!!firendId" />
          </template>
        </el-form-item>

        <!-- <el-form-item label="选择客户标签" v-if="form.scopeType === 0">
              <el-tag sizi="mini" v-for="(unit, key) in selectedTagList" :key="key">{{
                unit.name
              }}</el-tag>
              <div>
                <el-button type="primary" plain @click="selectedFn">选择标签</el-button>
              </div>
            </el-form-item> -->
        <el-form-item label="执行时间">
          <div class="tips" v-if="!firendId">
            可自由设定该朋友圈任务下发通知的开始时间，如未设置则默认创建时间即开始执行时间
          </div>
          <el-date-picker
            v-model="form.executeTime"
            type="datetime"
            placeholder="选择年月日时分"
            format="YYYY-MM-DD HH:mm"
            v-bind="pickerOptions"></el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="executeEndTime" v-if="![2, 3].includes(firendType)">
          <div class="tips" v-if="!firendId">朋友圈任务可设置截止时间，则未完成的成员不允许再执行本条任务</div>
          <el-date-picker
            v-model="form.executeEndTime"
            type="datetime"
            placeholder="选择年月日时分"
            format="YYYY-MM-DD HH:mm"
            v-bind="pickerOptions"></el-date-picker>
        </el-form-item>
        <el-form-item label="自动标签" v-if="[0].includes(form.sendType)">
          <div class="tips">可根据客户的点赞或评论行为分别打上对应标签</div>
          <div>点赞自动打标签</div>
          <div v-if="likeTagList.length">
            <el-tag sizi="mini" v-for="(unit, key) in likeTagList" :key="key">{{ unit.name }}</el-tag>
          </div>
          <div class="tips" v-if="!likeTagList.length && firendId">未选择标签</div>
          <div v-if="!firendId">
            <el-button type="primary" plain @click="selectedFn">选择标签</el-button>
          </div>
          <div class="mt10">评论自动打标签</div>
          <div v-if="commentTagList.length">
            <el-tag sizi="mini" v-for="(unit, key) in commentTagList" :key="key">{{ unit.name }}</el-tag>
          </div>
          <div class="tips" v-if="!commentTagList.length && firendId">未选择标签</div>
          <div v-if="!firendId">
            <el-button type="primary" plain @click="selectedFn2">选择标签</el-button>
          </div>
        </el-form-item>
        <el-form-item label="朋友圈内容" v-if="[1, 2, 3].includes(firendType)">
          <el-input
            v-model="form.content"
            placeholder="未填写文本内容"
            :disabled="true"
            type="textarea"
            :rows="4"
            v-if="firendType === 1"></el-input>
          <div class="firend-box" v-else>
            <FirendContent :list="friendsList" :content="form.content" />
          </div>
        </el-form-item>
      </div>
      <!-- <FriendCircleContent ref="friendCircleContent" :data="form"></FriendCircleContent> -->
      <AddMaterial
        :moduleType="4"
        @update="onBackStep"
        @submit="submit"
        :otherType="3"
        :showPhone="false"
        :detail="firendId !== undefined"
        v-if="!firendId || (firendId && firendType === 1)"
        :baseData="baseData"></AddMaterial>

      <!-- <el-form-item label-width="0" style="margin-top: 20px; margin-bottom: 0">
            <el-button @click="onBackStep">取消</el-button>
            <el-button type="primary" @click="submit">保存</el-button>
          </el-form-item> -->
    </el-form>
    <!-- 选择标签弹窗 -->
    <SelectTag v-model:visible="dialogVisibleSelectTag" :selected="likeTagList" @success="submitSelectTag"></SelectTag>
    <SelectTag
      v-model:visible="dialogVisibleSelectTag2"
      :selected="commentTagList"
      @success="submitSelectTag2"></SelectTag>
    <!-- <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      @success="selectedUser"
    ></SelectUser> -->
  </div>
</template>

<script>
import { addMoments, numMoments, getDetail } from '@/api/circle'
import AddMaterial from '@/components/ContentCenter/AddMaterial'
import FirendContent from './components/FirendContent.vue'
import moment from 'moment'
import { getList } from '@/api/customer/tag'
import { getCustomerList } from '@/api/groupMessage'

export default {
  name: 'publish-detail',
  components: {
    AddMaterial,
    FirendContent,
    FriendCircleContent: defineAsyncComponent(() => import('@/components/FriendCircleContent')),
  },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 24 * 60 * 60 * 1000
        },
      },
      form: {
        scopeType: 0, // 发送范围: 0全部客户 1按条件筛选
        sendType: 0, // 发送方式: 0企微群发，1成员群发
        // customerTag: '', // 客户标签，多个使用逗号隔开
        // noAddUser: '', // 发送员工，使用逗号隔开
        customerNum: 0, // 朋友圈可见客户数
        executeTime: '', // 执行时间
        executeEndTime: '', // 结束时间
        content: '', //文本框内容
        likeTagIds: [], // 点赞标签集合
        commentTagIds: [], // 评论标签集合
        materialIds: [], // 素材id集合
        // otherContent: [],
        // contentType: '', //图片:image 视频:video 图文链接:link
      },
      // 遮罩层
      loading: false,
      // selectedUserList: [],
      // dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      dialogVisibleSelectTag2: false,
      likeTagList: [],
      commentTagList: [],
      // addWeUser: {
      //   userIds: [],
      //   deptIds: [],
      //   posts: [],
      //   customerTag: [],
      // },
      rules: {
        name: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
        sendType: [{ required: true, message: '请选择发送方式', trigger: 'change' }],
        executeEndTime: [{ type: 'date', required: true, message: '请选择结束时间', trigger: 'change' }],
      },
      firendId: undefined,
      firendType: undefined,
      friendsList: [],
      baseData: {},
    }
  },
  mounted() {
    this.firendId = this.$route.query.id
    this.firendType = +this.$route.query.type
    if (this.firendId) {
      // 详情页面
      this.getDetail(this.firendId)
    } else {
      // 新增页面
      let form = {}
      form.scopeType = 0
      this.getNumMoments(form)
    }
  },
  methods: {
    // 获取页面详情
    getDetail(id) {
      getDetail(id)
        .then((res) => {
          if (res.code === 200) {
            this.form = res.data
            // this.addWeUser = res.data
            this.likeTagList = res.data.likeTagIds ? res.data.likeTagIds : []
            this.commentTagList = res.data.commentTagIds ? res.data.commentTagIds : []
            this.friendsList = res.data.materialList ? res.data.materialList : []
            let obj = {
              templateInfo: res.data.content ? res.data.content : '',
              attachments: res.data.materialList ? res.data.materialList : [],
            }
            this.baseData = JSON.parse(JSON.stringify(obj))
            this.setEditTag()
          }
        })
        .catch()
    },
    // 处理详情页面里的点赞/评论自动打标签
    setEditTag() {
      this.likeTagList = []
      this.commentTagList = []
      if (this.form.likeTagIds && this.form.likeTagIds.length) {
        getList({ groupTagType: 1 }).then(({ rows }) => {
          this.form.likeTagIds.forEach((dd) => {
            rows.forEach((inx) => {
              let index = inx.weTags.findIndex((item) => item.tagId === dd)
              if (inx.weTags[index] !== undefined) {
                this.likeTagList.push(inx.weTags[index])
              }
            })
          })
        })
      }
      if (this.form.commentTagIds && this.form.commentTagIds.length) {
        getList({ groupTagType: 1 }).then(({ rows }) => {
          this.form.commentTagIds.forEach((dd) => {
            rows.forEach((inx) => {
              let index = inx.weTags.findIndex((item) => item.tagId === dd)
              if (inx.weTags[index] !== undefined) {
                this.commentTagList.push(inx.weTags[index])
              }
            })
          })
        })
      }
    },
    // 获取可见客户数
    getNumMoments(data) {
      if (this.form.sendType == 2) {
        this.form.customerNum = undefined
        return
      }

      numMoments(data)
        .then((res) => {
          this.form.customerNum = res.data
        })
        .catch()
    },
    customerRangeFormChange(params) {
      this.form.weCustomersQuery = params
      if (this.form.scopeType == 1 && !this.firendId) {
        this.loading = true
        getCustomerList(params, 1)
          .then(({ data }) => {
            if (data?.length) {
              this.form.senderList = data
              this.getNumMoments(this.form)
            } else {
              this.msgError('未找到可发送客户！')
              this.loading = false
            }
          })
          .catch(() => {
            this.loading = false
          })
      }
    },
    selectedFn() {
      this.dialogVisibleSelectTag = true
    },
    selectedFn2() {
      this.dialogVisibleSelectTag2 = true
    },
    submitSelectTag(data) {
      this.form.likeTagIds = []
      data.forEach((el) => {
        this.form.likeTagIds.push(el.tagId)
      })
      this.likeTagList = data
    },
    submitSelectTag2(data) {
      this.form.commentTagIds = []
      data.forEach((el) => {
        this.form.commentTagIds.push(el.tagId)
      })
      this.commentTagList = data
    },
    // onSelectUser() {
    //   this.dialogVisibleSelectUser = true
    // },
    // selectedUser(users) {
    //   this.selectedUserList = users
    // },
    onInsertMaterial(e) {
      this.form.contentType = e
      this.form.otherContent.push({
        annexType: e,
        annexUrl: '',
        contentError: '',
      })
    },
    onRemoveMaterial(index) {
      this.form.otherContent.splice(index, 1)
      if (!this.form.otherContent.length) {
        this.form.contentType = ''
      }
    },
    // 上一步
    onBackStep() {
      this.$router.go(-1)
    },

    submit(data) {
      if (this.form.sendType != 2 && !this.form.customerNum) {
        this.msgError('未找到可发送客户！')
        return
      }
      this.$refs['ruleForm'].validate((valid) => {
        if (valid) {
          this.form.materialIds = []
          data.attachments.forEach((item) => {
            this.form.materialIds.push(item.materialId)
          })
          this.form.content = data.templateInfo
          // if (data.attachments.length !== 0) {
          //   this.form.contentType = 'link'
          //   this.form.realType = data.attachments[0].realType
          //   this.form.materialId = data.attachments[0].materialId
          //   this.dealType(data.attachments[0])
          // } else {
          //   this.form.otherContent = []
          //   this.form.contentType = 'text'
          // }
          // // if (this.$refs.friendCircleContent.validate()) {
          // if (this.form.scopeType === 0) {
          //   this.form.customerTag = this.selectedTagList
          //     .map((dd) => {
          //       return dd.tagId
          //     })
          //     .join(',')
          //   this.form.noAddUser = this.selectedUserList
          //     .map((dd) => {
          //       return dd.userId
          //     })
          //     .join(',')
          // }
          if (this.form.executeTime && typeof this.form.executeTime !== 'string') {
            let time = this.form.executeTime.getTime()
            let time2 = Date.now()
            if (time2 > time) {
              this.msgError('执行时间不可早于当前日期！')
              return false
            }
            this.form.executeTime = moment(this.form.executeTime).format('YYYY-MM-DD HH:mm')
          }
          if (this.form.executeEndTime && typeof this.form.executeEndTime !== 'string') {
            let time = this.form.executeEndTime.getTime()
            let time2 = Date.now()
            if (time2 > time) {
              this.msgError('结束时间不可早于当前日期！')
              return false
            }
            this.form.executeEndTime = moment(this.form.executeEndTime).format('YYYY-MM-DD HH:mm')
          }
          addMoments(this.form).then((res) => {
            if (res.code === 200) {
              this.msgSuccess('操作成功')
              this.$router.go(-1)
            }
          })
          // }
        } else {
          return false
        }
      })
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
    // dealType(data) {
    //   this.form.otherContent = []
    //   let arr = {}
    //   let linkUrl =
    //     window.document.location.origin + '/mobile/#/metrialDetail?materiaId=' + data.materialId
    //   switch (data.realType) {
    //     case 0:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: data.picUrl,
    //         other: data.picUrl,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 2:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.picUrl,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 3:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: this.filPicType(data.fileUrl),
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 4:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.content,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 5:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.fileUrl,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 9:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: data.linkUrl,
    //         other: data.picUrl ? data.picUrl : window.lwConfig.DEFAULT_H5_TP,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 12:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.picUrl ? data.picUrl : window.lwConfig.DEFAULT_H5_ART,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //   }
    // },
  },
}
</script>

<style lang="scss" scoped>
.firend-box {
  width: 460px;
  min-height: 100px;
  border: 1px solid #dfe4ed;
  padding: 12px;
}
.tips {
  color: #aaa;
  font-size: 12px;
  line-height: 34px;
}
.customer-num {
  span {
    font-size: 12px;
    line-height: 30px;
  }
  span:nth-child(1) {
    color: #aaa;
  }
  span:nth-child(2) {
    color: #07c160;
  }
}
.question {
  display: inline-block;
  width: 16px;
  // overflow: hidden;
  .question-content {
    width: 14px;
    height: 14px;
    border-radius: 16px;
    background-color: #888;
    color: #fff;
    font-size: 12px;
    text-align: center;
    line-height: 14px;
  }
}
</style>
