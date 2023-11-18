<template>
  <div>
    <div class="flex">
      <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
        <div class="g-card">
          <div class="g-card-title fxbw">
            <div class="">群发统计</div>
            <div class="operation" v-if="isTask !== 1">
              <span v-if="data.refreshTime">最近同步时间：{{ data.refreshTime }}</span>
              <el-button class="ml10" type="primary" @click="setFn">同步</el-button>
            </div>
          </div>
          <div class="total_list fxbw">
            <div class="item">
              <div>已发送{{ data.chatType === 1 ? '员工' : '群主' }}</div>
              <div style="font-size: 18px; color: var(--font-black)">
                {{ data.alreadySendNum ? data.alreadySendNum : 0 }}
              </div>
            </div>
            <div class="item">
              <div>未发送{{ data.chatType === 1 ? '员工' : '群主' }}</div>
              <div style="font-size: 18px; color: var(--font-black)">
                {{ data.toBeSendNum ? data.toBeSendNum : 0 }}
              </div>
            </div>
            <div class="item">
              <div>已送达{{ data.chatType === 1 ? '客户' : '客户群' }}</div>
              <div style="font-size: 18px; color: var(--font-black)">
                {{ data.alreadySendCustomerNum ? data.alreadySendCustomerNum : 0 }}
              </div>
            </div>
            <div class="item">
              <div>未送达{{ data.chatType === 1 ? '客户' : '客户群' }}</div>
              <div style="font-size: 18px; color: var(--font-black)">
                {{ data.toBeSendCustomerNum ? data.toBeSendCustomerNum : 0 }}
              </div>
            </div>
          </div>
        </div>
        <div class="g-card">
          <div class="g-card-title">{{ data.chatType === 1 ? '员工' : '群主' }}详情</div>
          <el-form :model="queryMember" ref="queryMemberForm" :inline="true" label-position="left" label-width="">
            <el-form-item :label="data.chatType === 1 ? '发送员工' : '发送群主'" prop="userName">
              <el-input v-model="queryMember.userName" placeholder="请输入" />
            </el-form-item>
            <el-form-item label="发送状态" prop="status">
              <el-select v-model="queryMember.status" placeholder="请选择发送状态">
                <el-option label="全部" value=""></el-option>
                <el-option
                  v-for="(value, key, index) in memberState"
                  :label="value"
                  :value="key"
                  :key="index"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label-width="0">
              <el-button type="primary" @click="getMemberList(1)">查询</el-button>
              <el-button @click="$refs.queryMemberForm.resetFields()">重置</el-button>
            </el-form-item>
          </el-form>
          <div>
            <el-table v-loading="member.loading" :data="member.list">
              <el-table-column :label="data.chatType === 1 ? '发送员工' : '发送群主'" align="center" prop="userName" />
              <el-table-column
                :label="data.chatType === 1 ? '预计发送客户' : '预计发送客户群'"
                align="center"
                prop="total">
                <template #default="scope">
                  {{ scope.row.toBeCustomerName ? scope.row.toBeCustomerName : 0 }}
                </template>
              </el-table-column>
              <el-table-column
                :label="data.chatType === 1 ? '实际发送客户' : '实际发送客户群'"
                align="center"
                prop="already">
                <template #default="scope">
                  {{ scope.row.alreadyCustomerName ? scope.row.alreadyCustomerName : 0 }}
                </template>
              </el-table-column>
              <el-table-column label="发送状态" align="center" prop="status">
                <template #default="scope">
                  {{ memberState[scope.row.status] }}
                </template>
              </el-table-column>
            </el-table>
            <pagination
              v-show="member.total > 0"
              :total="member.total"
              v-model:page="queryMember.pageNum"
              v-model:limit="queryMember.pageSize"
              @pagination="getMemberPage" />
          </div>
        </div>
        <div class="g-card">
          <div class="g-card-title">
            <div class="">{{ data.chatType === 1 ? '客户' : '客户群' }}详情</div>
          </div>
          <el-form :model="queryCustomer" ref="queryForm" :inline="true" label-position="left" label-width="">
            <el-form-item
              :label="data.chatType === 1 ? '发送客户' : '发送客户群'"
              :prop="data.chatType === 1 ? 'customerName' : 'chatName'">
              <el-input
                v-model="queryCustomer[data.chatType === 1 ? 'customerName' : 'chatName']"
                style="width: 150px"
                placeholder="请输入" />
            </el-form-item>
            <el-form-item label="发送状态" prop="status">
              <el-select v-model="queryCustomer.status" placeholder="请选择发送状态">
                <el-option label="全部" value=""></el-option>
                <el-option
                  v-for="(value, key, index) in customerState"
                  :label="value"
                  :value="key"
                  :key="index"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label-width="0">
              <el-button type="primary" @click="getCustomerList(1)">查询</el-button>
              <el-button @click="$refs.queryForm.resetFields()">重置</el-button>
            </el-form-item>
          </el-form>
          <div>
            <el-table v-loading="customer.loading" :data="customer.list">
              <el-table-column
                :label="data.chatType === 1 ? '客户' : '客户群'"
                align="center"
                :prop="data.chatType === 1 ? 'customerName' : 'chatName'" />
              <el-table-column :label="data.chatType === 1 ? '所属员工' : '所属群主'" align="center" prop="userName" />
              <el-table-column label="送达时间" align="center" prop="sendTime" width="180"></el-table-column>
              <el-table-column label="送达状态" align="center" prop="status">
                <template #default="scope">
                  {{ customerState[scope.row.status] }}
                </template>
              </el-table-column>
            </el-table>
            <pagination
              v-show="customer.total > 0"
              :total="customer.total"
              v-model:page="queryCustomer.pageNum"
              v-model:limit="queryCustomer.pageSize"
              @pagination="getCustomerPage" />
          </div>
        </div>
      </div>
      <div class="g-card" style="width: 425px; margin-top: 0">
        <PreviewInPhone :templateInfo="form.welcomeMsg" :originList="form.materialMsgList"></PreviewInPhone>
      </div>
    </div>
  </div>
