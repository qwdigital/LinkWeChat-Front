<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="" prop="customerName">
        <el-input clearable v-model="query.customerName" placeholder="请输入老客名称"></el-input>
      </el-form-item>
      <el-form-item label="" prop="qrUserName">
        <el-input :value="qrUserName" readonly @focus="dialogVisible = true" placeholder="请选择发送员工" />
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="oldCustomerName" label="老客" align="center"></el-table-column>
        <el-table-column prop="sendWeUserName" label="发送员工" align="center"></el-table-column>
        <el-table-column prop="inviterState" label="裂变状态" align="center"> </el-table-column>
        <el-table-column prop="createBy" label="裂变新客数" align="center">
          <template slot-scope="{ row }">
            <a class="self_a">{{ row.inviterNumber }}</a>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="query.pageNum"
        :limit.sync="query.pageSize"
        @pagination="getList"
      />
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
  export default {
    name: 'task-customer-detail-table',
    data() {
      return {
        loading: false,
        list: [],
        query: {
          customerName: '',
          pageNum: '',
          pageSize: '',
          weUserId: ''
        },
        dialogVisible: false,
        userArray: [], // 选择人员
        userArrayStr: ''
      }
    },
    methods: {
      getList() {},
      search() {
        this.query.pageSize = 1
        this.getList()
      },
      resetQuery() {
        this.query.weUserId = ''
        this.userArray = []
        this.qrUserName = ''
        this.search()
      },
      getSelectUser(data) {
        this.userArray = data
        this.qrUserName = this.userArray
          .map(function (obj, index) {
            return obj.name
          })
          .join(',')
        this.query.weUserId = this.userArray
          .map(function (obj, index) {
            return obj.userId
          })
          .join(',')
      }
    }
  }
</script>

<style lang="scss" scoped>
  .self_a {
    color: #07c160;
    text-decoration: underline;
    &:hover {
      opacity: 0.8;
    }
  }
</style>
