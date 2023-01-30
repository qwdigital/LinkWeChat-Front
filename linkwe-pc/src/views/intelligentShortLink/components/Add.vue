<script>
import { touchTypeDict } from './mixin'
export default {
  components: {
    SelectQrCode: () => import('@/components/SelectQrCode.vue'),
    SelectStaffQrCode: () => import('@/components/SelectStaffQrCode.vue'),
  },
  props: {
    form: {
      type: Object,
    },
  },
  data() {
    return {
      rules: {
        shortLinkName: [{ required: true, message: '必填项', trigger: 'blur' }],
        name: [{ required: true, message: '必填项', trigger: 'blur' }],
        describe: [{ required: true, message: '必填项', trigger: 'blur' }],
        longLink: [
          { required: true, message: '必填项', trigger: 'blur' },
          {
            validator(rule, value, callback) {
              if (value && !/^http/gi.test(value)) callback('链接格式错误，需以http(s)开头')
              else callback()
            },
            trigger: 'blur',
          },
        ],
        avatar: [{ required: true, message: '必填项', trigger: 'change' }],
        qrCode: [{ required: true, message: '必填项', trigger: 'change' }],
        qrCodeId: [{ required: true, message: '必填项', trigger: 'change' }],
        appId: [{ required: true, message: '必填项', trigger: 'blur' }],
        secret: [{ required: true, message: '必填项', trigger: 'blur' }],
      },
      touchTypeDict,
      prefixFormLabel: Object.freeze({
        1: '公众号',
        2: '微信',
        3: '微信群',
        10: '小程序',
      }),
      selectQrCodeVisible: false,
      selectStaffQrCodeVisible: false,
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('/detail')
    },
  },
  watch: {},
  created() {},
  mounted() {},
  methods: {
    choiceQqcode(type) {
      this[type == 4 ? 'selectStaffQrCodeVisible' : 'selectQrCodeVisible'] = true
    },
    // 选择二维码确认按钮
    submitSelectQrCode(data) {
      this.form.qrCodeId = data.id
      // this.form.qrCodeName = data.activityName
      this.form.qrCode = data.codeUrl || data.qrCode
      // this.$refs.form.validateField('groupCodeId')
    },
  },
}
</script>

<template>
  <div>
    <el-form
      :class="isDetail && 'form-detail'"
      :disabled="isDetail"
      ref="form"
      :model="form"
      label-suffix="："
      label-width="140px"
      :rules="rules">
      <el-form-item label="短链类型">
        <span>{{ touchTypeDict[form.type].allName }}</span>
      </el-form-item>
      <el-form-item label="短链名称" prop="shortLinkName">
        <el-input clearable v-model="form.shortLinkName" placeholder="请输入" maxlength="30" show-word-limit></el-input>
      </el-form-item>

      <!-- 公众号文章 -->
      <template v-if="form.type == 0">
        <el-form-item prop="longLink" label="公众号文章链接">
          <!-- <template v-if="isDetail">
            {{ form.longLink }}
          </template>
          <template v-else>
          </template> -->
          <el-input clearable v-model="form.longLink" placeholder="请输入"></el-input>
          <div v-if="!isDetail" class="tips">请在公众号后台文章发布列表页中获取并复制文章的永久链接</div>
        </el-form-item>
      </template>

      <!-- 公众号二维码,个人二维码,群二维码,小程序二维码 -->
      <template v-else-if="Object.keys(prefixFormLabel).includes(form.type + '')">
        <el-form-item prop="name" :label="prefixFormLabel[form.type] + '名称'">
          <el-input clearable v-model="form.name" placeholder="请输入" maxlength="15" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="describe" :label="prefixFormLabel[form.type] + '描述'">
          <el-input clearable v-model="form.describe" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="avatar" :label="prefixFormLabel[form.type] + '头像'">
          <upload class="image-uploader" :fileUrl.sync="form.avatar"></upload>
        </el-form-item>
        <el-form-item prop="qrCode" :label="prefixFormLabel[form.type] + '二维码'">
          <upload class="image-uploader" :fileUrl.sync="form.qrCode"></upload>
        </el-form-item>
      </template>
      <!-- 员工活码,客群活码 -->
      <template v-else-if="[4, 5].includes(+form.type)">
        <el-form-item prop="5" :label="'选择' + touchTypeDict[form.type].name">
          <el-image
            v-if="form.qrCode"
            class="mr10"
            style="width: 100px; height: 100px; vertical-align: middle"
            :src="form.qrCode"
            fit="fit"></el-image>
          <!-- <span>{{ form.qrCodeName }}</span> -->
          <el-button type="primary" plain @click="choiceQqcode(form.type, '选择' + touchTypeDict[form.type].name)">
            选择{{ touchTypeDict[form.type].name }}
          </el-button>
        </el-form-item>
      </template>
      <!-- 门店导购活码,门店群活码 -->
      <template v-else-if="[6, 8].includes(+form.type)">
        <el-form-item prop="qrCodeId" :label="touchTypeDict[form.type].name">
          <el-button type="primary" plain @click="choiceQqcode(form.type, '选择' + touchTypeDict[form.type].name)">
            暂无{{ touchTypeDict[form.type].name }}，去配置
          </el-button>
        </el-form-item>
      </template>
      <!-- 个人小程序 -->
      <template v-else-if="form.type == 7">
        <el-form-item prop="name" label="小程序名称">
          <el-input clearable v-model="form.name" placeholder="请输入" maxlength="15" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="avatar" label="小程序头像">
          <upload class="image-uploader" :fileUrl.sync="form.avatar"></upload>
        </el-form-item>
        <el-form-item prop="appId" label="小程序AppID">
          <el-input clearable v-model="form.appId" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="longLink" label="小程序页面路径">
          <el-input clearable v-model="form.longLink" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
      </template>
      <!-- 企业小程序 -->
      <template v-else-if="form.type == 9">
        <el-form-item prop="name" label="小程序名称">
          <el-input clearable v-model="form.name" placeholder="请输入" maxlength="15" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="avatar" label="小程序头像">
          <upload class="image-uploader" :fileUrl.sync="form.avatar"></upload>
        </el-form-item>
        <el-form-item prop="appId" label="小程序AppID">
          <el-input clearable v-model="form.appId" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="secret" label="小程序Secret">
          <el-input clearable v-model="form.secret" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="" label="小程序原始ID">
          <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="longLink" label="小程序页面路径">
          <el-input clearable v-model="form.longLink" placeholder="请输入" maxlength="30" show-word-limit></el-input>
        </el-form-item>
      </template>
    </el-form>

    <template v-if="isDetail">
      <SelectQrCode
        :visible.sync="selectQrCodeVisible"
        @success="submitSelectQrCode"
        :selected="[form.qrCodeId]"></SelectQrCode>

      <SelectStaffQrCode
        :visible.sync="selectStaffQrCodeVisible"
        @success="submitSelectQrCode"
        :selected="[form.qrCodeId]"></SelectStaffQrCode>
    </template>
  </div>
</template>

<style lang="scss" scoped>
.tips {
  color: #aaa;
  font-size: 12px;
}
</style>