</template>

<script>
import { getDetail, memberList, resultList, syncMsg } from '@/api/groupMessage'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone.vue'

export default {
  components: {
    PreviewInPhone,
  },
  props: {},
  data() {
    return {
      customerState: {
        0: '未送达',
        1: '已送达',
        2: '非好友',
        3: '接收达上限',
      },
      memberState: {
        0: '未发送',
        2: '已发送',
      },
      member: {
        loading: false,
        total: 0,
        list: [],
      },
      customer: {
        loading: false,
        total: 0,
        list: [],
      },
      queryMember: {
        userName: '',
        msgTemplateId: '',
        pageNum: 1,
        pageSize: 10,
        status: '',
      },
      queryCustomer: {
        customerName: '',
        msgTemplateId: '',
        status: '',
        pageNum: 1,
        pageSize: 10,
      },
      form: {
        welcomeMsg: '',
        materialMsgList: [],
      },
      data: {
        chatType: 1,
        alreadySendCustomerNum: 0,
        alreadySendNum: 0,
        toBeSendCustomerNum: 0,
        toBeSendNum: 0,
        refreshTime: '',
      },
      activeName: '0',
      total1: 0,
      total0: 0,
      msgId: '',
      isTask: 0,
      status: 0,
    }
  },
  watch: {},
  computed: {},
  created() {
    this.isTask = this.$route.query.isTask
    this.status = this.$route.query.status
    this.msgId = this.$route.query.id
    this.queryMember.msgTemplateId = this.msgId
    this.queryCustomer.msgTemplateId = this.msgId
    this.getDetail()
    this.getMemberList()
    this.getCustomerList()
  },
  mounted() {},
  methods: {
    setFn() {
      this.$confirm('确定同步？', '提示', {
        confirmButtonText: '确认同步',
        cancelButtonText: '放弃',
        type: 'warning',
      })
        .then(
          () => {
            syncMsg(this.msgId).then((fdfd) => {
              this.getDetail()
              this.getMemberList()
              this.getCustomerList()
              this.$message({
                type: 'success',
                message: '同步成功!',
              })
            })
          },
          () => {
            this.$message({
              type: 'info',
              message: '已取消同步！',
            })
          },
        )
        .catch(() => {})
    },
    getMemberList(page) {
      page && (this.queryMember.pageNum = page)
      this.member.loading = true
      memberList(this.queryMember).then((res) => {
        this.member.loading = false
        this.member.total = Number(res.total)
        this.member.list = res.rows
      })
    },
    getCustomerList(page) {
      page && (this.queryCustomer.pageNum = page)
      this.customer.loading = true
      resultList(this.queryCustomer).then((res) => {
        this.customer.loading = false
        this.customer.total = Number(res.total)
        this.customer.list = res.rows
      })
    },
    getCustomerPage(e) {
      this.queryCustomer.pageNum = e.page
      this.getCustomerList()
    },
    getMemberPage(e) {
      this.queryMember.pageNum = e.page
      this.getMemberList()
    },
    getDetail() {
      getDetail(this.msgId).then((res) => {
        if (res.code == 200) {
          this.data = res.data
          this.form.welcomeMsg = res.data.content
          // this.form.materialMsgList = res.data.attachments
          // this.form.welcomeMsg = res.data.attachments ? res.data.attachments[0].content : '',
          this.form.materialMsgList = res.data.attachments || []
          // this.$forceUpdate()
        } else {
          this.msgError(res.msg || '获取失败')
        }
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  .operation {
    display: flex;
    align-items: flex-end;
    font-size: 12px;
    color: var(--font-black-6);
  }
}
.total_list {
  .item {
    height: 50px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    text-align: center;
  }
}
.label {
  width: 70px;
  display: inline-block;
  text-align: right;
}

.crumb {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-4);
  display: flex;
}

.crumb- {
  // 一级 页面标题
  &title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 90px; // line-height: 90px;
    font-size: 18px;
    font-weight: 500;
    color: var(--font-black);
    padding: 0 20px;
    background: var(--bg-white);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }
}
</style>
