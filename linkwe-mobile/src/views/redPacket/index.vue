<script>
  import {
    getList,
    sendCustomerPersonalRedPacket,
    sendCustomerEnterpriseRedPacket,
    sendCustomerGroupPersonalRedPacket,
    sendCustomerGroupEnterpriseRedPacket
  } from '@/api/redPacket.js'
  import { obj2query, param2Obj } from '@/utils/index.js'
  export default {
    name: '',
    components: {},
    data() {
      let that = this
      return {
        loading: false,
        finished: false,
        loadFail: false,
        sceneType: undefined, // 1:客户 2:客群
        list: [],
        visible: false,
        redPacketType: 'personal', // personal,enterprise
        form: {
          redEnvelopeAmount: 1, // 红包金额
          redEnvelopeName: '', // 红包名
          redEnvelopeNum: 1, // 红包数量
          sendUserId: '', // 发送人id
          redEnvelopesType: 1, // 红包类型 1: 普通红包 2:拼手气红包
          chatId: '', // 群id
          externalUserid: process.env.NODE_ENV !== 'development' ? '' : 'wmbhUTLgAA6ByLnY45U-uiC4ccoMvwng'
        },
        rules: {
          redEnvelopeAmount: [
            {
              required: true
            },
            {
              // formatter: (value) => +(+value).toFixed(2),
              pattern: /(^([1-9]\d{0,1}|1\d{2})(\.\d{1,2})?$|^200$)/,
              message: '输入错误'
            }
          ],
          redEnvelopeNum: [
            {
              required: true
            },
            // {
            //   // formatter: (value) => Math.round(value.replace(/\D/g, '')),
            //   pattern: /(^[1-9]{1}\d*$)/,
            //   message: '输入错误',
            // },
            {
              validator(val) {
                if (that.form.redEnvelopesType == 1) {
                  if (!/(^([1-9]\d{0,1}|[1-5]\d{2})$|^600$)/.test(val)) {
                    return false
                  }
                  if (that.form.redEnvelopeAmount) {
                    let max = that.form.redEnvelopeAmount * 3
                    let boolean = max >= val
                    if (!boolean) {
                      that.$notify({ type: 'danger', message: `当前红包金额最多可发${max}个红包` })
                    }
                    return boolean
                  } else {
                    return true
                  }
                } else {
                  return /(^([1-9]\d{0,1}|1\d{2})(\.\d{1,2})?$|^200$)/.test(val)
                }
              },
              message: '输入错误'
            }
          ]
        }
      }
    },

    computed: {
      userId() {
        return process.env.NODE_ENV !== 'development' ? this.$store.state.userId : 'XuXueJun'
      }
    },
    watch: {},
    created() {},
    mounted() {
      this.init()
    },
    methods: {
      init() {
        this.$toast.loading({
          duration: 0,
          forbidClick: true
        })
        let entry = undefined
        let that = this
        wx.invoke('getContext', {}, async function (res) {
          if (res.err_msg == 'getContext:ok') {
            entry = res.entry //返回进入H5页面的入口类型，目前 contact_profile、single_chat_tools、group_chat_tools
            if (!['single_chat_tools', 'group_chat_tools'].includes(entry)) {
              // _this.$toast.clear()
              that.$toast('入口错误：' + entry)
              return
            }
            try {
              let invokeApi = 'getCurExternalContact'
              if (entry === 'single_chat_tools') {
                that.sceneType = 1
              } else if (entry === 'group_chat_tools') {
                that.sceneType = 2
                invokeApi = 'getCurExternalChat'
              }
              that.getList()
              wx.invoke(invokeApi, {}, (res) => {
                if (res.err_msg == invokeApi + ':ok') {
                  that.form.externalUserid = res.userId //返回当前外部联系人userId
                  that.form.chatId = res.chatId //返回当前客户群的群聊ID
                } else {
                  //错误处理
                  that.$dialog({ message: '进入失败：' + JSON.stringify(res) })
                }
                that.$toast.clear()
              })
            } catch (err) {
              that.$dialog({ message: 'err' + JSON.stringify(err.message) })
            }
          }
        })
      },
      getList() {
        this.loading = true
        this.finished = false
        getList(this.sceneType)
          .then(({ data, total }) => {
            // this.total = total
            data.forEach((e) => {
              // 单位换算 分转元
              e.money = (e.money / 100).toFixed(2)
            })
            this.list = data

            this.loading = false
            this.refreshing = false
            this.finished = true
            // 数据全部加载完成
            // if (this.list.length >= +total) {
            //   this.finished = true
            // } else {
            //   this.pageNum++
            // }
            // if (this.list.length == 0) {
            //   this.pageNum = 1
            // }
          })
          .catch(() => {
            this.loadFail = true
          })
      },
      showDialog(type, row = {}) {
        // if (!sessionStorage.appId || !sessionStorage.secret) {
        //   this.$dialog({
        //     message: '当前企业未配置微信公众号appid或secret，无法发送红包，请前往后台设置',
        //   })
        //   return
        // }
        Object.assign(this.form, {
          redEnvelopeAmount: row.money || 1,
          redenvelopesId: row.id,
          redEnvelopeName: row.name || '恭喜发财，大吉大利',
          redEnvelopeNum: row.redEnvelopeNum || 1
        })
        this.redPacketType = type
        this.visible = true
        this.$nextTick(() => {
          // this.$refs.form.resetValidation()
        })
      },
      // transMoney(value) {
      //   this.form.redEnvelopeAmount = +(+value).toFixed(2)
      // },
      sendRedPacket() {
        this.$toast.loading({
          duration: 0,
          forbidClick: true
        })
        let request = ''
        if (this.sceneType == 1) {
          request = {
            personal: sendCustomerPersonalRedPacket,
            enterprise: sendCustomerEnterpriseRedPacket
          }[this.redPacketType]
        } else {
          request = {
            personal: sendCustomerGroupPersonalRedPacket,
            enterprise: sendCustomerGroupEnterpriseRedPacket
          }[this.redPacketType]
        }
        let form = Object.assign({}, this.form)
        // 单位换算 元转分
        form.redEnvelopeAmount *= 100
        form.sendUserId = this.userId
        request(form)
          .then(({ data, msg }) => {
            this.$toast.clear()
            this.send(form, data || msg)
          })
          .finally(() => {
            this.$toast.clear()
          })
      },
      async send(form, orderId) {
        let that = this
        let mes = {}
        try {
          let query = param2Obj(window.location.search)
          let hash = param2Obj(window.location.hash)
          Object.assign(
            form,
            {
              orderId,
              sceneType: that.sceneType,
              appId: sessionStorage.appId,
              tenantId: sessionStorage.tenantId
            },
            query,
            hash
          )
          // 删除空值字段
          for (const key in form) {
            if (form.hasOwnProperty.call(form, key)) {
              !form[key] && delete form[key]
            }
          }
          // 删除code字段，避免和微信端授权登录回到参数的code冲突
          delete form.code
          let formQueryString = obj2query(form)
          let baseUrl = location.protocol + '//' + location.host + window.lwConfig.BASE_URL
          let redPacketUrl = `${baseUrl}?${formQueryString}#/redPacketReceive`

          // msgtype 文本(“text”)，图片(“image”)，视频(“video”)，文件(“file”)，H5(“news”）和小程序(“miniprogram”)
          mes = {
            msgtype: 'news',
            news: {
              link: redPacketUrl, //H5消息页面url 必填
              title: form.redEnvelopeName, //H5消息标题
              desc: '点我领取红包', //H5消息摘要
              imgUrl: baseUrl + 'static/redPacketThumb.png' //H5消息封面图片URL
            }
          }
          // that.$dialog({ message: 'mes：' + JSON.stringify(redPacketUrl) })
        } catch (err) {
          that.$dialog({ message: 'err:' + JSON.stringify(err.message) })
        }
        wx.invoke('sendChatMessage', mes, function (resSend) {
          if (resSend.err_msg == 'sendChatMessage:ok') {
            //发送成功 sdk会自动弹出成功提示，无需再加
            // that.$toast('发送成功')
          } else {
            //错误处理
            // that.$dialog({ message: '发送失败：' + JSON.stringify(resSend) })
          }
        })
      }
    }
  }
