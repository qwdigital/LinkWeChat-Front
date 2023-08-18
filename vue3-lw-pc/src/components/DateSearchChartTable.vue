<!-- 时间搜索（近一周，近一月，自定义）数据图表或表格 组件 -->
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
    // 数据展示图表类型
    type: {
      type: String, // lineChart, barChart, table
      default: 'lineChart',
    },
    // 接口请求
    request: {
      type: Function,
    },
    // 是否显示时间查询
    isTimeQuery: {
      type: Boolean,
      default: true,
    },

    // 是否显示选择部门员工搜索框
    isStaffQuery: {
      type: Boolean,
      default: false,
    },
    // 选择员工搜索框的placeholder
    staffQueryPlaceholder: {
      type: String,
      default: '请选择部门或员工',
    },
    // 是否只选择员工, 不能通过选择部门来选择员工
    isOnlyStaff: {
      type: Boolean,
      default: false,
    },
    // 是否只选择部门
    isOnlyDepart: {
      type: Boolean,
      default: false,
    },

    // 是否显示选择群聊搜索框
    isGroupQuery: {
      type: Boolean,
      default: false,
    },

    // 自定义的查询参数处理方法，可用于添加和修改查询参数
    dealQueryFun: {
      type: Function,
      default: null,
    },
    // 自定义的返回数据处理方法，可用于添加和修改查询参数
    dealDataFun: {
      type: Function,
      default: null,
    },

    // 导出接口请求
    requestExport: {
      type: Function,
      default: null,
    },
    // 导出文件名(需包含后缀名)
    exportFileName: { type: String },

    // 图表图例; 单个图例可传字符串，多个图例传数组
    legend: {
      type: [Array, String],
      default: null,
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
      // 表格列表数据，或图表的series数据
      data: [],
      xData: [],
      // 日期范围
      dateRange: [],
      // 查询参数
      query: {
        pageNum: 1,
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
    this.isGroupQuery && this.getGroupList()
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

      this.dealQueryFun && this.dealQueryFun(this.query)

      if (Array.isArray(this.userArray)) {
        this.query.deptIds = this.userArray
          .filter((e) => e.isParty)
          .map((e) => e.id)
          .join(',')
        this.query.userIds = this.userArray
          .filter((e) => !e.isParty)
          .map((e) => e.userId)
          .join(',')

        if (this.isGroupQuery) {
          this.query.ownerIds = this.userArray
            .filter((e) => !e.isParty)
            .map((e) => e.userId)
            .join(',')
        }
      } else {
        this.query.deptIds = this.query.userIds = this.query.ownerIds = ''
      }

      this.loading = true
      page && (this.query.pageNum = page)

      this.request(this.query)
        .then(({ rows, total, data }) => {
          data = data || rows
          // if (!data) {
          //   return
          // }
          if (this.type == 'table') {
            // 表格
            this.data = data
            this.total = +total
          } else {
            // 自定义echarts图表数据处理
            // this.data = data
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
    // showDialog(type) {
    //   this.dialogType = type
    //   this.dialogVisible = true
    // },
    getSelectUser(data) {
      this.userArray = data
      if (this.isGroupQuery) {
        this.query.chatIds = ''
        // 根据群主获取群列表
        this.getGroupList({
          userIds: data.map((e) => e.userId).join(','),
        })
      }
      this.getList()
    },
    // 获取群列表
    getGroupList(params) {
      getGroupList(params)
        .then(({ rows }) => {
          this.groupChats = rows
        })
        .catch(() => {})
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
        .then((resBlob) => {
          this.downloadBlob(resBlob, this.exportFileName)
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
        v-if="isStaffQuery"
        style="width: 180px; margin-left: 20px"
        :model-value="userArray.map((e) => e.name) + ''"
        readonly
        @click="dialogVisible = true"
        :placeholder="staffQueryPlaceholder" />
      <el-select
        style="margin-left: 20px; vertical-align: middle"
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
      <!-- <el-input
        v-if="isStaffQuery"
        style="width: 180px; margin-left: 20px"
        :model-value="userArray.map((e) => e.name) + ''"
        readonly
        @click="showDialog('_users')"
        :placeholder="staffQueryPlaceholder"/> -->

      <slot name="query" :query="query"></slot>

      <el-button v-if="requestExport" style="position: absolute; right: 0" type="primary" @click="exprotTable">
        导出 Excel
      </el-button>
    </div>

    <div v-loading="loading">
      <!-- 折线图 -->
      <ChartLine v-if="type == 'lineChart'" :xData="xData" :legend="legend" :series="data" :option="option"></ChartLine>

      <!-- 柱状图 -->
      <ChartBar v-else-if="'barChart'.includes(type)" :xData="xData" :series="data" :option="option"></ChartBar>

      <!-- 表格 -->
      <template v-else-if="type == 'table'">
        <slot name="table" :data="data"></slot>

        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </template>
    </div>

    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      departReplaceUser
      :defaultValues="userArray"
      :isOnlyDepart="isOnlyDepart"
      :isOnlyLeaf="isOnlyStaff"
      @success="getSelectUser"></SelectUser>
  </div>
</template>

<style lang="scss" scoped>
.operation {
  position: relative;
  // display: flex;
  // align-items: center;
  margin-bottom: var(--card-margin, 16px);
}
</style>
