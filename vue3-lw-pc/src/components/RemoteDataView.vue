<script>
// import * as customerApi from '@/api/operateCenter/customerAnalysis'
// import * as groupApi from '@/api/operateCenter/groupAnalysis'
// import * as conversationApi from '@/api/operateCenter/conversationAnalysis'
import { getList as getGroupList } from '@/api/customer/group'
export default {
  name: '',
  components: {
    ChartLine: defineAsyncComponent(() => import('@/components/ChartLine')),
    ChartBar: defineAsyncComponent(() => import('@/components/ChartBar')),
  },
  props: {
    // 图表类型
    type: {
      type: String, // lineChart, barChart, table
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
    // 是否显示时间查询
    isTimeQuery: {
      type: Boolean,
      default: false,
    },
    // 是否显示选择群主
    isGroupOwnerQuery: {
      type: Boolean,
      default: false,
    },
    // 是否显示选择群聊
    isGroupQuery: {
      type: Boolean,
      default: false,
    },
    // 是否显示选择部门或员工
    isDepartOrStaff: {
      type: Boolean,
      default: false,
    },
    // 导出接口请求
    requestExport: {
      type: Function,
      default: null,
    },
    // 自定义图表配置项，使用loadsh.merge(origin, option)和原有的配置进行覆盖合并
    // loadsh.merge: https://www.html.cn/doc/lodash/#_mergeobject-sources
    option: {
      type: Object,
      default: null,
    },
    // 导出接口请求
    dealDataFun: {
      type: Function,
      default: null,
    },
  },
  data() {
    return {
      loading: false,
      timeRange: 7,

      total: 0,
      // 表格数据
      data: [],
      xData: [],
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
      tableProps: [],
      userArray: [], // 选择人员
      dialogVisible: false,
      dialogType: '',
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
      if (this.type == 'table') {
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
          if (!data || !data.length) {
            return
          }
          if (this.type == 'table') {
            // 表格
            this.data = data
            this.total = Number(total)
          } else {
            this.dealDataFun && this.dealDataFun(data, this.data, this.xData)
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
    exprotTable() {
      this.$confirm('是否确认导出吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.loading = true
          let query = Object.assign({}, this.query, { pageNum: undefined, pageSize: undefined })
          return this.requestExport(query)
        })
        .then((res) => {
          this.download(res.data)
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <div>
    <div class="operation">
      <template v-if="isTimeQuery">
        <el-button-group>
          <el-button type="primary" :plain="timeRange != 7" @click="setTime(7)">近一周</el-button>
          <el-button type="primary" :plain="timeRange != 30" @click="setTime(30)">近一月</el-button>
          <el-button type="primary" :plain="!!timeRange" @click="setTime()">自定义</el-button>
        </el-button-group>
        <el-date-picker
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
          @change="getList(1)"></el-date-picker>
      </template>
      <el-input
        v-if="isGroupOwnerQuery"
        style="width: 180px; margin-left: 20px"
        :model-value="userArray.map((e) => e.name) + ''"
        readonly
        @click="showDialog('_groupOwners')"
        placeholder="请选择群主"></el-input>
      <el-select
        style="margin-left: 20px"
        v-if="isGroupQuery"
        v-model="query.chatIds"
        placeholder="请选择群聊"
        clearable
        @change="getList()">
        <el-option
          v-for="item in groupChats"
          :key="item.chatId"
          :label="item.groupName"
          :value="item.chatId"></el-option>
      </el-select>
      <el-input
        v-if="isDepartOrStaff"
        style="width: 180px; margin-left: 20px"
        :model-value="userArray.map((e) => e.name) + ''"
        readonly
        @click="showDialog('_users')"
        placeholder="请选择部门或员工" />
      <el-button v-if="requestExport" class="fr" type="primary" @click="exprotTable">导出 Excel</el-button>
    </div>

    <div v-loading="loading">
      <ChartLine v-if="type == 'lineChart'" :xData="xData" :legend="legend" :series="data"></ChartLine>

      <template v-else-if="type == 'table'">
        <el-table :data="data" style="width: 100%">
          <el-table-column
            v-for="(item, index) in tableProps[type]"
            :key="index"
            :prop="item.prop"
            :label="item.label"
            align="center"></el-table-column>
        </el-table>
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </template>

      <ChartBar v-else-if="'barChart'.includes(type)" :xData="xData" :series="data"></ChartBar>

      <ChartLine
        v-else-if="'rowEchart'.includes('vChart')"
        :xData="xData"
        :legend="legend"
        :series="data"
        :option="option"></ChartLine>
    </div>

    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
      :isOnlyLeaf="dialogType === '_groupOwners'"></SelectUser>
  </div>
</template>

<style lang="scss" scoped></style>
