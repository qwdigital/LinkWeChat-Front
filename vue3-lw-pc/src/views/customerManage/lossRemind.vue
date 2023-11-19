<script>
import { getListNew, lossRemind, getLossRemindStatus } from '@/api/customer'

export default {
  name: 'LossRemind',
  components: {},
  props: {},
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        name: '', // "客户名称",
        userIds: '', // "添加人id",
        tagIds: '', // "标签id,多个标签，id使用逗号隔开",
        beginTime: '', // "开始时间",
        endTime: '', // "结束时间"
        trackState: 5,
      },
      queryTag: [], // 搜索框选择的标签
      queryUser: [], // 搜索框选择的添加人
      dateRange: [], // 添加日期
      loading: false,
      isMoreFilter: false,
      total: 0,
      // 添加标签表单
      form: {
        gourpName: '',
        weTags: [],
      },
      list: [], // 客户列表
      multipleSelection: [], // 多选数组
      dialogVisible: false, // 选择标签弹窗显隐
      dialogVisibleSelectUser: false, // 选择添加人弹窗显隐
      isNotice: '0',
    }
  },
  watch: {},
  computed: {},
  created() {
    this.getList()
    this.getLossRemindStatus()

    this.$store.setBusininessDesc(
      `
        <div>当企业成员被客户删除时，会在流失列表中产生一条记录，开启删除通知后，被删除的成员会收到一条推送</div>
      `,
    )
  },
  mounted() {},
  methods: {
    getList(page) {
      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0]
        this.query.endTime = this.dateRange[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
      this.query.userIds = this.queryUser.map((d) => d.userId)?.join(',')
      this.query.tagIds = this.queryTag.map((d) => d.tagId)?.join(',')

      page && (this.query.pageNum = page)
      this.loading = true
      getListNew(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
          this.loading = false
          this.multipleSelection = []
        })
        .catch(() => {
          this.loading = false
        })
    },
    getLossRemindStatus() {
      getLossRemindStatus().then(({ data }) => {
        this.isNotice = data
      })
    },
    // /** 导出按钮操作 */
    // exportCustomer() {
    //   const queryParams = this.query
    //   this.$confirm('是否确认导出所有客户数据项?', '警告', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //     type: 'warning'
    //   })
    //     .then(function() {
    //       return exportCustomer(queryParams)
    //     })
    //     .then((response) => {
    //       this.download(response.msg)
    //     })
    //     .catch(function() {})
    // },
    resetForm() {
      this.dateRange = []
      this.queryTag = []
      this.queryUser = []
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    // 流失提醒开关事件
    remindSwitch(val) {
      lossRemind(val).then(() => {
        this.msgSuccess('操作成功')
      })
    },
  },
}
</script>

<template>
  <div>
    <el-form ref="queryForm" :inline="true" :model="query" label-width="70px" class="top-search">
      <el-form-item label="客户名称" prop="name">
        <el-input clearable v-model="query.name" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="添加人">
        <div class="tag-input" @click="dialogVisibleSelectUser = true">
          <span class="tag-place" v-if="!queryUser.length">请选择</span>
          <template v-else>
            <el-tag type="info" v-for="(unit, unique) in queryUser" :key="unique">{{ unit.name }}</el-tag>
          </template>
        </div>
      </el-form-item>
      <el-form-item label="添加日期">
        <el-date-picker
          clearable
          v-model="dateRange"
          type="daterange"
          value-format="YYYY-MM-DD"
          v-bind="pickerOptions"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"></el-date-picker>
      </el-form-item>
      <el-form-item label="标签">
        <div class="tag-input" @click="dialogVisible = true">
          <span class="tag-place" v-if="!queryTag.length">请选择</span>
          <template v-else>
            <el-tag type="info" v-for="(unit, unique) in queryTag" :key="unique">{{ unit.name }}</el-tag>
          </template>
        </div>
      </el-form-item>
      <el-form-item label="">
        <!-- v-hasPermi="['customerManage:customer:query']" -->
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <!-- v-hasPermi="['customerManage:customer:query']" -->
        <el-button @click="resetForm()">重置</el-button>
        <!-- <el-button
          v-hasPermi="['customerManage:customer:export']"
          type="info"
          @click="exportCustomer"
          >导出列表</el-button
        > -->
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <div>
          通知提醒
          <el-switch
            class="ml10 mr10"
            v-model="isNotice"
            active-value="1"
            inactive-value="0"
            active-color="#07c160"
            inactive-color="#ff4949"
            @change="remindSwitch"></el-switch>
        </div>
        <!-- v-hasPermi="['customerManage/customer:makeTag']" -->
      </div>

      <el-table v-loading="loading" ref="multipleTable" :data="list" tooltip-effect="dark">
        <!-- <el-table-column type="selection" align="center" width="55"></el-table-column> -->
        <el-table-column label="客户" prop="name" align="center">
          <template #default="scope">
            {{ scope.row.customerName }}
            <!-- <span :style="{ color: scope.row.type === 1 ? '#4bde03' : '#f9a90b' }">{{
            { 1: '@微信', 2: '@企业微信' }[scope.row.type]
          }}</span>
          <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[scope.row.gender]]"/> -->
          </template>
        </el-table-column>
        <!-- <el-table-column prop="corpName" label="公司名称" align="center"></el-table-column> -->
        <el-table-column prop="userName" label="添加人（首位）" align="center">
          <!-- <template #default="scope">{{ scope.row.weFlowerCustomerRels[0].userName }}</template> -->
        </el-table-column>
        <el-table-column prop="firstAddTime" label="添加时间" align="center">
          <!-- <template #default="scope">{{ scope.row.weFlowerCustomerRels[0].createTime }}</template> -->
        </el-table-column>
        <el-table-column label="留存天数" prop="retentionDays" align="center"></el-table-column>
        <el-table-column prop="lossTime" label="流失时间" align="center">
          <!-- <template #default="scope">{{ scope.row.weFlowerCustomerRels[0].createTime }}</template> -->
        </el-table-column>
        <el-table-column prop="address" label="标签" align="center">
          <template #default="{ row }">
            <TagEllipsis :list="row.tagNames?.split(',')" emptyText="无标签"></TagEllipsis>
            <!-- <el-tag type="info" v-for="(unit, unique) in row?.tagNames?.split(',')" :key="unique">{{ unit }}</el-tag> -->

            <!-- <div v-for="(item, index) in row.weFlowerCustomerRels" :key="index">
            <el-tag type="info" v-for="(unit, unique) in item.weFlowerCustomerTagRels" :key="unique">{{
              unit.tagName
            }}</el-tag>
          </div> -->
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <!-- v-hasPermi="['customerManage:customer:view']" -->

            <el-button
              @click="
                $router.push({
                  name: lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
                  query: {
                    externalUserid: row.externalUserid,
                    userId: row.firstUserId,
                  },
                })
              "
              text>
              查看
            </el-button>
            <!-- <el-button text >编辑</el-button> -->
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

    <!-- 选择标签弹窗 -->
    <SelectTag v-model:visible="dialogVisible" :selected="queryTag" @success="(list) => (queryTag = list)"></SelectTag>

    <!-- 选择添加人弹窗 -->
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择添加人"
      @success="(list) => (queryUser = list)"></SelectUser>
  </div>
</template>

<style lang="scss" scoped>
.el-icon-s-custom {
  font-size: 16px;
  margin-left: 4px;
  color: var(--font-black-6);
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
.bfc-d + .bfc-d .el-checkbox:first-child {
  margin-left: 10px;
}
</style>
