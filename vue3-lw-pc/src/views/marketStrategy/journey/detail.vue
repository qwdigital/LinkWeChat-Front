<template>
  <div>
    <div class="g-card">
      <div class="card-top">
        <!-- <span>每天促活新客户</span> -->
        <span>{{ titleList.name }}</span>
        <el-button size="mini" :type="buttomStyle">{{ titleList.statusText }}</el-button>
      </div>
      <div class="card-bottom">
        <div>
          <span class="title">旅程分组：</span>
          <span class="content">{{ titleList.groupName }}</span>
          <span class="title" style="margin-left: 16px">执行方式：</span>
          <!-- <span class="content">每天 09:00</span> -->
          <span class="content">{{ dealType }}</span>
        </div>
        <div>
          <span class="title">起止时间：</span>
          <span class="content">{{ titleList.startTime || '-' }} ~ {{ titleList.finishTime || '-' }}</span>
        </div>
      </div>
    </div>
    <div class="card-tab">
      <div :class="activeIndex === 0 ? 'active' : ''" @click="activeIndex = 0">旅程画布</div>
      <div :class="activeIndex === 1 ? 'active' : ''" @click="activeIndex = 1">触达明细</div>
    </div>
    <div class="g-card card-content pad20">
      <!-- 旅程画布 -->
      <Flow pageType="view" v-if="activeIndex === 0" />
      <!-- 触达明细 -->
      <TouchDetails :showDatePicker="showDatePicker" v-else />
    </div>
  </div>
</template>

<script>
import Flow from './Flow.vue'
import TouchDetails from './TouchDetails.vue'
import { getDetail } from '@/api/marketStrategy/journey.js'
export default {
  components: { Flow, TouchDetails },
  data() {
    return {
      activeIndex: 0,
      id: '',
      titleList: {
        name: '每天促活新客户',
        type: 1, // 执行方式
        startTime: '_', // 开始时间
        finishTime: '_', // 结束时间
        status: null, // 状态
      },
      buttomStyle: '', // 按钮颜色
      showDatePicker: false,
    }
  },
  computed: {
    dealType() {
      if (this.titleList.type === 1) {
        return '立即执行'
      } else if (this.titleList.type === 2) {
        return '定时执行 ' + this.titleList.executeTime
      } else if (this.titleList.type === 3) {
        this.showDatePicker = true
        if (this.titleList.cycleCode === 1) {
          let dealType = '每天 ' + this.titleList.executeTime
          return dealType
        } else if (this.titleList.cycleCode === 2) {
          let week = ''
          switch (this.titleList.cycleValue) {
            case 1:
              week = '周一 '
              break
            case 2:
              week = '周二 '
              break
            case 3:
              week = '周三 '
              break
            case 4:
              week = '周四 '
              break
            case 5:
              week = '周五 '
              break
            case 6:
              week = '周六 '
              break
            case 7:
              week = '周日'
              break
          }
          return '每周 ' + week + this.titleList.executeTime
        } else if (this.titleList.cycleCode === 3) {
          return '每月 ' + this.titleList.cycleValue + '号 ' + this.titleList.executeTime
        }
      }
    },
  },
  methods: {
    getJourneyDtail() {
      getDetail(this.id).then((res) => {
        this.titleList = res.data
        switch (this.titleList.status) {
          case 0:
            this.titleList.statusText = '未发布'
            this.buttomStyle = 'info'
            break
          case 1:
            this.titleList.statusText = '待执行'
            this.buttomStyle = 'info'
            break
          case 2:
            this.titleList.statusText = '执行中'
            this.buttomStyle = 'primary'
            break
          case 3:
            this.titleList.statusText = '已完成'
            this.buttomStyle = 'success'
            break
          case 4:
            this.titleList.statusText = '已暂停'
            this.buttomStyle = 'primary'
            break
          case 5:
            this.titleList.statusText = '已停用'
            this.buttomStyle = 'danger'
            break
          case 6:
            this.titleList.statusText = '执行失败'
            this.buttomStyle = 'danger'
            break
          default:
            break
        }
      })
    },
  },
  created() {
    this.id = this.$route.query.id
    this.getJourneyDtail()
  },
}
</script>

<style lang="scss" scoped>
.active {
  font-weight: 600;
  color: #0079de !important;
  background-color: #fff !important;
  box-shadow: 0px 6px 30px 5px rgba(59, 59, 59, 0.05);
}
.card-top {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
  span {
    font-size: 16px;
    font-weight: 600;
    color: rgba(0, 0, 0, 0.9);
    line-height: 28px;
  }
}
.card-bottom {
  display: flex;
  justify-content: space-between;
  span {
    font-size: 14px;
    color: #000;
    line-height: 22px;
  }
  .title {
    opacity: 0.9;
  }
  .content {
    opacity: 0.6;
  }
}
.card-tab {
  display: flex;
  div {
    width: 88px;
    height: 30px;
    background: #fafafa;
    border-radius: 32px 32px 32px 32px;
    font-size: 14px;
    color: rgba(0, 0, 0, 0.4);
    line-height: 30px;
    text-align: center;
    margin-top: 15px;
    margin-right: 12px;
    margin-bottom: 6px;
  }
}
.card-tab:hover {
  cursor: pointer;
  box-shadow: 0px 6px 30px 5px rgba(59, 59, 59, 0.05);
}
.card-content {
  ::v-deep .flow-wrap {
    height: calc(100vh - 345px);
  }
}
</style>
