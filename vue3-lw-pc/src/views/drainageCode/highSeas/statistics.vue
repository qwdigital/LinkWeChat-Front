<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div class="g-card">
      <div class="g-card-title">导入记录</div>
      <el-table v-loading="importLoading" :data="importList" max-height="600">
        <el-table-column
          label="导入表格名称"
          align="center"
          prop="tableExcelName"
          min-width="180px"
          show-overflow-tooltip />
        <el-table-column label="导入客户总数" align="center" prop="cutomerTotalNum" show-overflow-tooltip />
        <el-table-column
          label="导入时间"
          align="center"
          prop="createTime"
          show-overflow-tooltip
          width="180"></el-table-column>
        <el-table-column label="分配员工" align="center" prop="addUserName" show-overflow-tooltip />
        <el-table-column label="待添加客户数" align="center" prop="waitAddCustomerNum"></el-table-column>
        <el-table-column label="待通过客户数" align="center" prop="waitPassCustomerNum"></el-table-column>
        <el-table-column label="已添加客户数" align="center" prop="addCustomerNum" show-overflow-tooltip />
        <el-table-column label="添加完成率" align="center" prop="completionRate" show-overflow-tooltip>
          <template #default="{ row }">
            <span>{{ row.completionRate }}%</span>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="importTotal > 0"
        :total="importTotal"
        v-model:page="importPage.pageNum"
        v-model:limit="importPage.pageSize"
        @pagination="getImportListFn()" />
    </div>
    <div class="g-card">
      <div class="g-card-title">员工添加统计</div>
      <el-table v-loading="addLoading" :data="addList" max-height="600">
        <el-table-column label="员工名称" align="center" prop="addUserName" show-overflow-tooltip />
        <el-table-column label="分配客户总数" align="center" prop="cutomerTotalNum" show-overflow-tooltip />
        <el-table-column
          label="待添加客户数"
          align="center"
          prop="waitAddCustomerNum"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="待通过客户数" align="center" prop="waitPassCustomerNum" width="180"></el-table-column>
        <el-table-column label="已添加客户数" align="center" prop="addCustomerNum" show-overflow-tooltip />
        <el-table-column label="添加完成率" align="center" show-overflow-tooltip>
          <template #default="{ row }">
            <span>{{ row.completionRate }}%</span>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="addTotal > 0"
        :total="addTotal"
        v-model:page="addPage.pageNum"
        v-model:limit="addPage.pageSize"
        @pagination="getAddList()" />
    </div>
  </div>
</template>

<script>
import moment from 'moment'

import { getTotal, getImportAndStaffList } from '@/api/drainageCode/seas'
export default {
  components: {},
  data() {
    return {
      loading: false,
      importList: [],
      importLoading: false,
      importPage: {
        groupByType: 1,
        pageSize: 10,
        pageNum: 1,
      },
      importTotal: 0,
      addList: [],
      addLoading: false,
      addPage: {
        groupByType: 2,
        pageSize: 10,
        pageNum: 1,
      },
      addTotal: 0,
      cardData: [],
    }
  },
  created() {
    this.getTotalFn()
    this.getImportListFn()
    this.getAddList()
    // this.$store.setBusininessDesc(
    //
    // 	`
    //      <div>支持单人、批量单人及多人方式新建员工活码，客户可以通过扫描员工活码添加员工为好友，并支持自动给客户打标签和发送欢迎语。</div>
    //    `
    // )
  },
  mounted() {},
  methods: {
    getTotalFn() {
      getTotal().then(({ data }) => {
        this.cardData = [
          {
            title: '导入客户总数',
            value: data.importCustomerTotalNum,
          },
          {
            title: '已添加客户数',
            value: data.addCustomerNum,
          },
          {
            title: '添加完成率',
            value: data.completionRate + '%',
          },
          {
            title: '待添加客户数',
            value: data.waitAddCustomerNum,
          },
          {
            title: '待通过客户数',
            value: data.waitPassCustomerNum,
          },
        ]
      })
    },
    getImportListFn() {
      this.importLoading = true
      getImportAndStaffList(this.importPage)
        .then(({ rows, total }) => {
          this.importList = rows
          this.importList.forEach((ddd) => {
            ddd.createTime = moment(ddd.createTime).format('YYYY-MM-DD HH:mm:ss')
          })
          this.importTotal = +total
          this.importLoading = false
        })
        .catch(() => {
          this.importLoading = false
        })
    },
    getAddList() {
      this.addLoading = true
      getImportAndStaffList(this.addPage)
        .then(({ rows, total }) => {
          this.addList = rows
          this.addTotal = +total
          this.addLoading = false
        })
        .catch(() => {
          this.addLoading = false
        })
    },
  },
}
</script>

<style lang="scss" scoped>
::v-deep .el-tabs__header {
  margin-bottom: 0;
}

.bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}

.total-item {
  // width: 200px;
  padding: 20px;
  background: linear-gradient(90deg, #3c89f0 0%, #1364f4 100%);
  border-radius: 4px;

  .name {
    font-size: 14px;

    font-weight: 400;
    color: var(--font-white, #fff);
  }

  .value {
    margin-top: 5px;
    font-size: 18px;

    font-weight: 400;
    color: var(--font-white, #fff);
  }
}
</style>
