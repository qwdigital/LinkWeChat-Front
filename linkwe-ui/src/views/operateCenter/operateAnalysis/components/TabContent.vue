<script>
// import * as customerApi from '@/api/operateCenter/customerAnalysis'
// import * as groupApi from '@/api/operateCenter/groupAnalysis'
// import * as conversationApi from '@/api/operateCenter/conversationAnalysis'
export default {
  name: '',
  components: {
    ChartLine: () => import('@/components/ChartLine'),
    ChartBar: () => import('@/components/ChartBar'),
    SelectUser: () => import('@/components/SelectUser')
  },
  props: {
    // 图表类型
    type: {
      type: String,
      default: ''
    },
    // 图表图例; 单个图例可传字符串，多个图例传数组
    legend: {
      type: [Array, String],
      default: null
    },
    // 接口请求
    request: {
      type: Function,
      default: () => {}
    },
    // 导出接口请求
    requestExport: {
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
      list: [],
      xData: [],
      series: [],
      legendDict: {
        customerTotalChart: ['客群总数'],
        customerTotalChart: ['客群总数']
      },
      // 日期范围
      dateRange: [],
      // 查询参数
      query: {
        pageNum: undefined,
        pageSize: undefined,
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
        // 客户数据报表
        customerTotalTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'totalCnt', label: '客户总数' },
          { prop: 'addCnt', label: '新增客户数' },
          { prop: 'lostCnt', label: '流失客户数' },
          { prop: 'netCnt', label: '净增客户数' },
          { prop: 'applyCnt', label: '昨日发送申请数' }
        ],
        // 客群数据报表
        customerGroupTotalTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'totalCnt', label: '客群总数' },
          { prop: 'addCnt', label: '新增客群数' },
          { prop: 'dissolveCnt', label: '解散客群数' }
        ],
        // 客群成员数据报表
        customerGroupMemberTotalTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'totalCnt', label: '客群成员总数' },
          { prop: 'addCnt', label: '新增客群成员数' },
          { prop: 'quitCnt', label: '流失客群成员数' }
        ],
        // 客户联系
        customerContactTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'chatCnt', label: '单聊总数' },
          { prop: 'messageCnt', label: '发送消息数' },
          { prop: 'replyPercentage', label: '已回复聊天占比' },
          { prop: 'avgReplyTime', label: '平均回复时长(分)' }
        ],
        // 客群联系
        customerGroupContactTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'chatTotal', label: '群聊总数' },
          { prop: 'msgTotal', label: '群聊消息数' },
          { prop: 'memberHasMsg', label: '发送消息群成员数' }
        ]
      },
      userArray: [], // 选择人员
      dialogVisible: false,
      dialogType: '_users'
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
      if (this.type.includes('Table')) {
        this.query.pageSize || (this.query.pageSize = 10)
      }

      this.query.beginTime = this.dateRange && this.dateRange[0]
      this.query.endTime = this.dateRange && this.dateRange[1]
      if (this.dialogType === '_users') {
        if (Array.isArray(this.userArray)) {
          this.query.deptIds = this.userArray
            .filter((e) => e.isParty)
            .map((e) => e.id)
            .join(',')
          this.query.userIds = this.userArray
            .filter((e) => !e.isParty)
            .map((e) => e.userId)
            .join(',')
        } else {
          this.query.deptIds = this.query.userIds = ''
        }
      } else if (this.dialogType === '_groupOwners') {
        if (Array.isArray(this.userArray)) {
          this.query.ownerIds = this.userArray
            .filter((e) => !e.isParty)
            .map((e) => e.userId)
            .join(',')
        } else {
          this.query.ownerIds = ''
        }
      }
      this.loading = true
      page && (this.query.pageNum = page)

      this.request(this.query)
        .then(({ rows, total, data }) => {
          data = data || rows
          if (this.type.includes('Chart')) {
            this.xData = data.map((e) => e.xtime)

            if (
              'customerTotalChart,customerGroupTotalChart,customerGroupMemberTotalChart'.includes(
                this.type
              )
            ) {
              // 客户总数
              this.series = data.map((e) => e.totalCnt)
            } else if (this.type === 'realDataChart') {
              // 实时数据
              this.series.push(data.map((e) => e.addCnt))
              this.series.push(data.map((e) => e.lostCnt))
              this.series.push(data.map((e) => e.netCnt))
              this.series.push(data.map((e) => e.applyCnt))
            } else {
              let dict = {
                singleChatTotalChart: 'chatCnt', // 单聊总数
                sendMessageNumChart: 'messageCnt', // 发送消息数
                replySingleChatChart: 'replyPercentage', // 回复单聊占比
                averageReplyDurationChart: 'avgReplyTime', // 平均首次回复时长
                groupChatTotalChart: 'chatTotal', // 群聊总数
                groupChatMessageNumChart: 'msgTotal', // 群聊消息数
                sendMessageGroupMemberChart: 'memberHasMsg' // 发送消息群成员数
              }
              this.series = data.map((e) => e[dict[this.type]])
            }
          } else if (this.type === 'staffCustomerBar') {
            // 员工客户Top10
            this.xData = data.map((e) => e.userName)
            this.series = data.map((e) => e.totalCnt)
          } else if (this.type.includes('Table')) {
            this.list = data
            this.total = Number(total)
          }
        })
        .catch((e) => {
          console.error(e)
        })
        .finally(() => {
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
    showDialog(type) {
      this.dialogType = type
      this.dialogVisible = true
    },
    getSelectUser(data) {
      this.userArray = data
      this.query[this.dialogType] = data.map((e) => e.name).join(',')
      this.getList()
    },
    exprotTable() {
      this.$confirm('是否确认导出吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(() => {
          let query = Object.assign({}, this.query, { pageNum: undefined, pageSize: undefined })
          return this.requestExport(query)
        })
        .then((res) => {
          this.download(res.msg)
        })
        .catch((error) => {
          console.error(error)
        })
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
        :picker-options="pickerOptions"
        range-separator="-"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        @change="getList(1)"
      ></el-date-picker>
      <el-input
        v-if="type.toLowerCase().includes('group')"
        style="width: 180px"
        v-model="query._groupOwners"
        readonly
        @focus="showDialog('_groupOwners')"
        placeholder="请选择群主"
        @change="getList(1)"
      >
      </el-input>
      <el-select
        v-if="['customerGroupMemberTotalChart', 'customerGroupMemberTotalTable'].includes(type)"
        v-model="query.group"
        placeholder="请选择群聊"
        @change="getList(1)"
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
        v-if="
          [
            'customerTotalChart',
            'customerTotalTable',
            'realDataChart',
            'customerContactTable'
          ].includes(type)
        "
        style="width: 180px"
        :value="query._users"
        readonly
        @focus="showDialog('_users')"
        placeholder="请选择部门或员工"
        @change="getList(1)"
      />
      <el-button v-if="type.includes('Table')" class="fr" type="primary" @click="exprotTable"
        >导出 Excel</el-button
      >
    </div>

    <div v-loading="loading">
      <ChartLine
        v-if="type.includes('Chart')"
        :xData="xData"
        :legend="legend || legendDict[type]"
        :series="series"
      ></ChartLine>

      <template v-else-if="type.includes('Table')">
        <el-table :data="list" style="width: 100%">
          <el-table-column
            v-for="(item, index) in tableProps[type]"
            :key="index"
            :prop="item.prop"
            :label="item.label"
            align="center"
          >
          </el-table-column>
        </el-table>
        <pagination
          :total="total"
          :page.sync="query.pageNum"
          :limit.sync="query.pageSize"
          @pagination="getList()"
        />
      </template>

      <ChartBar
        v-else-if="'staffCustomerBar'.includes(type)"
        :xData="xData"
        :series="series"
      ></ChartBar>
    </div>

    <SelectUser
      :visible.sync="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
      :isOnlyLeaf="dialogType === '_groupOwners'"
    ></SelectUser>
  </div>
</template>

<style lang="scss" scoped></style>
