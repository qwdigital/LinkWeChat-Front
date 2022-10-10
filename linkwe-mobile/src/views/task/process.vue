<script>
import ClipboardJS from 'clipboard'
import { getProgress } from '@/api/task'
export default {
  name: '',
  components: {},
  data() {
    return {
      poster: '',
      completeNum: 0,
      left: 0,
      data: {
        customerList: [],
      },
      show: false,
    }
  },
  computed: {},
  watch: {},
  created() {
    let query = this.$route.query
    this.poster = query.poster
    getProgress(query).then(({ data }) => {
      this.data = data
      data.fissNum = data.fissNum || 0
      data.customerList = data.customerList || []
      let length = (this.completeNum = data.customerList.length)
      this.left = data.fissNum - length < 0 ? 0 : data.fissNum - length
    })
  },
  mounted() {
    this.clipboard = new ClipboardJS('.copy-btn')

    this.clipboard.on('success', (e) => {
      this.$toast.success('复制成功')
    })
    this.clipboard.on('error', (e) => {
      this.$toast.fail('复制失败')
    })
  },
  destroyed() {
    this.clipboard.destroy()
  },
  methods: {},
}
</script>

<template>
  <div class="container">
    <div class="title">活动兑奖</div>
    <div class="generalContent">
      <div class="reward-info" :style="{ filter: left ? 'blur(1px)' : 'blur(0px)' }">
        <div class="listMsg">
          <div class="generalFont">兑换链接</div>
          <div class="codeDetail codeLink">
            {{ data.rewardUrl }}
            <van-button
              v-if="!left"
              class="copy-btn"
              plain
              hairline
              type="info"
              size="mini"
              :data-clipboard-text="data.rewardUrl"
              style="padding: 0px 8px;"
            >
              复制
            </van-button>
          </div>
        </div>
        <div class="listMsg">
          <div class="generalFont">兑奖图片</div>
          <!-- <div class="codeDetail codeImg">1024</div> -->
          <img
            class="codeDetail codeImg"
            fit="contain"
            :src="data.rewardImageUrl"
            @click="show = true"
          />
          <van-image-preview v-model="show" :images="[data.rewardImageUrl]"> </van-image-preview>
        </div>
        <div class="listMsg">
          <div class="generalFont">兑换规则</div>
          <div class="codeDetail codeNum">{{ data.rewardRule }}</div>
        </div>
      </div>

      <div class="cc tip" v-if="left">
        任务完成后显示兑换信息
      </div>
    </div>
    <div class="title">邀请列表</div>
    <div class="generalFont">
      您已邀请<span class="completeNum">{{ completeNum }}</span
      >人，
      <template v-if="left">
        还差<span class="loseNum">{{ left }}</span
        >人，即可领奖
      </template>
      <span v-else>可前往领奖</span>
    </div>
    <div class="customersBox">
      <div class="customersList" v-for="(item, index) of data.customerList" :key="index">
        <img :src="item.avatar" class="customersImg" />
        <span class="name">{{ item.customerName }}</span>
        <span class="time">{{ item.addTime }}</span>
        <span class="customersSuccess">邀请成功</span>
      </div>
    </div>
    <div class="activityPoster">
      <div>活动海报</div>
      <img :src="poster" class="activityPosterImg" />
    </div>
  </div>
</template>

<style lang="less" scoped>
.title {
  color: #333;
  font-size: 18px;
  padding: 37px 18px;
  padding-bottom: 18px;
  background-color: #fff;
}
.container {
  height: 100%;
  background-color: rgb(239, 239, 244);
}
.generalFont {
  color: #909399;
  font-size: 12px;
  padding: 0 18px;
  padding-bottom: 8px;
}
.container > .generalFont {
  background-color: #fff;
}

.listMsg {
  display: flex;
  align-items: center;
  margin: 20px 0;
}
.listMsg .generalFont {
  flex: none;
  width: 56px;
  margin-right: 30px;
  text-align: right;
}
.codeDetail {
  font-size: 12px;
  color: #333;
  word-break: break-all;
  overflow: hidden;
}
.generalContent {
  position: relative;
  background-color: rgb(246, 246, 249);
  margin-bottom: 15px;
  border: 18px solid #fff;
  border-top: 0;
  padding: 0 8px;
  overflow: auto;
  .tip {
    background: rgba(69, 63, 63, 81%);
    padding: 6px;
    border-radius: 5px;
    color: #fff;
    white-space: nowrap;
  }
}
.codeImg {
  height: 50px;
}
.customersList {
  display: flex;
  align-items: center;
  font-size: 15px;
  background-color: rgb(246, 246, 249);
  padding: 8px;

  .customersImg {
    height: 37px;
    border-radius: 50%;
    margin-right: 8px;
  }
  .name {
    font-size: 13px;
    font-weight: 500;
    margin-right: 8px;
  }
  .time {
    color: #909399;
    font-size: 12px;
  }
  .customersSuccess {
    flex: 1;
    font-size: 13px;
    text-align: right;
    color: #06c160;
  }
}
.customersBox {
  padding: 18px;
  background-color: #fff;
}

.activityPoster {
  padding: 18px;
  font-size: 18px;
  background-color: #fff;
  margin-top: 18px;
}
.activityPosterImg {
  width: 100%;
  margin-top: 18px;
}
</style>
