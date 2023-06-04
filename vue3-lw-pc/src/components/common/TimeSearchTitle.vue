<template>
  <div class="search">
    <div class="item">
      <el-button-group>
        <el-button @click="setType(1)" :type="active === 1 ? 'primary' : ''">近一周</el-button>
        <el-button @click="setType(2)" :type="active === 2 ? 'primary' : ''">近一月</el-button>
        <el-button @click="setType(3)" :type="active === 3 ? 'primary' : ''">自定义</el-button>
      </el-button-group>
    </div>
    <div class="item" v-if="active === 3">
      <el-date-picker
        style="width: 250px"
        @change="setTime"
        clearable
        v-model="value"
        type="daterange"
        v-bind="pickerOptions"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"></el-date-picker>
    </div>
  </div>
</template>
<script>
import moment from 'moment'
export default {
  name: 'search-title',
  props: {},
  data() {
    return {
      active: 1,
      value: [],
      options: [{ value: 10, label: '1123' }],
      value2: [],
      data: {
        beginTime: '',
        endTime: '',
      },
      sceneList: [],
      customerList: [],
      manList: [],
    }
  },
  methods: {
    submit() {
      this.$emit('search', this.data)
    },
    setTime(e) {
      if (e) {
        this.data.beginTime = moment(e[0]).format('YYYY-MM-DD')
        this.data.endTime = moment(e[1]).format('YYYY-MM-DD')
      } else {
        this.data.beginTime = ''
        this.data.endTime = ''
      }
      this.submit()
    },
    setType(type) {
      this.active = type
      if (type === 1) {
        const weekStart = moment().subtract(6, 'days').format('YYYY-MM-DD')
        const weekEnd = moment().format('YYYY-MM-DD')
        this.data.beginTime = weekStart
        this.data.endTime = weekEnd
        this.submit()
      } else if (type === 2) {
        this.data.endTime = moment().format('YYYY-MM-DD')
        this.data.beginTime = moment().subtract(29, 'days').format('YYYY-MM-DD')
        this.submit()
      }
    },
  },
  created() {
    this.setType(1)
  },
}
</script>
<style lang="scss" scoped>
.search {
  display: flex;
  align-items: center;
  .item {
    margin-right: 20px;
  }
}
</style>
