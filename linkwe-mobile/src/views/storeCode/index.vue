<template>
  <div class="bg" v-loading="loading">
    <van-field v-model="form.area" readonly label="" placeholder="请选择所在地区" @click="addressShow = true" />
    <van-field readonly clickable :value="currentItem.storeName" placeholder="请选择门店" @click="showPicker = true" />
    <template v-if="!columns.length">
      <div class="tip">
        {{ data.outOfRangeTip }}
      </div>
      <div class="code_content">
        <img class="code_img" v-if="data.codeState === 1" src="../../assets/no_code.svg" alt="" />
        <img class="code_img" v-else :src="data.customerServiceUrl" alt="" />
      </div>
      <div class="sub-des" v-if="data.codeState !== 1">
        长按识别二维码添加客服
      </div>
    </template>
    <template v-else>
      <div class="tip" style="text-align: center;"><van-icon name="location-o" /> {{ currentItem.address }}</div>
      <div class="code_content">
        <!-- <img class="code_img" v-if="value.codeState === 1" src="../../../assets/drainageCode/no_code.svg" alt=""> -->
        <img
          class="code_img"
          @touchstart="setStart"
          @touchend="setEnd"
          v-if="currentItem.shopGuideUrl"
          :src="currentItem.shopGuideUrl"
          alt=""
        />
        <img class="code_img" v-else src="../../assets/no_code.svg" alt="" />
        <!-- <img class="code_img" v-else src="../../../assets/drainageCode/code.png" alt=""> -->
      </div>
      <div class="sub-des" v-if="currentItem.shopGuideUrl">
        长按识别二维码添加门店导购
      </div>
    </template>

    <van-popup v-model="showPicker" round position="bottom">
      <van-picker
        value-key="storeName"
        show-toolbar
        :columns="columns"
        @cancel="showPicker = false"
        @confirm="onConfirm"
      />
    </van-popup>
    <van-popup v-model="addressShow" round position="bottom">
      <van-cascader
        v-model="area"
        title="请选择所在地区"
        :options="addressOptions"
        :field-names="{
          text: 'name',
          value: 'name'
        }"
        @close="addressShow = false"
        @finish="selectedArea"
      />
    </van-popup>
  </div>
