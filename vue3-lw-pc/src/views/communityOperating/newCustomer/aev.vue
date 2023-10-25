<script>
import { getDetail, add, update } from '@/api/communityOperating/newCustomer'
import PhoneDialog from '@/components/PhoneDialog'

export default {
  components: { PhoneDialog },
  data() {
    return {
      selectedUserList: [],
      newGroupId: '',
      dialogVisibleSelectUser: false, // 选择员工会话
      dialogVisibleSelectTag: false, // 选择客户标签会话
      dialogVisibleSelectQrCode: false, // 选择群活码会话
      loading: false,
      form: {
        codeName: '', // 活码名称
        emplList: [], // 员工
        welcomeMsg: '', //加群引导语
        groupCodeId: undefined, // 群活码ID
        tagList: [], // 客户标签
        skipVerify: 0, // 无需确认自动加好友
        users: [],
        tags: [],
      },
      codes: [],
      groupQrCode: {},
      rules: Object.freeze({
        codeName: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        emplList: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        tagList: [{ required: true, message: '该项为必填项', trigger: 'change' }],
        groupCodeId: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
        welcomeMsg: [{ required: true, message: '该项为必填项', trigger: 'blur' }],
      }),
    }
  },
  watch: {
    tags: {
      deep: true,
      handler(tags) {
        this.form.tagList = tags.map((t) => t.tagId)
      },
    },
    users: {
      deep: true,
      handler(users) {
        this.form.emplList = users.map((u) => u.businessId)
        this.$refs.form.validateField('emplList')
      },
    },
  },
  created() {
    this.newGroupId = this.$route.query.id
    this.newGroupId && this.getDetail(this.newGroupId)
    // this.$route.meta.title = (this.newGroupId ? '编辑' : '新建') + '新客自动拉群'
  },
  methods: {
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id).then(({ data }) => {
        this.form.codeName = data.codeName || ''
        this.form.skipVerify = data.skipVerify || 0
        this.form.welcomeMsg = data.welcomeMsg || ''

        if (data.groupCodeInfo && data.groupCodeInfo.id) {
          this.codes = [data.groupCodeInfo]
          this.groupQrCode = data.groupCodeInfo
          this.form.groupCodeId = data.groupCodeInfo.id
        } else {
          this.codes = []
          this.groupQrCode = {}
          this.form.groupCodeId = ''
        }

        this.tags = data.tagList || []
        this.users = data.emplList || []

        this.loading = false
      })
    },
    // 选择人员变化事件
    submitSelectUser(users) {
      this.users = users.map((d) => {
        return {
          businessId: d.id || d.userId,
          businessName: d.name,
          businessIdType: d.userId ? 2 : 1,
          mobile: d.mobile,
          empleCodeId: d.empleCodeId,
        }
      })
    },
    onSelectUser() {
      this.selectedUserList = []
      let arr = []
      if (this.users && this.users.length) {
        arr = this.users.map((dd, index) => {
          return {
            userId: dd.businessId,
            name: dd.businessName,
          }
        })
      }
      this.selectedUserList = arr
      this.dialogVisibleSelectUser = true
    },
    // 客户标签选择
    submitSelectTag(tags) {
      this.tags = tags.map((t) => {
        return {
          tagId: t.tagId,
          tagName: t.name,
        }
      })
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
          if (this.newGroupId) {
            update(this.newGroupId, this.form)
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
        }
      })
    },
  },
}
</script>

