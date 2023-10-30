<template>
  <div class="flex" v-loading="loading">
    <el-form :model="form" ref="form" :rules="rules" label-width="100px" class="fxauto g-margin-r">
      <div class="g-card">
        <div class="g-card-title fxbw">
          群发设置
          <el-button
            v-if="isDetail"
            type="primary"
            @click="$router.push({ path: './aev', query: { id: $route.query.id } })">
            同步
          </el-button>
        </div>

        <el-form-item label="任务名称" prop="taskName">
          <el-input v-model="form.taskName" show-word-limit placeholder="请输入" clearable />
        </el-form-item>

        <el-form-item label="发送范围" prop="sendScope">
          <el-radio-group v-model="form.sendScope">
            <el-radio v-for="(target, index) in sendScopeOptions" :key="index" :label="target.value">
              {{ target.label }}
            </el-radio>
          </el-radio-group>
        </el-form-item>

        <template v-if="form.sendScope == 1">
          <el-form-item label="添加人员">
            <el-button type="primary" @click="dialogVisibleSelectUser = true" :disabled="form.sendScope == 0">
              选择人员
            </el-button>
            <br />
            <TagEllipsis :list="form.users" limit="10"></TagEllipsis>

            <SelectUser
              v-model:visible="dialogVisibleSelectUser"
              title="选择人员"
              @success="submitSelectUser"></SelectUser>
          </el-form-item>

          <el-form-item label="客户类型" prop="customerType">
            <el-checkbox-group v-model="form.sendGender" :disabled="form.sendScope == 0">
              <el-checkbox v-for="(item, index) in { 1: '微信用户', 2: '企业用户' }" :key="key" :label="key">
                {{ item }}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>

          <el-form-item label="客户性别" prop="sendGender">
            <el-checkbox-group v-model="form.sendGender" :disabled="form.sendScope == 0">
              <el-checkbox v-for="(sendGender, index) in sendGenderOptions" :key="index" :label="sendGender.value">
                {{ sendGender.label }}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>

          <el-form-item label="添加时间">
            <el-date-picker
              v-model="dateRange"
              value-format="YYYY-MM-DD"
              type="daterange"
              v-bind="pickerOptions"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              align="right"
              :disabled="form.sendScope == 0"></el-date-picker>
          </el-form-item>

          <el-form-item label="客户标签" prop="tagList">
            <el-button type="primary" @click="dialogVisibleSelectTag = true" :disabled="form.sendScope == 0">
              选择标签
            </el-button>
            <SelectTag v-model:visible="dialogVisibleSelectTag" :selected="tags" @success="submitSelectTag"></SelectTag>

            <div>
              <el-radio-group v-model="isContain" @change="">
                <el-radio
                  v-for="(item, key) in { 1: '包含全部选中标签', 2: '包含全部选中标签', 3: '包含全部选中标签' }"
                  :key="key"
                  :label="key">
                  {{ item }}
                </el-radio>
              </el-radio-group>
            </div>

            <TagEllipsis :list="form.tags" limit="10"></TagEllipsis>
          </el-form-item>
          <el-form-item label="商机阶段" prop="sendType">
            <el-select v-model="query.sendType" placeholder="请选择">
              <el-option
                v-for="(sendType, index) in sendTypeOptions"
                :label="sendType.label"
                :value="sendType.value"
                :key="index"></el-option>
            </el-select>
          </el-form-item>
        </template>
      </div>

      <div class="g-card">
        <div class="g-card-title">拉群设置</div>
        <el-form-item label="加群引导语" prop="welcomeMsg">
          <TextareaExtend
            v-model="form.welcomeMsg"
            maxlength="220"
            show-word-limit
            :autosize="{ minRows: 5, maxRows: 20 }"
            placeholder="请输入"
            clearable />
        </el-form-item>
        <el-form-item label="活码客群:" prop="groups">
          <el-button type="primary" @click="dialogVisibleSelectGroup = true">选择客群</el-button>
          <div class="g-tip">最多选择五个客群</div>
          <SelectGroup
            v-model:visible="dialogVisibleSelectGroup"
            :defaults="form.groups"
            @submit="(data) => ((form.groups = data), $refs.form.validateField('groups'))"></SelectGroup>
          <TagEllipsis :list="form.groups" limit="5" defaultProps="groupName"></TagEllipsis>
        </el-form-item>

        <el-form-item label="群满自动建群:">
          <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
          <div class="g-tip">默认以第一个群的群主作为新建群的群主</div>
        </el-form-item>
        <template v-if="form.autoCreateRoom">
          <el-form-item label="群名前缀:" prop="roomBaseName">
            <el-input
              show-word-limit
              maxlength="20"
              v-model="form.roomBaseName"
              placeholder="请输入群名前缀"></el-input>
          </el-form-item>
          <el-form-item label="群起始序号:" prop="roomBaseId">
            <el-input-number v-model="form.roomBaseId" controls-position="right" :min="1"></el-input-number>
          </el-form-item>
        </template>

        <el-form-item label="链接标题" prop="linkTitle">
          <el-input v-model="form.linkTitle" maxlength="20" show-word-limit placeholder="请输入" clearable></el-input>
        </el-form-item>
        <el-form-item label="链接描述" prop="linkDesc">
          <el-input v-model="form.linkDesc" maxlength="30" show-word-limit placeholder="请输入" clearable></el-input>
        </el-form-item>
        <el-form-item label="链接封面" prop="linkCoverUrl">
          <upload v-model:fileUrl="form.linkCoverUrl" type="0" :maxSize="2" :format="['jpg', 'jpeg', 'png']">
            <template #tip><div>支持jpg/jpeg/png格式，图片大小不超过2M</div></template>
          </upload>
        </el-form-item>
        <!-- <el-form-item label="发送方式" prop="sendType">
        <el-radio-group v-model="form.sendType">
          <el-radio
            v-for="(sendType, index) in sendTypeOptions"
            :key="index"
            :label="sendType.value"
            >{{ sendType.label }}</el-radio
          >

          <div class="tip">
            注：客户每天只能接收来自一名成员的一条群发消息，每月最多接收来自同一企业的四条群发消息。
          </div>
        </el-radio-group>
      </el-form-item> -->

        <el-form-item label=" ">
          <el-button type="primary" @click="submit">保存</el-button>
          <el-button @click="$router.back()">取消</el-button>
        </el-form-item>
      </div>
      <div class="g-footer-sticky" style="z-index: 10" v-if="!isDetail">
        <el-button type="primary" @click="submit">保存</el-button>
        <el-button @click="$router.back()">取消</el-button>
      </div>
    </el-form>
    <div>
      <div class="preview-wrap g-card mt0 sticky-t">
        <div class="g-card-title">预览</div>
        <PhoneDialog :message="form.welcomeMsg || '请输入加群引导语'">
          <el-image
            style="border-radius: 6px; width: 100px"
            v-if="groupQrCode?.codeUrl"
            :src="groupQrCode?.codeUrl"></el-image>
        </PhoneDialog>
      </div>
    </div>

    <!-- 选择群活码弹窗 -->
    <!-- <SelectQrCode
      v-model:visible="dialogVisibleSelectQrCode"
      @success="submitSelectQrCode"
      :selected="codes"></SelectQrCode> -->
  </div>
