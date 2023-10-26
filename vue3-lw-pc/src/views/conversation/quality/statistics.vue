<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div style="display: flex; align-items: center">
        <search-title :showMore="true" @search="getTableFn"></search-title>
        <el-input
          style="width: 150px"
          :model-value="userName"
          readonly
          @click="dialogVisible = true"
          placeholder="请选择成员" />
        <el-input
          style="width: 150px; margin: 0 20px"
          :model-value="deptName"
          readonly
          @click="dialogDeptVisible = true"
          placeholder="请选择部门" />
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column
          label="成员名称"
          align="center"
          prop="userName"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="所属部门" align="center" prop="deptName" show-overflow-tooltip></el-table-column>
        <el-table-column label="所属会话" align="center" prop="chatName" show-overflow-tooltip></el-table-column>
        <el-table-column label="会话类型" align="center" prop="chatType" show-overflow-tooltip>
          <template #default="{ row }">
            <div>
              {{ row.chatType == 1 ? '客户会话' : '客群会话' }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="超时时长" align="center" prop="timeout" show-overflow-tooltip></el-table-column>
        <el-table-column
          label="触发时间"
          align="center"
          prop="createTime"
          width="180"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180">
          <template #default="{ row }">
            <el-button text @click="showChatList(row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getTableChangeSize()" />
    </div>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
    <SelectDept
      :defaultValues="deptArray"
      v-model:visible="dialogDeptVisible"
      title="选择部门"
      @success="selectedDept"></SelectDept>
    <ChatList v-if="showChat" v-model:visible="showChat" :queryChat="queryChat"></ChatList>
  </div>
</template>
<script>
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'
import { statisticData, statisticTable } from './api.js'
import SelectDept from '@/components/SelectDept'
import ChatList from './chatList.vue'
export default {
  name: 'quality-statistics',
  components: {
    SearchTitle,
    ChartLine,
    SelectDept,
    ChatList,
  },
  data() {
    return {
      deptArray: [],
      deptName: '',
      dialogDeptVisible: false,
      dialogVisible: false,
      userArray: [],
      userName: '',
      cardData: [
        {
          title: '总超时次数',
          tips: '成员在会话中未能及时回复的次数，仅计算产生双方参与的会话次数',
          value: 0,
        },
        {
          title: '总超时率',
          tips: '成员在会话中未能及时回复的次数/双方共产生会话的次数',
          value: 0,
        },
        {
          title: '今日超时人数',
          tips: '今日未能及时回复用户会话的成员人数',
          value: 0,
        },
        {
          title: '今日超时次数',
          tips: '今日成员在会话中未能及时回复的次数',
          value: 0,
        },
        {
          title: '今日超时率',
          tips: '今日成员在会话中未能及时回复的次数/今日双方共产生会话的次数',
          value: 0,
        },
      ],
      value: [],
      id: '',
      exportLoading: false,
      tableList: [],
      loading: false,
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        deptIds: '',
        userIds: '',
      },
      tableSearch: {},
      showChat: false,
      queryChat: {
        formId: '',
        msgId: '',
        pageType: 0,
        receiveId: '',
        roomId: '',
      },
    }
  },
  methods: {
    showChatList(data) {
      this.queryChat = {
        fromId: data.fromId,
        msgId: data.msgId,
        pageType: 0,
        receiveId: data.receiveId,
        roomId: data.roomId,
      }
      this.showChat = true
    },
    handleSearch() {
      this.getTableChangeSize()
    },
    resetQuery() {
      this.query = {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        deptIds: '',
        userIds: '',
      }
      this.userArray = []
      this.userName = ''
      this.deptArray = []
      this.deptName = ''
      this.getTableChangeSize()
    },
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
    selectedDept(data) {
      this.deptArray = data
      this.deptName = this.deptArray
        .map(function (obj, index) {
          return obj.deptName
        })
        .join(',')
      this.query.deptIds = this.userArray
        .map(function (obj, index) {
          return obj.deptId
        })
        .join(',')
    },
    getTabTotalFn() {
      statisticData(this.id).then((res) => {
        this.cardData[0].value = res.data.timeOutTotalNum
        this.cardData[1].value = Number(res.data.timeOutTotalRate) * 100 + '%'
        this.cardData[2].value = res.data.todayTimeOutUserNum
        this.cardData[3].value = res.data.todayTimeOutNum
        this.cardData[4].value = Number(res.data.todayTimeOutRate) * 100 + '%'
      })
    },
    getTableChangeSize() {
      this.loading = true
      statisticTable(this.id, Object.assign({}, this.query)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.tableSearch = data
      this.loading = true
      // this.query.id = this.id
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
  },
  created() {
    this.id = this.$route.query.id
    this.getTabTotalFn()
  },
}
</script>
<style lang="scss" scoped></style>
