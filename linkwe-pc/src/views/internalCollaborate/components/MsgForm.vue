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
      form: Object.assign(
        { scopeType: 1, sendType: 1, toParty: [], toUser: [], weMessageTemplate: { msgType: 'text' } },
        this.data,
      ),
      rules: Object.freeze({
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        fileUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        title: [{ required: true, message: '不能为空', trigger: 'blur' }],
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
  watch: {},
  created() {},
  mounted() {},
  methods: {
    selectedUser(value) {
      this.form.toParty = []
      this.form.toUser = []
      value.map((item) => {
        if (item.isParty) {
          // 部门
          this.form.toParty.push({
            userId: item.userId,
            name: item.name,
            type: 1,
          })
        } else {
          let isInSelectDepart = item.userDepts.some((e) => value.some((e2) => e2.userId === e.deptId))
          // 人员
          isInSelectDepart ||
            this.form.toUser.push({
              userId: item.userId,
              name: item.name,
              type: 2,
            })
        }
      })
    },
    async submit() {
      let form = JSON.parse(JSON.stringify(this.form))
      let valid = await this.$refs['form'].validate()
      valid = await this.$refs['formCon'].validate()
      if (valid) {
        if (form.scopeType == 2 && !form.toParty.concat(form.toUser).length) {
          this.msgError('发送范围不能为空')
        } else if (form.sendType == 2 && new Date(form.sendTime).getTime() <= Date.now()) {
          this.msgError('定时发送时间不能小于当前时间')
        } else {
          form.toParty = form.toParty.map((e) => e.userId)
          form.toUser = form.toUser.map((e) => e.userId)
          this.$emit('submit', form)
        }
      }
    },
  },
}
</script>

<template>
  <div style="margin: 0 20px">
    <el-form ref="form" :model="form" :rules="rules" label-width="100px">
      <div class="">
        <div class="title">
          <span>消息设置</span>
          <span style="font-size: 12px; margin-left: 10px">将通过应用 【{{ form.agentName }}】 发送消息</span>
        </div>

        <el-form-item label="消息标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入标题" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="发送范围" prop="scopeType">
          <el-radio-group v-model="form.scopeType">
            <el-radio :label="1">全部</el-radio>
            <el-radio :label="2">自定义</el-radio>
            <template v-if="form.scopeType == 2">
              <el-button class="mr10" type="text" @click="dialogVisible = true">选择范围</el-button>
              <TagEllipsis :list="form.toParty.concat(form.toUser)" />
            </template>
          </el-radio-group>
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
            value-format="yyyy-MM-dd hh:mm:ss"
            placeholder="选择日期时间"
            :picker-options="{
              disabledDate(time) {
                let date = new Date()
                return time.getTime() < date.setDate(date.getDate() - 1)
              },
            }"></el-date-picker>
        </el-form-item>
      </div>
    </el-form>

    <div class="mt20">
      <div class="title">消息内容</div>
      <el-form ref="formCon" :model="form.weMessageTemplate" :rules="rules" label-width="100px">
        <el-form-item label="发送类型" prop="msgType">
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
        <el-form-item label="图片" prop="fileUrl" v-else-if="form.weMessageTemplate.msgType === 'image'">
          <Upload :fileUrl.sync="form.weMessageTemplate.fileUrl" :maxSize="20" type="0">
            <div slot="tip">支持jpg/jpeg/png格式，图片大小不超过2M</div>
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
              :maxlength="64"
              show-word-limit
              placeholder="请输入图文标题"></el-input>
          </el-form-item>
          <el-form-item label="图文描述" prop="description">
            <el-input
              v-model="form.weMessageTemplate.description"
              type="textarea"
              :maxlength="200"
              show-word-limit
              :autosize="{ minRows: 2, maxRows: 50 }"
              placeholder="请输入"></el-input>
          </el-form-item>
          <el-form-item label="图文封面">
            <Upload :fileUrl.sync="form.weMessageTemplate.picUrl" type="0">
              <div slot="tip">支持jpg/jpeg/png格式，建议200*200</div>
            </Upload>
          </el-form-item>
        </template>

        <el-form-item v-else-if="form.weMessageTemplate.msgType === 'video'" label="上传视频" prop="fileUrl">
          <Upload :fileUrl.sync="form.weMessageTemplate.fileUrl" :type="2" @getPicUrl="getPicUrl">
            <div slot="tip">支持mp4/mov格式，视频大小不超过100M</div>
          </Upload>
        </el-form-item>

        <el-form-item v-else-if="form.weMessageTemplate.msgType === 'file'" label="上传文件" prop="fileUrl">
          <Upload :fileUrl.sync="form.weMessageTemplate.fileUrl" :type="3" :isThree="true">
            <div slot="tip">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
          </Upload>
        </el-form-item>
      </el-form>
    </div>

    <div v-if="!disabled" class="mt20">
      <el-button @click="$emit('submit')">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </div>

    <!-- 选择发起员工弹窗 -->
    <SelectWeUser
      :visible.sync="dialogVisible"
      append-to-body
      title="选择成员"
      :isOnlyLeaf="false"
      :isSigleSelect="false"
      :destroy-on-close="false"
      :defaultValues="form.toParty.concat(form.toUser)"
      @success="selectedUser"></SelectWeUser>
  </div>
</template>

<style lang="less" scoped></style>
