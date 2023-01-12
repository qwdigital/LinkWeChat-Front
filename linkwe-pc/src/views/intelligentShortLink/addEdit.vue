<script>
import { getDetail, add, update } from '@/api/intelligentShortLink'
export default {
  name: '',
  components: {},
  data() {
    return {
      currentActive: 0,
      form: {
        jumpType: 1,
        extensionType: 1,
        touchType: 0,
        avatar: '',
        qrCode: '',
      },
      rules: {
        shortLinkName: [{ required: true, message: '必填项', trigger: 'blur' }],
        name: [{ required: true, message: '必填项', trigger: 'blur' }],
        describe: [{ required: true, message: '必填项', trigger: 'blur' }],
        longLink: [
          { required: true, message: '必填项', trigger: 'blur' },
          {
            validator(rule, value, callback) {
              if (value && !/^http/gi.test(value)) callback('链接格式错误，需以http(s)开头')
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
      dictDesc: [],
      dictTouchType: Object.freeze({
        1: {
          name: '公众号',
          touchType: {
            0: {
              name: '文章',
              allName: '跳入微信-公众号-文章',
              tip: '跳转进入微信后，打开一篇公众号文章',
              previewMobileTitle: '公众号标题',
            },
            1: {
              name: '二维码',
              allName: '跳入微信-公众号-二维码',
              tip: '跳转进入微信后，展示一张公众号二维码，长按引导关注',
              previewMobileTitle: '添加公众号',
            },
          },
        },
        2: {
          name: '个人微信',
          touchType: {
            2: {
              name: '个人二维码',
              allName: '跳入微信-个人微信-个人二维码',
              tip: '跳转进入微信后，展示一张个人二维码，长按扫码添加好友',
              previewMobileTitle: '添加微信',
            },
            3: {
              name: '群二维码',
              allName: '跳入微信-个人微信-群二维码',
              tip: '跳转进入微信后，展示一张微信群二维码，长按扫码入群',
              previewMobileTitle: '添加微信群',
            },
          },
        },
        3: {
          name: '企业微信',
          touchType: {
            4: {
              name: '员工活码',
              allName: '跳入微信-企业微信-员工活码',
              tip: '跳转进入微信后，展示一张企微员工活码，长按扫码添加企业员工',
              previewMobileTitle: '添加企业员工',
            },
            5: {
              name: '客群活码',
              allName: '跳入微信-企业微信-客群活码',
              tip: '跳转进入微信后，展示一张企微客群活码，长按扫码入群',
              previewMobileTitle: '添加企业客群',
            },
            6: {
              name: '门店导购活码',
              allName: '跳入微信-企业微信-门店导购码',
              tip: '跳转进入微信后，展示一张门店导购码，长按扫码添加附近门店的导购',
              previewMobileTitle: '添加门店导购',
            },
            8: {
              name: '门店群活码',
              allName: '跳入微信-企业微信-门店群活码',
              tip: '跳转进入微信后，展示一张门店群活码，长按扫码进入附近的门店群',
              previewMobileTitle: '添加门店群',
            },
          },
        },
        4: {
          name: '小程序',
          touchType: {
            7: {
              name: '个人小程序',
              allName: '跳入微信-小程序-个人小程序',
              tip: '跳转进入微信后，直接打开一个个人小程序',
              previewMobileTitle: '打开小程序',
            },
            9: {
              name: '企业小程序',
              allName: '跳入微信-小程序-企业小程序',
              tip: '跳转进入微信后，直接打开一个企业小程序',
              previewMobileTitle: '打开小程序',
            },
            10: {
              name: '小程序二维码',
              allName: '跳入微信-小程序-小程序二维码',
              tip: '跳转进入微信后，展示一张小程序二维码，长按扫码打开小程序',
              previewMobileTitle: '打开小程序',
            },
          },
        },
      }),
      prefixFormLabel: Object.freeze({
        1: '公众号',
        2: '微信',
        3: '微信群',
        10: '小程序',
      }),
      data: {},
    }
  },
  computed: {},
  watch: {},
  created() {
    Object.values(this.dictTouchType).forEach((element) => Object.assign(this.dictDesc, element.touchType))
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  destroyed() {
    this.clipboard.destroy()
  },
  methods: {
    getDetail() {
      this.loading = true
      let id = this.$route.query.id
      getDetail(id)
        .then((res) => {
          this.form = res
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    submit() {
      this.$refs['form'].validate((validate) => {
        if (validate) {
          this.loading = true
          ;(this.form.id ? update : add)(this.form)
            .then((res) => {
              this.data = res
              this.currentActive++
            })
            .catch((e) => {
              console.log(e)
            })
            .finally(() => {
              this.loading = false
            })
        }
      })
    },
    download() {
      const name = this.form.shortLinkName + '.png'
      const link = document.createElement('a') // 创建a标签
      link.href = this.data.shortUrl
      link.download = name // 重命名文件
      link.click()
    },
  },
}
</script>

<template>
  <el-container v-loading="loading">
    <el-header class="g-card g-pad20 mb10" height="108px">
      <el-steps style="margin-top: 10px" :active="currentActive" align-center>
        <el-step title="短链类型"></el-step>
        <el-step title="内容设置"></el-step>
        <el-step title="生成短链"></el-step>
      </el-steps>
    </el-header>

    <el-form
      v-show="currentActive == 0"
      label-suffix="："
      label-width=""
      class="g-card g-pad20"
      style="padding-right: 18%">
      <el-form-item label="跳转类型">
        <el-radio-group v-model="form.jumpType">
          <el-radio-button :label="1">跳入微信</el-radio-button>
          <el-radio-button :label="2">跳出微信</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="推广类型">
        <el-radio-group v-model="form.extensionType">
          <el-radio-button v-for="(item, key) in dictTouchType" :key="key" :label="key">
            {{ item.name }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="触达类型">
        <el-radio-group v-model="form.touchType">
          <template v-for="(item, key) in dictTouchType">
            <div v-show="form.extensionType == key" :key="key">
              <el-radio-button v-for="(unit, unique) in item.touchType" :key="key + '-' + unique" :label="unique">
                {{ unit.name }}
              </el-radio-button>
            </div>
          </template>
        </el-radio-group>
      </el-form-item>
      <div class="g-card g-pad20" style="background: #eee">
        <span>{{ dictDesc[form.touchType].tip }}</span>
      </div>
    </el-form>

    <div v-show="currentActive == 1" class="fxbw ais mt10" style="overflow: auto">
      <div class="g-card g-pad20" style="width: 58%">
        <el-form ref="form" :model="form" label-suffix="：" label-width="140px" :rules="rules">
          <el-form-item label="短链类型">
            <span>{{ dictDesc[form.touchType].allName }}</span>
          </el-form-item>
          <el-form-item label="短链名称" prop="shortLinkName">
            <el-input
              clearable
              v-model="form.shortLinkName"
              placeholder="请输入"
              maxlength="30"
              show-word-limit></el-input>
          </el-form-item>

          <!-- 公众号文章 -->
          <template v-if="form.touchType == 0">
            <el-form-item prop="longLink" label="公众号文章链接">
              <el-input clearable v-model="form.longLink" placeholder="请输入"></el-input>
              <div class="tips">请在公众号后台文章发布列表页中获取并复制文章的永久链接</div>
            </el-form-item>
          </template>
          <!-- 公众号二维码,个人二维码,群二维码,小程序二维码 -->
          <template v-else-if="Object.keys(prefixFormLabel).includes(form.touchType + '')">
            <el-form-item prop="name" :label="prefixFormLabel[form.touchType] + '名称'">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="15" show-word-limit></el-input>
            </el-form-item>
            <el-form-item prop="describe" :label="prefixFormLabel[form.touchType] + '描述'">
              <el-input
                clearable
                v-model="form.describe"
                placeholder="请输入"
                maxlength="30"
                show-word-limit></el-input>
            </el-form-item>
            <el-form-item prop="avatar" :label="prefixFormLabel[form.touchType] + '头像'">
              <upload class="image-uploader" :fileUrl.sync="form.avatar"></upload>
            </el-form-item>
            <el-form-item prop="qrCode" :label="prefixFormLabel[form.touchType] + '二维码'">
              <upload class="image-uploader" :fileUrl.sync="form.qrCode"></upload>
            </el-form-item>
          </template>
          <!-- 员工活码,客群活码 -->
          <template v-else-if="[4, 5].includes(+form.touchType)">
            <el-form-item prop="qrCodeId" :label="'选择' + dictDesc[form.touchType].name">
              <el-button
                type="primary"
                plain
                @click="choiceQqcode(form.touchType, '选择' + dictDesc[form.touchType].name)">
                选择{{ dictDesc[form.touchType].name }}
              </el-button>
            </el-form-item>
          </template>
          <!-- 门店导购活码,门店群活码 -->
          <template v-else-if="[6, 8].includes(+form.touchType)">
            <el-form-item prop="qrCodeId" :label="dictDesc[form.touchType].name">
              <el-button
                type="primary"
                plain
                @click="choiceQqcode(form.touchType, '选择' + dictDesc[form.touchType].name)">
                暂无{{ dictDesc[form.touchType].name }}，去配置
              </el-button>
            </el-form-item>
          </template>
          <!-- 个人小程序 -->
          <template v-else-if="form.touchType == 7">
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
              <el-input
                clearable
                v-model="form.longLink"
                placeholder="请输入"
                maxlength="30"
                show-word-limit></el-input>
            </el-form-item>
          </template>
          <!-- 企业小程序 -->
          <template v-else-if="form.touchType == 9">
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
              <el-input
                clearable
                v-model="form.longLink"
                placeholder="请输入"
                maxlength="30"
                show-word-limit></el-input>
            </el-form-item>
          </template>
        </el-form>
      </div>

      <div class="g-card g-pad20" style="width: 40%; margin-top: 0">
        <PhoneTemplate :title="dictDesc[form.touchType].previewMobileTitle">
          <template v-if="form.touchType == 0">
            <div class="mask" style="position: absolute">
              <div class="cc ac g-card g-pad20" style="width: 70%">公众号文章示例</div>
            </div>
          </template>
          <template v-else-if="[7, 9, 10].includes(+form.touchType)">
            <div class="g-card g-pad20 cc ac" style="width: 80%">
              小程序
              <el-image style="width: 120px; height: 120px" :src="form.avatar" error="头像" fit="fit"></el-image>
              <el-button type="primary">点击打开小程序</el-button>
            </div>
          </template>
          <template v-else>
            <div class="g-card g-pad20 cc ac" style="width: 80%">
              <div class="al bfc-o">
                <el-image
                  class="fl mr10"
                  style="width: 50px; height: 50px"
                  :src="form.avatar"
                  error="头像"
                  fit="fit"></el-image>
                <div class="toe">{{ form.name || '名称' }}</div>
                <div class="tips mt20 toe">{{ form.describe || '描述' }}</div>
              </div>
              <el-image style="width: 120px; height: 120px; margin: 20px 0" :src="url" :fit="fit"></el-image>
              <div class="mt20">长按二维码{{ dictDesc[form.touchType].previewMobileTitle }}</div>
            </div>
          </template>
        </PhoneTemplate>
      </div>
    </div>

    <div v-show="currentActive == 2" class="g-card g-pad20 ac">
      <i class="el-icon-success" style="font-size: 36px; color: #06c160; margin: 10px 0 20px"></i>
      <div style="">短链创建成功，支持直接复制链接或下载短链二维码</div>
      <div class="g-card g-pad20" style="background: #eee; width: 50%; margin: 30px auto">
        <span>{{ data.shortUrl }}</span>
      </div>
      <el-image style="width: 120px; height: 120px" :src="data.qrCode" fit="fit"></el-image>
      <div>
        <el-button type="text" class="copy-btn" :data-clipboard-text="data.shortUrl">复制链接</el-button>
        <el-button type="text" @click="download(row)">下载二维码</el-button>
      </div>
    </div>

    <el-footer class="mt20 ar" style="padding: 0" height="">
      <template v-if="currentActive == 0">
        <el-button plain @click="$router.back()">取消</el-button>
        <el-button type="primary" @click="currentActive++">下一步</el-button>
      </template>
      <template v-else-if="currentActive == 1">
        <el-button type="primary" @click="currentActive--">上一步</el-button>
        <el-button type="primary" @click="submit()">生成短链</el-button>
      </template>
      <template v-else-if="currentActive == 2">
        <el-button type="primary" @click="$router.back()">完成</el-button>
      </template>
    </el-footer>
  </el-container>
</template>

<style lang="scss" scoped>
.tips {
  color: #aaa;
  font-size: 12px;
}
</style>
