<script>
import ChartBar from '@/components/ChartBar'
import ChartLine from '@/components/ChartLine'
import SelectUser from '@/components/SelectUser'
import { getList } from '@/api/drainageCode/staff'
export default {
  name: '',
  components: { ChartLine, ChartBar, SelectUser },
  props: {
    type: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      loading: false,
      timeRange: 7,

      total: 0,
      // 表格数据
      list: [
        {
          time: '2021-12-01',
          num: 120
        },
        {
          time: '2021-12-01',
          num: 120
        },
        {
          time: '2021-12-01',
          num: 120
        },
        {
          time: '2021-12-01',
          num: 120
        },
        {
          time: '2021-12-01',
          num: 120
        }
      ],
      xData: [],
      series: [],
      legend: {
        customerGroup: ['新增客群数', '解散客群数'],
        customerGroupMember: ['新增客群成员数', '流失客群成员数']
      },
      // 日期范围
      dateRange: [],
      // 查询参数
      query: {
        group: '',
        beginTime: undefined,
        endTime: undefined
      },
      // 群主
      groupOwners: [],
      // 群聊
      groupChats: []
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getSelectList('groupOwners')
    // this.getSelectList('groupChats')
    this.setTime(7)
  },
  mounted() {},
  methods: {
    getList(page) {
      this.query.beginTime = this.dateRange && this.dateRange[0]
      this.query.endTime = this.dateRange && this.dateRange[1]
      this.loading = true
      page && (this.query.pageNum = page)

      this.xData = this.list.map((e) => e.time)
      this.legend['customerGroup'].forEach((element) => {
        this.series.push(this.list.map((e) => e.num))
      })

      // getList(this.query)
      //   .then(({ rows, total }) => {
      //     this.list = rows
      //     this.total = Number(total)
      //     this.loading = false
      //   })
      //   .catch(() => {
      //     this.loading = false
      //   })
    },
    getSelectList(type) {
      getList()
        .then(({ rows }) => {
          this[type] = rows
        })
        .catch(() => {})
    },
    getTime(datePar) {
      const d = datePar ? new Date(datePar) : new Date()
      d.setMinutes(d.getMinutes() - d.getTimezoneOffset())
      return d.toJSON().substr(0, 10)
    },
    setTime(days) {
      this.timeRange = days
      if (days) {
        let date = new Date()
        date.setDate(date.getDate() - days)
        this.dateRange = [this.getTime(date), this.getTime()]
        this.getList()
      } else {
        this.dateRange = null
      }
    },
    getSelectUser(data) {
      this.userArray = data
      this.query.qrUserName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
    }
  }
}
</script>

<template>
  <div>
    <div class="operation">
      <el-button-group>
        <el-button size="small" type="primary" :plain="timeRange != 7" @click="setTime(7)"
          >近一周</el-button
        >
        <el-button size="small" type="primary" :plain="timeRange != 30" @click="setTime(30)"
          >近一月
        </el-button>
        <el-button size="small" type="primary" :plain="!!timeRange" @click="setTime()"
          >自定义
        </el-button>
      </el-button-group>
      <el-date-picker
        v-if="!timeRange"
        v-model="dateRange"
        size="small"
        class="ml20"
        style="width: 260px"
        value-format="yyyy-MM-dd"
        type="daterange"
        :clearable="false"
        range-separator="-"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        @change="getList"
      ></el-date-picker>
      <el-select
        v-if="
          [
            'customerGroupTotalChart',
            'customerGroupMemberTotalChart',
            'customerGroupTotalTable',
            'customerGroupMemberTotalTable'
          ].includes(type)
        "
        v-model="query.group"
        placeholder="请选择群主"
        @change="getList"
      >
        <el-option
          v-for="item in groupOwners"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        >
        </el-option>
      </el-select>
      <el-select
        v-if="['customerGroupMemberTotalChart', 'customerGroupMemberTotalTable'].includes(type)"
        v-model="query.group"
        placeholder="请选择群聊"
        @change="getList"
      >
        <el-option
          v-for="item in groupChats"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        >
        </el-option>
      </el-select>
      <el-input
        v-if="['customerTotalChart', 'realDataChart'].includes(type)"
        style="width: 180px"
        :value="query.qrUserName"
        readonly
        @focus="dialogVisible = true"
        placeholder="请选择员工"
      />
    </div>
    <el-row :gutter="10">
      <el-col :span="12">
        <ChartLine :xData="xData" :legend="legend['customerGroup']" :series="series"></ChartLine>
      </el-col>
      <el-col :span="12">
        <ChartLine
          :xData="xData"
          :legend="legend['customerGroupMember']"
          :series="series"
        ></ChartLine>
      </el-col>
    </el-row>
  </div>
</template>

<style lang="scss" scoped></style>
