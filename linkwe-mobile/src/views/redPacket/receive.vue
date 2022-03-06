<script>
import {
  receiveRedPacket,
  getReceiveList,
  getRedPacketInfo,
  getReceiveStatus,
} from '@/api/redPacket.js'
import { param2Obj, getWxCode } from '@/utils/index.js'
export default {
  name: '',
  components: {},
  data() {
    return {
      list: [],
      opened: false,
      openId: 0,
      redPacket: {
        // logo:
        //   'http://wx.qlogo.cn/mmhead/JiavaWZxX4YuaWQrmvO6Gia7DyUGibLWU6diaI3szAgfv6NHsmC5bb8F5Q/0',
        // corpName: '合肥仟微网络科技',
        // redEnvelopeName: '合肥仟微网络科技',
        // redEnvelopesType: 1,
        // sceneType: 2,
        // currentAcceptMoney: 0,
        // totalMoney: 0,
        // accpectMoney: 1000,
        // accpestCustomerList: [
        //   {
        //     avatar:
        //       'http://wx.qlogo.cn/mmhead/JiavaWZxX4YuaWQrmvO6Gia7DyUGibLWU6diaI3szAgfv6NHsmC5bb8F5Q/0',
        //     accpectTime: '2022-02-18T11:38:06.000+08:00',
        //     accpectMoney: 1000,
        //     customerName: 's是否',
        //   },
        // ],
      },
      errorMsg: '',
      animate: false,
      over: false, // 红包是否抢光
    }
  },
  computed: {
    title() {
      let redPacket = this.redPacket
      let total = redPacket.totalMoney
      let num = redPacket.redEnvelopeNum
      return redPacket.currentAcceptMoney != 0
        ? `己领取${(redPacket.accpestCustomerList || []).length}/${num}个红包，共${
            redPacket.accpectMoney
          }/${total}元`
        : `${num}个红包共${total}元，已被抢光`
    },
  },
  watch: {},
  created() {
    this.init()
  },
  mounted() {},
  methods: {
    init() {
      this.$toast.loading({
        duration: 0,
        forbidClick: true,
      })
      getWxCode()
        .then(({ openId, nickName, headImgUrl }) => {
          if (openId) {
            let query = param2Obj(window.location.search)
            let hash = param2Obj(window.location.hash)
            Object.assign(query, hash)
            this.redPacket = query

            this.openId = openId
            this.receiveName = nickName
            this.avatar = headImgUrl
            this.getRedPacketInfo()
            this.getReceiveStatus()
          } else {
            this.$toast.clear()
          }
        })
        .catch(() => {
          this.$toast('授权异常，请刷新重试')
        })
    },
    getRedPacketInfo() {
      getRedPacketInfo().then(({ data }) => {
        // let query = param2Obj(window.location.search)
        // let hash = param2Obj(window.location.hash)
        // Object.assign(query, hash)
        // this.redPacket = query
        this.redPacket = Object.assign({}, this.redPacket, data)
        // this.$set(this.redPacket, 'logo', data.logo)
        // this.$set(this.redPacket, 'corpName', data.corpName)
      })
    },
    getReceiveStatus() {
      let form = {
        orderNo: this.redPacket.orderId, // 订单id
        openId: this.openId, // 客户公众号id
      }
      getReceiveStatus(form).then(({ data }) => {
        data ? this.getReceiveList(true) : this.$toast.clear()
      })
    },
    receive() {
      if (!this.openId) {
        return
      }
      this.$toast.loading({
        duration: 0,
        forbidClick: true,
      })

      let form = {
        orderNo: this.redPacket.orderId, // 订单id
        openId: this.openId, // 客户公众号id
        appId: window.CONFIG.appId, // 微信公众号id
        chatId: this.redPacket.chatId, // 客户企微id
        externalUserid: this.redPacket.externalUserid, // 客户企微id
        receiveName: this.receiveName,
        avatar: this.avatar,
      }
      receiveRedPacket(form).then((data) => {
        if (data.code === 200) {
          return this.getReceiveList()
        } else {
          this.errorMsg = data.msg
          this.$toast.clear()
          // return Promise.reject()
        }
      })
    },
    getReceiveList(isOpened) {
      let form = {
        orderNo: this.redPacket.orderId, // 订单id
        openId: this.openId, // 客户公众号id
        appId: window.CONFIG.appId, // 微信公众号id
        chatId: this.redPacket.chatId, // 客户群企微id
        // externalUserid: this.redPacket.externalUserid, // 客户企微id
      }
      getReceiveList(form).then(({ data }) => {
        if (data.currentAcceptMoney == 0) {
          this.over = true
        }
        data.currentAcceptMoney /= 100
        data.totalMoney /= 100
        data.accpectMoney /= 100
        data.accpestCustomerList.forEach((element) => {
          element.accpectMoney /= 100
        })
        this.$toast.clear()

        if (isOpened) {
          this.opened = true
          Object.assign(this.redPacket, data)
        } else {
          this.$refs.audio.play()
          this.animate = true
          setTimeout(() => {
            this.opened = true
            Object.assign(this.redPacket, data)
          }, 1000)
        }
      })
    },
    dateFormat(value) {
      return value.substring(0, 19).replace(/[T]/g, ' ')
    },
  },
}
</script>

