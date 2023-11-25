<template>
  <div v-loading="saveLoading">
    <div class="g-card">
      <el-steps :active="active" align-center finish-status="success">
        <el-step title="直播设置"></el-step>
        <el-step title="分享设置"></el-step>
      </el-steps>
    </div>
    <div class="g-card" v-show="active == 0">
      <el-form ref="liveForm" :rules="liveRules" :model="liveForm" label-position="right" label-width="100px">
        <el-form-item label="直播标题" label-width="120px" prop="liveTitle">
          <el-input
            v-model="liveForm.liveTitle"
            maxlength="20"
            show-word-limit
            clearable
            placeholder="请输入直播标题"></el-input>
        </el-form-item>
        <el-form-item label="直播成员" label-width="120px" v-if="!$route.query.id" required :error="liveUserInfo">
          <div v-if="users.length > 0">
            <el-tag v-for="(item, index) in users" :key="index">{{ item.name }}</el-tag>
          </div>
          <el-button type="primary" plain @click="onSelectUser">{{ users.length ? '修改' : '选择' }}员工</el-button>
        </el-form-item>
        <el-form-item label="直播开始时间" label-width="120px" required class="mb0">
          <div class="pickerStyle">
            <el-form-item prop="liveStartDate">
              <el-date-picker
                v-model="liveForm.liveStartDate"
                v-bind="pickerOptions"
                type="date"
                placeholder="选择年月日"
                style="width: 150px; margin-right: 30px"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
                @change="liveStartDateChange"></el-date-picker>
            </el-form-item>
            <el-form-item prop="liveStartTime">
              <el-time-select
                v-model="liveForm.liveStartTime"
                style="width: 150px"
                v-bind="{
                  start: '00:00',
                  step: '00:15',
                  end: '23:59',
                  minTime: minTime,
                  maxTime: maxTime,
                }"
                placeholder="选择时分"
                @click="liveStartTimeChange"></el-time-select>
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item label="直播结束时间" label-width="120px" required class="mb0">
          <div class="pickerStyle">
            <el-form-item prop="liveEndDate">
              <el-date-picker
                v-model="liveForm.liveEndDate"
                v-bind="pickerOptions"
                type="date"
                placeholder="选择年月日"
                style="width: 150px; margin-right: 30px"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
                @change="liveEndDateChange"></el-date-picker>
            </el-form-item>
            <el-form-item prop="liveEndTime">
              <el-time-select
                v-model="liveForm.liveEndTime"
                style="width: 150px"
                v-bind="{
                  start: '00:00',
                  step: '00:15',
                  end: '23:59',
                  minTime: minEndTime,
                }"
                placeholder="选择时分"
                @click="liveEndTimeChange"></el-time-select>
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item label="直播简介" label-width="120px">
          <el-input
            type="textarea"
            :rows="6"
            maxlength="150"
            show-word-limit
            placeholder="请输入内容"
            v-model="liveForm.liveDesc"></el-input>
        </el-form-item>
        <el-form-item label="开播提醒" label-width="120px">
          <el-select v-model="liveForm.startReminder" placeholder="请选择提醒时间">
            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
          </el-select>
          <div class="sub-des">选择后会在开播前发送应用消息提醒员工开播</div>
        </el-form-item>
        <el-form-item>
          <el-button plain @click="cancelFn">取消</el-button>
          <el-button type="primary" @click="nextStep(1)">下一步</el-button>
          <el-button type="primary" @click="submit(false)" v-if="$route.query.id">保存</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-margin-t" style="display: flex" v-show="active == 1">
      <el-form
        class="fxauto g-margin-r"
        ref="shareForm"
        :rules="shareRules"
        :model="shareForm"
        label-position="right"
        label-width="100px">
        <div class="g-card">
          <el-form-item label="发送目标" prop="targetType" required>
            <el-radio-group v-model="shareForm.targetType">
              <el-radio :label="1">客户</el-radio>
              <el-radio :label="2">客户群</el-radio>
            </el-radio-group>
          </el-form-item>
          <!-- 客户 -->
          <template v-if="shareForm.targetType === 1">
            <el-form-item label="发送成员" required :error="userInfo">
              <el-radio-group v-model="sendUser" @input="radioChange">
                <el-radio :label="1">全部成员</el-radio>
                <el-radio :label="2">部分成员</el-radio>
              </el-radio-group>
              <el-form-item prop="sendWeUser" v-if="sendUser === 2">
                <div v-if="sendUsers.length > 0">
                  <el-tag v-for="(item, index) in sendUsers" :key="index">{{ item.name }}</el-tag>
                </div>
                <el-button type="primary" plain @click="onSendSelectUser">
                  {{ sendUsers.length ? '修改' : '选择' }}员工
                </el-button>
              </el-form-item>
            </el-form-item>
            <!-- 发送客户 -->
            <el-form-item label="发送客户" required :error="customerInfo">
              <el-radio-group v-model="sendCustomer" @input="customerRadioChange">
                <el-radio :label="1">全部客户</el-radio>
                <el-radio :label="2">部分客户</el-radio>
              </el-radio-group>
              <el-form-item v-if="sendCustomer === 2">
                <div v-if="sendCustomers.length > 0">
                  <el-tag v-for="(item, index) in sendCustomers" :key="index">
                    {{ item.tagName }}
                  </el-tag>
                </div>
                <div>
                  <el-button type="primary" icon="el-icon-plus" @click="selectedFn">
                    {{ sendCustomer.length == 0 ? '选择' : '编辑' }}标签
                  </el-button>
                </div>
              </el-form-item>
            </el-form-item>
          </template>
          <!-- 客户群 -->
          <template v-else>
            <!-- 发送客群 -->
            <el-form-item label="发送客户" required :error="groupInfo">
              <el-radio-group v-model="sendCustomer" @input="customerRadioChange">
                <el-radio :label="1">全部客群</el-radio>
                <el-radio :label="2">部分客群</el-radio>
              </el-radio-group>
              <el-form-item v-if="sendCustomer === 2">
                <div v-if="sendGroupCustomers.length > 0">
                  <el-tag v-for="(item, index) in sendGroupCustomers" :key="index">
                    {{ item.name }}
                  </el-tag>
                </div>
                <div>
                  <el-button type="primary" icon="el-icon-plus" @click="onGroupSelectUser">
                    {{ sendGroupCustomers.length == 0 ? '选择' : '编辑' }}群主
                  </el-button>
                </div>
              </el-form-item>
            </el-form-item>
          </template>
        </div>

        <AddMaterial
          :moduleType="4"
          :otherType="2"
          @update="updateData"
          @submit="getWelData"
          :baseData="materialData"
          isTransData
          :liveUrl="liveUrl"
          :showPhone="false"
          :showFooter="false"
          @phoneData="getPhoneData"
          @changeInfo="changeInfo"></AddMaterial>
      </el-form>
      <div class="g-card mt0 fxnone">
        <PreviewInPhone :templateInfo="materialData.templateInfo" :originList="talkList" :liveUrl="liveUrl" />
      </div>
    </div>
    <!-- <div class="mt20 g-card" v-if="active === 1">
      <div class="fr">
        <el-button @click="active = 0">上一步</el-button>
        <el-button type="primary" @click="nextStep(2)">确定</el-button>
      </div>
    </div> -->
    <!-- 直播成员弹框 -->
    <SelectUser
      key="1"
      v-model:visible="dialogVisibleSelectUser"
      title="选择直播成员"
      :isOnlyLeaf="true"
      :isSigleSelect="true"
      @success="selectedUser"
      :defaultValues="selectedUserList"></SelectUser>
    <!-- 发送成员弹框 -->
    <SelectUser
      :defaultValues="sendSelectedUserList"
      v-model:visible="dialogVisibleSendSelectUser"
      title="选择发送成员"
      :isOnlyLeaf="false"
      @success="sendSelectedUser"></SelectUser>
    <!-- 选择标签弹窗 -->
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      :selected="selectedTagList"
      @success="submitSelectTag"></SelectTag>
    <!-- 发送客群弹框 -->
    <SelectUser
      :defaultValues="selectedTagList"
      v-model:visible="dialogVisibleSelectCustomers"
      title="选择发送群主"
      @success="sendSelectedCustomer"></SelectUser>
  </div>
