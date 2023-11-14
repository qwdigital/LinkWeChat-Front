<script>
import { getList, remove, download, downloadBatch } from './api'

export default {
  components: {},
  props: {},
  data() {
    return {
      getList,
      query: {
        pageNum: 1,
        pageSize: 10,
        codeName: '', // 活码名称
        createBy: '', // 创建人
        beginTime: '', // 开始日期
        endTime: '', // 结束日期
      },
      dateRange: [], // 添加日期
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
    this.$store.setBusininessDesc(
      `
        <div>指在客户通过员工活码加为好友后，员工自动推送入群引导语和群活码，客户可通过群活码扫码入群。</div>
      `,
    )
  },
  mounted() {},
  methods: {
    // 新建/编辑新客数据
    goRoute(path = 'aev', query) {
      this.$router.push({ path, query })
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
          this.$refs.table.getList()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
    // 批量下载
    downloadBatch() {
      this.$confirm('确认下载所有选中活码图片吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return downloadBatch(this.ids + '')
          // window.open(downloadBatch(this.ids))
        })
        .then((res) => {
          this.downloadBlob(res, '批量新客拉群活码.zip', 'zip')
        })
        .catch(function () {})
    },
  },
}
</script>

<template>
  <div>
    <RequestChartTable ref="table" :request="(params) => (Object.assign(params, query), getList(params))">
      <template #query="{ query }">
        <el-form-item label="活码名称" prop="codeName">
          <el-input clearable v-model="query.codeName" placeholder="请输入"></el-input>
        </el-form-item>
      </template>

      <template #operation>
        <div class="fxbw">
          <el-button type="primary" @click="goRoute()">新建活码</el-button>
          <div>
            <el-button type="primary" :disabled="!ids.length" @click="downloadBatch()">批量下载</el-button>
            <el-button type="primary" :disabled="!ids.length" @click="remove()">批量删除</el-button>
          </div>
        </div>
      </template>

      <template #="{ data }">
        <el-table :data="data" @selection-change="(selection) => (ids = selection.map((item) => item.id))">
          <el-table-column type="selection" width="50" align="center"></el-table-column>
          <el-table-column prop="codeName" label="活码名称" align="center"></el-table-column>
          <el-table-column prop="emplList" label="活码" align="center" width="130">
            <template #default="{ row }">
              <el-popover placement="bottom" trigger="hover">
                <template #reference><el-image :src="row.emplCodeUrl" class="code-image--small"></el-image></template>
                <el-image :src="row.emplCodeUrl" class="code-image"></el-image>
              </el-popover>
            </template>
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
              <div class="g-color cp" @click="goRoute('detail', { id: row.id, index: 1 })">
                {{ row.addCustomerNumber }}/{{ row.joinGroupNumber }}
              </div>
            </template>
          </el-table-column>
          <!-- <el-table-column label="创建人" align="center" prop="createBy"></el-table-column> -->
          <el-table-column label="创建时间" align="center" prop="createTime" width="160"></el-table-column>
          <el-table-column label="操作" align="center" width="280" fixed="right">
            <template #default="{ row }">
              <el-button text @click="goRoute('detail', { id: row.id })">详情|统计</el-button>
              <el-button text @click="goRoute('aev', { id: row.id })">编辑</el-button>
              <el-button text title="下载活码" @click="downloadBlob(row.groupCodeUrl, row.codeName + '.png', 'image')">
                下载
              </el-button>
              <el-button text title="复制二维码链接" @click="$copyText(row.groupCodeUrl)">复制</el-button>
              <el-button text @click="remove(row.id)">删除</el-button>
              <!-- <el-tooltip effect="light">
                <el-icon-MoreFilled class="el-icon-MoreFilled g-color cp"></el-icon-MoreFilled>
                <template #content></template>
              </el-tooltip> -->
            </template>
          </el-table-column>
        </el-table>
      </template>
    </RequestChartTable>
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
