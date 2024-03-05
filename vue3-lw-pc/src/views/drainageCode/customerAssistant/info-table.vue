<template>
  <div class="g-card">
    <search-title @search="getData">
      <template v-slot>
        <el-input :model-value="userNames" readonly @click="dialogVisible = true" placeholder="请选择添加员工" />
      </template>
    </search-title>
    <div class="mt20">
      <el-table ref="table" :data="list" tooltip-effect="dark" highlight-current-row>
        <!-- -->
        <el-table-column label="客户" prop="customerName" header-align="center" align="" width="180">
          <template #default="{ row }">
            <div class="cp flex aic" @click="goRoute(row)">
              <el-image class="avatar" :src="row.avatar" fit="fill"></el-image>
              <div class="ml10">
                <p class="blod">{{ row.customerName }}</p>
                <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[row.gender]]" />
                <span :style="{ color: row.customerType === 1 ? '#4bde03' : '#f9a90b' }">
                  {{ { 1: '@微信', 2: '@企业微信' }[row.customerType] }}
                </span>
              </div>
            </div>
          </template>
        </el-table-column>
        <!-- <el-table-column prop="tagNames" label="客户标签" align="center" width="220">
          <template #default="{ row }">
            <div v-if="row.tagNames">
              <TagEllipsis :list="row.tagNames"></TagEllipsis>
            </div>
            <span v-else>无标签</span>
          </template>
        </el-table-column> -->
        <el-table-column prop="userName" label="跟进员工" align="center"></el-table-column>

        <el-table-column prop="addTime" label="添加时间" align="center"></el-table-column>

        <el-table-column label="操作" width="200" align="center">
          <template #default="{ row }">
            <el-button @click="goRoute(row)" text>查看</el-button>
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
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
  </div>
</template>
<script>
import SearchTitle from '@/components/SearchTitle.vue'
import { getCustomerInLink } from './api'
export default {
  data() {
    return {
      query: {
        pageSize: 10,
        pageNum: 1,
        weUserId: '',
        linkId: '',
      },
      total: 0,
      userNames: '',
      dialogVisible: false,
      userArray: [],
      list: [],
      tableSearch: {},
    }
  },
  components: {
    SearchTitle,
  },
  created() {
    this.query.linkId = this.$route.query.linkId
  },
  methods: {
    getData(data) {
      this.tableSearch = data
      this.query.linkId = this.$route.query.linkId
      getCustomerInLink(Object.assign({}, this.query, data)).then((res) => {
        this.list = res.rows
        this.total = res.total
      })
    },
    goRoute(row) {
      let { externalUserid, firstUserId: userId } = row
      this.$router.push({
        name: window.lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
        query: { externalUserid, userId },
      })
    },
    getSelectUser(data) {
      this.userArray = data
      this.userNames = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.weUserId = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
      this.query.pageNum = 1
      getCustomerInLink(Object.assign({}, this.query, this.tableSearch)).then((res) => {
        this.list = res.rows
        this.total = res.total
      })
    },
  },
  created() {},
}
</script>
<style lang="scss" scoped>
.avatar {
  width: 56px;
  height: 56px;
  flex: none;
  border-radius: var(--border-radius-big);
}
.el-icon-Avatar {
  font-size: 16px;
  // margin-left: 4px;
  color: var(--font-black-6);
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
</style>
