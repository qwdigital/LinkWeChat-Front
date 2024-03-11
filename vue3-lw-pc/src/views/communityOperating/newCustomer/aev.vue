<script>
import { getDetail, add, update } from './api'

export default {
  components: { SelectGroup: defineAsyncComponent(() => import('@/components/SelectGroup.vue')) },
  data() {
    return {
      selectedUserList: [],
      newGroupId: '',
      dialogVisibleSelectUser: false, // 选择员工会话
      dialogVisibleSelectTag: false, // 选择客户标签会话
      dialogVisibleSelectGroup: false, // 选择客群弹窗
      loading: false,
      form: {
        codeName: '', // 活码名称
        emplList: [], // 员工
        welcomeMsg: '', //加群引导语
        groupCodeId: undefined, // 群活码ID
        skipVerify: false, // 无需确认自动加好友
        // users: [],
        // tags: [], // 客户标签
      },
      // codes: [],
      // groupQrCode: {},
      rules: Object.freeze({
        codeName: [{ required: true, message: '必填项', trigger: 'blur' }],
        users: [{ required: true, message: '必填项', trigger: 'blur' }],
        // tags: [{ required: true, message: '必填项', trigger: 'change' }],
        welcomeMsg: [{ required: true, message: '必填项', trigger: 'blur' }],
        groups: [{ required: true, message: '必填项', trigger: 'change' }],
        linkTitle: [{ required: true, message: '必填项', trigger: 'blur' }],
        linkDesc: [{ required: true, message: '必填项', trigger: 'blur' }],
        // groupCodeId: [{ required: true, message: '必填项', trigger: 'blur' }],
      }),
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
  },
  watch: {
    // tags: {
    //   deep: true,
    //   handler(tags) {
    //     this.form.tagList = tags.map((t) => t.tagId)
    //   },
    // },
    // users: {
    //   deep: true,
    //   handler(users) {
    //     this.form.emplList = users.map((u) => u.businessId)
    //     this.$refs.form.validateField('emplList')
    //   },
    // },
  },
  created() {
    this.$route.query.id && this.getDetail(this.$route.query.id)
  },
  methods: {
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id).then(({ data }) => {
        this.form = data

        // if (data.groupCodeInfo && data.groupCodeInfo.id) {
        //   this.codes = [data.groupCodeInfo]
        //   this.groupQrCode = data.groupCodeInfo
        //   this.form.groupCodeId = data.groupCodeInfo.id
        // } else {
        //   this.codes = []
        //   this.groupQrCode = {}
        //   this.form.groupCodeId = ''
        // }

        this.loading = false
      })
    },
    // 选择二维码确认按钮
    // submitSelectQrCode(data) {
    //   this.groupQrCode = data
    //   this.form.groupCodeId = data.id
    //   this.$refs.form.validateField('groupCodeId')
    // },
    submit() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.loading = true
          ;(this.$route.query.id ? update : add)(this.form)
            .then(() => {
              this.msgSuccess()
              this.loading = false
              this.$router.back()
            })
            .catch(() => {
              this.loading = false
            })
        }
      })
    },
  },
}
</script>

