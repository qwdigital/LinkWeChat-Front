<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <el-form :inline="true" label-width="" label-position="left" class="top-search">
      <el-form-item label="群聊名称">
        <el-input v-model="query.groupName" placeholder="请输入群聊名称" clearable @keyup.enter="search()" />
      </el-form-item>
      <el-form-item label="SOP结果状态">
        <el-select v-model="query.executeState">
          <el-option v-for="(unit, key) in statusList" :key="key" :label="unit.name" :value="unit.status"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="成员名称">
        <el-input :model-value="userName" readonly @click="dialogVisible = true" placeholder="请选择客群群主" />
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" @click="search()">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="g-card-title mid-action">
        数据明细
        <el-button type="primary" class="" @click="syncFn()">同步</el-button>
      </div>

      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column
          label="群聊名称"
          align="center"
          min-width="100"
          prop="groupName"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="SOP结果状态" align="center" min-width="130" prop="visitTotalCnt" show-overflow-tooltip>
          <template #default="{ row }">
            <div>
              {{ setName(row.executeState) }}
            </div>
          </template>
        </el-table-column>
        <el-table-column
          label="客群成员"
          align="center"
          prop="userName"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="岗位名称"
          align="center"
          prop="position"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="所属部门"
          align="center"
          prop="deptName"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="SOP执行效率" align="center" prop="efficiency" min-width="100" show-overflow-tooltip>
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                SOP执行效率
                <el-icon-QuestionFilled class="el-icon-QuestionFilled" />
              </template>
              <div>成员在规定时间内及时推送的SOP数/截止目前应推送的总SOP数</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            {{ row.efficiency ? row.efficiency + '%' : '--' }}
          </template>
        </el-table-column>
        <el-table-column
          label="进入SOP时间"
          align="center"
          prop="createTime"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="结束SOP时间"
          align="center"
          prop="executeEndTime"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" class-name="small-padding fixed-width">
          <template #default="{ row }">
            <el-button text :data="row" @click="getContent(row.chatId, row.executeTargetId)">查看推送详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>
    <el-drawer :size="650" title="查看推送详情" v-model="drawer" direction="rtl">
      <SendDetail :detail="detail" :list="sendList"></SendDetail>
    </el-drawer>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
  </div>
</template>
<script>
import { getDetailTab, getGroupDetailTable, getGroupSendContent, getSopDetail, getSyncData } from '@/api/sop/index'
import Calculation from '@/utils/calculation'
import SendDetail from '../components/SendDetail'
export default {
  name: 'customer-sop-detail',
  components: {
    SendDetail,
  },
  data() {
    return {
      detail: {},
      sendList: [],
      drawer: false,
      id: '',
      userName: undefined,
      userArray: [],
      total: 0,
      dialogVisible: false,
      query: {
        pageSize: 10,
        pageNum: 1,
        sopBaseId: '',
        groupName: '',
        executeState: '',
        weUserId: '',
      },
      statusList: [
        {
          status: '',
          name: '全部',
        },
        {
          status: 1,
          name: '进行中',
        },
        {
          status: 2,
          name: '提前结束',
        },
        {
          status: 3,
          name: '正常结束',
        },
        {
          status: 4,
          name: '异常结束',
        },
      ],
      tableList: [],
      loading: false,
      cardData: [
        {
          title: 'SOP对象客群数',
          tips: '满足当前SOP执行的目标对象条件，且正在执行中的客群数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '正常结束客群数',
          tips: 'SOP执行完成后自动变更配置SOP结束条件的客群数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '提前结束客群数',
          tips: 'SOP执行过程中已满足SOP结束条件而提前结束SOP执行过程的客群数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '异常结束客群数',
          tips: '除了正常结束与提前结束外，不满足“员工继续发送”或“客群继续接收”导致的SOP无法正常执行而结束SOP的客群数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
      ],
    }
  },
  methods: {
    syncFn() {
      getSyncData(this.id).then((res) => {
        if (res.code === 200) {
          this.getTabFn()
          this.getList()
          this.msgSuccess('同步成功！')
        }
      })
    },
    setName(type) {
      let index = this.statusList.findIndex((item) => {
        return item.status === type
      })
      if (index !== -1) {
        return this.statusList[index].name
      } else {
        return ''
      }
    },
    getContent(chatId, executeTargetId) {
      getGroupSendContent({ chatId, executeTargetId, sopBaseId: this.id }).then((res) => {
        this.sendList = res.data
        this.drawer = true
      })
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        sopBaseId: this.id,
        groupName: '',
        executeState: '',
        weUserId: '',
      }
      this.userArray = []
      this.userName = ''
      this.getList()
    },
    getSelectUser(data) {
      this.userArray = data
      this.userName = this.userArray
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
    getList() {
      this.query.sopBaseId = this.id
      getGroupDetailTable(this.query).then((res) => {
        if (res.code === 200 && res.rows) {
          this.tableList = res.rows
          this.total = ~~res.total
        }
      })
    },
    getTabFn() {
      getDetailTab(this.id).then((res) => {
        if (res.code === 200) {
          this.cardData[0].value = res.data.tdCustomerNumber
          this.cardData[0].value1 = Calculation.accSub(res.data.tdCustomerNumber, res.data.ydCustomerNumber)
          this.cardData[1].value = res.data.tdCommonEndCustomerNumber
          this.cardData[1].value1 = Calculation.accSub(
            res.data.tdCommonEndCustomerNumber,
            res.data.ydCommonEndCustomerNumber,
          )
          this.cardData[2].value = res.data.tdEarlyEndCustomerNumber
          this.cardData[2].value1 = Calculation.accSub(
            res.data.tdEarlyEndCustomerNumber,
            res.data.ydEarlyEndCustomerNumber,
          )
          this.cardData[3].value = res.data.tdErrorEndCustomerNumber
          this.cardData[3].value1 = Calculation.accSub(
            res.data.tdErrorEndCustomerNumber,
            res.data.ydErrorEndCustomerNumber,
          )
        }
      })
    },
  },
  created() {
    this.id = this.$route.query.id
    this.getTabFn()
    this.getList()
    getSopDetail(this.id).then((res) => {
      if (res.code === 200) {
        this.detail = res.data
      }
    })
  },
}
</script>
<style lang="scss" scoped></style>