</script>

<template>
  <div class="red-packet">
    <div class="personal">
      <van-button type="info" size="mini" @click="showDialog('personal')">+ 发送个人红包</van-button>
    </div>
    <div>
      <div class="title">企业红包</div>
      <van-list
        v-model="loading"
        :finished="finished"
        finished-text="没有更多了"
        :error.sync="loadFail"
        error-text="请求失败，点击重新加载"
      >
        <div v-for="(item, index) in list" :key="index" class="fxbw red-packet-list">
          <div class="red-packet-message">{{ item.name }}</div>
          <div class="ar red-packet-list--right">
            <div class="money">￥{{ item.money }}</div>
            <van-button type="info" size="small" @click="showDialog('enterprise', item)">发送</van-button>
          </div>
        </div>
      </van-list>
    </div>

    <van-action-sheet v-model="visible" :description="(redPacketType.includes('personal') ? '个人' : '企业') + '红包'">
      <van-form ref="form" colon @submit="sendRedPacket">
        <!-- 企业红包相关字段 -->
        <van-field
          v-if="redPacketType.includes('enterprise')"
          label="红包金额(元)"
          :value="'￥' + form.redEnvelopeAmount"
          readonly
        />

        <!-- 客户群红包相关字段 -->
        <van-field v-if="sceneType == 2" name="radio" label="红包类型" required>
          <template #input>
            <van-radio-group v-model="form.redEnvelopesType" direction="horizontal">
              <van-radio :name="1">普通红包</van-radio>
              <van-radio :name="2">拼手气红包</van-radio>
            </van-radio-group>
          </template>
        </van-field>

        <!-- 个人红包相关字段 -->
        <template v-if="redPacketType.includes('personal')">
          <van-field
            v-model="form.redEnvelopeAmount"
            type="text"
            :label="{ 1: '红包金额(元)', 2: '红包总额(元)' }[sceneType]"
            placeholder="请输入金额"
            required
            :rules="rules.redEnvelopeAmount"
          />
          <!-- :formatter="(value) => +(+value).toFixed(2)"
            format-trigger="onBlur" -->
          <div class="sub-des">精确到小数点后两位，可输入1~200</div>
        </template>

        <!-- 客户群红包相关字段 -->
        <van-field
          v-if="sceneType == 2"
          v-model="form.redEnvelopeNum"
          type="digit"
          label="红包个数"
          placeholder="请输入大于1的正整数"
          required
          :rules="rules.redEnvelopeNum"
        />
        <van-field
          v-model="form.redEnvelopeName"
          type="text"
          label="红包名称"
          placeholder="请输入名称"
          maxlength="16"
          show-word-limit
        />

        <div style="width: 90%; margin: 20px auto 40px;">
          <van-button round block size="normal" type="info" native-type="submit">确认发送</van-button>
        </div>
      </van-form>
    </van-action-sheet>
  </div>
</template>

<style lang="less" scoped>
  .personal {
    background: #eee;
    padding: 15px;
  }
  .title {
    font-weight: 500;
    margin: 15px;
  }
  .red-packet-list {
    margin: 10px;
    padding: 10px 20px;
    border: 1px solid #eee;
    align-items: stretch;

    .money {
      font-size: 30px;
      font-weight: 600;
    }
    .red-packet-list--right {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      justify-content: space-between;
    }
  }
  .red-packet-message {
    display: inline-block;
    width: 175px;
    height: 75px;
    padding: 15px 0 0 50px;
    color: #fff;
    line-height: 1.15;
    font-size: 16px;
    font-weight: 500;
    background: url('../../assets/red-packet-1.png') 0 0 no-repeat;
    background-size: 100%;
  }
  .sub-des {
    color: #888;
    margin: 10px 100px 0;
    font-size: 12px;
  }
</style>
