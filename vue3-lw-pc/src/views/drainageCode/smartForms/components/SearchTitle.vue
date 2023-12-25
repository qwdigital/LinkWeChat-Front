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
    <div class="item" v-if="showScene">
      <!-- <el-select  v-model="data." placeholder="请选择场景" clearable>
        <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
      </el-select> -->
      <el-select @change="submit()" v-model="data.dataSource" placeholder="请选择渠道">
        <el-option v-for="(item, index) in sceneList.channelsName" :key="index" :value="item" :label="item"></el-option>
      </el-select>
    </div>
    <!-- <div class="item" v-if="showMember">
      <el-select  v-model="data.openKfIds" @change="setMemeber" clearable placeholder="请选择客服">
        <el-option value="" label="全部客服"></el-option>
        <el-option v-for="(data, index) in customerList" :key="index" :value="data.openKfId" :label="data.name"></el-option>
      </el-select>
    </div>
    <div class="item" v-if="showMember">
      <el-select  v-model="data.userIds" @change="selectMember" clearable placeholder="请选择接待员工">
        <el-option value="" label="全部员工"></el-option>
        <el-option v-for="item in manList" :key="item.value" :label="item.userName" :value="item.userId">
        </el-option>
      </el-select>
    </div> -->
  </div>
</template>
<script>
import moment from 'moment'
// import { getList } from '@/api/drainageCode/customerService.js'
import { selectInfoToSurvey } from '@/api/drainageCode/smartForms.js'
export default {
  name: 'search-title',
  props: {
    showScene: {
      type: Boolean,
      default: false,
    },
    showMember: {
      type: Boolean,
      default: false,
    },
    id: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      active: 1,
      value: [],
      options: [{ value: 10, label: '1123' }],
      value2: [],
      data: {
        startDate: '',
        endDate: '',
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
      this.$emit('search', this.data)
      // this.$forceUpdate()
    },
    setTime(e) {
      if (e) {
        this.data.startDate = moment(e[0]).format('YYYY-MM-DD')
        this.data.endDate = moment(e[1]).format('YYYY-MM-DD')
      } else {
        this.data.startDate = ''
        this.data.endDate = ''
      }
      this.submit()
    },
    setType(type) {
      this.active = type
      if (type === 1) {
        const weekStart = moment().subtract(6, 'days').format('YYYY-MM-DD')
        const weekEnd = moment().format('YYYY-MM-DD')
        this.data.startDate = weekStart
        this.data.endDate = weekEnd
        this.data.type = 'week'
        // delete this.data.startDate
        // delete this.data.endDate
        this.submit()
      } else if (type === 2) {
        this.data.endDate = moment().format('YYYY-MM-DD')
        this.data.startDate = moment().subtract(29, 'days').format('YYYY-MM-DD')
        this.data.type = 'month'
        // delete this.data.startDate
        // delete this.data.endDate
        this.submit()
      } else if (type == 3) {
        this.data.type = 'customization'
      }
    },
  },
  created() {
    if (this.showScene) {
      selectInfoToSurvey(this.id).then((dd) => {
        this.sceneList = dd.data || { channelsName: '' }
        this.sceneList.channelsName = this.sceneList.channelsName.split(',')
        this.data.dataSource = this.sceneList.channelsName[0]
        this.$emit('search', this.data)
      })
    }
    // if (this.showMember) {
    //   getList().then((res) => {
    //     this.customerList = res.rows
    //   })
    // }

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
