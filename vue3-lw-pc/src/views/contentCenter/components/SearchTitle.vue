<template>
  <div class="search">
    <div class="item">
      <el-button-group>
        <el-button @click="setType(0)" :type="active === 0 ? 'primary' : ''" v-if="showToday">今日</el-button>
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
    <!-- <div class="item" v-if="showScene">
      <el-select  v-model="data." placeholder="请选择场景" clearable>
        <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
      </el-select>
      <el-select :popper-append-to-body="false"  @change="submit()" v-model="data.scenes" clearable placeholder="请选择场景">
        <el-option value="" label="全部场景"></el-option>
        <el-option v-for="(data, index) in sceneList" :key="index" :value="data.scenes" :label="data.name"></el-option>
      </el-select>
    </div>
    <div class="item" v-if="showMember">
      <el-select :popper-append-to-body="false"  v-model="data.openKfIds" @change="setMemeber" clearable placeholder="请选择客服">
        <el-option value="" label="全部客服"></el-option>
        <el-option v-for="(data, index) in customerList" :key="index" :value="data.openKfId" :label="data.name"></el-option>
      </el-select>
    </div>
    <div class="item" v-if="showMember">
      <el-select :popper-append-to-body="false"  v-model="data.userIds" @change="selectMember" clearable placeholder="请选择接待员工">
        <el-option value="" label="全部员工"></el-option>
        <el-option v-for="item in manList" :key="item.value" :label="item.userName" :value="item.userId">
        </el-option>
      </el-select>
    </div> -->
  </div>
</template>
<script>
import moment from 'moment'
import { getSceneList, getList } from '@/api/drainageCode/customerService.js'
export default {
  name: 'search-title',
  props: {
    showToday: {
      type: Boolean,
      default: false,
    },
    // showMember: {
    //   type: Boolean,
    //   default: false
    // }
  },
  data() {
    return {
      active: 1,
      value: [],
      options: [{ value: 10, label: '1123' }],
      value2: [],
      data: {
        // openKfIds: '',
        // scenes: '',
        // userIds: '',
        beginTime: '',
        endTime: '',
      },
      sceneList: [],
      customerList: [],
      manList: [],
    }
  },
  methods: {
    setMemeber(e) {
      if (e) {
        this.data.userIds = ''
        this.customerList.forEach((dd) => {
          if (dd.openKfId === e) {
            this.manList = dd.userIdList
          }
        })
      } else {
        this.manList = []
        this.data.userIds = ''
      }
      this.submit()
    },
    selectMember(e) {
      this.submit()
    },
    submit() {
      console.log(this.data)
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
      if (type === 0) {
        this.data.beginTime = moment().format('YYYY-MM-DD')
        this.data.endTime = moment().format('YYYY-MM-DD')
        this.submit()
      } else if (type === 1) {
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
    // if (this.showScene) {
    //   getSceneList({ pageSize: 1000 }).then(dd => {
    //     this.sceneList = dd.rows
    //   })
    // }
    // if (this.showMember) {
    //   getList().then(res => {
    //     this.customerList = res.rows
    //   })
    // }
    if (this.showToday) {
      this.setType(0)
    } else {
      this.setType(1)
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