<template>
  <div class="receive">
    <div v-if="!opened" class="red-packet-thumb-wrap">
      <div class="red-packet-info">
        <van-image width="60" height="60" radius="4" :src="redPacket.logo" />
        <div class="corp-name">{{ redPacket.corpName }}</div>
        <div class="red-packet-name">{{ redPacket.redEnvelopeName }}</div>
        <div class="red-packet-error" v-if="errorMsg">{{ errorMsg }}</div>
      </div>
      <van-image
        :class="['open-btn', animate && 'tarns']"
        width="30"
        height="30"
        radius="4"
        :src="require('@/assets/open.png')"
      />
      <img src="@/assets/redPacketThumb.png" class="red-packet-thumb" @click="receive" />
    </div>
    <div v-else class="red-packet-received">
      <div class="red-packet-received-thumb"></div>
      <div class="red-packet-received-info ac">
        <van-image width="60" height="60" radius="4" :src="redPacket.logo" />
        <div class="corp-name">
          {{ redPacket.corpName }}发出的红包
          <!-- sceneType 1:客户 2:客群 -->
          <span v-if="redPacket.sceneType == 2" class="red-icon">{{
            { 1: '普', 2: '拼' }[redPacket.redEnvelopesType]
          }}</span>
        </div>
        <div class="red-packet-name">{{ redPacket.redEnvelopeName }}</div>
        <template v-if="redPacket.currentAcceptMoney != 0">
          <div class="received-num-wrap">
            <span class="red-packet-received-num">{{ redPacket.currentAcceptMoney }}</span
            >元
          </div>
          <div class="red-packet-text">已存入零钱，可直接使用</div>
        </template>
      </div>
      <van-cell-group :title="title">
        <van-cell center v-for="(item, index) in redPacket.accpestCustomerList" :key="index">
          <template #title>
            <van-image width="60" height="60" :src="item.avatar" />
            <div class="bfc-d user">
              <div class="user-name">{{ item.customerName }}</div>
              <div class="red-packet-text">{{ dateFormat(item.accpectTime) }}</div>
            </div>
          </template>
          <div class="money">{{ item.accpectMoney }}元</div>
        </van-cell>
      </van-cell-group>
    </div>
    <audio ref="audio" src="@/assets/redPacket.mp3"></audio>
  </div>
</template>

<style lang="less" scoped>
.red-packet-info {
  position: absolute;
  top: 50vw;
  width: 100%;
  text-align: center;
  .corp-name {
    color: #ed7e46;
    margin: 15px 0;
  }
  .red-packet-name {
    font-size: 20px;
    font-weight: 500;
    color: #f5af4d;
  }
  .red-packet-error {
    .red-packet-name();
    margin-top: 35px;
  }
}
// .red-packet-thumb {
//   height: calc(100vh - 30px);
//   margin: 15px;
//   background: url('../../assets/redPacketThumb.png') center top / 100% auto no-repeat;
// }

.red-packet-received {
  .red-packet-received-thumb {
    position: relative;
    margin-top: -25px;
    height: 100px;
    background: #da4c3e;
    border-radius: 0 0 50% 50%;
  }
  .red-packet-received-info {
    margin-top: -25px;
  }
  .corp-name {
    color: #333;
    font-size: 18px;
    font-weight: 500;
    margin: 15px 0;
  }
  .red-icon {
    display: inline-block;
    vertical-align: 2px;
    color: #fff;
    font-size: 12px;
    margin-left: 10px;
    padding: 2px 4px;
    border-radius: 3px;
    background: #bba385;
  }
  .red-packet-name {
    color: #bba385;
    margin: 15px 0;
  }
  .received-num-wrap {
    color: #bba385;
    .red-packet-received-num {
      font-size: 26px;
      font-weight: 800;
      margin-right: 5px;
    }
  }
  .red-packet-text {
    color: #aaa;
  }
  .user {
    margin-left: 10px;
    .user-name {
      font-weight: 500;
    }
  }
  .money {
    color: #333;
    font-weight: 800;
  }
}
/deep/.van-cell__title {
  display: flex;
  align-items: center;
}
/deep/.van-cell__value {
  flex: none !important;
}

.open-btn {
  position: absolute;
  z-index: 9;
  left: 50%;
  transform: translateX(-50%);
  opacity: 0;
  visibility: hidden;
  top: 109vw;
  transition: all 1.5s;
}
.tarns {
  visibility: visible;
  transform: translate(-50%, -30vw) scale(2) rotateX(360deg);
  -webkit-transform: translate(-50%, -30vw) scale(2) rotateX(360deg);
  opacity: 0.8;
}
</style>
