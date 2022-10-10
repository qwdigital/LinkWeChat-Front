<template>
  <div class="content">
    <div class="header">
      <div class="button" :class="{'active': current === 'begin'}" @click="setUp('begin')" style="margin-right: 10px;">
        <div class="name">开始时间</div>
        <div class="date">{{setDate(beginTime) || '--'}}</div>
      </div>
      <div class="button" :class="{'active': current === 'end'}" @click="setUp('end')"> 
        <div class="name">结束时间</div>
        <div class="date">{{setDate(endTime) || '--'}}</div>
      </div>
    </div>
    <div class="body">
      <van-datetime-picker key="1" v-if="current === 'begin'" type="date" v-model="beginTime" visible-item-count="5" :max-date="today" :show-toolbar="false" />
      <van-datetime-picker key="2" v-if="current === 'end'" type="date" v-model="endTime" visible-item-count="5" :max-date="today" :show-toolbar="false" />
    </div>
    <div class="buttom">
      <div class="cancel_button" @click="resetFn">
        重置
      </div>
      <div class="submit_button" @click="submitFn">
        确定
      </div>
    </div>
  </div>
</template>
<script>
import {dateFormat} from '@/utils/index'
export default {
  name: 'select-date',
  data () {
    return {
      current: '',
      today: new Date(),
      beginTime: '',
      endTime: ''
    }
  },
  props: {
    start: {
      type: String,
      default: ''
    },
    end: {
      type: String,
      default: ''
    }
  },
  watch: {
    start: {
      handler (val) {
        if (val) {
          this.beginTime = new Date(val)
        }
      },
      immediate: true
    },
    end: {
      handler (val) {
        if (val) {
          this.endTime =  new Date(val)
        }
      },
      immediate: true
    },
  },
  methods: {
    setUp (type) {
      if (this.current === type) {
        this.current = ''
      } else {
        this.current = type
        if (type === 'begin' && !this.beginTime) {
          this.beginTime = new Date()
        }
        if (type === 'end' && !this.endTime) {
          this.endTime = new Date()
        }
      }
    },
    setDate (date) {
      if (date) return dateFormat(date, 'yyyy-MM-dd')
    },
    formatFn (type, val) {
      return val;
    },
    resetFn() {
      this.beginTime = ''
      this.endTime = ''
      this.current = ''
    },
    submitFn () {
      if (this.beginTime && this.endTime) {
        if (this.compare(this.beginTime, this.endTime)) {
          this.$emit('success', dateFormat(this.beginTime, 'yyyy-MM-dd'), dateFormat(this.endTime, 'yyyy-MM-dd'))
        } else {
          this.$toast('开始时间不得大于结束时间!')
        }
      } else if (!this.beginTime && !this.endTime) {
        this.$emit('success', '','')
      } else {
        this.$toast('请选择完整开始结束时间!')
      }
    },
    compare (date1, date2) {
      let dates1 = new Date(date1)
      let dates2 = new Date(date2)
      if (dates1 > dates2) {
        return false
      } else {
        return true
      }
    }
  },
  created() {
    
  },
}
</script>
<style lang="less" scoped>
  .content {
    padding: 20px;
  }
  .header {
    display:flex;
    .button {
      flex:  1;
      border-radius: 8px;
      border: 1px solid #F2F2F2;
      text-align: center;
      color: #999999;
      font-weight: 500;
      height:40px;
      padding: 6px 0;
      .name {
        margin-bottom: 2px;
        font-size: 10px;
      }
      .date {
        font-size: 12px;
      }
    }
    .active {
      border: 1px solid  rgba(0,121,222,0.5);
      color: #0079DE;
    }
  }
   .buttom {
    padding-top: 20px;
    display: flex;
    font-size: 16px;
    font-weight: 600px;
    .cancel_button {
      flex:1;
      background: #F8F8F8;
      border-radius: 8px;
      color: #666666;
      text-align: center;
      height: 40px;
      line-height: 40px;
      margin-right: 9px;
    }
    .submit_button {
      flex:1;
      background: #0079DE;
      border-radius: 8px;
      color: #fff;
      text-align: center;
      height: 40px;
      line-height: 40px;
    }
  }
</style>