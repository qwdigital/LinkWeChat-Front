<script>
import { touchTypeDict } from './mixin'
import { getCode } from '@/api/drainageCode/store'
export default {
  components: {},
  props: {
    form: {
      type: Object,
      defaut: () => ({}),
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
            validator: (rule, value, callback) => {
              if (this.form.type == 0 && value && !/^http/gi.test(value)) callback('链接格式错误，需以http(s)开头')
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

      selectQrCode: defineAsyncComponent(() => import('@/components/SelectQrCode.vue')),
      selectStaffQrCode: defineAsyncComponent(() => import('@/components/SelectStaffQrCode.vue')),
      component: '',
      qrCodeVisible: false,

      storeLoading: false,
      isLoadForm: false,
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('/detail')
    },
  },
  watch: {
    // 注意：id会滞后type执行，这点与vue2的执行顺序正好相反
    'form.id'(val) {
      // console.log(1, this.isLoadForm)
      this.isLoadForm = true
    },
    'form.type'(val, oldVal) {
      // 触达类型改变时情况已有表单数据
      // console.log(0)
      if (!this.form.id || this.isLoadForm) {
        // console.log(1, this.form)
        let { id, jumpType, extensionType, type } = this.form
        this.$emit('update:form', { id, jumpType, extensionType, type })
        // this.$refs.form.resetFields()
      }
      this.isLoadForm = true
      // <!-- 门店导购活码,门店群活码 -->
      if ([6, 8].includes(+val)) {
        this.getCode()
      }
    },
  },
  created() {},
  mounted() {},
  methods: {
    // 获取门店导购活码,门店群活码
    getCode() {
      this.storeLoading = true
      getCode({ 6: 1, 8: 2 }[this.form.type])
        .then(({ data }) => {
          this.form.qrCode = data && data.storeCodeConfigQr
          this.storeLoading = false
        })
        .finally(() => {
          this.storeLoading = false
        })
    },
    choiceQqcode(type) {
      this.qrCodeVisible = true
      this.component = this[type == 4 ? 'selectStaffQrCode' : 'selectQrCode']
    },
    // 选择二维码确认按钮
    submitSelectQrCode(data) {
      this.form.qrCodeId = data.id

      if (this.form.type == 4) {
        let desc = []
        data.qrUserInfos &&
          data.qrUserInfos.forEach((element) => {
            element.weQrUserList &&
              element.weQrUserList.forEach((el) => {
                desc.push(el.userName)
              })
          })
        this.form.describe = desc + ''
        this.form.name = data.name
        this.form.qrCode = data.qrCode
      } else {
        this.form.describe = data.tags
        this.form.name = data.activityName
        this.form.qrCode = data.codeUrl
      }
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
      label-width="160px"
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
          <upload class="image-uploader" v-model:fileUrl="form.avatar"></upload>
        </el-form-item>
        <el-form-item prop="qrCode" :label="prefixFormLabel[form.type] + '二维码'">
          <upload class="image-uploader" v-model:fileUrl="form.qrCode"></upload>
        </el-form-item>
      </template>

      <!-- 员工活码,客群活码 -->
      <template v-else-if="[4, 5].includes(+form.type)">
        <el-form-item prop="qrCode" :label="touchTypeDict[form.type].name">
          <!-- 员工活码,客群活码 -->
          <el-button v-if="!form.qrCode && !isDetail" type="primary" plain @click="choiceQqcode(form.type)">
            {{ '选择' + touchTypeDict[form.type].name }}
          </el-button>

          <el-form v-else label-width="">
            <el-form-item label="活码名称">{{ form.name }}</el-form-item>
            <el-form-item :label="form.type == 4 ? '使用员工' : '活码客群'">
              <tag-ellipsis v-if="form.describe" limit="2" :list="form.describe.split(',')"></tag-ellipsis>
            </el-form-item>
            <el-form-item label="二维码">
              <el-image class="mr10 qrCode" :src="form.qrCode" fit="fill"></el-image>
              <el-button v-if="!isDetail" text @click="choiceQqcode(form.type)">修改</el-button>
            </el-form-item>
          </el-form>
        </el-form-item>
      </template>

      <!-- 门店导购活码,门店群活码 -->
      <el-form-item
        v-else-if="[6, 8].includes(+form.type)"
        prop="qrCode"
        :label="'选择' + touchTypeDict[form.type].name">
        <el-button
          v-if="!form.qrCode && !isDetail"
          v-loading="storeLoading"
          type="primary"
          plain
          @click="$router.push('/drainageCode/qrCode/store/list')">
          暂无{{ touchTypeDict[form.type].name }}，去配置
        </el-button>
        <div v-else>
          <el-image v-loading="storeLoading" class="mr10 qrCode" :src="form.qrCode" fit="fill"></el-image>
          <el-button v-if="!isDetail" text @click="getCode()">同步</el-button>
        </div>
      </el-form-item>

      <!-- 个人小程序,企业小程序 -->
      <template v-else-if="[7, 9].includes(+form.type)">
        <el-form-item prop="name" label="小程序名称">
          <el-input clearable v-model="form.name" placeholder="请输入" maxlength="15" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="avatar" label="小程序头像">
          <upload class="image-uploader" v-model:fileUrl="form.avatar"></upload>
        </el-form-item>
        <el-form-item prop="appId" label="小程序AppID">
          <el-input clearable v-model="form.appId" placeholder="请输入" show-word-limit></el-input>
        </el-form-item>
        <!-- <template v-if="form.type == 0">
        <el-form-item prop="secret" label="小程序Secret">
          <el-input clearable v-model="form.secret" placeholder="请输入" show-word-limit></el-input>
        </el-form-item>
        <el-form-item prop="" label="小程序原始ID">
          <el-input clearable v-model="form.name" placeholder="请输入" show-word-limit></el-input>
        </el-form-item>
      </template> -->
        <el-form-item prop="longLink" label="小程序页面路径">
          <el-input
            clearable
            v-model="form.longLink"
            placeholder="请输入小程序页面路径（不含.html）"
            show-word-limit></el-input>
          <div v-if="!isDetail" class="tips">
            示例：page/index/index、page/index/index?id=123；
            <a href="https://www.yuque.com/linkwechat/help/gy4ghv#a1bXG" target="_blank">如何添加小程序页面路径?</a>
          </div>
        </el-form-item>
      </template>
    </el-form>

    <KeepAlive>
      <component
        :is="component"
        v-model:visible="qrCodeVisible"
        @success="submitSelectQrCode"
        :selected="[form.qrCodeId].filter((e) => !!e)" />
    </KeepAlive>

    <!-- <SelectQrCode
               v-model:visible="selectQrCodeVisible"
              @success="submitSelectQrCode"
              :selected="[form.qrCodeId].filter((e) => !!e)"></SelectQrCode>

            <SelectStaffQrCode
               v-model:visible="selectStaffQrCodeVisible"
              @success="submitSelectQrCode"
              :selected="[form.qrCodeId].filter((e) => !!e)"></SelectStaffQrCode> -->
  </div>
</template>

<style lang="scss" scoped>
.tips {
  color: var(--font-black-7);
  font-size: 12px;
}
::v-deep.qrCode {
  width: 150px;
  height: 150px;
  vertical-align: bottom;
}
</style>
