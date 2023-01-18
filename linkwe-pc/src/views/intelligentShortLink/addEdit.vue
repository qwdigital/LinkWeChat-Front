<script>
import { getDetail, add, update } from '@/api/intelligentShortLink'
import { typeDict, touchTypeDict } from './components/mixin'
export default {
  name: '',
  components: {
    PhonePreview: () => import('./components/PhonePreview.vue'),
    Add: () => import('./components/Add'),
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
          <el-radio-button v-for="(item, key) in typeDict" :key="key" :label="+key">
            {{ item.name }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="触达类型">
        <el-radio-group v-model="form.type">
          <template v-for="(item, key) in typeDict">
            <div v-show="form.extensionType == key" :key="key">
              <el-radio-button v-for="(unit, unique) in item.touchType" :key="key + '-' + unique" :label="+unique">
                {{ unit.name }}
              </el-radio-button>
            </div>
          </template>
        </el-radio-group>
      </el-form-item>
      <div class="g-card g-pad20" style="background: #eee">
        <span>{{ touchTypeDict[form.type].tip }}</span>
      </div>
    </el-form>

    <div v-show="currentActive == 1" class="fxbw ais mt10" style="overflow: auto">
      <div class="g-card g-pad20 mr10" style="flex: auto">
        <Add ref="add" :form="form" />
      </div>

      <PhonePreview :data="form" />
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

<style lang="scss" scoped></style>
