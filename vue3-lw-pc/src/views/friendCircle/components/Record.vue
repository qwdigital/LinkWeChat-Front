<template>
  <div>
    <div class="content-box">
      <div style="display: flex; align-items: center">
        <el-date-picker
          v-model="dateRange"
          value-format="YYYY-MM-DD HH:mm:ss"
          type="datetimerange"
          range-separator="-"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          align="right"
          clearable
        >
        </el-date-picker>
        <el-input
          style="width: 150px; margin: 0 20px"
          :model-value="userName"
          readonly
          @click="dialogVisible = true"
          placeholder="请选择成员"
        />
        <el-select
          v-model="query.surveyState"
          placeholder="请选择状态"
          style="width: 150px; margin-right: 20px"
        >
          <el-option label="未执行" :value="0"></el-option>
          <el-option label="已执行" :value="1"></el-option>
        </el-select>
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">清空</el-button>
      </div>
      <div>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出</el-button>
      </div>
    </div>
    <el-table v-loading="loading" :data="tableList" style="width: 100%">
      <el-table-column
        label="客户名称"
        align="center"
        prop="customerName"
        min-width="100"
        show-overflow-tooltip
      ></el-table-column>
      <el-table-column
        label="对应成员"
        align="center"
        prop="userName"
        min-width="100"
        show-overflow-tooltip
      ></el-table-column>
      <el-table-column label="互动类型" align="center" prop="type" show-overflow-tooltip>
        <template #default="{ row }">
          <div>
            {{ row.type }}
          </div>
        </template>
      </el-table-column>
      <el-table-column
        label="互动时间"
        align="center"
        prop="interactTime"
        show-overflow-tooltip
      ></el-table-column>
    </el-table>
    <pagination
      :total="total"
      v-model:page="query.pageNum"
      v-model:limit="query.pageSize"
      @pagination="getList()"
    />
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectUser>
  </div>
</template>

<script>
import { dateFormat } from '@/utils/index'
import { getInteractList, exportInteract } from '@/api/circle'
export default {
  data() {
    return {
      dateRange: [],
      query: {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        status: '',
        weUserIds: [],
      },
      loading: false,
      tableList: [],
      userName: '',
      userArray: [],
      dialogVisible: false,
      id: undefined,
      type: undefined, // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
      name: '',
      total: 0,
      exportLoading: false,
    }
  },
  mounted() {
    this.type = this.$route.query.type
    this.id = this.$route.query.id
    this.name = this.$route.query.name
    this.getList()
  },
  methods: {
    getSelectUser(data) {
      this.userArray = data
      this.userName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.weUserIds = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
    },
    exportFn() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          this.query.weMomentsTaskId = this.id
          return exportInteract(Object.assign({}, this.query))
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型
          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '互动统计')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '-' + this.name + '-互动统计.xlsx' //指定下载文件名
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
    getList() {
      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0]
        this.query.endTime = this.dateRange[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
      this.loading = true
      this.query.weMomentsTaskId = this.id
      getInteractList(this.query).then((res) => {
        this.tableList = res.rows
        this.total = +res.total
        this.loading = false
      })
    },
    handleSearch() {
      this.getList()
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        interactType: '',
        weUserIds: '',
      }
      this.userName = ''
      this.dateRange = []
      this.userArray = []
      this.getList()
    },
  },
}
</script>

<style lang="scss" scoped>
.content-box {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
