<template>
  <div>
    <!-- 素材分析 -->
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">员工记录</div>
      <div style="display: flex; align-items: center; justify-content: space-between">
        <div style="display: flex; align-items: center">
          <!-- <search-title :showMore="true" @search="getTableFn"></search-title> -->
          <el-input
            style="width: 150px"
            :model-value="userName"
            readonly
            @click="dialogVisible = true"
            placeholder="请选择成员"
          />
          <el-input
            style="width: 150px; margin: 0 20px"
            :model-value="deptName"
            readonly
            @click="dialogDeptVisible = true"
            placeholder="请选择部门"
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
          <el-button type="primary" @click="remind(id)">提醒执行</el-button>
          <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出</el-button>
        </div>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column
          label="执行人名称"
          align="center"
          prop="userName"
          min-width="100"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column
          label="执行人所属部门"
          align="center"
          prop="deptName"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column label="执行状态" align="center" prop="timeOutNum" show-overflow-tooltip>
          <template #default="{ row }">
            <div>
              {{ row }}
            </div>
          </template>
        </el-table-column>
        <el-table-column
          label="提醒执行次数"
          align="center"
          prop="timeOutNum"
          show-overflow-tooltip
        ></el-table-column>
      </el-table>
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getTableChangeSize()"
      />
    </div>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectUser>
    <SelectDept
      :defaultValues="deptArray"
      v-model:visible="dialogDeptVisible"
      title="选择部门"
      @success="selectedDept"
    ></SelectDept>
  </div>
</template>
<script>
import SelectDept from '@/components/SelectDept'
import { getTableTotal } from '@/api/contentCenter/common.js'
import { reminderMoments, statisticMoments } from '@/api/circle'

export default {
  name: 'scene-statistics-scene',
  components: {
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
          title: '目标执行员工数 ',
          tips: '应执行本朋友圈任务的员工总数',
          value: 0,
          noArrow: true,
        },
        {
          title: '未执行员工数',
          tips: '当前未执行本朋友圈任务的员工数',
          value: 0,
        },
        {
          title: '已执行员工数',
          tips: '当前已执行本朋友圈任务的员工数',
          value: 0,
        },
        {
          title: '今日执行员工数',
          tips: '今日已执行本朋友圈任务的员工数',
          value: 0,
        },
        {
          title: '已提醒次数',
          tips: '本朋友圈任务对未执行成员已提醒执行的次数',
          value: 0,
        },
      ],
      value: [],
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
      id: undefined,
      type: undefined, // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
    }
  },
  mounted() {
    this.type = this.$route.query.type
    this.id = this.$route.query.id
    this.getTabTotalFn()
  },
  methods: {
    getTabTotalFn() {
      statisticMoments(this.id).then((res) => {
        this.cardData[0].value = res.data.inviterOldCustomerNum
        this.cardData[1].value = res.data.completeTaskOldCustomerNum
        this.cardData[2].value = res.data.fissionCustomerNum
        this.cardData[3].value = res.data.tdCompleteTaskOldCustomerNum
      })
    },
    remind(id) {
      this.$confirm('提醒执行将针对本任务未执行的成员再次催促执行，是否确认提醒？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      })
        .then(() => {
          reminderMoments(id).then((res) => {
            if (res.code === 200) {
              this.msgSuccess(res.msg)
            }
          })
        })
        .catch(() => {})
    },
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
    // getTableFn(data) {
    //   this.loading = true
    //   this.query.beginTime = data.beginTime
    //   this.query.endTime = data.endTime
    //   this.getTableChangeSize()
    // },
    getTableChangeSize() {
      this.loading = true
      getTableTotal(this.query).then((res) => {
        this.tableList = res.data
        this.loading = false
      })
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
    handleSearch() {
      this.getTableChangeSize()
    },
  },
  created() {
    this.getTableChangeSize()
    this.$store.setBusininessDesc(
      `
      <div>全部素材发送与查看情况数据统计与分析</div>
    `
    )
  },
}
</script>
<style lang="scss" scoped></style>
