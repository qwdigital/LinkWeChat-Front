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
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"></el-date-picker>
    </div>
    <div class="item" v-if="showMore">
      <el-cascader
        :popper-append-to-body="false"
        clearable
        placeholder="请选择所属地区"
        v-model="areaIds"
        :props="props"
        :options="cityTree"
        ref="tree"
        @change="handleChange"></el-cascader>
    </div>
    <div class="item" v-if="showMore">
      <el-select :transfer="true" placeholder="选择门店" clearable v-model="data.storeCodeId" @change="submit">
        <!-- <el-option label="全部" value=""></el-option> -->
        <el-option v-for="(unit, key) in list" :key="key" :label="unit.storeName" :value="unit.id"></el-option>
      </el-select>
    </div>
  </div>
</template>
<script>
import moment from 'moment'
import { getProCityList } from '@/api/common'
import { getTableList } from '@/api/drainageCode/store'

export default {
  name: 'search-title-in-store',
  props: {
    showMore: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      active: 1,
      value: [],
      data: {
        beginTime: '',
        endTime: '',
        area: '',
        storeCodeId: '',
      },
      areaIds: [],
      cityTree: [],
      list: [],
      props: {
        label: 'name',
        value: 'id',
      },
    }
  },
  methods: {
    handleChange(data) {
      let arr = this.$refs.tree.getCheckedNodes()
      if (arr[0]) {
        this.data.area = arr[0].pathLabels.join('')
      } else {
        this.areaIds = []
        this.data.area = ''
      }
      this.submit()
    },
    getList() {
      getTableList({ pageSize: 10000, pageNum: 1 }).then(({ rows, total }) => {
        this.list = rows
      })
    },
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
    if (this.showMore) {
      getProCityList().then((res) => {
        if (res.code === 200) {
          this.cityTree = res.data
        }
      })
      this.getList()
    }
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