</template>
<script>
  import { getWxCode, getQueryValue, baiduMapError, splitName } from '@/utils/index'
  import { getAreaList, getWxTicket } from '@/api/common'
  import { getCodeInStore, getCodeBase, recordCode } from '@/api/groupCode'
  export default {
    name: 'store-guide-code',
    data() {
      return {
        loading: false,
        area: '',
        userInfo: {},
        tenantId: '',
        addressOptions: [],
        addressShow: false,
        form: {
          area: '',
          latitude: '',
          longitude: ''
        },
        showPicker: false,
        columns: [],
        value: '',
        data: {
          outOfRangeTip: '',
          codeState: 1,
          customerServiceUrl: ''
        },
        currentItem: {
          storeName: '',
          address: ''
        },
        showTip: false,
        timer: '',
        query: {
          currentLat: '',
          currentLng: '',
          storeCodeId: '',
          unionid: '',
          source: 1,
          tenantId: ''
        }
      }
    },
    methods: {
      setStart() {
        this.timer = setTimeout(() => {
          this.query.storeCodeId = this.currentItem.id
          this.query.unionid = this.userInfo.unionId
          this.query.tenantId = sessionStorage.getItem('tenantId')
          recordCode(this.query)
        }, 500)
      },
      setEnd() {
        clearTimeout(this.timer)
      },
      selectedArea({ selectedOptions }) {
        this.addressShow = false
        delete this.form.latitude
        delete this.form.longitude
        this.form.area = selectedOptions.map((option) => option.name).join('')
        this.getStoreList()
      },
      getAreaList() {
        getAreaList().then(({ data }) => {
          this.addressOptions = data
        })
      },
      onConfirm(data, index) {
        if (data) {
          this.currentItem = data
        }
        this.showPicker = false
      },
      getStoreList(type) {
        this.loading = true
        getCodeInStore({
          storeCodeType: 1,
          unionid: this.userInfo.unionId,
          longitude: this.form.longitude,
          latitude: this.form.latitude,
          area: this.form.area,
          tenantId: sessionStorage.getItem('tenantId')
        }).then((res) => {
          if (res.code === 200) {
            this.columns = res.data.weStoreCodes
            if (!this.columns || this.columns.length === 0) {
              this.currentItem = {
                storeName: '',
                address: ''
              }
              this.getNullFn()
            } else {
              if (type) {
                this.currentItem = this.columns[0]
                this.form.area = this.currentItem.area
                let arr = splitName(this.currentItem.area)
                if (arr[2]) {
                  this.area = [2]
                }
              } else {
                this.currentItem = this.columns[0]
              }
            }
          }
          this.loading = false
        })
      },
      getNullFn() {
        getCodeBase({ storeCodeType: 1, tenantId: sessionStorage.getItem('tenantId') }).then((res) => {
          if (res.code === 200 && res.data) {
            this.data = res.data
          }
        })
      },
      back() {
        document.addEventListener(
          'WeixinJSBridgeReady',
          function () {
            WeixinJSBridge.call('closeWindow')
          },
          false
        )
        WeixinJSBridge.call('closeWindow')
      }
    },
    async mounted() {
      await getWxCode()
      if (getQueryValue('code') && getQueryValue('state')) {
        this.userInfo = JSON.parse(sessionStorage.getItem('userinfo'))
        this.getAreaList()
        let _that = this
        this.loading = true
        getWxTicket(window.location.href.split('#')[0]).then((res) => {
          if (res.code === 200) {
            let { timestamp, nonceStr, signature } = res.data
            wx.config({
              beta: true,
              // debug: true,
              appId: sessionStorage.getItem('weAppId'),
              timestamp, // 必填，生成签名的时间戳
              nonceStr, // 必填，生成签名的随机串
              signature, // 必填，签名，见附录-JS-SDK使用权限签名算法
              jsApiList: ['getLocation'], //必填
              success: function (res) {},
              fail: (res) => {
                _that.loading = false
                alert('config失败:' + JSON.stringify(res))
                if (res.errMsg.indexOf('function not exist') > -1) {
                  alert('版本过低请升级')
                }
              }
            })
            wx.ready(function () {
              wx.getLocation({
                type: 'wgs84', //默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                success: function (dd) {
                  _that.form.latitude = dd.latitude
                  _that.form.longitude = dd.longitude
                  _that.query.currentLat = dd.latitude
                  _that.query.currentLng = dd.longitude
                  _that.getStoreList('init')
                },
                fail: function (ff) {
                  // alert(ff.errMsg)
                  alert('获取定位位置信息失败')
                  _that.loading = false
                  _that.back()
                },
                cancel: function (ff) {
                  _that.back()
                }
              })
            })
          }
        })
      }
      // else {
      //   if (getQueryValue('state')) {
      //     this.back()
      //   }
      // }
    },
    created() {
      this.tenantId = this.$route.query.tenantId
      sessionStorage.setItem('tenantId', this.tenantId)
    }
  }
</script>
<style lang="less" scoped>
  .bg {
    background: linear-gradient(180deg, #eaf5ff 0%, rgba(253, 253, 253, 0) 100%);
    border-radius: 0px 0px 0px 0px;
  }
  .tip {
    font-size: 12px;
    margin-top: 30px;
    text-align: center;
  }
  .code_content {
    margin-top: 10px;
    text-align: center;
    .code_img {
      height: 180px;
      width: 180px;
      margin: 10px auto;
    }
  }

  .sub-des {
    text-align: center;
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #999999;
  }
</style>
