<script>
import {
  sendCustomerPersonalRedPacket,
  sendCustomerEnterpriseRedPacket,
  sendCustomerGroupPersonalRedPacket,
  sendCustomerGroupEnterpriseRedPacket,
  receiveRedPacket,
  getReceiveList,
} from '@/api/redPacket.js'
import { param2Obj, getWxCode } from '@/utils/index.js'
export default {
  name: '',
  components: {},
  data() {
    return {
      list: [],
      opened: false,
      redPacket: {},
      form: {
        orderNo: '', // 订单id
        openId: '', // 客户公众号id
        appId: window.CONFIG.appId, // 微信公众号id
        externalUserid: '', // 客户企微id
      },
    }
  },
  computed: {},
  watch: {},
  created() {
    this.init()
    this.sendRedPacket()
  },
  mounted() {},
  methods: {
    init() {
      getWxCode().then((openId) => (this.form.openId = openId))
    },
    sendRedPacket() {
      this.$toast.loading({
        duration: 0,
        forbidClick: true,
      })
      let query = param2Obj(window.location.search)
      let hash = param2Obj(window.location.hash)
      Object.assign(query, hash)
      this.redPacket = query
      this.form.externalUserid = query.externalUserid
      let request = ''
      if (query.sceneType == 1) {
        request = {
          personal: sendCustomerPersonalRedPacket,
          enterprise: sendCustomerEnterpriseRedPacket,
        }[query.redPacketType]
      } else {
        request = {
          personal: sendCustomerGroupPersonalRedPacket,
          enterprise: sendCustomerGroupEnterpriseRedPacket,
        }[query.redPacketType]
      }
      request(query).then((res) => {
        this.$toast.clear()
      })
    },
    receive() {
      this.$toast.loading({
        duration: 0,
        forbidClick: true,
      })
      receiveRedPacket()
        .then(() => {
          return getReceiveList()
        })
        .then(({ data }) => {
          this.opened = true
          this.list = data
          this.$toast.clear()
        })
    },
  },
}
</script>

<template>
  <div class="receive">
    <div v-if="!opened" class="redPacketThumb" @click="receive"></div>
    <div v-else>
      <div class="ac">
        <van-image width="80" height="80" :src="11" />
        <div class="title">
          合肥仟微网络科技有限公司的红包
          <span class="red-icon">{{ { 1: '普', 2: '拼' }[redPacket.redEnvelopesType] }}</span>
        </div>
        <div>{{ { 1: '普通红包', 2: '拼手气红包' }[redPacket.redEnvelopesType] }}</div>
        <div>{{ redPacket.redEnvelopeAmount }}</div>
        <div>已存入零钱，可直接使用</div>
      </div>
      <van-cell-group
        :title="
          `己领取${list.length}/${redPacket.redEnvelopeNum}个红包，共${redPacket.redEnvelopeNum}/${redPacket.redEnvelopeAmount}元`
        "
      >
        <van-cell center v-for="(item, index) in list" :key="index">
          <template #title>
            <van-image width="80" height="80" :src="item.materialUrl" />
            <div class="brf-d">
              <div>{{ item.name }}</div>
              <div>{{ item.time }}</div>
            </div>
          </template>
          <div class="">
            {{ item.money }}
          </div>
        </van-cell>
      </van-cell-group>
    </div>
  </div>
</template>

<style lang="less" scoped>
.redPacketThumb {
  height: calc(100vh - 30px);
  margin: 15px;
  background: url('../../assets/redPacketThumb.png') center top / 100% auto no-repeat;
}
.red-icon {
  margin-left: 20px;
  padding: 2px 4px;
  border-radius: 3px;
  background: #af9565;
}
</style>