</template>

<script>
import { getDetail, add, update } from '@/api/communityOperating/oldCustomer'
import { getCustomerList } from '@/api/groupMessage'
import PhoneDialog from '@/components/PhoneDialog'
import SelectTag from '@/components/SelectTag'
import SelectQrCode from '@/components/SelectQrCode'
export default {
  components: { PhoneDialog, SelectTag, SelectQrCode },
  data() {
    return {
      taskId: '',
      dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      dialogVisibleSelectQrCode: false,
      loading: false,
      // 表单参数
      form: {
        taskName: '', // 任务名称
        welcomeMsg: '', // 加群引导语
        sendType: 1, // 发送方式
        groupCodeId: '', // 群活码ID
        tagList: [], // 标签
        scopeList: [], // 员工
        sendScope: 0, // 发送范围
        sendGender: null, // 发送性别
        cusBeginTime: '', // 目标客户添加起始时间
        cusEndTime: '', // 目标客户添加结束时间
      },
      tags: [],
      users: [],
      codes: [],
      groupQrCode: {}, // 选择的群活码链接
      dateRange: [],
      // sendTypeOptions: [
      //   { label: '企业群发', value: 0 },
      //   { label: '个人群发', value: 1 }
      // ],
      sendGenderOptions: [
        // { label: '全部', value: null },
        { label: '男', value: 1 },
        { label: '女', value: 2 },
        { label: '未知', value: 0 },
      ],
      sendScopeOptions: [
        { label: '全部客户', value: 0 },
        { label: '部分客户', value: 1 },
      ],
      rules: Object.freeze({
        taskName: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        welcomeMsg: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        groupCodeId: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        // sendType: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        sendScope: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        tagListValidate: [{ required: true, message: '该项为必填项', trigger: 'change' }],
        scopeListValidate: [{ required: true, message: '该项为必填项', trigger: 'change' }],
      }),
    }
  },
  watch: {
    // 日期选择器数据同步至查询参数
    dateRange: {
      deep: true,
      handler(val) {
        if (!val || val.length !== 2) {
          this.form.cusBeginTime = ''
          this.form.cusEndTime = ''
        } else {
          ;[this.form.cusBeginTime, this.form.cusEndTime] = val
        }
      },
    },
    users: {
      deep: true,
      handler(val) {
        this.form.scopeList = val.map((user) => {
          return user.userId
        })
        this.$refs.form.validateField('scopeList')
      },
    },
    tags: {
      deep: true,
      handler(val) {
        this.form.tagList = val.map((tag) => {
          return tag.tagId
        })
        this.$refs.form.validateField('tagList')
      },
    },
  },
  created() {
    this.taskId = this.$route.query.id
    this.taskId && this.getDetail(this.taskId)
  },
  methods: {
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id).then(({ data }) => {
        this.form.taskName = data.taskName || ''
        this.form.welcomeMsg = data.welcomeMsg || ''
        this.form.sendType = data.sendType || 1
        this.form.sendScope = data.sendScope || 0
        this.form.sendGender = data.sendGender || 0

        this.tags = data.tagList || []
        this.users = data.scopeList || []
        this.dateRange = [data.cusBeginTime || '', data.cusEndTime || '']

        if (data.groupCodeInfo && data.groupCodeInfo.id) {
          this.codes = [data.groupCodeInfo]
          this.groupQrCode = data.groupCodeInfo
          this.form.groupCodeId = this.groupQrCode.id
        } else {
          this.codes = []
          this.groupQrCode = {}
          this.form.groupCodeId = ''
        }

        this.loading = false
      })
    },
    // 选择人员事件
    submitSelectUser(users) {
      this.users = users
    },
    // 选择tag事件
    submitSelectTag(tags) {
      this.tags = tags
    },
    // 选择二维码确认按钮
    submitSelectQrCode(data) {
      this.groupQrCode = data
      this.form.groupCodeId = data.id
      this.$refs.form.validateField('groupCodeId')
    },
    submit() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.loading = true
          if (this.form.sendScope) {
            let data = {
              userIds: '',
              tagIds: '',
              beginTime: '',
              endTime: '',
              gender: '',
              customerType: 1,
            }
            data.gender = this.form.sendGender
            data.beginTime = this.form.cusBeginTime
            data.endTime = this.form.cusEndTime
            data.tagIds = this.form.tagList.join(',')
            data.userIds = this.form.scopeList.join(',')
            getCustomerList(data).then((res) => {
              if (res.code === 200) {
                if (res.data && res.data.length) {
                  this.form.externalUserIds = res.data.map((dd) => dd.externalUserid)
                  this.sendData()
                } else {
                  this.msgError('未找到可发送客户！')
                  this.loading = false
                }
              } else {
                this.msgError(res.msg)
                this.loading = false
              }
            })
          } else {
            delete this.form.externalUserIds
            this.sendData()
          }
        }
      })
    },
    sendData() {
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
    },
  },
}
</script>

<style lang="scss" scoped>
.preview-wrap {
  line-height: 26px;
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
