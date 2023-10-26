<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="成员" prop="userIds">
        <el-input v-model="query.userName" placeholder="请输入成员名称" />
      </el-form-item>
      <el-form-item label="选择时间">
        <el-date-picker
          v-model="query.dateTime"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          type="date"></el-date-picker>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <el-table v-loading="loading" :data="list">
        <el-table-column label="质检周期" align="center" width="180" prop="weeklyTime" show-overflow-tooltip />
        <el-table-column label="目标发送成员" align="center" prop="userName">
          <!-- <template #default="{ row }">
            <TagEllipsis :list="row.qiRuleScope" defaultProps="userName" />
          </template> -->
        </el-table-column>
        <el-table-column label="发送时间" align="center" prop="sendTime" width="180"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180">
          <template #default="{ row }">
            <el-button text @click="goRoute('recordsStatistic', row.id)">统计</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>
  </div>
</template>

<script>
import { qualityWeekly } from './api.js'
export default {
  name: 'quality-records',
  data() {
    return {
      dialogVisible: false,
      query: {
        dateTime: '',
        userName: '',
        pageNum: 1,
        pageSize: 10,
      },
      list: [],
      loading: false,
      total: 0,
    }
  },
  created() {
    this.getList()
  },
  methods: {
    goRoute(path, id) {
      this.$router.push({ path: path, query: { id } })
    },
    handleSearch() {
      this.query.pageNum = 1
      this.getList()
    },
    getList() {
      this.loading = true
      qualityWeekly(this.query)
        .then((res) => {
          if (res.code == 200) {
            this.list = res.rows
            this.total = Number(res.total)
          }
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        dateTime: '',
        userName: '',
      }
      this.getList()
    },
  },
}
</script>

<style lang="scss" scoped></style>
