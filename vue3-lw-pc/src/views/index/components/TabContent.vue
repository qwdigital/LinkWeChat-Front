<script>
// import { getList as getGroupList } from '@/api/customer/group'
export default {
  name: '',
  components: {
    ChartLine: defineAsyncComponent(() => import('@/components/ChartLine')),
    ChartBar: defineAsyncComponent(() => import('@/components/ChartBar')),
  },
  props: {
    // 图表类型
    type: {
      type: String,
      default: '',
    },
    // 图表图例; 单个图例可传字符串，多个图例传数组
    legend: {
      type: [Array, String],
      default: null,
    },
    // 接口请求
    request: {
      type: Function,
      default: () => {},
    },
    // 导出接口请求
    requestExport: {
      type: Function,
      default: () => {},
    },
    // 自定义图表配置项，使用loadsh.merge(origin, option)和原有的配置进行覆盖合并
    // loadsh.merge: https://www.html.cn/doc/lodash/#_mergeobject-sources
    option: {
      type: Object,
      default: null,
    },
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
        customerTotalChart: ['客群总数'],
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
        endTime: undefined,
      },
      // 群聊
      groupChats: [],
      tableProps: {
        // 客户数据报表
        customerTotalTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'totalCnt', label: '客户总数' },
          { prop: 'addCnt', label: '新增客户' },
          { prop: 'lostCnt', label: '流失客户' },
          { prop: 'netCnt', label: '净增客户' },
          { prop: 'gjCnt', label: '跟进客户' },
        ],
        // 客群数据报表
        customerGroupTotalTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'totalCnt', label: '客群总数' },
          { prop: 'addCnt', label: '新增客群数' },
          { prop: 'dissolveCnt', label: '解散客群数' },
        ],
        // 客群成员数据报表
        customerGroupMemberTotalTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'totalCnt', label: '客群成员总数' },
          { prop: 'addCnt', label: '新增成员' },
          { prop: 'quitCnt', label: '退出成员' },
        ],
        // 客户联系
        customerContactTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'chatCnt', label: '单聊总数' },
          { prop: 'messageCnt', label: '发送消息数' },
          { prop: 'replyPercentage', label: '已回复聊天占比' },
          { prop: 'avgReplyTime', label: '平均回复时长(分)' },
        ],
        // 客群联系
        customerGroupContactTable: [
          { prop: 'xtime', label: '日期' },
          { prop: 'chatTotal', label: '群聊总数' },
          { prop: 'msgTotal', label: '群聊消息数' },
          { prop: 'memberHasMsg', label: '发送消息群成员数' },
        ],
      },
      userArray: [], // 选择人员
      dialogVisible: false,
      dialogType: '_users',
    }
  },
  computed: {},
  watch: {},
  created() {
    this.setTime(7)
  },
  mounted() {},
  methods: {
    getList(page) {
      if (this.type.includes('Table')) {
        this.query.pageSize || (this.query.pageSize = 10)
      }

      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0]
        this.query.endTime = this.dateRange[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
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
          this.series = []
          data = data || rows

          if (this.type.includes('Chart')) {
            // （条形图）
            this.xData = data.map((e) => e.xtime)

            if ('customerTotalChart,customerGroupTotalChart,customerGroupMemberTotalChart'.includes(this.type)) {
              // 客户总数 / 客群总数 / 客群成员总数 （条形图）
              this.series = data.map((e) => e.totalCnt)
            } else if (this.type === 'realDataChart') {
              // 实时数据
              this.series.push(data.map((e) => e.addCnt))
              this.series.push(data.map((e) => e.lostCnt))
              this.series.push(data.map((e) => e.netCnt))
              this.series.push(data.map((e) => e.gjCnt))
            } else if (this.type === 'groupMemberChart') {
              // 实时数据
              this.series.push(data.map((e) => e.addCnt))
              this.series.push(data.map((e) => e.quitCnt))
            } else {
              let dict = {
                singleChatTotalChart: 'chatCnt', // 单聊总数
                sendMessageNumChart: 'messageCnt', // 发送消息数
                replySingleChatChart: 'replyPercentage', // 回复单聊占比
                averageReplyDurationChart: 'avgReplyTime', // 平均首次回复时长
                groupChatTotalChart: 'chatTotal', // 群聊总数
                groupChatMessageNumChart: 'msgTotal', // 群聊消息数
                sendMessageGroupMemberChart: 'memberHasMsg', // 发送消息群成员数
              }
              this.series = data.map((e) => e[dict[this.type]])
            }
          } else if (this.type === 'staffCustomerBar') {
            // 柱状图
            // 员工客户Top10
            this.xData = data.map((e) => e.userName)
            this.series = data.map((e) => e.totalCnt)
          } else if (this.type.includes('Table')) {
            // 表格
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
    getGroupList(params) {
      getGroupList(params)
        .then(({ rows }) => {
          this.groupChats = rows
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
      this.query[this.dialogType] = data.map((e) => e.userId).join(',')
      if (['customerGroupMemberTotalChart', 'customerGroupMemberTotalTable'].includes(this.type)) {
        this.query.chatIds = ''
        this.getGroupList({
          userIds: this.query[this.dialogType],
        })
      }
      this.getList()
    },
    // exprotTable() {
    //   this.$confirm('是否确认导出吗?', '提示', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //     type: 'warning',
    //   })
    //     .then(() => {
    //       this.loading = true
    //       let query = Object.assign({}, this.query, { pageNum: undefined, pageSize: undefined })
    //       return this.requestExport(query)
    //     })
    //     .then((res) => {
    //       this.download(res.data)
    //     })
    //     .catch((error) => {
    //       console.error(error)
    //     })
    //     .finally(() => {
    //       this.loading = false
    //     })
    // },
  },
}
</script>

<template>
  <div>
    <div class="operation">
      <!-- <el-button-group>
        <el-button type="primary" :plain="timeRange != 7" @click="setTime(7)">近一周</el-button>
        <el-button type="primary" :plain="timeRange != 30" @click="setTime(30)">近一月 </el-button>
        <el-button type="primary" :plain="!!timeRange" @click="setTime()">自定义 </el-button>
      </el-button-group> -->
      <!-- <el-date-picker
        v-if="!timeRange"
        v-model="dateRange"
        class="ml20"
        style="width: 260px"
        value-format="YYYY-MM-DD"
        type="daterange"
        :clearable="false"
        v-bind="pickerOptions"
        range-separator="-"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        @change="getList(1)"
      ></el-date-picker> -->
      <!-- <el-input
        v-if="type.toLowerCase().includes('group')"
        style="width: 180px; margin-left: 20px"
        :model-value="userArray.map((e) => e.name) + ''"
        readonly
        @click="showDialog('_groupOwners')"
        placeholder="请选择群主"
      >
      </el-input> -->
      <!-- <el-select
        style="margin-left: 20px"
        v-if="['customerGroupMemberTotalChart', 'customerGroupMemberTotalTable'].includes(type)"
        v-model="query.chatIds"
        placeholder="请选择群聊"
        clearable
        @change="getList()"
      >
        <el-option
          v-for="item in groupChats"
          :key="item.chatId"
          :label="item.groupName"
          :value="item.chatId"
        >
        </el-option>
      </el-select> -->
      <!-- <el-input
        v-if="
          [
            'customerTotalChart',
            'customerTotalTable',
            'realDataChart',
            'customerContactTable',
          ].includes(type)
        "
        style="width: 180px; margin-left: 20px"
        :model-value="userArray.map((e) => e.name) + ''"
        readonly
        @click="showDialog('_users')"
        placeholder="请选择部门或员工"
      /> -->
      <!-- <el-button v-if="type.includes('Table')" class="fr" type="primary" @click="exprotTable"
        >导出 Excel</el-button
      > -->
    </div>

    <div v-loading="loading">
      <ChartLine
        v-if="type.includes('Chart')"
        :xData="xData"
        :legend="legend || legendDict[type]"
        :series="series"
        :bgLinearGradient="$attrs.bgLinearGradient"></ChartLine>

      <!-- <template v-else-if="type.includes('Table')">
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
           v-model:page="query.pageNum"
           v-model:limit="query.pageSize"
          @pagination="getList()"
        />
      </template> -->

      <ChartBar v-else-if="'staffCustomerBar'.includes(type)" :xData="xData" :series="series"></ChartBar>

      <ChartLine
        v-else-if="'rowEchart'.includes('vChart')"
        :xData="xData"
        :legend="legend || legendDict[type]"
        :series="series"
        :option="option"></ChartLine>
    </div>

    <!-- <SelectUser
       v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
      :isOnlyLeaf="dialogType === '_groupOwners'"
    ></SelectUser> -->
  </div>
</template>

<style lang="scss" scoped></style>
