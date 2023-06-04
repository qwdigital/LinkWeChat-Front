<template>
  <div>
    <el-form-item label="发送类型" required>
      <el-radio-group v-model="form.sendType" @change="setChange" :disabled="isDetail">
        <el-radio :label="0">立即发送</el-radio>
        <el-radio :label="1">定时发送</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item v-if="form.sendType == 1">
      <div>
        <div class="item-magin">
          <div class="item-name">发送时间</div>
          <el-date-picker
            :disabled="isDetail"
            @change="setTimeChange"
            v-model="form.taskSendTime"
            type="datetime"
            placeholder="选择日期时间"
            v-bind="pickerOptions"></el-date-picker>
        </div>
      </div>
    </el-form-item>
  </div>
</template>

<script>
import { parseTime } from '@/utils/common'
import moment from 'moment'
export default {
  name: 'select-send-type',
  data() {
    return {
      form: {
        sendType: 0,
        taskSendTime: '',
      },
      pickerOptions: {
        disabledDate(time) {
          var date = new Date()
          date.setFullYear(date.getFullYear() + 2)
          date.setDate(date.getDate() - 1)
          return time.getTime() < Date.now() - 8.64e7 || time.getTime() > date.getTime()
        },
        selectableRange: parseTime(new Date(moment().format('YYYY-MM-DD HH:mm:ss')), '{hh}:{ii}:{ss}') + '- 23:59:59',
      },
    }
  },
  props: {
    data: {
      type: Object,
      default: {
        sendType: 0,
        taskSendTime: '',
      },
    },
    isDetail: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    data: {
      handler(val, old) {
        if (val) {
          this.form.sendType = val.sendType
          this.form.taskSendTime = val.taskSendTime
        }
      },
      deep: true,
      immediate: true,
    },
    'form.taskSendTime'(selectTime) {
      const myDate = new Date()
      const now = myDate.valueOf()
      const time = new Date(selectTime).valueOf()
      if (time > now) {
        this.pickerOptions.selectableRange =
          parseTime(new Date(moment().format('YYYY-MM-DD HH:mm:ss')), '00:00:00') + '- 23:59:59'
      } else {
        this.pickerOptions.selectableRange =
          parseTime(new Date(moment().format('YYYY-MM-DD HH:mm:ss')), '{hh}:{ii}:{ss}') + '- 23:59:00'
      }
    },
  },
  methods: {
    setChange(type) {
      if (type == 0) {
        this.form.taskSendTime = ''
      }
      this.$emit('update', this.form)
    },
    setTimeChange() {
      this.$emit('update', this.form)
    },
  },
}
</script>

<style scoped></style>
