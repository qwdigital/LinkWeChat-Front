<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="适用成员" prop="userIds">
        <el-input :value="userName" readonly @focus="dialogVisible = true" placeholder="请选择适用成员" />
      </el-form-item>
      <el-form-item label="操作时间">
        <el-date-picker
          v-model="searchDate"
          format="yyyy-MM-dd"
          value-format="yyyyMMdd"
          type="daterange"
          range-separator="-"
          @change="setDateChange"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <el-table v-loading="loading" :data="list">
        <el-table-column label="质检周期" align="center" min-width="100" prop="name" show-overflow-tooltip />
        <el-table-column label="目标发送成员" align="center" prop="qiRuleScope" min-width="160px">
          <template slot-scope="{ row }">
            <TagEllipsis :list="row.qiRuleScope" defaultProps="userName" />
          </template>
        </el-table-column>
        <el-table-column label="发送时间" align="center" prop="updateTime" width="180"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180" class-name="small-padding fixed-width">
          <template slot-scope="{ row }">
            <el-button type="text" @click="goRoute('detail', row.id)">统计</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
    </div>
    <SelectWeUser
      :visible.sync="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectWeUser>
  </div>
</template>

<script>
  import {} from './api.js'
  export default {
    name: 'quality-records',
    data() {
      return {
        dialogVisible: false,
        query: {
          beginTime: '',
          endTime: '',
          userIds: '',
          pageNum: 1,
          pageSize: 10
        },
        searchDate: [],
        userName: '',
        userArray: [],
        list: [],
        loading: false,
        total: 0
      }
    },
    methods: {
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
      setDateChange(data) {
        if (data && data[0]) {
          this.query.beginTime = data[0]
        } else {
          this.query.beginTime = ''
        }
        if (data && data[1]) {
          this.query.endTime = data[1]
        } else {
          this.query.endTime = ''
        }
      },
      handleSearch() {
        this.query.pageNum = 1
        this.getList()
      },
      getList() {},
      resetQuery() {
        this.query = {
          pageSize: 10,
          pageNum: 1,
          name: '',
          userIds: '',
          startTime: '',
          endTime: '',
          chatType: 1
        }
        this.userName = ''
        this.userArray = []
        this.getList()
      }
    }
  }
</script>

<style lang="scss" scoped></style>
