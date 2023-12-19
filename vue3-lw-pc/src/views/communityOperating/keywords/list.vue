<script>
import { getList, remove } from './api'

export default {
  props: {},
  components: { Preview: defineAsyncComponent(() => import('./Preview')) },
  data() {
    return {
      getList,
      h5Link: 'https://platform.wshoto.com/H5/?corpId=ww8e09372aff8d9190',
      query: {
        pageNum: 1,
        pageSize: 10,
        taskName: '', // 活码名称
        createBy: '', // 创建人
        keywords: '', // 关键词
        beginTime: '', // 创建开始时间
        endTime: '', // 创建结束时间
      },
      queryCreateByName: '',
      dateRange: [], // 添加日期
      total: 0, // 关键词拉群数据总量
      list: [], // 关键词拉群数据
      multiSelect: [], // 多选数据
      dialogVisible: false,
      dialogHowToConfig: false,
      disabled: false,
      loading: false,
      clipboard: null,
      preview: {
        dialogVisible: false,
        data: {},
      },
    }
  },
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
        <div>聚合多个群活码，生成落地页，客户在页面内根据关键词进入相应群聊</div>
      `,
    )
  },
  mounted() {},
  methods: {
    // 新增/编辑关键词拉群
    goRoute(path = 'aev', id) {
      this.$router.push({
        path,
        query: { id },
      })
    },
    // 重置查询参数
    resetQuery() {
      this.dateRange = []
      this.$refs['queryForm'].resetFields()

      this.$nextTick(() => {
        this.getList(1)
      })
    },
    // 批量删除
    handleBulkRemove() {
      this.$confirm('确认删除当前数据?删除操作无法撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          const ids = this.multiSelect.map((t) => t.taskId)

          remove(ids + '').then((res) => {
            if (res.code === 200) {
              this.getList()
            } else {
            }
          })
        })
        .catch(() => {})
    },
    // 删除
    handleRemove(id) {
      this.$confirm('确认删除当前数据?删除操作无法撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          remove(id + '').then((res) => {
            if (res.code === 200) {
              this.getList()
            } else {
            }
          })
        })
        .catch(() => {})
    },
    openHelpDialog() {
      this.dialogHowToConfig = true
    },
    // 获取显示用keyword字符串
    getDisplayKeywords(row) {
      const keywordList = row.keywordList || []
      const keywords = keywordList.map((k) => k.keyword)

      return keywords.join(' ')
    },
    // 获取显示用实际群码字符串
    getDisplayRealGroups(row) {
      if (!row || !row.groupNameList) return ''
      return row.groupNameList.join(' ')
    },
    // 处理多选
    handleSelectionChange(val) {
      this.multiSelect = val
    },
  },
}
</script>

<template>
  <div>
    <RequestChartTable ref="rct" :request="(params) => (Object.assign(params, query), getList(params))">
      <template #query="{ query }">
        <el-form-item label="链接名称" prop="taskName">
          <el-input clearable v-model="query.taskName" placeholder="请输入"></el-input>
        </el-form-item>
      </template>

      <template #operation="{ selectedIds }">
        <div class="fxbw">
          <el-button type="primary" @click="goRoute()">新建链接</el-button>
          <el-button @click="$refs.rct.remove(remove)" type="danger">批量删除</el-button>
        </div>
      </template>

      <template #table>
        <el-table-column label="链接标题" align="center" prop="taskName" show-overflow-tooltip />
        <el-table-column label="链接描述" align="center" prop="taskName" show-overflow-tooltip />
        <el-table-column label="关键词" align="center" width="120">
          <template #default="{ row }">
            <div
              class="g-color cp"
              @click="
                ;(externalUserid = row.externalUserid), (dialogVisible = true), $refs.RequestChartTableDialog?.getList()
              ">
              {{ row.keywords }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="访问客户数/进群客户数" align="center" prop="cusNumber" width="">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  访问客户数/进群客户数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>访问客户数：访问当前链接的客户总数（去重）；</div>
              <div>进群客户数：访问客户中成功进群的总数（去重）；</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <div class="g-color cp" @click="goRoute('detail', { id: row.id, index: 1 })">
              {{ row.touchWeCustomerNumber }}/{{ row.joinGroupCustomerNumber }}
            </div>
          </template>
        </el-table-column>

        <el-table-column label="最近更新" align="center" prop="updateTime">
          <template #default="{ row }">
            {{ row.updateTime }}
            <br />
            {{ row.updateTime }}
          </template>
        </el-table-column>

        <el-table-column label="操作" align="center" width="180">
          <template #default="{ row }">
            <el-button text @click="goRoute('detail', { id: row.id })">详情|统计</el-button>
            <el-button text @click="goRoute('aev', { id: row.id })">编辑</el-button>
            <el-button text @click=";(preview.data = row), (preview.dialogVisible = true)">预览</el-button>
            <el-button text @click="$refs.rct.remove(remove, row.id)">删除</el-button>
          </template>
        </el-table-column>
      </template>
    </RequestChartTable>

    <el-dialog title="关键词" v-model="dialogVisible">
      <RequestChartTable
        ref="RequestChartTableDialog"
        style="padding: 0 0 20px 0"
        :request="
          (query) => (
            (query.id = $route.query.id), (query.externalUserid = externalUserid), api.getCustomerToGroupList(query)
          )
        ">
        <template #="{ data }">
          <el-table :data="data">
            <el-table-column label="关键词" align="center" prop="groupName"></el-table-column>
            <el-table-column align="center" prop="joinTime" label="群活码">
              <template #default="{ row }">
                {{ row.joinTime || '—' }}
                <br />
                <el-image :src="row.emplCodeUrl" class="code-image"></el-image>
              </template>
            </el-table-column>
            <el-table-column label="活码客群数" align="center">
              <template #default="{ row }">
                <div
                  class="g-color cp"
                  @click="
                    $router.push({
                      name: lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
                      query: { externalUserid: row.externalUserid, userId: row.addUserId },
                    })
                  ">
                  客户详情
                </div>
              </template>
            </el-table-column>
          </el-table>
        </template>
      </RequestChartTable>
    </el-dialog>

    <el-dialog title="预览" v-model="preview.dialogVisible">
      <Preview :data="preview.data" />
      <el-button type="primary" plain @click="downloadBlob(row.groupCodeUrl, row.codeName + '.png', 'image')">
        下载二维码
      </el-button>
      <el-button type="primary" @click="$copyText(row.groupCodeUrl)">复制链接</el-button>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.help {
  .step {
    margin-bottom: 20px;
  }
}
.code-image {
  width: 200px;
  height: 200px;
}
.code-image--small {
  width: 50px;
  height: 50px;
}
.overflow-ellipsis {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.table-desc {
  max-width: 120px;
}
</style>
