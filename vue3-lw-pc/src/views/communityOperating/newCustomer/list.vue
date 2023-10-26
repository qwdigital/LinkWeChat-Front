<script>
import { getList, remove, download, downloadBatch } from '@/api/communityOperating/newCustomer'

export default {
  components: {},
  props: {},
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        emplCodeName: '', // 活码名称
        createBy: '', // 创建人
        beginTime: '', // 开始日期
        endTime: '', // 结束日期
      },
      dateRange: [], // 添加日期
      total: 0, // 数据总量
      form: {},
      list: [],
      dialogVisible: false,
      disabled: false,
      loading: false,
      status: ['正常', '停用'],
      pushType: {
        0: '发给客户',
        1: '发给客户群',
      },
      queryUser: [], // 搜索框选择的添加人
      ids: [],
    }
  },
  computed: {},
  watch: {
    // 日期选择器数据同步至查询参数
    dateRange: {
      deep: true,
      handler(val) {
        if (!val || val.length !== 2) {
          this.query.beginTime = ''
          this.query.endTime = ''
        } else {
          ;[this.query.beginTime, this.query.endTime] = val
        }
      },
    },
  },
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>指在客户通过员工活码加为好友后，员工自动推送入群引导语和群活码，客户可通过群活码扫码入群。</div>
      `,
    )
  },
  mounted() {
    // new clipboard(".copy-btn");
  },
  methods: {
    // 获取新客数据
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true

      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 新建/编辑新客数据
    goRoute(id) {
      this.$router.push({
        path: 'newCustomerAev',
        query: { id },
      })
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    /** 删除按钮操作 */
    remove(id) {
      const ids = id || this.ids
      this.$confirm('是否确认删除?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(function () {
          return remove(ids)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
    // 下载
    download(data) {
      let name = data.codeName + '.png'
      download(data.id).then((res) => {
        if (res != null) {
          let blob = new Blob([res], { type: 'application/zip' })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = name // 重命名文件
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
    // 批量下载
    downloadBatch() {
      this.$confirm('是否确认下载所有活码图片吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return downloadBatch(this.ids + '')
          // window.open(downloadBatch(this.ids))
        })
        .then((res) => {
          if (res != null) {
            let blob = new Blob([res], { type: 'application/zip' })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '批量员工活码.zip' // 重命名文件
            link.click()
            URL.revokeObjectURL(url) // 释放内存
          }
        })
        .catch(function () {})
    },
    // 重置查询参数
    resetQuery() {
      this.dateRange = []
      this.$refs['queryForm'].resetFields()

      this.$nextTick(() => {
        this.getList(1)
      })
    },
  },
}
</script>

<template>
  <div>
    <el-form ref="queryForm" :inline="true" :model="query" class="top-search">
      <el-form-item label="活码名称" prop="emplCodeName">
        <el-input clearable v-model="query.emplCodeName" placeholder="请输入"></el-input>
      </el-form-item>
      <!-- <el-form-item label="创建人" prop="createBy">
        <el-input clearable v-model="query.createBy" placeholder="请输入"></el-input>
      </el-form-item> -->
      <el-form-item label="创建时间">
        <el-date-picker
          clearable
          v-model="dateRange"
          value-format="YYYY-MM-DD"
          type="daterange"
          v-bind="pickerOptions"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"></el-date-picker>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery()">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="goRoute()">新建活码</el-button>
        <div>
          <el-button type="primary" :disabled="!ids.length" @click="downloadBatch()">批量下载</el-button>
          <el-button type="primary" :disabled="!ids.length" @click="remove()">批量删除</el-button>
        </div>
      </div>

      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="50" align="center"></el-table-column>
        <el-table-column prop="codeName" label="活码名称" align="center"></el-table-column>
        <el-table-column prop="emplList" label="活码" align="center" width="130">
          <template #default="{ row }">
            <el-popover placement="bottom" trigger="hover">
              <template #reference><el-image :src="row.emplCodeUrl" class="code-image--small"></el-image></template>
              <el-image :src="row.emplCodeUrl" class="code-image"></el-image>
            </el-popover>
          </template>
          <!-- <template #default="{ row }">
          <el-image v-if="row.emplCodeUrl" :src="row.emplCodeUrl" class="code-image">
          </el-image>
        </template> -->
        </el-table-column>
        <el-table-column prop="emplNames" label="使用员工" align="center">
          <template #default="{ row }">
            <TagEllipsis :list="row?.emplNames" emptyText></TagEllipsis>
          </template>
        </el-table-column>
        <el-table-column label="客户标签" align="center">
          <template #default="{ row }">
            <TagEllipsis :list="row?.tagNames" emptyText></TagEllipsis>
          </template>
        </el-table-column>
        <el-table-column label="实际群聊" align="center">
          <template #default="{ row }">
            <TagEllipsis :list="row?.groupNames" emptyText></TagEllipsis>
          </template>
        </el-table-column>
        <el-table-column label="添加客户数/进群客户数" align="center" prop="cusNumber" width="100">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  添加客户数/进群客户数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>添加客户数：通过此活码添加的客户总数（去重）；</div>
              <div>进群客户数：添加客户中成功进群的总数（去重）；</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <el-button text @click="goRoute(row.id)">{{ row.addCustomerNumber }}/{{ row.joinGroupNumber }}</el-button>
          </template>
        </el-table-column>
        <!-- <el-table-column label="创建人" align="center" prop="createBy"></el-table-column> -->
        <el-table-column label="创建时间" align="center" prop="createTime" width="160"></el-table-column>
        <el-table-column label="操作" align="center" width="180">
          <template #default="{ row }">
            <el-tooltip effect="light">
              <el-icon-MoreFilled class="el-icon-MoreFilled g-color cp"></el-icon-MoreFilled>
              <template #content>
                <!-- <el-button
                  text
                  @click="
                    $router.push({
                      path: 'groupAdd',
                      query: {
                        groupCodeId: row.id,
                        obj: encodeURIComponent(JSON.stringify(row)),
                      },
                    })
                  ">
                  编辑
                </el-button> -->
                <el-button text @click="goRoute(row.id)">详情|统计</el-button>
                <el-button text @click="goRoute(row.id)">编辑</el-button>
                <el-button text @click="download(row)">下载</el-button>
                <el-button text @click="download(row)">复制</el-button>
                <el-button text @click="remove(row.id)">删除</el-button>
              </template>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()" />
    </div>
  </div>
</template>

<style scoped lang="scss">
.code-image {
  width: 200px;
  height: 200px;
}

.code-image--small {
  width: 50px;
  height: 50px;
}
</style>
