<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="" prop="customerName">
        <el-input clearable v-model="query.customerName" placeholder="请输入客户名称"></el-input>
      </el-form-item>
      <el-form-item label="">
        <el-input :model-value="groupNames" readonly @click="showSelectModal = true" placeholder="请选择客群" />
      </el-form-item>
      <el-form-item label="">
        <el-input :model-value="qrUserName" readonly @click="dialogVisible = true" placeholder="请选择发送员工" />
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="search">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <div></div>
        <div>
          <el-button type="primary" v-loading="exportLoading" @click="exportFn">导出Excel</el-button>
        </div>
      </div>
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="customerName" label="客户" align="center"></el-table-column>
        <el-table-column prop="chatName" label="所在客群" align="center"></el-table-column>
        <el-table-column prop="sendUserName" label="发送员工" align="center"></el-table-column>
        <el-table-column prop="inviterState" label="裂变状态" align="center">
          <template #default="{ row }">
            {{ row.inviterState == 1 ? '已完成' : row.inviterState == 2 ? '未完成' : '' }}
          </template>
        </el-table-column>
        <el-table-column prop="inviterNumber" label="裂变新客数" align="center">
          <template #default="{ row }">
            <a :class="{ self_a: row.inviterNumber }" @click="getDetailTable(row.fissionInviterRecordId)">
              {{ row.inviterNumber || '-' }}
            </a>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList" />
    </div>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
    <SubDetailVue v-model:visible="detailVisible" :fissionInviterRecordId="detailId" fissionType="group"></SubDetailVue>
    <select-group v-model:visible="showSelectModal" :defaults="groupList" @submit="setSelectData"></select-group>
  </div>
</template>

<script>
import { getFissionGroupTable, exportGroupTable } from '../taskGroup/api'
import SubDetailVue from '../common/SubDetail.vue'
import { dateFormat } from '@/utils/index'
import SelectGroup from '@/views/drainageCode/components/SelectGroup.vue'

export default {
  name: 'task-group-detail-table',
  components: {
    SubDetailVue,
    SelectGroup,
  },
  data() {
    return {
      groupNames: '',
      groupList: [],
      showSelectModal: false,
      loading: false,
      list: [],
      total: 0,
      qrUserName: '',
      query: {
        customerName: '',
        pageNum: 1,
        pageSize: 10,
        weUserId: '',
        chatId: '',
        fissionId: '',
      },
      dialogVisible: false,
      userArray: [], // 选择人员
      userArrayStr: '',
      detailVisible: false,
      detailId: '',
      exportLoading: false,
    }
  },
  methods: {
    setSelectData(data) {
      if (data && data.length) {
        this.groupList = data
        this.query.chatId = this.groupList
          .map((dd) => {
            return dd.chatId
          })
          .join(',')
        this.groupNames = this.groupList
          .map((dd) => {
            return dd.groupName
          })
          .join(',')
      } else {
        this.groupList = []
        this.query.chatId = ''
        this.groupNames = ''
      }
    },
    exportFn() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          return exportGroupTable(this.query)
        })
        .then((res) => {
          if (res != null) {
            let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '裂变明细' + dateFormat(new Date()) + '.xlsx' //指定下载文件名
            link.click()
            URL.revokeObjectURL(url) // 释放内存
          }
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    getDetailTable(id) {
      this.detailId = id
      this.detailVisible = true
    },
    getList() {
      this.loading = true
      this.query.fissionId = this.$route.query.id
      getFissionGroupTable(this.query).then((res) => {
        this.loading = false
        this.list = res.rows
        this.total = Number(res.total)
      })
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.query.weUserId = ''
      this.query.customerName = ''
      this.userArray = []
      this.groupList = []
      this.query.chatId = ''
      this.groupNames = ''
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
    },
  },
  created() {
    this.search()
  },
}
</script>

<style lang="scss" scoped>
.self_a {
  color: var(--color);
  text-decoration: underline;
  &:hover {
    opacity: 0.8;
  }
}
</style>
