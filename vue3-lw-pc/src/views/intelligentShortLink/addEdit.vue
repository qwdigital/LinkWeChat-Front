<script>
import { getDetail, add, update } from '@/api/intelligentShortLink'
import { typeDict, touchTypeDict } from './components/mixin'
export default {
  name: '',
  components: {
    PhonePreview: defineAsyncComponent(() => import('./components/PhonePreview.vue')),
    Add: defineAsyncComponent(() => import('./components/Add')),
  },
  data() {
    return {
      loading: false,
      currentActive: 0,
      form: {
        jumpType: 1,
        extensionType: 1,
        type: 0,
        avatar: '',
        qrCode: '',
      },

      typeDict,
      touchTypeDict,
      data: {},
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {
    this.$route.query.id && this.getDetail()
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    getDetail() {
      this.loading = true
      let id = this.$route.query.id
      getDetail(id)
        .then(({ data }) => {
          this.form = data
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    extensionTypeChange(val) {
      let touchTypeList = this.typeDict[val].touchType
      this.form.type = Object.keys(touchTypeList)[0]
    },
    goStep(type) {
      this.$refs.add.$refs.form.clearValidate()
    },
    submit() {
      this.$refs.add.$refs['form'].validate((validate) => {
        if (validate) {
          if ([1, 0].includes(this.form.type)) {
            this.form.touchType = this.form.type + 1
          } else {
            delete this.form.touchType
          }
          this.loading = true
          ;(this.form.id ? update : add)(this.form)
            .then((res) => {
              this.data = res.data
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
      let canvas = this.$refs.canvas || document.createElement('canvas')
      canvas.width = '200'
      canvas.height = '200'
      this.$refs.qrCode.setAttribute('crossOrigin', 'anonymous')
      canvas.getContext('2d').drawImage(this.$refs.qrCode, 0, 0, 200, 200)
      canvas.toBlob((blob) => {
        let url = URL.createObjectURL(blob)
        const link = document.createElement('a') // 创建a标签
        link.href = url
        link.download = '短链二维码.png'
        link.click()
        link.remove()
        URL.revokeObjectURL(url)
      }, 'image/png')
    },
  },
}
</script>

<template>
  <el-container direction="vertical" v-loading="loading">
    <div class="g-card fxnone">
      <el-steps :active="currentActive" align-center finish-status="success">
        <el-step title="短链类型"></el-step>
        <el-step title="内容设置"></el-step>
        <el-step title="生成短链"></el-step>
      </el-steps>
    </div>

    <el-form v-show="currentActive == 0" label-suffix="：" label-width="" class="g-card" style="padding-right: 18%">
      <el-form-item label="跳转类型">
        <el-radio-group v-model="form.jumpType">
          <el-radio-button :label="1">跳入微信</el-radio-button>
          <!-- manual
          :value="currentActive == 0"
           transition="normal" -->
          <el-tooltip effect="light" content="尽情期待" placement="top">
            <el-radio-button :label="2" disabled>跳出微信</el-radio-button>
          </el-tooltip>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="推广类型">
        <el-radio-group v-model="form.extensionType" @change="extensionTypeChange">
          <el-radio-button v-for="(item, key) in typeDict" :key="key" :label="+key">
            {{ item.name }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="触达类型">
        <el-radio-group v-model="form.type">
          <template v-for="(item, key) in typeDict" :key="key">
            <div v-show="form.extensionType == key">
              <el-radio-button v-for="(unit, unique) in item.touchType" :key="key + '-' + unique" :label="+unique">
                {{ unit.name }}
              </el-radio-button>
            </div>
          </template>
        </el-radio-group>
      </el-form-item>
      <div class="g-card" style="background: var(--bg-black-9)">
        <span>{{ touchTypeDict[form.type].tip }}</span>
      </div>
    </el-form>

    <div v-show="currentActive == 1" class="fxbw ais mt10" style="overflow: auto">
      <div class="g-card mr10" style="flex: auto">
        <Add ref="add" v-model:form="form" />
      </div>

      <PhonePreview :data="form" />
    </div>

    <div v-show="currentActive == 2" class="g-card ac">
      <el-icon-SuccessFilled
        class="el-icon-SuccessFilled"
        style="font-size: 36px; color: var(--color); margin: 10px 0 20px"></el-icon-SuccessFilled>
      <div style="">短链创建成功</div>
      <div class="g-card" style="background: var(--bg-black-9); width: 50%; margin: 30px auto">
        <span>{{ data.shortUrl }}</span>
      </div>
      <img ref="qrCode" style="width: 180px; height: 180px" :src="data.qrCode" fit="fill" crossOrigin="anonymous" />
      <div>
        <el-button text class="copy-btn" :data-clipboard-text="data.shortUrl">复制链接</el-button>
        <el-button text @click="download()">下载二维码</el-button>

        <!-- <div style="font-size: 12px; color: var(--font-black-7)">
          此链接适用于短信、邮件、外部网页、微信内等拉起小程序的业务场景，
          <a
            href="https://developers.weixin.qq.com/miniprogram/dev/OpenApiDoc/qrcode-link/url-scheme/generateScheme.html">
            详见>>
          </a>
        </div> -->
      </div>
    </div>

    <div class="g-footer-sticky">
      <template v-if="currentActive == 0">
        <el-button plain @click="$router.back()">取消</el-button>
        <el-button type="primary" @click="goStep(currentActive++)">下一步</el-button>
      </template>
      <template v-else-if="currentActive == 1">
        <el-button type="primary" @click="goStep(currentActive--)">上一步</el-button>
        <el-button type="primary" @click="submit()">生成短链</el-button>
      </template>
      <template v-else-if="currentActive == 2">
        <el-button type="primary" @click="$router.back()">完成</el-button>
      </template>
    </div>
  </el-container>
</template>

<style lang="scss" scoped></style>
