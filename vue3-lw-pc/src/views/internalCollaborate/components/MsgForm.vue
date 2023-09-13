<script>
var validateHttp = (rule, value, callback) => {
  if (/^https?:\/\//gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 http://或 https://开头'))
  }
}
export default {
  name: '',
  components: {},
  props: {
    data: {
      type: Object,
      default: () => ({}),
    },
    disabled: {
      type: Boolean,
    },
  },

  data() {
    return {
      // 表单校验
      form: Object.assign({ scopeType: 1, sendType: 1, weMessageTemplate: { msgType: 'text' } }, this.data),
      rules: Object.freeze({
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        fileUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        title: [{ required: true, message: '不能为空', trigger: 'blur' }],
        msgTitle: [{ required: true, message: '不能为空', trigger: 'blur' }],
        description: [{ required: true, message: '不能为空', trigger: 'blur' }],
        picUrl: [{ required: true, message: '不能为空', trigger: 'blur' }],
        sendTime: [{ required: true, message: '不能为空', trigger: 'blur' }],
        linkUrl: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHttp, trigger: 'blur' },
        ],
      }),
      typeDict: {
        text: '文本',
        image: '图片',
        news: '图文',
        video: '视频',
        file: '文件',
      },

      dialogVisible: false,
    }
  },
  computed: {},
  watch: {
    'form.weMessageTemplate.msgType'(val, oldVal) {
      if (!this.disabled) {
        this.form.weMessageTemplate = { msgType: val }
        if (this.$route.query.posterId && val == 'image') {
          this.form.weMessageTemplate.picUrl = this.$route.query.posterId
        }
      }
    },
  },
  created() {
    if (!this.form.toParty) {
      this.form.toParty = []
      this.form.toPartyName = []
    } else if (typeof this.form.toParty === 'string') {
      this.form.toParty = this.form.toParty.split(',')
      this.form.toPartyName = this.form.toPartyName.split(',')
    }
    if (!this.form.toUser) {
      this.form.toUser = []
      this.form.toUserName = []
    } else if (typeof this.form.toUser === 'string') {
      this.form.toUser = this.form.toUser.split(',')
      this.form.toUserName = this.form.toUserName.split(',')
    }
    if (this.form.robotId) {
      // 机器人消息没有视频类型
      delete this.typeDict.video
    }
    if (this.$route.query.posterId) {
      this.form.weMessageTemplate.msgType = 'image'
      this.form.weMessageTemplate.picUrl = this.$route.query.posterId
    }
  },
  mounted() {},
  methods: {
    selectedUser(value) {
      this.form.toParty = []
      this.form.toPartyName = []
      this.form.toUser = []
      this.form.toUserName = []
      value.map((item) => {
        if (item.isParty) {
          // 部门
          this.form.toParty.push(item.userId)
          this.form.toPartyName.push(item.name)
        } else {
          let isInSelectDepart = item.userDepts.some((e) => value.some((e2) => e2.userId === e.deptId))
          // 人员
          if (!isInSelectDepart) {
            this.form.toUser.push(item.userId)
            this.form.toUserName.push(item.name)
          }
        }
      })
    },
    async submit(status) {
      let form = JSON.parse(JSON.stringify(this.form))
      let valid = await this.$refs['form'].validate()
      valid = await this.$refs['formCon'].validate()
      if (valid) {
        if (form.scopeType == 2 && !form.toParty.concat(form.toUser).length) {
          this.msgError('发送范围不能为空')
        } else if (form.sendType == 2 && new Date(form.sendTime).getTime() <= Date.now()) {
          this.msgError('定时发送时间不能小于当前时间')
        } else {
          form.status = status
          this.$emit('submit', form)
        }
      }
    },
  },
}
</script>

