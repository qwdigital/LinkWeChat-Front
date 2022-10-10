<script>
import { getPoster } from '@/api/task'
import { getQueryValue, getWxCode } from '@/utils/index.js'
export default {
  name: '',
  components: {},
  data() {
    return {
      poster: '',
      query: {
        tenantId: '',
        taskFissionId: '',
        userId: '',
      },
    }
  },
  computed: {},
  watch: {},
  created() {
    this.$toast.loading()
    getWxCode()
      .then(({ openId, unionId, headImgUrl }) => {
        if (openId) {
          let query = this.$route.query
          let { tenantId, taskId: taskFissionId, wxwork_userid: userId } = query
          this.query = { tenantId, taskFissionId, userId }
          getPoster(this.query)
            .then((res) => {
              this.poster = res.data.posterUrl
            })
            .finally(() => {
              this.$toast.clear()
            })
        } else {
          this.$toast.clear()
        }
      })
      .catch(() => {
        // this.$toast('授权异常，请刷新重试')
      })
  },
  mounted() {},
  methods: {
    tip() {
      this.$toast('长按图片在弹出菜单中发送给朋友或者可保存图片分享至朋友圈')
    },
    goDetail() {
      this.$router.push({
        path: '/taskProcess',
        query: { ...this.query, poster: this.poster },
      })
    },
  },
}
</script>

<template>
  <div class="container">
    <img :src="poster" class="posterImg" />
    <div class="footerLink">
      <div class="sharePic" @click="tip">分享图片</div>
      <div class="myTaskDetail" @click="goDetail">我的邀请任务进度</div>
    </div>
  </div>
</template>

<style lang="less" scoped>
.container {
  height: 100%;
  width: 100%;
}
.posterImg {
  width: 100%;
}
.footerLink {
  height: 75px;
  width: 100%;
  background-color: #ffffff;
  position: fixed;
  left: 0;
  bottom: 0;
  display: flex;
  justify-content: space-around;
  align-items: center;
  font-size: 13px;
}
.sharePic {
  background-color: cornflowerblue;
  color: #ffffff;
  height: 94px;
  line-height: 94px;
  text-align: center;
  padding: 0 26px;
  border-radius: 10px;
}
.myTaskDetail {
  color: cornflowerblue;
}
</style>
