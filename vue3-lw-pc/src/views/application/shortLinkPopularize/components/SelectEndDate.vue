<template>
  <div>
    <el-form-item label="结束时间">
      <el-date-picker
        :disabled="isDetail"
        @change="setTimeChange"
        v-model="form.taskEndTime"
        type="datetime"
        placeholder="选择日期时间"
        v-bind="pickerOptions"></el-date-picker>
    </el-form-item>
  </div>
</template>

<script>
import { parseTime } from '@/utils/common'
import moment from 'moment'
export default {
  name: 'select-end-date',
  data() {
    return {
      form: {
        taskEndTime: '',
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
        taskEndTime: '',
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
          this.form.taskEndTime = val.taskEndTime
        }
      },
      deep: true,
      immediate: true,
    },
    'form.taskEndTime'(selectTime) {
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
    setTimeChange() {
      this.$emit('update', this.form)
    },
  },
}
</script>

<style scoped></style>
