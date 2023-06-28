<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="" prop="taskName">
        <el-input clearable v-model="query.taskName" placeholder="请输入任务名称"></el-input>
      </el-form-item>
      <el-form-item label="" prop="shortLinkName">
        <el-input clearable v-model="query.shortLinkName" placeholder="请输入短链名称"></el-input>
      </el-form-item>
      <el-form-item label="" prop="type">
        <el-select :popper-append-to-body="false" v-model="query.type" placeholder="请选择推广方式">
          <el-option label="全部推广方式" value=""></el-option>
          <el-option v-for="(item, index) in infoType" :key="index" :label="item.name" :value="item.key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="" prop="taskStatus">
        <el-select :popper-append-to-body="false" v-model="query.taskStatus" placeholder="请选择任务状态">
          <el-option label="全部任务状态" value=""></el-option>
          <el-option v-for="(item, index) in statusType" :key="index" :label="item.name" :value="item.key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="$router.push('./add')">新建任务</el-button>
        <div>
          <el-button type="primary" plain :disabled="selectList.length == 0" @click="deleteMult">批量删除</el-button>
        </div>
      </div>
      <el-table :data="list" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" fixed="left"></el-table-column>
        <el-table-column prop="taskName" label="任务名称" align="center" width="120" fixed="left"></el-table-column>
        <el-table-column prop="shortLinkName" label="推广短链" align="center" width="180">
          <template #default="{ row }">
            <a @click="gotoShortLinkDetail(row.shortLinkId)" class="self_a">{{ row.shortLinkName }}</a>
          </template>
        </el-table-column>
        <el-table-column prop="type" label="推广方式" align="center" width="100">
          <template #default="{ row }">
            {{ setType(row) }}
          </template>
        </el-table-column>
        <el-table-column prop="statusType" label="任务状态" align="center" width="100">
          <template #default="{ row }">
            <el-tag :type="row.taskStatus == 0 ? 'info' : row.taskStatus == 2 ? 'danger' : ''">
              {{ setStatus(row) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="taskStartTime" label="任务开始时间" align="center" width="180">
          <template #default="{ row }">
            {{ row.taskStartTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="taskEndTime" label="任务结束时间" align="center" width="180">
          <template #default="{ row }">
            {{ row.taskEndTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="pvNum" label="访问总数" align="center" width="140">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  访问总数(pv)
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>在当前任务中短链页面访问的总次数</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            {{ row.pvNum || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="uvNum" label="访问总人数" align="center" width="140">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  访问总人数(uv)
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>在当前任务中短链页面访问的独立IP数</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            {{ row.uvNum || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="openNum" label="小程序总打开数" align="center" width="140">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  小程序总打开数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>在当前任务中小程序成功打开的总次数</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            {{ row.openNum || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
        <el-table-column prop="updateTime" label="最近操作时间" align="center" width="180"></el-table-column>
        <el-table-column label="操作" align="center" width="180" fixed="right">
          <template #default="{ row }">
            <el-button text @click="$router.push({ path: './detail', query: { id: row.id } })">详情|统计</el-button>
            <el-button
              text
              v-if="row.taskStatus == 0"
              @click="$router.push({ path: './add', query: { id: row.id, promotion: true } })">
              推广
            </el-button>
            <el-button text v-if="row.taskStatus == 0" @click="$router.push({ path: './add', query: { id: row.id } })">
              编辑
            </el-button>
            <el-button text @click="deleteFn(row)">删除</el-button>
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
  </div>
</template>
<script>
import { getList, deletePomotion, deleteMultPo } from './api'
export default {
  name: 'short-link-popularize-list',
  data() {
    return {
      // 0群发客户，1群发客户群，2群发朋友圈，4应用消息
      infoType: [
        { name: '群发客户', key: 0 },
        { name: '群发客户群', key: 1 },
        { name: '群发朋友圈', key: 2 },
        { name: '应用消息', key: 3 },
      ],

      // 0待推广 1推广中 2已结束
      statusType: [
        { name: '待推广', key: 0 },
        { name: '推广中', key: 1 },
        { name: '已结束', key: 2 },
      ],
      query: {
        pageSize: 10,
        pageNum: 1,
        taskName: '',
        shortLinkName: '',
        type: '',
        taskStatus: '',
      },
      total: 0,
      loading: false,
      list: [],
      selectList: [],
    }
  },
  methods: {
    gotoShortLinkDetail(id) {
      this.$router.push({
        path: '/drainageCode/publicCustomer/IntelligentShortLink/detail',
        query: {
          id,
        },
      })
    },
    setType(data) {
      let str = ''
      this.infoType.forEach((dd) => {
        if (dd.key == data.type) {
          str = dd.name
        }
      })
      return str
    },
    setStatus(data) {
      let str = ''
      this.statusType.forEach((dd) => {
        if (dd.key == data.taskStatus) {
          str = dd.name
        }
      })
      return str
    },
    getList() {
      this.loading = true
      getList(this.query).then((res) => {
        this.total = Number(res.total)
        this.list = res.rows
        this.loading = false
      })
    },
    handleSearch() {
      this.query.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.query.pageNum = 1
      this.$refs['queryForm'].resetFields()
      this.getList()
    },
    handleSelectionChange(e) {
      this.selectList = e.map((dd) => dd.id)
    },
    deleteFn(data) {
      this.$confirm('是否确认删除当前推广任务？删除后不可撤销，请谨慎操作。', '删除', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deletePomotion(data.id)
        })
        .then(() => {
          this.handleSearch()
          this.msgSuccess('删除成功')
        })
    },
    deleteMult() {
      if (!this.selectList.length) {
        this.msgInfo('请选择要删除项！')
        return
      }
      const ids = this.selectList.join(',')
      this.$confirm('是否确认删除当前推广任务？删除后不可撤销，请谨慎操作。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deleteMultPo(ids)
        })
        .then(() => {
          this.handleSearch()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
  },
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>通过群发、朋友圈、应用消息等多种推广形式快捷推广智能短链，触达客户</div>
      `,
    )
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