<template>
  <div style="margin: 0 20px" :class="disabled && 'detail-form'">
    <!-- 应用消息 -->
    <el-form
      class="mb20"
      v-if="form.agentId"
      ref="form"
      :model="form"
      :rules="rules"
      :disabled="disabled"
      label-width="100px">
      <div class="">
        <div class="title">
          <span>消息设置</span>
          <span style="font-size: 12px; margin-left: 10px">
            将通过应用
            <span class="theme">【{{ form.agentName }}】</span>
            发送消息
          </span>
        </div>

        <el-form-item label="消息标题" prop="msgTitle">
          <el-input v-model="form.msgTitle" placeholder="请输入标题" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="发送范围" prop="scopeType">
          <el-radio-group v-model="form.scopeType" class="mr20">
            <el-radio :label="1">全部</el-radio>
            <el-radio :label="2">自定义</el-radio>
          </el-radio-group>
          <template v-if="form.scopeType == 2">
            <el-button v-if="!disabled" class="mr10" text @click="dialogVisible = true">选择范围</el-button>
            <TagEllipsis
              v-if="form.toPartyName.concat(form.toUserName).length"
              :list="form.toPartyName.concat(form.toUserName)" />
          </template>
        </el-form-item>
        <el-form-item label="发送类型" prop="sendType">
          <el-radio-group v-model="form.sendType">
            <el-radio :label="1">立即发送</el-radio>
            <el-radio :label="2">定时发送</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="发送时间" v-if="form.sendType == 2" v-model="form.sendType" prop="sendTime">
          <el-date-picker
            v-model="form.sendTime"
            type="datetime"
            value-format="YYYY-MM-DD HH:mm:ss"
            placeholder="选择日期时间"
            v-bind="{
              disabledDate(time) {
                let date = new Date()
                return time.getTime() < date.setDate(date.getDate() - 1)
              },
            }"></el-date-picker>
        </el-form-item>
      </div>
    </el-form>

    <div class="title">消息内容</div>
    <!-- 机器人消息标题 -->
    <el-form
      class=""
      v-if="form.robotId"
      ref="form"
      :model="form"
      :rules="rules"
      :disabled="disabled"
      label-width="100px">
      <el-form-item label="消息标题" prop="msgTitle">
        <el-input v-model="form.msgTitle" placeholder="请输入标题" maxlength="30" show-word-limit></el-input>
      </el-form-item>
    </el-form>

    <el-form ref="formCon" :model="form.weMessageTemplate" :rules="rules" :disabled="disabled" label-width="100px">
      <el-form-item label="内容类型" prop="msgType">
        <el-radio-group v-model="form.weMessageTemplate.msgType">
          <el-radio v-for="(item, label, index) in typeDict" :key="index" :label="label">
            {{ item }}
          </el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="文本内容" prop="content" v-if="form.weMessageTemplate.msgType === 'text'">
        <el-input
          v-model="form.weMessageTemplate.content"
          type="textarea"
          :autosize="{ minRows: 2, maxRows: 50 }"
          placeholder="请输入内容"
          maxlength="2000"
          show-word-limit></el-input>
      </el-form-item>

      <!-- 图片 -->
      <el-form-item label="图片" prop="picUrl" v-else-if="form.weMessageTemplate.msgType === 'image'">
        <Upload v-model:fileUrl="form.weMessageTemplate.picUrl" :maxSize="2" type="0">
          <template #tip><div>支持jpg/jpeg/png格式，图片大小不超过2M</div></template>
        </Upload>
      </el-form-item>

      <!-- 图文 -->
      <template v-else-if="form.weMessageTemplate.msgType === 'news'">
        <el-form-item label="图文地址" prop="linkUrl">
          <el-input
            v-model="form.weMessageTemplate.linkUrl"
            type="text"
            placeholder="请输入图文地址，以http://或https://开头"></el-input>
        </el-form-item>
        <el-form-item label="图文标题" prop="title">
          <el-input
            v-model="form.weMessageTemplate.title"
            type="text"
            :maxlength="60"
            show-word-limit
            placeholder="请输入图文标题"></el-input>
        </el-form-item>
        <el-form-item label="图文描述" prop="description">
          <el-input
            v-model="form.weMessageTemplate.description"
            type="textarea"
            :maxlength="100"
            show-word-limit
            :autosize="{ minRows: 2, maxRows: 50 }"
            placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item label="图文封面">
          <Upload v-model:fileUrl="form.weMessageTemplate.picUrl" type="0">
            <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
          </Upload>
        </el-form-item>
      </template>

      <el-form-item v-else-if="form.weMessageTemplate.msgType === 'video'" label="上传视频" prop="fileUrl">
        <Upload v-model:fileUrl="form.weMessageTemplate.fileUrl" :maxSize="10" :format="['mp4', 'mov']" type="2">
          <template #tip><div>支持mp4/mov格式，视频大小不超过10M</div></template>
        </Upload>
      </el-form-item>

      <el-form-item v-else-if="form.weMessageTemplate.msgType === 'file'" label="上传文件" prop="fileUrl">
        <Upload v-model:fileUrl="form.weMessageTemplate.fileUrl" :maxSize="20" type="3" :isThree="true">
          <template #tip><div>支持pdf/ppt/word文件，单个文件大小不超过20M</div></template>
        </Upload>
      </el-form-item>
    </el-form>

    <div v-if="!disabled" class="mt20 ar">
      <el-button @click="$emit('submit')">取 消</el-button>
      <el-button type="primary" @click="submit(1)">确定发送</el-button>
      <el-button v-if="form.agentId" type="primary" @click="submit(0)">存为草稿</el-button>
    </div>

    <!-- 选择发起员工弹窗 -->
    <SelectUser
      v-if="dialogVisible"
      v-model:visible="dialogVisible"
      append-to-body
      title="选择成员"
      :isOnlyLeaf="false"
      :isSigleSelect="false"
      :destroy-on-close="false"
      :defaultValues="form.toParty.concat(form.toUser)"
      @success="selectedUser"></SelectUser>
  </div>
</template>

<style lang="scss" scoped>
.theme {
  color: var(--color);
}
::v-deep.detail-form {
  .el-input.is-disabled .el-input__inner,
  .el-textarea.is-disabled .el-textarea__inner {
    background-color: transparent;
    // border-color: transparent;
    color: inherit;
    cursor: default;
    // &:hover {
    //   border-color: transparent;
    // }
  }
  .el-radio__input.is-disabled {
    .el-radio__inner {
      background: var(--bg-white);
      border-color: var(--border-black-9);
      cursor: default;
    }
    + span.el-radio__label {
      color: inherit;
      cursor: default;
    }
    &.is-checked .el-radio__inner {
      background-color: var(--color);
      border-color: var(--color);
      cursor: default;

      &::after {
        background: var(--bg-white);
      }
    }
  }

  // .el-input-number__decrease,
  // .el-input-number__increase,
  // .el-input-group__prepend,
  // .el-input-group__append,
  // .el-icon-arrow-up,
  // .el-input__prefix {
  //   display: none;
  // }
}
</style>