<template>
  <div v-loading="loading">
    <div class="flex">
      <el-form
        :model="form"
        ref="form"
        :rules="rules"
        label-width="100px"
        scroll-to-error
        class="fxauto g-margin-r"
        :class="isDetail && 'form-detail'"
        :disabled="isDetail">
        <div class="g-card">
          <div class="g-card-title fxbw">
            基础信息
            <el-tag
              class="cp"
              v-if="isDetail"
              size="large"
              effect="dark"
              @click="$router.push({ path: './aev', query: { id: $route.query.id } })">
              编辑
            </el-tag>
          </div>
          <el-form-item label="活码名称" prop="codeName">
            <el-input v-model="form.codeName" maxlength="30" show-word-limit placeholder="请输入" clearable></el-input>
          </el-form-item>
          <el-form-item label="使用员工" prop="users">
            <div v-if="!isDetail">
              <el-button type="primary" @click="dialogVisibleSelectUser = true">选择员工</el-button>
            </div>
            <TagEllipsis :list="form.users" limit="10" emptyText></TagEllipsis>
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
            <template v-if="!isDetail">
              <el-button type="primary" @click="dialogVisibleSelectTag = true">选择标签</el-button>
              <div class="g-tip">通过此群活码进群的客户自动打上选中的标签</div>
            </template>
            <TagEllipsis :list="form.tags" limit="10" emptyText></TagEllipsis>
          </el-form-item>
          <el-form-item label="添加设置" prop="skipVerify">
            <el-checkbox v-model="form.skipVerify">客户添加时无需经过确认自动成为好友</el-checkbox>
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
          <el-form-item label="活码客群:" prop="groups">
            <template v-if="!isDetail">
              <el-button type="primary" @click="dialogVisibleSelectGroup = true">选择客群</el-button>
              <div class="g-tip">最多选择五个客群</div>
            </template>
            <TagEllipsis :list="form.groups" limit="5" defaultProps="groupName" emptyText></TagEllipsis>
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
            <el-input
              v-model="form.linkDesc"
              maxlength="30"
              show-word-limit
              placeholder="请输入"
              clearable
              type="textarea"
              :autosize="{ minRows: 3, maxRows: 20 }"></el-input>
          </el-form-item>
          <el-form-item label="链接封面" prop="linkCoverUrl">
            <upload v-model:fileUrl="form.linkCoverUrl" type="0" :maxSize="2" :format="['jpg', 'jpeg', 'png']">
              <template #tip><div>支持jpg/jpeg/png格式，图片大小不超过2M</div></template>
            </upload>
          </el-form-item>
        </div>
      </el-form>
      <div>
        <div class="g-card sticky-t" v-if="isDetail">
          <div class="g-card-title">活码</div>
          <div class="ac">
            <el-image class="" :src="form.emplCodeUrl" fit="contain" style="width: 120px"></el-image>
            <div class="mt10">
              <el-button text @click="downloadBlob(form.emplCodeUrl, '新客拉群活码.png', 'image')">下载活码</el-button>
              <el-button class="copy" text @click="$copyText(form.emplCodeUrl)">复制链接</el-button>
            </div>
          </div>
        </div>
        <div class="preview-wrap g-card sticky-t">
          <div class="g-card-title">预览</div>
          <PhoneDialog
            :list="[
              { text: form.welcomeMsg || '请输入加群引导语' },
              { title: form.linkTitle, desc: form.linkDesc, image: form.linkCoverUrl },
            ]" />
        </div>
      </div>
    </div>

    <div class="g-footer-sticky" style="z-index: 10" v-if="!isDetail">
      <el-button type="primary" @click="submit">保存</el-button>
      <el-button @click="$router.back()">取消</el-button>
    </div>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      :defaultValues="form.users"
      @success="(data) => ((form.users = data), $refs.form.validateField('users'))"></SelectUser>

    <!-- 选择标签弹窗 -->
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      :selected="form.tags"
      @success="(data) => ((form.tags = data), $refs.form.validateField('tags'))"></SelectTag>

    <!-- 选择客群弹窗 -->
    <SelectGroup
      v-model:visible="dialogVisibleSelectGroup"
      :defaults="form.groups"
      @submit="(data) => ((form.groups = data), $refs.form.validateField('groups'))"></SelectGroup>

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
.welcome-input {
  display: table;
  width: 80%;
  margin: 0 auto 20px;
}
.code-image {
  width: 100px;
  height: 100px;
}

.msg-title {
  font-weight: 500;
}
.msg-content {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  margin-top: 2px;
}
.msg-desc {
  font-size: 12px;
  color: var(--font-black-6);
}
.phone-dialog-image {
  width: 50px;
  height: 50px;
  border-radius: 6px;
  border: 1px solid var(--border-black-11);
}
</style>
