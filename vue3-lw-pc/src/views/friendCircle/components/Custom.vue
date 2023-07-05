<template>
  <div>
    <!-- 素材分析 -->
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">客户记录</div>
      <div style="display: flex; align-items: center; justify-content: space-between">
        <div style="display: flex; align-items: center">
          <!-- <search-title :showMore="true" @search="getTableFn"></search-title> -->
          <el-input
            style="width: 150px; margin-right: 20px"
            :model-value="userName"
            readonly
            @click="dialogVisible = true"
            placeholder="请选择成员"
          />
          <el-select
            v-model="query.deliveryStatus"
            placeholder="请选择状态"
            style="width: 150px; margin-right: 20px"
            v-if="type !== 3"
          >
            <el-option label="已送达" :value="0"></el-option>
            <el-option label="未送达" :value="1"></el-option>
            <el-option label="送达失败" :value="2"></el-option>
          </el-select>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetQuery">清空</el-button>
        </div>
        <div>
          <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出</el-button>
        </div>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%; margin-bottom: 20px">
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
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column label="送达状态" align="center" prop="timeOutNum" show-overflow-tooltip>
          <template #default="{ row }">
            <div>
              {{ dealStatus(row.deliveryStatus) }}
            </div>
          </template>
        </el-table-column>
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
  </div>
</template>
<script>
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SelectDept from '@/components/SelectDept'
import { dateFormat } from '@/utils/index'
import { statisticCustomer, getCustomerList, exportCustomer } from '@/api/circle'

export default {
  name: 'scene-statistics-scene',
  components: {
    ChartLine,
    ChartBar,
    SelectDept,
  },
  data() {
    return {
      // deptArray: [],
      dialogVisible: false,
      userArray: [],
      userName: '',
      cardData: [
        {
          title: '预计送达客户数 ',
          tips: '预计能够看到本朋友圈推送的客户数（不去重）',
          value: 0,
          noArrow: true,
        },
        {
          title: '未送达客户数',
          tips: '员工未执行该朋友圈任务而未收到相应推送的客户数（不去重）',
          value: 0,
        },
        {
          title: '已送达客户数',
          tips: '员工已执行该朋友圈任务而已收到相应推送的客户数（不去重）',
          value: 0,
        },
        {
          title: '送达失败客户数',
          tips: '因已达送但超过朋友圈可见数量上限导致送达失败的客户数（不去重）',
          value: 0,
        },
        {
          title: '今日送达客户数',
          tips: '员工今日已执行该朋友圈任务并成功收到推送的客户数（不去重）',
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
        weUserIds: '',
        deliveryStatus: '',
      },
      tableSearch: {},
      id: undefined,
      type: undefined, // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
      name: '',
    }
  },
  mounted() {
    this.type = this.$route.query.type
    this.id = this.$route.query.id
    this.name = this.$route.query.name
    if (this.type === 3) {
      this.cardData.shift()
    }
    this.getTabTotalFn()
    this.getTableChangeSize()
  },
  methods: {
    dealStatus(type) {
      switch (type) {
        case 0:
          return '已送达'
          break
        case 1:
          return '未送达'
          break
        case 2:
          return '送达失败'
          break

        default:
          break
      }
    },
    getTabTotalFn() {
      statisticCustomer(this.id).then((res) => {
        this.cardData[0].value = res.data.predictSend
        this.cardData[1].value = res.data.nonSend
        this.cardData[2].value = res.data.sent
        this.cardData[3].value = res.data.failSend
        if (this.type !== 3) {
          this.cardData[4].value = res.data.todaySend
        }
      })
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
          return exportCustomer(Object.assign({}, this.query))
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型
          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '客户统计')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '-' + this.name + '-客户统计.xlsx' //指定下载文件名
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
      this.query.weUserIds = this.userArray
        .map(function (obj, index) {
          return obj.userId
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
      this.query.weMomentsTaskId = this.id
      getCustomerList(this.query).then((res) => {
        this.tableList = res.rows
        this.total = +res.total
        this.loading = false
      })
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        weUserIds: '',
        deliveryStatus: '',
      }
      this.userArray = []
      this.userName = ''
      // this.deptArray = []
      this.getTableChangeSize()
    },
    handleSearch() {
      this.getTableChangeSize()
    },
  },
  created() {
    // this.$store.setBusininessDesc(
    //   `
    //   <div>全部素材发送与查看情况数据统计与分析</div>
    // `
    // )
  },
}
</script>
<style lang="scss" scoped></style>
