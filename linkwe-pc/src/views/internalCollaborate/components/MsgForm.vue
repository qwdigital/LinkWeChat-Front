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
  data() {
    return {
      form: { weMessageTemplate: {} },
      // 表单校验
      rules: Object.freeze({
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        fileUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        title: [{ required: true, message: '不能为空', trigger: 'blur' }],
        description: [{ required: true, message: '不能为空', trigger: 'blur' }],
        picUrl: [{ required: true, message: '不能为空', trigger: 'blur' }],
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
  methods: {},
}
</script>

<template>
  <div>
    <el-form ref="form" :model="form" :rules="rules" label-width="100px">
      <div class="g-pad20">
        <div class="title">
          <span>消息设置</span>
          <span>将通过应用 【应用名称】 发送消息</span>
        </div>

        <el-form-item label="消息标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入标题" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="发送范围" required prop="scopeType">
          <el-radio-group v-model="form.scopeType">
            <el-radio :label="1">全部</el-radio>
            <el-radio :label="2">
              自定义
              <template v-if="form.scopeType == 2">
                <TagEllipsis :list="form.sendClientUserList" />
                <el-button class="mr10" size="mini" type="primary" plain @click="dialogVisible = true">
                  选择范围
                </el-button>
              </template>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="发送类型" required prop="sendType">
          <el-radio-group v-model="form.sendType">
            <el-radio :label="1">立即发送</el-radio>
            <el-radio :label="2">
              定时发送
              <div v-if="form.sendType == 2">
                <el-date-picker
                  v-model="form.sendTime"
                  type="datetime"
                  placeholder="选择日期时间"
                  :picker-options="pickerOptions"></el-date-picker>
              </div>
            </el-radio>
          </el-radio-group>
        </el-form-item>
      </div>

      <div class="g-pad20">
        <div class="title">消息设置</div>

        <el-form-item label="发送类型" required prop="msgType">
          <el-radio-group v-model="form.weMessageTemplate.msgType">
            <el-radio v-for="(item, label, index) in typeDict" :key="index" :label="label">
              {{ item }}
            </el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="文本内容" prop="content" v-if="form.msgType === 'text'">
          <el-input
            v-model="form.weMessageTemplate.content"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 50 }"
            placeholder="请输入内容"
            maxlength="2000"
            show-word-limit></el-input>
        </el-form-item>

        <!-- 图片 -->
        <el-form-item label="图片" prop="fileUrl" v-else-if="form.msgType === 'image'">
          <Upload
            :fileUrl.sync="form.weMessageTemplate.fileUrl"
            :fileName.sync="form.weMessageTemplate.materialName"
            :maxSize="20"
            type="0"
            v-if="dialogVisible">
            <div slot="tip">支持jpg/jpeg/png格式，图片大小不超过2M</div>
          </Upload>
        </el-form-item>

        <!-- 图文 -->
        <template v-else-if="form.msgType === 'news'">
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
            <Upload :fileUrl.sync="form.weMessageTemplate.picUrl" type="0" v-if="dialogVisible">
              <div slot="tip">支持jpg/jpeg/png格式，建议200*200</div>
            </Upload>
          </el-form-item>
        </template>

        <el-form-item v-else-if="form.msgType === 'video'" label="上传视频" prop="materialUrl">
          <Upload
            :fileUrl.sync="form.weMessageTemplate.fileUrl"
            :fileName.sync="form.weMessageTemplate.materialName"
            :type="2"
            @getPicUrl="getPicUrl"
            v-if="dialogVisible">
            <div slot="tip">支持mp4/mov格式，视频大小不超过100M</div>
          </Upload>
        </el-form-item>

        <el-form-item v-else-if="form.msgType === 'file'" label="上传文件" prop="materialUrl">
          <Upload
            :fileUrl.sync="form.weMessageTemplate.fileUrl"
            :fileName.sync="form.weMessageTemplate.materialName"
            :type="3"
            v-if="dialogVisible"
            :isThree="true">
            <div slot="tip">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
          </Upload>
        </el-form-item>
      </div>
    </el-form>
    <div>
      <el-button @click="$emit('submit')">取 消</el-button>
      <el-button type="primary" @click="$emit('submit', form)">确 定</el-button>
    </div>

    <!-- 选择发起员工弹窗 -->
    <SelectWeUser
      :visible.sync="dialogVisible"
      append-to-body
      title="选择成员"
      :isOnlyLeaf="false"
      :isSigleSelect="false"
      @success="selectedUser"></SelectWeUser>
  </div>
</template>

<style lang="less" scoped></style>
