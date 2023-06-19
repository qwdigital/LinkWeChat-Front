<template>
  <div>
    <div class="content-box">
      <div style="display: flex; align-items: center">
        <el-date-picker
          v-model="dateRange"
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
        prop="userName"
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
      <el-table-column label="互动类型" align="center" prop="timeOutNum" show-overflow-tooltip>
        <template #default="{ row }">
          <div>
            {{ row }}
          </div>
        </template>
      </el-table-column>
      <el-table-column
        label="互动时间"
        align="center"
        prop="timeOutNum"
        show-overflow-tooltip
      ></el-table-column>
    </el-table>
    <pagination
      :total="total"
      v-model:page="query.pageNum"
      v-model:limit="query.pageSize"
      @pagination="getList()"
    />
  </div>
</template>

<script>
export default {
  data() {
    return {
      dateRange: [],
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      loading: false,
      tableList: [],
    }
  },
  methods: {
    getList() {
      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0]
        this.query.endTime = this.dateRange[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
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
      }
      this.dateRange = []
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
