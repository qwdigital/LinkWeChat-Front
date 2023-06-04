<template>
  <div>
    <el-steps class="g-card" :active="currentActive" align-center finish-status="success">
      <el-step title="选SOP类型"></el-step>
      <el-step title="选择发送配置"></el-step>
      <el-step title="制定发送内容"></el-step>
      <el-step title="设置结束条件"></el-step>
    </el-steps>
    <div class="g-card" v-if="currentActive === 1">
      <div class="g-card-title">客户SOP类型</div>
      <el-divider></el-divider>
      <div>
        <div class="unit active" :class="{ selected: form.businessType === 1 }" @click="gotoNext(1)">
          <img style="height: 80px; width: 80px; margin-right: 10px" src="../../../assets/sop/sop1.svg" />
          <div class="content">
            <div class="content-title">新客SOP</div>
            <div class="content-sub">
              <div>适用于新客户的承接、留存、转化。对新添加的客户设置SOP自动推送营销内容。</div>
              <div style="margin-top: 3px">仅对创建本类型SOP开始之日起后添加的新客户有效。</div>
            </div>
          </div>
        </div>
        <div class="unit active" :class="{ selected: form.businessType === 2 }" @click="gotoNext(2)">
          <img style="height: 80px; width: 80px; margin-right: 10px" src="../../../assets/sop/sop2.svg" />
          <div class="content">
            <div class="content-title">活动节日SOP</div>
            <div class="content-sub">
              <div>可对特定目标的客户群体做自定义的节日问候SOP或活动推广预热SOP。</div>
              <div style="margin-top: 3px">适用于所有客户。</div>
            </div>
          </div>
        </div>
        <div class="unit active" :class="{ selected: form.businessType === 3 }" @click="gotoNext(3)">
          <img style="height: 80px; width: 80px; margin-right: 10px" src="../../../assets/sop/sop3.svg" />
          <div class="content">
            <div class="content-title">客户转化SOP</div>
            <div class="content-sub">
              <div>当客户状态满足设定的条件时，开始定期给客户发送指定的消息，起到更好的培育转化效果。</div>
              <div style="margin-top: 3px">适用于所有客户。</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-if="currentActive === 2">
      <CustomerStep2 :initData="form" @stepFn="setStepChange" />
    </div>
    <div v-if="currentActive === 3">
      <CustomerStep3 :initData="form" @stepFn="setStepChange" />
    </div>
    <div v-if="currentActive === 4">
      <CustomerStep4 :initData="form" :loading="submitLoading" @stepFn="setStepChange" @success="submit" />
    </div>
  </div>
</template>
<script>
import { addSop, updateSop, getSopDetail } from '@/api/sop/index'
import CustomerStep2 from '../components/customerStep2.vue'
import CustomerStep3 from '../components/customerStep3.vue'
import CustomerStep4 from '../components/customerStep4.vue'
export default {
  name: 'customer-sop-add-or-edit',
  components: {
    CustomerStep2,
    CustomerStep3,
    CustomerStep4,
  },
  data() {
    return {
      submitLoading: false,
      currentActive: 1,
      form: {
        baseType: 1, // 1 客户sop  2 客群sop
        businessType: null, // 1:新客sop;2:活动节日sop;3:客户转化sop;4:新群培育sop;5:周期营销sop;6:特定宣发sop
        sopName: '',
        sendType: 1, // 1:企业微信发送;2:手动发送
        executeWeUser: null,
        executeCustomerOrGroup: {
          executeCustomerCondit: {
            change: false,
            executeCustomerQUECondits: [],
          },
          crowdAttribute: {
            change: false,
            crowdIds: [],
          },
        },
        weSopPushTimes: [
          {
            pushStartTime: '',
            pushEndTime: '',
            pushTimeType: 3,
            pushTimePre: '',
            attachments: [],
          },
        ],
      },
    }
  },
  methods: {
    gotoNext(type) {
      this.form.businessType = type
      this.currentActive = 2
    },
    setStepChange(type, data) {
      this.currentActive = type
      if (data) {
        this.form = { ...this.form, ...data }
      }
    },
    submit(data) {
      this.submitLoading = true
      this.form = { ...this.form, ...data }
      if (this.form.executeCustomerOrGroup) {
        if (this.form.executeCustomerOrGroup.executeCustomerCondit.change) {
          let arr = this.form.executeCustomerOrGroup.executeCustomerCondit.executeCustomerQUECondits
          let value = []
          arr.forEach((dd) => {
            dd.executeCustomerQUECondits.forEach((ff) => {
              ff.andOr = dd.andOr
            })
            value = [...value, ...dd.executeCustomerQUECondits]
          })
          if (value.length) {
            this.form.executeCustomerSwipe = value
          } else {
            this.form.executeCustomerSwipe = null
          }
        } else {
          this.form.executeCustomerSwipe = null
        }
      }
      if (this.form.weSopPushTimes.length && this.form.endContent.joinCustomerGroup.change) {
        if (this.form.endContent.joinCustomerGroup.joinGroupTip) {
          let obj = {
            source: 2,
            msgType: 'text',
            content: this.form.endContent.joinCustomerGroup.joinGroupTip,
          }
          this.form.weSopPushTimes[this.form.weSopPushTimes.length - 1].attachments.push(obj)
        }
        if (this.form.endContent.joinCustomerGroup.groupCodeId) {
          let obj = {
            source: 2,
            msgType: 'image',
            picUrl: this.form.endContent.joinCustomerGroup.groupUrl,
          }
          this.form.weSopPushTimes[this.form.weSopPushTimes.length - 1].attachments.push(obj)
        }
      }
      if (this.$route.query.id) {
        updateSop(this.form).then((res) => {
          if (res.code === 200) {
            this.msgSuccess('操作成功!')
            this.$router.back(-1)
          } else {
            this.msgError(res.msg)
          }
          this.submitLoading = false
        })
      } else {
        addSop(this.form).then((res) => {
          if (res.code === 200) {
            this.msgSuccess('操作成功!')
            this.$router.back(-1)
          } else {
            this.msgError(res.msg)
          }
          this.submitLoading = false
        })
      }
    },
  },
  created() {
    if (this.$route.query.id) {
      getSopDetail(this.$route.query.id).then((res) => {
        if (res.code === 200) {
          this.form = res.data
          let arr = JSON.parse(
            JSON.stringify(this.form.weSopPushTimes[this.form.weSopPushTimes.length - 1].attachments),
          )
          this.form.weSopPushTimes[this.form.weSopPushTimes.length - 1].attachments = arr.filter(
            (item) => item.source !== 2,
          )
          this.currentActive = 2
        }
      })
    }
  },
}
</script>
<style lang="scss" scoped>
.unit {
  padding: 20px;
  height: 120px;
  display: flex;
  align-items: center;
  background: #fafafa;
  color: rgba(0, 0, 0, 0.6);
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  margin-bottom: 12px;
  .content {
    padding: 5px 0;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    .content-title {
      font-size: 16px;
      color: #333;
    }
  }
}
.selected {
  font-weight: 500;
  color: rgba(0, 0, 0, 0.9);
  background: #ecf5ff;
}
.active {
  &:hover {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.9);
    background: #ecf5ff;
  }
}
</style>
