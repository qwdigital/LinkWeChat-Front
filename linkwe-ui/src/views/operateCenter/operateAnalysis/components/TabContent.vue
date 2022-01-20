<script>
import ChartBar from '@/components/ChartBar'
import ChartLine from '@/components/ChartLine'
import SelectUser from '@/components/SelectUser'
import * as customerApi from '@/api/operateCenter/customerAnalysis'
import * as groupApi from '@/api/operateCenter/groupAnalysis'
import * as conversationApi from '@/api/operateCenter/conversationAnalysis'
export default {
  name: '',
  components: { ChartLine, ChartBar, SelectUser },
  props: {
    type: {
      type: String,
      default: ''
    },
    legend: {
      type: Array,
      default: null
    },
    request: {
      type: Function,
      default: () => {}
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
      legendDict: {
        customerTotalChart: ['客户总数'],
        realDataChart: ['新增客户数', '流失客户数', '净增客户数', '发送申请数'],
        customerGroupTotalChart: ['客群总数'],
        customerGroupMemberTotalChart: ['客群成员总数'],
        customerTotalChart: ['客群总数'],
        customerTotalChart: ['客群总数']
      },
      // 日期范围
      dateRange: [],
      // 查询参数
      query: {
        deptIds: [],
        userIds: [],
        chatIds: [],
        ownerIds: [],
        beginTime: undefined,
        endTime: undefined
      },
      // 群主
      groupOwners: [],
      // 群聊
      groupChats: [],
      tableProps: {
        customerTotalTable: [
          { prop: '', label: '日期' },
          { prop: '', label: '客户总数' },
          { prop: '', label: '新增客户数' },
          { prop: '', label: '流失客户数' },
          { prop: '', label: '净增客户数' },
          { prop: '', label: '昨日发送申请数' }
        ],
        customerGroupTotalTable: [
          { prop: '', label: '日期' },
          { prop: '', label: '客群总数' },
          { prop: '', label: '新增客群数' },
          { prop: '', label: '解散客群数' }
        ],
        customerGroupMemberTotalTable: [
          { prop: '', label: '日期' },
          { prop: '', label: '客群成员总数' },
          { prop: '', label: '新增客群成员数' },
          { prop: '', label: '流失客群成员数' }
        ],
        // 客户联系
        customerContactTable: [
          { prop: '', label: '日期' },
          { prop: '', label: '单聊总数' },
          { prop: '', label: '发送消息数' },
          { prop: '', label: '已回复聊天占比' },
          { prop: '', label: '平均回复时长(分)' }
        ],
        // 客户联系
        customerGroupContactTable: [
          { prop: '', label: '日期' },
          { prop: '', label: '群聊总数' },
          { prop: '', label: '群聊消息数' },
          { prop: '', label: '发送消息群成员数' }
        ]
      },
      userArray: [], // 选择人员
      dialogVisible: false
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

      this.request(this.query)
        .then(({ rows, total, data }) => {
          if (this.type.includes('Chart')) {
            this.xData = data.map((e) => e.xtime)
            this.series = data.map((e) => e.totalCnt)
          } else if (this.type === 'realDataChart') {
            this.xData = data.map((e) => e.time)
            this.legendDict[this.type].forEach((element) => {
              this.series.push(data.map((e) => e.num))
            })
          }
          this.total = Number(total)
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
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
        v-if="type.toLowerCase().includes('group')"
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
        v-if="['customerTotalChart', 'realDataChart', 'customerContactTable'].includes(type)"
        style="width: 180px"
        :value="query.qrUserName"
        readonly
        @focus="dialogVisible = true"
        placeholder="请选择部门或员工"
      />
      <el-button v-if="type.includes('Table')" class="fr" type="primary">导出 Exce</el-button>
    </div>
    <ChartLine
      v-if="type.includes('Chart')"
      :xData="xData"
      :legend="legend || legendDict[type]"
      :series="series"
    ></ChartLine>
    <el-table v-else-if="type.includes('Table')" :data="list" style="width: 100%">
      <el-table-column
        v-for="(item, index) in tableProps[type]"
        :key="index"
        :prop="item.label"
        :label="item.label"
        align="center"
      >
      </el-table-column>
    </el-table>
    <ChartBar v-else-if="'staffCustomerBar'.includes(type)"></ChartBar>

    <SelectUser
      :visible.sync="dialogVisible"
      title="组织架构"
      :selected="userArray"
      @success="getSelectUser"
    ></SelectUser>
  </div>
</template>

<style lang="scss" scoped></style>
