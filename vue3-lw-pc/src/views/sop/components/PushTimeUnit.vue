<template>
  <div style="padding: 10px 20px">
    <template v-if="dateType === 1 || dateType === 3 || dateType === 4">
      第
      <el-input-number
        style="width: 100px"
        v-model="form.pushTimePre"
        controls-position="right"
        :min="1"
        :readonly="read"
        @input="nubmerFn($event)"></el-input-number>
      天，
    </template>
    <template v-else-if="dateType === 2 || dateType === 6">
      <el-date-picker
        :readonly="read"
        style="width: 130px; margin-right: 10px"
        v-model="form.pushTimePre"
        value-format="YYYY-MM-DD"
        @change="setChange"
        type="date"
        placeholder="选择日期"
        v-bind="pickerOptions"></el-date-picker>
    </template>
    <template v-else>
      推送周期：
      <el-select :readonly="read" @change="setChange" v-model="form.pushTimePre">
        <el-option v-for="(unit, key) in list" :key="key" :value="unit.value" :label="unit.label"></el-option>
      </el-select>
      <div style="margin-top: 20px">
        具体时间：
        <el-time-select
          :readonly="read"
          style="width: 120px"
          v-model="form.pushStartTime"
          v-bind="{
            start: '00:00',
            end: '23:59',
            step: '00:15',
            maxTime: form.pushEndTime,
          }"
          placeholder="时间点"
          @change="setChange"></el-time-select>
        --
        <el-time-select
          :readonly="read"
          style="width: 120px"
          v-bind="{
            start: '00:00',
            end: '23:59',
            step: '00:15',
            minTime: form.pushStartTime,
          }"
          v-model="form.pushEndTime"
          placeholder="时间点"
          @change="setChange"></el-time-select>
      </div>
    </template>
    <template v-if="dateType !== 5">
      <el-time-select
        :readonly="read"
        style="width: 120px"
        v-model="form.pushStartTime"
        v-bind="{
          start: '00:00',
          end: '23:59',
          step: '00:15',
          maxTime: form.pushEndTime,
        }"
        placeholder="时间点"
        @change="setChange"></el-time-select>
      至
      <el-time-select
        :readonly="read"
        style="width: 120px"
        v-bind="{
          start: '00:00',
          end: '23:59',
          step: '00:15',
          minTime: form.pushStartTime,
        }"
        v-model="form.pushEndTime"
        placeholder="时间点"
        @change="setChange"></el-time-select>
      内推送
    </template>
  </div>
</template>
<script>
export default {
  name: 'push-time-unit',
  props: {
    read: {
      type: Boolean,
      default: false,
    },
    dateType: {
      type: Number,
      default: 1,
    },
    init: {
      type: Object,
      default: {
        pushStartTime: '',
        pushEndTime: '',
        pushTimeType: 3,
        pushTimePre: '',
        attachments: [],
      },
    },
  },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 24 * 60 * 60 * 1000
        },
      },
      form: {
        pushStartTime: '',
        pushEndTime: '',
        pushTimeType: 3,
        pushTimePre: '',
        attachments: [],
      },
      list: [
        { value: '', label: '请选择周期' },
        { value: '1', label: '周一' },
        { value: '2', label: '周二' },
        { value: '3', label: '周三' },
        { value: '4', label: '周四' },
        { value: '5', label: '周五' },
        { value: '6', label: '周六' },
        { value: '7', label: '周日' },
      ],
      rules: {},
    }
  },
  methods: {
    nubmerFn(event) {
      console.log()
      let data = event.target.value
      let reg = /^[1-9]+$/
      if (!reg.test(data)) {
        this.msgError('只能输入正整数排序')
        this.$nextTick(() => {
          console.log(data)
          event.target.value = data ? data.replace(/[^1-9]/g, '') : 1
        })
      }
      this.setChange()
    },
    setChange() {
      this.$emit('update', this.form)
    },
  },
  created() {
    this.form = this.init
    this.form.pushTimeType = this.dateType === 5 ? 2 : this.dateType === 2 || this.dateType === 6 ? 1 : 3
  },
}
</script>
<style lang="scss" scoped></style>
