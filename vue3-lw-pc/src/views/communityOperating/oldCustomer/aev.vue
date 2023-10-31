<template>
  <div class="flex">
    <el-form
      v-loading="loading"
      :model="form"
      ref="form"
      :rules="rules"
      label-width="100px"
      class="fxauto g-margin-r"
      :class="isDetail && 'form-detail'"
      :disabled="isDetail">
      <div class="g-card">
        <div class="g-card-title fxbw">
          群发设置
          <el-tag
            class="cp"
            v-if="isDetail"
            size="large"
            effect="dark"
            @click="$router.push({ path: './aev', query: { id: $route.query.id } })">
            同步
          </el-tag>
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
          <CustomerRangeForm :form="form.weCustomersQuery" label-width="100px" />
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
          <template v-if="form.linkTitle">
            <div style="line-height: 1.5">
              <div class="msg-title">{{ form.linkTitle }}</div>
              <div class="msg-content">
                <div class="msg-desc">{{ form.linkDesc }}</div>
                <el-image class="phone-dialog-image fxnone" :src="form.linkCoverUrl" fit="contain"></el-image>
              </div>
            </div>
          </template>
        </PhoneDialog>
      </div>
    </div>
  </div>
</template>

<script>
import { getDetail, add, update } from './api'
import { getCustomerList } from '@/api/groupMessage'
import { getList } from '@/api/salesCenter/businessConver.js'
import PhoneDialog from '@/components/PhoneDialog'
export default {
  components: { PhoneDialog, SelectGroup: defineAsyncComponent(() => import('@/components/SelectGroup.vue')) },
  data() {
    return {
      taskId: '',

      dialogVisibleSelectGroup: false,
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
        weCustomersQuery: {},
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
      sendScopeOptions: [
        { label: '全部客户', value: 0 },
        { label: '部分客户', value: 1 },
      ],
      rules: Object.freeze({
        taskName: [{ required: true, message: '必填项', trigger: 'blur' }],
        welcomeMsg: [{ required: true, message: '必填项', trigger: 'blur' }],
        groups: [{ required: true, message: '必填项', trigger: 'blur' }],
        // sendType: [{ required: true, message: '必填项', trigger: 'blur' }],
        sendScope: [{ required: true, message: '必填项', trigger: 'blur' }],
        linkTitle: [{ required: true, message: '必填项', trigger: 'change' }],
        linkDesc: [{ required: true, message: '必填项', trigger: 'change' }],
      }),
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
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

    getList().then((res) => {
      this.stageList = res.data
    })
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
