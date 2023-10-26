<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="规则名称" prop="name">
        <el-input clearable v-model="query.name" placeholder="请输入规则名称"></el-input>
      </el-form-item>
      <el-form-item label="适用成员" prop="userIds">
        <el-input :model-value="userName" readonly @click="dialogVisible = true" placeholder="请选择适用成员" />
      </el-form-item>
      <el-form-item label="会话类型">
        <el-select v-model="query.chatType" :popper-append-to-body="false">
          <el-option :label="data.value" :value="data.key" v-for="(data, key) in chatTypeArray" :key="key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="操作时间">
        <el-date-picker
          v-model="searchDate"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          type="daterange"
          range-separator="-"
          @change="setDateChange"
          start-placeholder="开始日期"
          end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="$router.push('./add')">新建质检规则</el-button>
        <el-button type="primary" plain @click="$router.push('./records')">质检报告记录</el-button>
      </div>
      <el-table v-loading="loading" :data="list">
        <el-table-column label="规则名称" align="center" min-width="100" prop="name" show-overflow-tooltip />
        <el-table-column label="适用成员范围" align="center" prop="qiRuleScope" min-width="160px">
          <template #default="{ row }">
            <TagEllipsis :list="row.qiRuleScope" defaultProps="userName" />
          </template>
        </el-table-column>
        <el-table-column label="超时时间标准" align="center" min-width="100" prop="timeOut" show-overflow-tooltip>
          <template #default="{ row }">{{ row.timeOut }}分钟</template>
        </el-table-column>
        <el-table-column label="质检会话类型" align="center" prop="chatType" min-width="160px">
          <template #default="{ row }">
            {{ row.chatType == 1 ? '全部' : row.chatType == 2 ? '客户会话' : '客群会话' }}
          </template>
        </el-table-column>
        <el-table-column label="质检督导" align="center" prop="manageUser" min-width="160px">
          <template #default="{ row }">
            <TagEllipsis :list="row.manageUserInfo" defaultProps="userName" />
            <!-- {{ row.manageUser }} -->
          </template>
        </el-table-column>
        <el-table-column label="操作时间" align="center" prop="updateTime" width="180"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180">
          <template #default="{ row }">
            <el-button text @click="goRoute('statistic', row.id)">统计</el-button>
            <el-button text @click="goRoute('add', row.id)">编辑</el-button>
            <el-button text @click="removeFn(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>

    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
  </div>
</template>

<script>
import { getList, deleteQuality } from './api.js'
export default {
  name: 'quality',
  data() {
    return {
      query: {
        pageSize: 10,
        pageNum: 1,
        name: '',
        userIds: '',
        startTime: '',
        endTime: '',
        chatType: 1,
      },
      total: 0,
      dialogVisible: false,
      userName: '',
      userArray: [],
      searchDate: [],
      list: [],
      loading: false,
      chatTypeArray: [
        {
          key: 1,
          value: '全部',
        },
        {
          key: 2,
          value: '客户会话',
        },
        {
          key: 3,
          value: '客群会话',
        },
      ],
    }
  },
  created() {
    this.getList()
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
    getList() {
      getList(this.query).then((res) => {
        this.total = Number(res.total)
        this.list = res.rows
      })
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        name: '',
        userIds: '',
        startTime: '',
        endTime: '',
        chatType: 1,
      }
      this.userName = ''
      this.userArray = []
      this.getList()
    },
    goRoute(path, id) {
      this.$router.push({ path: path, query: { id } })
    },
    removeFn(id) {
      this.$confirm('是否确认删除当前质检规则？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deleteQuality(id)
        })
        .then(() => {
          this.handleSearch()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
  },
}
</script>

<style lang="scss" scoped></style>
