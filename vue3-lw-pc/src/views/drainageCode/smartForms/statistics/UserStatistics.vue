<template>
  <div style="padding-bottom: 30px">
    <div>
      <div class="g-card">
        <div class="mid-action">
          <search-title :id="$route.query.id" :showScene="true" @search="getTableFn"></search-title>
          <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
        </div>
        <!-- <div v-if="tableList&&tableList.length!=0">
              {{tableList[0].answer}}
            </div> -->
        <template v-if="tableList">
          <el-table v-loading="loading1" :data="tableList" style="width: 100%">
            <!-- <el-table-column label="日期" align="center" min-width="100"  show-overflow-tooltip >
                  <template #default="{ row }">
                    <div style="display: flex;justify-content:center;">{{row.updateTime.substring(0,10)}}</div>
                  </template>
                </el-table-column> -->
            <el-table-column label="序号" width="50" align="center">
              <template #default="scope">
                {{ scope.$index + 1 }}
              </template>
            </el-table-column>
            <el-table-column label="日期" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                {{ row.createTime }}
              </template>
            </el-table-column>
            <el-table-column label="用户昵称" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                {{ row.name }}
              </template>
            </el-table-column>
            <!--  <el-table-column label="用户手机号" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                {{ row.mobile }}
              </template>
            </el-table-column> -->
            <el-table-column label="渠道" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                {{ row.dataSource }}
              </template>
            </el-table-column>
            <el-table-column label="openId" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-if="row.openId">{{ row.openId }}</div>
                <div v-if="!row.openId">无</div>
              </template>
            </el-table-column>
            <el-table-column label="unionId" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-if="row.unionId">{{ row.unionId }}</div>
                <div v-if="!row.unionId">无</div>
              </template>
            </el-table-column>
            <el-table-column label="是否是企业用户" align="center" min-width="100" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-if="row.isOfficeCustomer">是</div>
                <div v-if="!row.isOfficeCustomer">否</div>
              </template>
            </el-table-column>
            <!--  <el-table-column label="总访问数" align="center" min-width="100" prop="visitTotalCnt" show-overflow-tooltip />
                <el-table-column label="总访问用户" align="center" prop="consultTotalCnt" min-width="100" show-overflow-tooltip></el-table-column>
                <el-table-column label="有效收集量" align="center" prop="EffectiveCollectionQuantity" min-width="100" show-overflow-tooltip></el-table-column>
                <el-table-column label="收集量" align="center" prop="CollectionQuantity" min-width="100" show-overflow-tooltip></el-table-column>
                <el-table-column label="平均完成时间" align="center" prop="average" min-width="100" show-overflow-tooltip></el-table-column> -->
          </el-table>
          <pagination
            :total="total"
            v-model:page="query.pageNum"
            v-model:limit="query.pageSize"
            @pagination="getTableChangeSize(query.pageNum, query.pageSize)" />
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import { statisticsCustomer, userExport } from '@/api/drainageCode/smartForms.js'
import SearchTitle from '../components/SearchTitle.vue'
export default {
  props: ['formId'],
  components: {
    SearchTitle,
  },
  data() {
    return {
      loading1: false,
      total: 0,
      baseList: '',
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      tableList: [],
      exportLoading: false,
      dataSource: '默认渠道',
    }
  },
  methods: {
    exportFn() {
      let that = this
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        this.exportLoading = true
        let data = this.tableSearch
        console.log('data', data)
        if (!data.dataSource) {
          return
        }
        data.belongId = this.$route.query.id
        userExport(data)
          .then((res) => {
            console.log('数据报表导出返回值', res)
            if (res != null) {
              let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
              let url = window.URL.createObjectURL(blob)
              const link = document.createElement('a') // 创建a标签
              link.href = url
              link.download = '数据报表.xlsx' //指定下载文件名
              link.click()
              URL.revokeObjectURL(url) // 释放内存
            }
          })
          .catch((error) => {
            console.error(error)
          })
          .finally(() => {
            that.exportLoading = false
          })
        // delete data.pageNum
        // delete data.pageSize
        // that.dataSource = data.dataSource
        // statisticsCustomer(data).then((res) => {
        //   console.log('用户统计数据返回值', res)
        //   let b = []
        //   if (res.data && res.data.length) {
        //     that.tableList = []
        //     for (let i = 0; i < res.data.length; i++) {
        //       b.push(res.data[i].data)
        //       console.log('b', b)
        //     }
        //     that.tableList = b
        //     that.total = Number(res.data[0].total)
        //   } else {
        //     that.tableList = []
        //   }
        //   console.log('that.tableList', that.tableList)
        //   // this.tableList = res.data.xAxis.data.length
        //   that.loading1 = false
        //   let data = []
        //   for (let i = 0; i < that.tableList.length; i++) {
        //     let isOfficeCustomer = '否'
        //     if (that.tableList[i].isOfficeCustomer) {
        //       isOfficeCustomer = '是'
        //     }
        //     let a = {
        //       createTime: that.tableList[i].createTime,
        //       dataSource: that.dataSource,
        //       isOfficeCustomer: isOfficeCustomer,
        //       mobile: that.tableList[i].mobile,
        //       unionId: that.tableList[i].unionId,
        //       openId: that.tableList[i].openId,
        //     }
        //     data.push(a)
        //   }
        //   console.log('that.tableList', that.tableList)
        //   console.log('data', JSON.stringify(data))

        //   userExport(data)
        //     .then((res) => {
        //       console.log('数据报表导出返回值', res)
        //       download(res.msg)
        //     })
        //     .catch((error) => {
        //       console.error(error)
        //     })
        //     .finally(() => {
        //       that.exportLoading = false
        //     })
        // })
      })
    },
    getTableChangeSize(pageNum, pageSize) {
      this.loading1 = true
      let data = this.tableSearch
      if (!data.dataSource) {
        this.loading1 = false
        return
      }
      data.pageNum = pageNum
      data.pageSize = pageSize
      this.dataSource = data.dataSource
      statisticsCustomer(data).then((res) => {
        this.tableList = res.rows || []
        this.total = Number(res.total || 0)
        this.loading1 = false
      })
    },
    getTableFn(data) {
      this.loading1 = true
      data.belongId = this.$route.query.id
      // getTableTotal(Object.assign({}, this.query, data)).then(res => {
      //   this.tableList = res.rows
      //   this.total = Number(res.total)
      //   this.loading = false
      // })
      if (!data.dataSource) {
        this.loading1 = false
        return
      }
      this.tableSearch = data
      this.dataSource = data.dataSource
      this.getTableChangeSize(1, 10)
    },
  },
  mounted() {},
}
</script>

<style lang="scss" scoped>
.dataStatistics_optionGraph_ul {
  margin-top: 30px;
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  .dataStatistics_optionGraph_li {
    margin-bottom: 10px;
    width: 49.6%;
    background: var(--bg-white);
    padding: 30px;
  }
}

.data-content {
  margin-top: 10px;

  .chart-content {
    margin-top: 10px;

    .my_button {
      float: right;
    }

    .column {
      display: flex;

      .column-item {
        flex: 1;
      }
    }
  }

  .search-content {
    display: flex;
    justify-content: space-between;
  }

  .table-content {
    margin-top: 10px;
  }
}
</style>
