<template>
  <div>
    <el-table v-loading="loading" :data="tableList" style="width: 100%">
      <el-table-column
        label="查看用户"
        align="center"
        min-width="100"
        prop="viewBy"
        show-overflow-tooltip
      />
      <el-table-column
        label="是否是企业客户"
        align="center"
        min-width="100"
        prop="isCustomer"
        show-overflow-tooltip
      >
        <template #default="scope">
          {{ scope.row.isCustomer ? '是' : '否' }}
        </template>
      </el-table-column>
      <el-table-column
        label="查看次数"
        align="center"
        min-width="100"
        prop="viewTotalNum"
        show-overflow-tooltip
      />
      <el-table-column
        label="查看时长"
        align="center"
        min-width="100"
        prop="viewDurationCpt"
        show-overflow-tooltip
      />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button text @click="goDetail(scope.row.id)" v-if="scope.row.isCustomer"
            >客户详情</el-button
          >
          <el-button text v-else> - </el-button>
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
</template>

<script>
export default {
  data() {
    return {
      loading: false,
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      tableList: [],
      total: 0,
    }
  },
  methods: {
    getTableChangeSize() {
      this.loading = true
      getTableDetail(this.query).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    goDetail(row) {
      let { externalUserid, firstUserId: userId } = row
      this.$router.push({
        path: '/operateCenter/customerManage/customerDetail',
        query: { externalUserid, userId },
      })
    },
  },
}
</script>

<style></style>
