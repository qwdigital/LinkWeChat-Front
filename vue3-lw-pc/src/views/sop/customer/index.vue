<template>
  <div>
    <el-form :inline="true" label-width="80px" label-position="left" class="top-search">
      <el-form-item label="SOP名称">
        <el-input v-model="query.sopName" placeholder="请输入SOP规则名称" clearable @keyup.enter="search()" />
      </el-form-item>
      <el-form-item label="SOP类型">
        <el-select v-model="query.businessType">
          <el-option v-for="(unit, key) in styleList" :key="key" :label="unit.name" :value="unit.type"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          value-format="YYYY-MM-DD"
          v-model="dateValue"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          @change="setDateChange"></el-date-picker>
      </el-form-item>
      <el-form-item label="SOP状态">
        <el-select v-model="query.sopState">
          <el-option v-for="(unit, key) in statusList" :key="key" :label="unit.name" :value="unit.status"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" @click="search()">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="goRoute('add')">新建SOP</el-button>
      </div>
      <el-table v-loading="loading" :data="list" style="width: 100%">
        <el-table-column
          label="SOP名称"
          align="center"
          prop="sopName"
          min-width="120"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="SOP类型" align="center" prop="qrCode" min-width="120">
          <template #default="{ row }">
            <div>
              {{
                row.businessType === 1
                  ? '新客SOP'
                  : row.businessType === 2
                  ? '活动节日SOP'
                  : row.businessType === 3
                  ? '客户转化SOP'
                  : ''
              }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="执行成员" align="center" min-width="150" prop="executeUser">
          <template #default="{ row }">
            <tag-ellipsis v-if="row.executeUser" :list="row.executeUser.split(',')"></tag-ellipsis>
          </template>
        </el-table-column>
        <el-table-column label="SOP数据" align="center" min-width="100" prop="crowdNum" show-overflow-tooltip>
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                SOP数据
                <el-icon-QuestionFilled class="el-icon-QuestionFilled" />
              </template>
              <div>本SOP执行完毕所需的全部天数与全部次数</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <div>推送所需天数： {{ row.pushNeedDayNumber }}</div>
            <div>推送所需次数： {{ row.pushNeedUserNumber }}</div>
          </template>
        </el-table-column>
        <el-table-column
          label="创建人"
          align="center"
          min-width="140"
          prop="createBy"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="SOP状态" align="center" min-width="100" prop="sopState" show-overflow-tooltip>
          <template #default="{ row }">
            <div :class="{ color1: row.sopState === 1, color2: row.sopState === 2 }">
              {{ row.sopState === 2 ? '已暂停' : row.sopState === 1 ? '执行中' : '' }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="SOP推送方式" align="center" min-width="100" prop="sendType" show-overflow-tooltip>
          <template #default="{ row }">
            <div :class="{ color1: row.sendType === 1, color2: row.sendType === 2 }">
              {{ row.sendType === 1 ? '企微群发' : row.sendType === 2 ? '手动发送' : '' }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="180"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="200">
          <template #default="{ row }">
            <el-button text @click="goRoute('detail', row.sopBaseId)">详情</el-button>

            <el-button text @click="goRoute('add', row.sopBaseId)">复制</el-button>

            <!-- 暂停中 -->
            <template v-if="row.sopState === 2">
              <el-button text @click="updateStateFn(row.sopBaseId, 1)">执行</el-button>
              <el-button text @click="removeFn(row.sopBaseId)">删除</el-button>
            </template>
            <template v-else>
              <el-button text @click="updateStateFn(row.sopBaseId, 2)">暂停</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>
  </div>
</template>
<script>
import TagEllipsis from '@/components/TagEllipsis'
import { getTableList, deleteTableItems, updateSopState } from '@/api/sop/index'
export default {
  name: 'customer-sop',
  data() {
    return {
      query: {
        sopName: '',
        baseType: 1, // 1.客户sop  2.客群sop
        businessType: '',
        sopState: '',
        beginTime: '',
        endTime: '',
        pageNum: 1,
        pageSize: 10,
      },
      dateValue: [],
      styleList: [
        {
          type: '',
          name: '全部',
        },
        {
          type: 1,
          name: '新客SOP',
        },
        {
          type: 2,
          name: '活动节日SOP',
        },
        {
          type: 3,
          name: '客户转化SOP',
        },
      ],
      statusList: [
        {
          status: '',
          name: '全部',
        },
        {
          status: 1,
          name: '执行中',
        },
        {
          status: 2,
          name: '暂停',
        },
      ],
      loading: false,
      list: [],
      total: 0,
    }
  },
  components: {
    TagEllipsis,
  },
  methods: {
    setDateChange(data) {
      if (data) {
        this.query.beginTime = data[0]
        this.query.endTime = data[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.query = {
        sopName: '',
        baseType: 1, // 1.客户sop  2.客群sop
        businessType: '',
        sopState: '',
        beginTime: '',
        endTime: '',
        pageNum: 1,
        pageSize: 10,
      }
      this.dateValue = []
      this.getList()
    },
    getList() {
      this.loading = true
      getTableList(this.query).then((res) => {
        if (res.code === 200) {
          this.total = Number(res.total)
          this.list = res.rows
        }
        this.loading = false
      })
    },
    goRoute(path, id) {
      if (path == 'add' && id) {
        this.$confirm('是否确认从当前SOP进行复制？点击确定进入复制新建页面', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(() => {
          this.$router.push({ path: path, query: { id } })
        })
      } else {
        this.$router.push({ path: path, query: { id } })
      }
    },
    updateStateFn(id, state) {
      this.$confirm('是否确认进行当前操作！', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return updateSopState({ id, sopState: state })
        })
        .then(() => {
          this.search()
          this.msgSuccess('操作成功')
        })
        .catch(function () {})
    },
    removeFn(id) {
      this.$confirm('是否确认删除当前客户SOP？删除后不可撤销，历史数据将清空，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deleteTableItems(id)
        })
        .then(() => {
          this.search()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
  },
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>管理员在创建个人SOP规则后，员工通过推送的消息通知，在指定时间内给指定客户发送指定内容</div>
      `,
    )
  },
}
</script>
<style lang="scss" scoped>
.color1 {
  color: var(--font-black);
}
.color2 {
  color: #fa7216;
}
</style>
