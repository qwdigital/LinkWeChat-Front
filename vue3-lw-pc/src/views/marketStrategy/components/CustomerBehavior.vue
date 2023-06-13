<template>
  <div>
    <el-form
      :inline="true"
      :rules="rules"
      ref="customerBehavior"
      :model="current"
      label-width="0"
      label-position="left"
    >
      <el-form-item>
        在
      </el-form-item>
      <el-form-item prop="code">
        <el-select :disabled="detail" @change="setValueList" v-model="current.code" placeholder="请选择行为时间">
          <el-option v-for="(item, key) in baseData" :key="key" :label="item.value" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
      <template v-if="current.code === 5">
        <el-form-item prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="2"
            v-model="current.startTime"
            type="date"
            @change="setDateChange"
            placeholder="选择日期"
          ></el-date-picker>
        </el-form-item>
      </template>
      <template v-if="current.code === 6">
        <el-form-item prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="1"
            v-model="dateValue"
            @change="setDate"
            value-format="yyyy-MM-dd"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-form-item>
      </template>
      <el-form-item prop="happenType">
        <el-select :disabled="detail" @change="setValueState" v-model="current.happenType" placeholder="请选择发生类型">
          <el-option
            v-for="(item, index) in happenList"
            :key="index"
            :label="item.value"
            :value="item.code"
          ></el-option>
        </el-select>
      </el-form-item>
      <el-form-item prop="behavior">
        <el-select :disabled="detail" v-model="current.behavior" placeholder="请选择行为事件">
          <template v-for="(item, index) in behaviorList">
            <el-option :key="index" :label="item.value" :value="item.code" v-if="filterFn(item.code)"></el-option>
          </template>
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
  import { dateFormat } from '@/utils/index'
  export default {
    name: 'customer-behavior',
    data() {
      return {
        dateValue: [],
        current: {
          code: null,
          behavior: '',
          endTime: '',
          happenType: '',
          relation: '',
          startTime: '',
          value: '',
          name: ''
        },
        rules: {
          code: [{ required: true, message: '请选择行为时间', trigger: 'blur' }],
          startTime: [{ required: true, message: '请选择时间', trigger: 'blur' }],
          happenType: [{ required: true, message: '请选择发生类型', trigger: 'blur' }],
          behavior: [{ required: true, message: '请选择行为事件', trigger: 'blur' }]
        },
        showList: [1, 2, 3, 4, 5, 6, 9]
      }
    },
    props: {
      detail: {
        type: Boolean,
        default: false
      },
      baseData: {
        type: Array,
        default: () => []
      },
      happenList: {
        type: Array,
        default: () => []
      },
      behaviorList: {
        type: Array,
        default: () => []
      },
      currentData: {
        type: Object,
        default: () => {}
      }
    },
    methods: {
      filterFn(code) {
        return this.showList.includes(code)
      },
      handleValidateFn() {
        let status = null
        this.$refs['customerBehavior'].validate((valid) => {
          if (valid) {
            status = true
          } else {
            status = false
          }
        })
        return status
      },
      setValueList() {
        this.current.startTime = ''
        this.current.endTime = ''
        this.current.happenType = ''
        this.current.behavior = ''
        this.dateValue = []
      },
      setValueState() {
        this.current.behavior = ''
      },
      setDate(data) {
        if (!data) {
          this.dateValue = []
          this.current.startTime = ''
          this.current.endTime = ''
        } else {
          if (data[0]) {
            this.current.startTime = data[0]
          }
          if (data[1]) {
            this.current.endTime = data[1]
          }
        }
      },
      setDateChange() {
        this.current.startTime = dateFormat(this.current.startTime, 'yyyy-MM-dd')
      }
    },
    mounted() {
      this.current = this.currentData
      if (this.current.code) {
        this.current.code = Number(this.current.code)
      }
      if (this.current.happenType) {
        this.current.happenType = Number(this.current.happenType)
      }
      if (this.current.behavior) {
        this.current.behavior = Number(this.current.behavior)
      }
      if (this.current.startTime && this.current.endTime) {
        this.dateValue = [this.current.startTime, this.current.endTime]
      }
    }
  }
</script>
<style lang="scss" scoped></style>
