<template>
  <div class="g-card">
    <el-table ref="table" :data="list" tooltip-effect="dark" highlight-current-row>
      <el-table-column label="客户" prop="customerName" header-align="center" align="" width="180">
        <template slot-scope="{ row }">
          <div class="cp flex aic" @click="goRoute(row)">
            <el-image style="width: 50px; height: 50px; flex: none" :src="row.avatar" fit="fit"></el-image>
            <div class="ml10">
              <p>{{ row.customerName }}</p>
              <i :class="['el-icon-s-custom', { 1: 'man', 2: 'woman' }[row.gender]]"></i>
              <span :style="{ color: row.customerType === 1 ? '#4bde03' : '#f9a90b' }">
                {{ { 1: '@微信', 2: '@企业微信' }[row.customerType] }}
              </span>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="tagNames" label="客户标签" align="center" width="220">
        <div v-if="row.tagNames" slot-scope="{ row }">
          <TagEllipsis :list="row.tagNames.split(',')"></TagEllipsis>
        </div>
        <span v-else>无标签</span>
      </el-table-column>
      <el-table-column prop="userName" label="跟进员工" align="center"></el-table-column>
      <el-table-column prop="trackState" label="跟进状态" align="center">
        <template slot-scope="{ row }">
          <el-tag v-if="row.trackState" :type="dictTrackState[~~row.trackState + ''].color">
            {{ dictTrackState[~~row.trackState + ''].name }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="addMethod" label="添加方式" align="center">
        <template slot-scope="{ row }">{{ dictAddType[row.addMethod + ''] }}</template>
      </el-table-column>
      <el-table-column prop="firstAddTime" label="添加时间" align="center"></el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="{ row }">
          <el-button @click="goRoute(row)" type="text" size="small">查看</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getData()" />
  </div>
</template>

<script>
import { dictAddType, dictTrackState } from '@/utils/dictionary'
import { customerInCrowd } from '@/api/marketStrategy/people'

export default {
  name: 'people-customer-detail',
  data() {
    return {
      list: [],
      total: 0,
      query: {
        pageNum: 1,
        pageSize: 10,
        id: '',
      },
      dictCustomerType: Object.freeze({ 1: '微信客户', 2: '企业客户' }),
      dictAddType,
      dictTrackState,
    }
  },
  methods: {
    goRoute(row) {
      let { externalUserid, firstUserId: userId } = row
      this.$router.push({
        path: '/operateCenter/customerManage/customerDetail',
        query: { externalUserid, userId },
      })
    },
    getData() {
      customerInCrowd(this.query).then((res) => {
        if (res.code === 200) {
          this.list = res.rows
          this.total = Number(res.total)
        }
      })
    },
  },
  created() {
    this.query.id = this.$route.query.id
    if (this.query.id) {
      this.getData()
    }
  },
}
</script>
<style lang="scss" scoped>
.el-icon-s-custom {
  font-size: 16px;
  // margin-left: 4px;
  color: #999;
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
</style>