</template>

<script>
import AddMaterial from '@/components/ContentCenter/AddMaterial'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { addOrUpdate, detailLive } from '@/api/operateCenter/liveBroadcast'
import * as api from '@/api/enterpriseId'
export default {
  components: {
    AddMaterial,
    PreviewInPhone,
  },
  data() {
    return {
      saveLoading: false,
      liveForm: {},
      shareForm: {
        targetType: 1,
        sendWeUser: {},
        sendTarget: {},
      },
      materialData: {
        templateInfo: '',
        materialMsgList: [],
      },
      sendUser: 1, // 发送成员
      sendCustomer: 1, // 发送客户
      selectedUserList: [],
      sendSelectedUserList: [],
      dialogVisibleSelectUser: false, // 直播成员弹框
      dialogVisibleSendSelectUser: false, // 发送成员弹框
      dialogVisibleSelectTag: false, // 发送客户|发送客群
      dialogVisibleSelectCustomers: false,
      selectedTagList: [],
      users: [],
      sendUsers: [],
      sendCustomers: [],
      sendGroupCustomers: [],
      minTime: '',
      minEndTime: '',
      active: 0,
      liveUrl: 'http://demo.linkwechat.net/mobile/#/***', // 直播链接
      talkList: [],
      userInfo: '',
      groupInfo: '',
      customerInfo: '',
      liveUserInfo: '',
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < new Date().setDate(new Date().getDate() - 1)
        },
      },
      liveRules: {
        liveTitle: [{ required: true, message: '请输入直播标题', trigger: 'blur' }],
        liveWeUserid: [{ required: true, message: '请选择直播成员', trigger: 'change' }],
        liveStartDate: [{ required: true, message: '请选择年月日', trigger: 'blur' }],
        liveStartTime: [{ required: true, message: '请选择时分', trigger: 'blur' }],
        liveEndDate: [{ required: true, message: '请选择年月日', trigger: 'blur' }],
        liveEndTime: [{ required: true, message: '请选择时分', trigger: 'blur' }],
      },
      shareRules: {},
      options: [
        { value: 300, label: '5分钟前' },
        { value: 900, label: '15分钟前' },
        { value: 3600, label: '1小时前' },
        { value: 86400, label: '1天前' },
      ],
      maxTime: '',
      weLiveAttachments: [],
    }
  },
  computed: {
    // disabled() {
    //   return this.$route.query.type == "view";
    // },
    // defaultTime() {
    //   let date = new Date()
    //   date.setMinutes(date.getMinutes() - date.getTimezoneOffset() + 60)
    //   return date.toJSON().substring(11, 19)
    // },
  },
  watch: {},
  created() {
    if (this.$route.query.id) {
      this.getDeatil(this.$route.query.id)
    }
    api.getDetail().then(({ data }) => {
      if (data.liveSecret === null) {
        this.$message.error('直播秘钥为空,请于 管理中心->企微配置->直播 中配置')
      }
    })
  },
  methods: {
    getPhoneData(val) {
      this.talkList = [...val]
    },
    changeInfo(val) {
      this.materialData.templateInfo = val
    },
    updateData(val) {
      this.active = 0
      this.materialData = {
        templateInfo: val.templateInfo,
        attachments: val.attachments,
      }
      this.weLiveAttachments = [...val.attachments]
    },
    dealDate(newVal) {
      let date = new Date()
      let year = date.getFullYear()
      let mouth = this.get0(date.getMonth() + 1)
      let day = this.get0(date.getDate())
      let hours = this.get0(date.getHours())
      let mutations = this.get0(date.getMinutes())
      let value = year + '-' + mouth + '-' + day
      let valData = year + '' + mouth + '' + day
      let newValData = ''
      newVal.split('-').map((item) => {
        newValData += item
      })
      if (valData > newValData) {
        return '24:00'
      } else if (newVal === value) {
        return hours + ':' + mutations
      } else {
        return ''
      }
    },
    liveStartDateChange(newVal) {
      this.minTime = this.dealDate(newVal)
      this.liveStartTimeChange()
    },
    liveStartTimeChange() {
      if (this.liveForm.liveStartDate === this.liveForm.liveEndDate && this.liveForm.liveEndTime !== '') {
        this.maxTime = this.liveForm.liveEndTime
      } else {
        this.maxTime = ''
      }
    },
    liveEndDateChange(newVal) {
      this.minEndTime = this.dealDate(newVal)
      this.liveEndTimeChange(this.minEndTime)
    },
    liveEndTimeChange(minEndTime) {
      if (this.liveForm.liveStartDate === this.liveForm.liveEndDate && !minEndTime) {
        if (this.liveForm.liveStartTime !== '' && this.minEndTime !== '24:00') {
          this.minEndTime = this.liveForm.liveStartTime
        }
      } else if (this.liveForm.liveStartDate === this.liveForm.liveEndDate && this.liveForm.liveStartTime) {
        // 日期相同时开始时间选择过以后选择的结束时间大于开始时间
        let minTime = this.del0(this.liveForm.liveStartTime.split(':'))
        let h = +minTime[0]
        let m = +minTime[1]
        if (m > 44) {
          if (h > 22) {
            this.minEndTime = '24:00'
          } else {
            this.minEndTime = this.get0(h + 1) + ':' + this.get0(m - 46)
          }
        } else {
          this.minEndTime = this.get0(h) + ':' + this.get0(m + 14)
        }
      }
    },
    getWelData(data) {
      this.submit(data)
    },
    submit(data) {
      if (this.shareForm.targetType === 1) {
        // 客户
        if (this.sendUser === 1) {
          // 全部成员
          this.shareForm.sendWeUser = {}
        } else if (this.sendUser === 2) {
          // 部分成员
          // console.log(this.shareForm.sendWeUser.weUserIds)
          if (
            this.shareForm.sendWeUser &&
            this.shareForm.sendWeUser.weUserIds &&
            this.shareForm.sendWeUser.weUserIds.length
          ) {
            this.userInfo = ''
          } else {
            this.userInfo = '请选择员工'
            return
          }
        }
      }
      if (this.sendCustomer === 1) {
        // 全部客户
        this.shareForm.sendTarget = {}
      } else if (this.sendCustomer === 2) {
        // 部分客户
        if (
          this.shareForm.sendTarget &&
          this.shareForm.sendTarget.tagIdsOrOwnerIds &&
          this.shareForm.sendTarget.tagIdsOrOwnerIds.length
        ) {
          this.groupInfo = ''
          this.customerInfo = ''
        } else {
          if (this.shareForm.targetType === 1) {
            this.customerInfo = '请选择发送客户'
            return
          } else if (this.shareForm.targetType === 2) {
            this.groupInfo = '请选择群主'
            // return
          }
        }
      }
      let query = { ...this.shareForm, ...this.liveForm }
      if (data) {
        query.attachments = [
          {
            content: data.templateInfo,
            msgType: 'text',
          },
        ]
        query.attachments.push(...data.attachments)
      } else if (this.materialData.templateInfo) {
        query.attachments = [
          {
            content: this.materialData.templateInfo,
            msgType: 'text',
          },
        ]
        if (this.weLiveAttachments && this.weLiveAttachments.length) {
          query.attachments.push(...this.weLiveAttachments)
        } else if (this.shareForm.weLiveAttachments) {
          query.attachments = []
          query.attachments.push(...this.shareForm.weLiveAttachments)
        }
      } else if (!this.materialData.templateInfo) {
        // query.attachments.push(...this.shareForm.weLiveAttachments)
        this.$message.error('请输入群发内容')
        return
      }
      delete query.liveUserName
      delete query.sendTargetNames
      delete query.sendWeuserNames
      this.saveLoading = true
      if (query.id && data !== false) {
        this.$confirm('是否确认保存当前直播分享设置？由于企微限制，直播邀请消息一天内仅可向客户发送一次。', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(() => {
          addOrUpdate(query)
            .then((res) => {
              if (res.code === 200) {
                this.$router.back()
              }
            })
            .finally((error) => {
              this.saveLoading = false
            })
        })
      } else {
        addOrUpdate(query)
          .then((res) => {
            if (res.code === 200) {
              this.$router.back()
            }
          })
          .finally((error) => {
            this.saveLoading = false
          })
      }
    },
    radioChange(val) {
      if (val === 2) {
        this.sendUsers = []
        this.shareForm.sendWeUser = {}
      }
    },
    customerRadioChange(val) {
      if (val === 2) {
        this.sendCustomers = []
        this.shareForm.sendTarget = {}
      }
    },
    // customerGroupChange(val) {
    //   if (val === 2) {
    //     this.sendCustomers = []
    //     this.shareForm.sendTarget = {}
    //   }
    // },
    cancelFn() {
      this.$router.back()
    },
    nextStep(nextStep) {
      let form = ''
      if (nextStep == 1) {
        form = 'liveForm'
      } else if (nextStep == 2) {
        form = 'shareForm'
      }

      this.$refs[form].validate((validate) => {
        if (this.liveForm.liveWeUserid) {
          this.liveUserInfo = ''
        } else {
          this.liveUserInfo = '请选择直播成员'
          return
        }
        if (validate) {
          let id = this.liveForm.liveWeUserid.split(',')
          if (id.length > 1) {
            this.$message.error('直播成员有且仅有一人')
            return
          }
          if (this.dealTime(this.liveForm)) {
            this.$message.error('开始时间必须早于结束时间')
            return
          }
          if (nextStep === 2) {
          } else {
            this.active = nextStep
          }
        }
      })
    },
    // 直播成员-选择员工
    onSelectUser() {
      this.selectedUserList = []
      let arr = []
      if (this.liveForm.liveWeUserid) {
        arr = this.liveForm.liveWeUserid.split(',').map((dd, index) => {
          return {
            userId: dd,
            name: this.liveForm.liveUserName.split(',')[index],
          }
        })
      }
      this.selectedUserList = arr
      this.dialogVisibleSelectUser = true
    },
    // 发送成员-选择员工
    onSendSelectUser() {
      this.sendSelectedUserList = []
      let arr = []
      if (this.shareForm.sendWeUser && this.shareForm.sendWeUser.weUserIds) {
        arr = this.shareForm.sendWeUser.weUserIds.map((dd, index) => {
          return {
            userId: dd,
            name: this.shareForm.sendWeuserNames.split(',')[index],
          }
        })
      }
      this.dialogVisibleSendSelectUser = true
      this.sendSelectedUserList.push(...arr)
    },
    // 发送客群-选择群主
    onGroupSelectUser() {
      this.selectedTagList = []
      let arr = []
      if (this.shareForm.sendTarget && this.shareForm.sendTarget.tagIdsOrOwnerIds) {
        arr = this.shareForm.sendTarget.tagIdsOrOwnerIds.map((dd, index) => {
          return {
            userId: dd,
            name: this.shareForm.tagNamesOrGroupOwners.split(',')[index],
          }
        })
      }
      this.selectedTagList = arr
      this.dialogVisibleSelectCustomers = true
    },
    selectedFn() {
      this.selectedTagList = []
      let arr = []
      if (this.sendCustomers) {
        arr = this.sendCustomers.map((dd) => ({
          tagId: dd.tagId,
          name: dd.tagName,
        }))
      }
      this.selectedTagList = arr
      this.dialogVisibleSelectTag = true
    },
    // 选择成功后
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
      this.liveForm.liveWeUserid = ids.join(',')
      this.liveForm.liveUserName = names.join(',')
    },
    sendSelectedUser(users) {
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
      this.sendUsers = selectedUserList
      if (this.shareForm.sendWeUser) {
        this.shareForm.sendWeUser.weUserIds = ids
      }

      this.shareForm.sendWeuserNames = names.join(',')
    },
    sendSelectedCustomer(users) {
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
      this.sendGroupCustomers = selectedUserList
      this.shareForm.sendTarget.tagIdsOrOwnerIds = ids
      this.shareForm.tagNamesOrGroupOwners = names.join(',')
    },
    submitSelectTag(data) {
      let ids = []
      let names = []
      const selectedUserList = data.map((d) => {
        ids.push(d.tagId)
        names.push(d.name)
        return {
          tagId: d.tagId,
          tagName: d.name,
        }
      })
      this.sendCustomers = selectedUserList
      this.shareForm.sendTarget.tagIdsOrOwnerIds = ids
      // this.shareForm.sendWeuserNames = names.join(',')
    },
    // 获取直播详情
    getDeatil(id) {
      detailLive(id)
        .then(({ data }) => {
          this.liveEndDateChange(data.liveEndDate)
          this.liveStartDateChange(data.liveStartDate)
          this.liveForm = {}
          let liveForm = {}
          liveForm.id = data.id
          liveForm.liveTitle = data.liveTitle
          liveForm.liveStartDate = data.liveStartDate
          liveForm.liveStartTime = data.liveStartTime
          liveForm.liveEndDate = data.liveEndDate
          liveForm.liveEndTime = data.liveEndTime
          liveForm.liveDesc = data.liveDesc
          liveForm.startReminder = data.startReminder === 0 ? '' : data.startReminder
          liveForm.liveWeUserid = data.liveWeUserid
          liveForm.liveUserName = data.liveUserName
          this.liveForm = JSON.parse(JSON.stringify(liveForm))
          this.shareForm = JSON.parse(JSON.stringify(data))
          this.liveUrl = data.shareOrJoinUrl
          if (data.targetType === 1) {
            // 客群
            // if (data.sendWeUser?.weUserIds?.length == 0) {
            //   // 全部成员
            //   this.sendUser = 1
            // } else
            if (data.sendWeUser?.weUserIds?.length) {
              // 部分成员
              this.sendUser = 2
            }
          }
          // if (this.shareForm.sendTarget?.tagIdsOrOwnerIds?.length == 0) {
          //   // 全部客户
          //   this.sendCustomer = 1
          // } else
          if (this.shareForm.sendTarget?.tagIdsOrOwnerIds?.length) {
            // 部分客户
            this.sendCustomer = 2
          }
          this.materialData = {
            templateInfo: data.weLiveAttachments ? data.weLiveAttachments[0].content : '',
            attachments: data.weLiveAttachments,
          }
          this.talkList = this.materialData.attachments
          // 获取员工列表
          this.setUserData()
          this.setSendUserData(data)
          if (data.targetType === 1) {
            this.setTargeData(data)
          } else if (data.targetType === 2) {
            this.setGroupUserData(data)
          }
        })
        .catch(() => {})
    },
    setUserData() {
      this.selectedUserList = []
      let arr = []
      if (this.liveForm.liveWeUserid) {
        arr = this.liveForm.liveWeUserid.split(',').map((dd, index) => {
          return {
            userId: dd,
            name: this.liveForm.liveUserName,
          }
        })
      }
      this.users = arr
    },
    setSendUserData(data) {
      this.sendSelectedUserList = []
      let arr = []
      if (data.sendWeUser && data.sendWeUser.weUserIds && data.sendWeUser.weUserIds.length) {
        arr = data.sendWeUser.weUserIds.map((dd, index) => {
          return {
            userId: dd,
            name: data.sendWeuserNames.split(',')[index],
          }
        })
      }
      this.sendUsers = arr
    },
    setGroupUserData(data) {
      this.selectedTagList = []
      let arr = []
      if (data.sendTarget && data.sendTarget.tagIdsOrOwnerIds) {
        arr = data.sendTarget.tagIdsOrOwnerIds.map((dd, index) => {
          return {
            userId: dd,
            name: data.tagNamesOrGroupOwners.split(',')[index],
          }
        })
      }
      this.sendGroupCustomers = arr
    },
    setTargeData(data) {
      this.selectedTagList = []
      let arr = []
      if (data.sendTarget && data.sendTarget.tagIdsOrOwnerIds) {
        arr = data.sendTarget.tagIdsOrOwnerIds.map((dd, index) => {
          return {
            tagId: dd,
            tagName: data.tagNamesOrGroupOwners.split(',')[index],
          }
        })
      }
      this.sendCustomers = arr
    },
    // 补零
    get0(num) {
      if (num < 10) {
        num = '0' + num
      }
      return num
    },
    //去0
    del0(numList) {
      let list = JSON.parse(JSON.stringify(numList))
      let arr = []
      list.map((item) => {
        let a = item.split('')
        if (a[0] === '0') {
          arr.push(a[1])
        } else {
          arr.push(item)
        }
      })
      return arr
    },
    // 开始时间必须早于结束时间
    dealTime(query) {
      let startDate = this.del0(query.liveStartDate.split('-'))
      let endDate = this.del0(query.liveEndDate.split('-'))
      let startTime = this.del0(query.liveStartTime.split(':'))
      let endTime = this.del0(query.liveEndTime.split(':'))
      if (+startDate[0] > +endDate[0]) {
        return true
      } else if (+startDate[0] === +endDate[0]) {
        if (+startDate[1] > +endDate[1]) {
          return true
        } else if (+startDate[1] === +endDate[1]) {
          if (+startDate[2] > +endDate[2]) {
            return true
          } else if (+startDate[2] === +endDate[2]) {
            if (+startTime[0] > +endTime[0]) {
              return true
            } else if (+startTime[0] === +endTime[0]) {
              if (+startTime[1] > +endTime[1]) {
                return true
              }
            }
          }
        }
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.pickerStyle {
  display: flex;
  .el-form-item {
    padding: 0 !important;
  }
}
.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
