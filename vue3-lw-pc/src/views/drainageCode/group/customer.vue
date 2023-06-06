<script>
import { getList } from '@/api/customer/group'

export default {
  props: {
    customerGroupId: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      query: {
        groupLeader: '',
        groupName: '',
        beginTime: '',
        endTime: '',
        pageNum: 1,
        pageSize: 10,
      },
      searchDate: '', // 查询日期
      loading: false, // 加载状态
      total: 0, // 总数据量
      customerGroups: [], // 客户群数据
      currentRow: null, // 当前选中行
    }
  },
  watch: {
    searchDate: {
      deep: true,
      handler(dateRange) {
        if (!dateRange || dateRange.length !== 2) {
          this.query.beginTime = ''
          this.query.endTime = ''
        } else {
          ;[this.query.beginTime, this.query.endTime] = dateRange
        }
      },
    },
  },
  created() {
    this.getList()
  },
  methods: {
    // 获取客户群数据
    getList() {
      const params = Object.assign({}, this.query)
      this.loading = true
      getList(params)
        .then((res) => {
          this.customerGroups = res.rows
          this.total = parseInt(res.total)

          for (let group of this.customerGroups) {
            if (group.chatId === this.customerGroupId) this.currentRow = group
          }

          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 单选变更
    handleSelectionChange(val) {
      this.currentRow = val
    },
    resetQuery() {
      this.searchDate = []
      this.$refs['queryForm'].resetFields()

      this.$nextTick(() => {
        this.getList()
      })
    },
    submit() {
      this.$emit('callback', this.currentRow)
    },
  },
}
</script>

<template>
  <div>
    <el-form ref="queryForm" :model="query" :inline="true" class="top-search" label-width="70px">
      <el-form-item label="群名" prop="groupName">
        <el-input clearable v-model="query.groupName" placeholder="请输入群名"></el-input>
      </el-form-item>
      <el-form-item label="群主" prop="groupLeader">
        <el-input clearable v-model="query.groupLeader" placeholder="请输入群主"></el-input>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          clearable
          v-model="searchDate"
          format="YYYY-MM-DD"
          value-format="YYYYMMDD"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="getList">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <el-table
        :data="customerGroups"
        v-loading="loading"
        highlight-current-row
        @current-change="handleSelectionChange">
        <el-table-column width="55" align="center">
          <template #default="{ row }">
            <el-checkbox :value="currentRow && row.chatId === currentRow.chatId"></el-checkbox>
          </template>
        </el-table-column>
        <el-table-column prop="groupName" label="群名" align="center"></el-table-column>
        <el-table-column prop="memberNum" label="群人数" align="center"></el-table-column>
        <el-table-column prop="groupLeaderName" label="群主" align="center"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" align="center"></el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList"></pagination>
    </div>
  </div>
</template>