<template>
  <div v-loading="loading">
    <div class="flex">
      <el-form :model="form" ref="form" :rules="rules" label-width="100px" class="fxauto g-margin-r">
        <div class="g-card">
          <div class="g-card-title">基础信息</div>
          <el-form-item label="活码名称" prop="codeName">
            <el-input v-model="form.codeName" maxlength="30" show-word-limit placeholder="请输入" clearable></el-input>
          </el-form-item>
          <el-form-item label="使用员工" prop="emplList">
            <el-button type="primary" @click="onSelectUser">选择员工</el-button>
            <br />
            <TagEllipsis :list="form.users" limit="10" defaultProps="businessName"></TagEllipsis>
          </el-form-item>

          <!-- <el-form-item label="选择群活码" prop="groupCodeId">
            <el-image
              style="width: 160px; height: 160px"
              v-if="groupQrCode && groupQrCode.codeUrl"
              :src="groupQrCode.codeUrl"
              class="code-image mr10"></el-image>
            <el-button type="primary" plain icon="el-icon-plus" @click="dialogVisibleSelectQrCode = true">
              {{ groupQrCode && groupQrCode.codeUrl ? '修改' : '选择' }}
            </el-button>
          </el-form-item> -->
          <el-form-item label="入群标签" prop="tags">
            <!-- closable -->
            <el-button type="primary" @click="dialogVisibleSelectTag = true">选择标签</el-button>
            <div class="tip">通过此群活码进群的客户自动打上标签</div>
            <TagEllipsis :list="form.tags" limit="10" defaultProps="tagName"></TagEllipsis>
          </el-form-item>
          <el-form-item label="添加设置" prop="skipVerify">
            <el-checkbox :true-label="1" :false-label="0" v-model="form.skipVerify">
              客户添加时无需经过确认自动成为好友
            </el-checkbox>
          </el-form-item>
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
              clearable></TextareaExtend>
          </el-form-item>
          <el-form-item label="活码客群:" prop="chatIdList">
            <el-button type="primary" @click="selectGroupFn">选择客群</el-button>
            <div class="tip">最多选择五个客群</div>
            <TagEllipsis :list="form.groupList" limit="10" defaultProps="groupName"></TagEllipsis>
          </el-form-item>

          <el-form-item label="群满自动建群:">
            <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
            <div class="sub-des">默认以第一个群的群主作为新建群的群主</div>
          </el-form-item>
          <el-form-item v-if="form.autoCreateRoom" label="">
            <el-card>
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
            </el-card>
          </el-form-item>

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
      </el-form>
      <div>
        <div class="g-card" v-if="form.id"></div>
        <div class="preview-wrap g-card">
          <!-- 预览 -->
          <PhoneDialog :message="form.welcomeMsg || '请输入加群引导语'">
            <div v-if="groupQrCode.linkCoverUrl">
              <div class="msg-title">{{ form.linkTitle }}</div>
              <div>
                <div class="msg-title">{{ form.linkDesc }}</div>
                <el-image class="phone-dialog-image" :src="groupQrCode.linkCoverUrl" fit="fill"></el-image>
              </div>
            </div>
          </PhoneDialog>
        </div>
      </div>
    </div>

    <div class="g-footer-sticky">
      <el-button type="primary" @click="submit">保存</el-button>
      <el-button @click="$router.back()">取消</el-button>
    </div>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      :isWechat="false"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      :defaultValues="selectedUserList"
      @success="submitSelectUser"></SelectUser>

    <!-- 选择标签弹窗 -->
    <SelectTag v-model:visible="dialogVisibleSelectTag" :selected="tags" @success="submitSelectTag"></SelectTag>

    <!-- 选择二维码弹窗 -->
    <!-- <SelectQrCode
      v-model:visible="dialogVisibleSelectQrCode"
      @success="submitSelectQrCode"
      :selected="codes"></SelectQrCode> -->
  </div>
</template>

<style lang="scss" scoped>
.wrap {
  display: flex;
  margin-top: 24px;
  .el-form {
    margin-right: 10%;
  }
}
.preview-wrap {
  line-height: 26px;
}
.tip {
  color: var(--font-black-6);
}
.welcome-input {
  display: table;
  width: 80%;
  margin: 0 auto 20px;
}
.code-image {
  width: 100px;
  height: 100px;
}
.phone-dialog-image {
  border-radius: 6px;
  width: 100px;
}
</style>
