<template>
  <div>
    <div class="g-card">
      <div class="g-card-title">SOP基本信息</div>
      <div class="cont">
        <div class="sub-title">SOP规则名称：</div>
        {{ detail.sopName }}
      </div>
      <div class="cont">
        <div class="sub-title">SOP类型：</div>
        {{ setName(detail.businessType) }}
      </div>
      <div class="cont">
        <div class="sub-title">SOP已发送天数：</div>
        {{ totalDayNumber }}
      </div>
      <div class="cont">
        <div class="sub-title">SOP已发送次数：</div>
        {{ totalNumber }}
      </div>
    </div>
    <div class="g-pad20">
      <div class="tab">
        <el-steps :active="currentActive">
          <template v-for="(unit, index) in list" :key="index">
            <el-step :class="{ current: currentClick === index }" @click="setCurrent(index)"></el-step>
          </template>
        </el-steps>
      </div>
      <div class="send-content" v-if="list.length">
        <div class="word-row">
          <span v-if="detail.businessType === 1 || detail.businessType === 3 || detail.businessType === 4">
            第{{ list[currentClick].pushTimePre }}天，
          </span>
          <!-- <span v-else>{{ list[currentClick].pushTimePre }}</span> -->
          {{ list[currentClick].pushStartTime }} -- {{ list[currentClick].pushEndTime }}内推送
        </div>
        <div class="word-row">
          SOP推送状态：
          <span v-html="setStateStr()"></span>
        </div>
        <div class="view">
          <show-in-phone name="SOP目标推送内容" :list="list[currentClick].weQrAttachments"></show-in-phone>
          <show-in-phone name="SOP实际推送内容" :list="list[currentClick].actualPushWeQrAttachments"></show-in-phone>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { compareTime } from '@/utils/index'
import ShowInPhone from './ShowInPhone'
export default {
  name: 'send-detail',
  data() {
    return {
      currentActive: 1,
      currentClick: 0,
      totalNumber: 0,
      totalDayNumber: 0,
    }
  },
  components: {
    ShowInPhone,
  },
  props: {
    detail: {
      type: Object,
      default: {},
    },
    list: {
      type: Array,
      default: () => [],
    },
  },
  watch: {
    list: {
      handler(val) {
        this.totalNumber = 0
        this.totalDayNumber = 0
        if (val && val.length) {
          val.forEach((dd) => {
            this.totalNumber = Number(dd.sendNumber) + this.totalNumber
            this.totalDayNumber = Number(dd.sendDayNumber) + this.totalDayNumber
          })
        }
      },
      immediate: true,
      deep: true,
    },
  },
  methods: {
    setStateStr() {
      let timeS = compareTime(this.list[this.currentClick].pushStartTime, this.list[this.currentClick].pushEndTime)
      if (this.list[this.currentClick].executeState === 0) {
        if (timeS === 'before') {
          return '未到发送日期'
        } else if (timeS === 'middle') {
          return '成员待发送'
        } else {
          return '成员未发送'
        }
      } else {
        let sendState = compareTime(
          this.list[this.currentClick].pushStartTime,
          this.list[this.currentClick].pushEndTime,
          this.list[this.currentClick].executeTime,
        )
        if (sendState === 'middle') {
          return '成员已发送（' + this.list[this.currentClick].executeTime + '）'
        } else {
          return (
            '成员已发送（' + '<span style="color: red;">' + this.list[this.currentClick].executeTime + '</span>' + '）'
          )
        }
      }
    },
    setCurrent(index) {
      this.currentClick = index
    },
    setName(data) {
      let str = ''
      switch (data) {
        case 1:
          str = '新客SOP'
          break
        case 2:
          str = '活动节日SOP'
          break
        case 3:
          str = '客户转化SOP'
          break
        case 4:
          str = '新群培育SOP'
          break
        case 5:
          str = '周期营销SOP'
          break
        case 6:
          str = '特定宣发SOP'
          break
        default:
          str = ''
          break
      }
      return str
    },
  },
}
</script>
<style lang="scss" scoped>
.current {
  ::v-deep .el-step__head {
    color: var(--color);
    border-color: var(--color);
  }
  ::v-deep .el-step__icon {
    background: var(--bg-black-9);
  }
}
.title {
  margin-bottom: 10px;
  font-size: 16px;
  color: var(--font-black);
  font-weight: 500;
}
.cont {
  margin-bottom: 10px;
  display: flex;
}
.sub-title {
  width: 120px;
  text-align: right;
  color: var(--font-black-6);
}
.tab {
  width: 500px;
  height: 50px;
  overflow-x: scroll;
  overflow-y: hidden;
  ::v-deep .el-step__icon {
    cursor: pointer;
  }
}
.send-content {
  margin-top: 10px;
}
.view {
  display: flex;
}
.word-row {
  margin-bottom: 10px;
}
</style>
<style>
.el-drawer__header {
  margin-bottom: 10px;
}
</style>
