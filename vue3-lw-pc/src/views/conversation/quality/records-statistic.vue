<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div style="display: flex; align-items: center; justify-content: space-between">
        <div style="display: flex; align-items: center">
          <search-title :showMore="true" @search="getTableFn"></search-title>
          <el-input
            style="width: 150px"
            :model-value="userName"
            readonly
            @click="dialogVisible = true"
            placeholder="请选择成员" />
          <el-input
            style="width: 150px; margin: 0 20px"
            :model-value="deptName"
            readonly
            @click="dialogDeptVisible = true"
            placeholder="请选择部门" />
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
        </div>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column
          label="成员名称"
          align="center"
          prop="userName"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="所属部门" align="center" prop="deptName" show-overflow-tooltip></el-table-column>
        <el-table-column label="超时次数" align="center" prop="timeOutNum" show-overflow-tooltip></el-table-column>
        <el-table-column label="超时率" align="center" prop="timeOutRate" show-overflow-tooltip>
          <template #default="{ row }">
            <div>{{ Number(row.timeOutRate) * 100 + '%' }}</div>
          </template>
        </el-table-column>
        <el-table-column label="客户会话超时率" align="center" prop="chatTimeOutRate" show-overflow-tooltip>
          <template #default="{ row }">
            <div>{{ Number(row.chatTimeOutRate) * 100 + '%' }}</div>
          </template>
        </el-table-column>
        <el-table-column label="客群会话超时率" align="center" prop="groupChatTimeOutRate" show-overflow-tooltip>
          <template #default="{ row }">
            <div>{{ Number(row.groupChatTimeOutRate) * 100 + '%' }}</div>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getTableChangeSize()" />
    </div>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
    <SelectDept
      :defaultValues="deptArray"
      v-model:visible="dialogDeptVisible"
      title="选择部门"
      @success="selectedDept"></SelectDept>
  </div>
</template>
<script>
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'
import { qualityWeeklyDetailTotal, qualityWeeklyTable, getTableExport } from './api.js'
import SelectDept from '@/components/SelectDept'
import { dateFormat } from '@/utils/index'

export default {
  name: 'records-statistic',
  components: {
    SearchTitle,
    ChartLine,
    SelectDept,
  },
  data() {
    return {
      deptArray: [],
      deptName: '',
      dialogDeptVisible: false,
      dialogVisible: false,
      userArray: [],
      userName: '',
      cardData: [
        {
          title: '本周督导成员数',
          value: 0,
        },
        {
          title: '客户会话数',
          value: 0,
        },
        {
          title: '客群会话数',
          value: 0,
        },
        {
          title: '成员回复次数',
          value: 0,
        },
        {
          title: '成员超时次数',
          value: 0,
        },
        {
          title: '成员超时率',
          value: 0,
        },
        {
          title: '客户会话超时率',
          value: 0,
        },
        {
          title: '客群会话超时率',
          value: 0,
        },
      ],
      value: [],
      id: '',
      exportLoading: false,
      tableList: [],
      loading: false,
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        deptIds: '',
        userIds: '',
      },
      tableSearch: {},
    }
  },
  methods: {
    exportFn() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          return getTableExport(this.id, Object.assign({}, this.query))
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型
          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '质检详情')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '-质检详情.xlsx' //指定下载文件名
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    handleSearch() {
      this.getTableChangeSize()
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        deptIds: '',
        userIds: '',
      }
      this.userArray = []
      this.userName = ''
      this.deptArray = []
      this.deptName = ''
      this.getTableChangeSize()
    },
    getSelectUser(data) {
      this.userArray = data
      this.userName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.userIds = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
    },
    selectedDept(data) {
      this.deptArray = data
      this.deptName = this.deptArray
        .map(function (obj, index) {
          return obj.deptName
        })
        .join(',')
      this.query.deptIds = this.userArray
        .map(function (obj, index) {
          return obj.deptId
        })
        .join(',')
    },
    getTabTotalFn() {
      qualityWeeklyDetailTotal(this.id).then((res) => {
        this.cardData[0].value = res.data.staffNum
        this.cardData[1].value = res.data.chatNum
        this.cardData[2].value = res.data.groupChatNum
        this.cardData[3].value = res.data.replyNum
        this.cardData[4].value = res.data.timeOutNum
        this.cardData[5].value = Number(res.data.timeOutRate) * 100 + '%'
        this.cardData[6].value = Number(res.data.chatTimeOutRate) * 100 + '%'
        this.cardData[7].value = Number(res.data.chatTimeOutRate) * 100 + '%'
      })
    },
    getTableChangeSize() {
      this.loading = true
      qualityWeeklyTable(this.id, Object.assign({}, this.query)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.loading = true
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
  },
  created() {
    this.id = this.$route.query.id
    this.getTabTotalFn()
  },
}
</script>
<style lang="scss" scoped></style>
