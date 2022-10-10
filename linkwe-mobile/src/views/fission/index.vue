<script>
import { setFissionComplete } from '@/api/task'
export default {
  name: '',
  components: {},
  data() {
    return {
      qrcode: '',
      errMsg: '',
    }
  },
  computed: {},
  watch: {},
  created() {
    this.$toast.loading({
      duration: 0,
      forbidClick: true,
    })
    getWxCode()
      .then(({ openId, unionId, nickName, headImgUrl }) => {
        if (openId) {
          const fissionId = getUrlParam('fissionId')
          const recordId = getUrlParam('recordId')

          if (!(fissionId && recordId && openId)) {
            this.errMsg = '缺失必要数据, 请联系管理员'
            return
          }

          setFissionComplete(fissionId, recordId, {
            name: nickName,
            unionid: unionId,
            userid: openId,
            avatar: headImgUrl,
          })
            .then(({ data }) => {
              this.qrcode = data
              this.$toast.clear()
            })
            .catch(() => {
              this.errMsg = '未获取到可用的二维码'
              this.$toast.clear()
            })
        } else {
          this.errMsg = '获取用户信息失败'
          this.$toast.clear()
        }
      })
      .catch(() => {
        this.errMsg = '获取用户信息失败'
        this.$toast('授权异常，请刷新重试')
      })
  },
  mounted() {},
  methods: {},
}
</script>

<template>
  <div class="container">
    <div id="qrcode" class="qrcode" v-if="qrcode">
      <div class="qrcode-tip">长按识别进入群组</div>
      <div class="qrcode-content">
        <img id="qrcodeImg" :src="qrcode" />
      </div>
    </div>

    <div v-else id="error" class="error-content">
      <div id="message">{{ errMsg }}</div>
    </div>
  </div>
</template>

<style lang="less" scoped>
.container {
  height: 100%;
  background-color: rgb(239, 239, 244);
  display: flex;
  align-items: center;
}

.qrcode {
  width: 100%;
  display: flex;
  justify-content: center;
  flex-direction: column;
}

.qrcode-tip {
  text-align: left;
  font-size: 40px;
  padding: 20px;
  text-indent: 15%;
}

.qrcode-content {
  width: 100%;
  text-align: center;
}

.qrcode-content > img {
  width: 70%;
}

.error-content {
  text-align: center;
  font-size: 40px;
  width: 100%;
  display: none;
}
</style>
