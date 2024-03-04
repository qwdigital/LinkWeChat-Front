<template>
  <div>
    <div class="g-card">
      <el-steps :active="active" align-center finish-status="success">
        <el-step :status="activeStatus(1)" title="SOP类型"></el-step>
        <el-step :status="activeStatus(2)" title="发送配置"></el-step>
        <el-step :status="activeStatus(3)" title="发送内容"></el-step>
        <el-step :status="activeStatus(4)" title="结束条件"></el-step>
      </el-steps>
    </div>
    <div class="g-card" v-if="active === 1">
      <div class="g-card-title">客户SOP类型</div>
      <el-divider></el-divider>
      <div>
        <div class="unit active" :class="{ selected: form.businessType === 4 }" @click="gotoNext(4)">
          <img style="height: 80px; width: 80px; margin-right: 10px" src="../../../assets/sop/sop4.svg" />
          <div class="content">
            <div class="content-title">新群培育SOP</div>
            <div class="content-sub">
              <div>适用于新创建的群聊，帮助成员在群聊中快速破冰，熟络客群成员，建立群聊氛围。</div>
              <div style="margin-top: 3px">仅针对创建本类型SOP开始之日起后目标新客群有效。</div>
            </div>
          </div>
        </div>
        <div class="unit active" :class="{ selected: form.businessType === 5 }" @click="gotoNext(5)">
          <img style="height: 80px; width: 80px; margin-right: 10px" src="../../../assets/sop/sop5.svg" />
          <div class="content">
            <div class="content-title">周期营销SOP</div>
            <div class="content-sub">
              <div>适用于所有群聊，帮助企业定期推广自身的运营任务，强化客户企业品牌印象。</div>
              <div style="margin-top: 3px">适用于除新创建客群之外的其它所有客群。</div>
            </div>
          </div>
        </div>
        <div class="unit active" :class="{ selected: form.businessType === 6 }" @click="gotoNext(6)">
          <img style="height: 80px; width: 80px; margin-right: 10px" src="../../../assets/sop/sop6.svg" />
          <div class="content">
            <div class="content-title">特定宣发SOP</div>
            <div class="content-sub">
              <div>适用于所有群聊，帮助企业在特殊节日、活动推广等一次性主题相关的活动中提前宣发推广，造势预热。</div>
              <div style="margin-top: 3px">适用于所有客群。</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-if="active === 2">
      <GroupStep2 :initData="form" @stepFn="setStepChange" />
    </div>
    <div v-if="active === 3">
      <CustomerStep3 :initData="form" @stepFn="setStepChange" />
    </div>
    <div v-if="active === 4">
      <GroupStep4 :initData="form" :loading="submitLoading" @stepFn="setStepChange" @success="submit" />
    </div>
  </div>
</template>
<script>
import { addSop, updateSop, getSopDetail } from '@/api/sop/index'
import GroupStep2 from '../components/groupStep2.vue'
import CustomerStep3 from '../components/customerStep3.vue'
import GroupStep4 from '../components/groupStep4.vue'
import { delTreeKeys } from '@/utils/index'

export default {
  name: 'group-sop-add-or-edit',
  components: {
    GroupStep2,
    CustomerStep3,
    GroupStep4,
  },
  data() {
    return {
      submitLoading: false,
      active: 1,
      form: {
        baseType: 2, // 1 客户sop  2 客群sop
        businessType: null, // 1:新客sop;2:活动节日sop;3:客户转化sop;4:新群培育sop;5:周期营销sop;6:特定宣发sop
        sopName: '',
        sendType: 2, // 1:企业微信发送;2:手动发送
        executeWeUser: null,
        executeCustomerOrGroup: null,
        //  {
        //   weSopExecuteGroupTimeCondit: {
        //     change: false,
        //     beginTime: '',
        //     endTime: ''
        //   },
        //   weSopExecuteGroupTagIdsCondit: {
        //     change: false,
        //     tagIds: []
        //   },
        //   weSopExecuteGroupMemberLimitCondit: {
        //     change: false,
        //     groupMemberUp: '',
        //     groupMemberDown: ''
        //   }
        // },
        weSopPushTimes: [
          {
            pushStartTime: '',
            pushEndTime: '',
            pushTimeType: 3,
            pushTimePre: '',
            attachments: [],
          },
        ],
        executeTag: {
          change: false,
          tagIds: [],
        },
        earlyEnd: 0,
      },
    }
  },
  created() {
    if (this.$route.query.id) {
      getSopDetail(this.$route.query.id).then(({ data }) => {
        // 删除主键
        delTreeKeys(data, ['id'])
        data.sopName += '-复制'

        this.form = data
        let arr = JSON.parse(JSON.stringify(this.form.weSopPushTimes[this.form.weSopPushTimes.length - 1].attachments))
        this.form.weSopPushTimes[this.form.weSopPushTimes.length - 1].attachments = arr.filter(
          (item) => item.source !== 2,
        )
        // this.active = 2
      })
    }
  },
  methods: {
    gotoNext(type) {
      this.form.businessType = type
      this.active = 2
    },
    setStepChange(type, data) {
      this.active = type
      if (data) {
        this.form = { ...this.form, ...data }
      }
    },
    submit(data) {
      this.submitLoading = true
      this.form = { ...this.form, ...data }
      // if (this.$route.query.id) {
      //   updateSop(this.form).then((res) => {
      //     if (res.code === 200) {
      //       this.msgSuccess('操作成功!')
      //       this.$router.back(-1)
      //     } else {
      //       this.msgError(res.msg)
      //     }
      //     this.submitLoading = false
      //   })
      // } else {
      // }
      addSop(this.form).then((res) => {
        if (res.code === 200) {
          this.msgSuccess('操作成功!')
          this.$router.back(-1)
        } else {
          this.msgError(res.msg)
        }
        this.submitLoading = false
      })
    },
    activeStatus(index) {
      return this.active == index ? 'process' : this.active > index ? 'success' : 'wait'
    },
  },
}
</script>
<style lang="scss" scoped>
.unit {
  padding: 20px;
  height: 120px;
  display: flex;
  align-items: center;
  background: var(--bg-black-11);
  color: var(--font-black-5);
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
      color: var(--font-black);
    }
  }
}
.selected {
  font-weight: 500;
  color: var(--font-black);
  background: var(--color-light-10);
}
.active {
  &:hover {
    font-weight: 500;
    color: var(--font-black);
    background: var(--color-light-10);
  }
}
</style>
