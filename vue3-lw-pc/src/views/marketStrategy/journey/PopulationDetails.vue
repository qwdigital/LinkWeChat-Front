<template>
  <div>
    <el-table
      ref="table"
      :data="list"
      tooltip-effect="dark"
      highlight-current-row
      v-loading="loading"
    >
      <el-table-column
        label="客户"
        prop="customerName"
        header-align="center"
        align=""
        width="180"
      >
        <template slot-scope="{ row }">
          <div class="cp flex aic" @click="goRoute(row)">
            <el-image
              style="width: 50px; height: 50px; flex: none"
              :src="row.avatar"
              fit="fit"
            ></el-image>
            <div class="ml10">
              <p>{{ row.customerName }}</p>
              <i
                :class="[
                  'el-icon-s-custom',
                  { 1: 'man', 2: 'woman' }[row.gender],
                ]"
              ></i>
              <span
                :style="{
                  color: row.customerType === 1 ? '#4bde03' : '#f9a90b',
                }"
              >
                {{ { 1: "@微信", 2: "@企业微信" }[row.customerType] }}
              </span>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="tagNames"
        label="客户标签"
        align="center"
        width="220"
      >
        <div v-if="row.tagNames" slot-scope="{ row }">
          <TagEllipsis :list="row.tagNames"></TagEllipsis>
        </div>
        <span v-else>无标签</span>
      </el-table-column>
      <!-- <el-table-column prop="corpName" label="公司名称" align="center"></el-table-column> -->
      <el-table-column prop="userName" label="跟进员工" align="center">
        <!-- <template slot-scope="{ row }">{{
          row.weFlowerCustomerRels[0] ? row.weFlowerCustomerRels[0].userName : ''
        }}</template> -->
      </el-table-column>
      <el-table-column prop="trackState" label="跟进状态" align="center">
        <template slot-scope="{ row }">
          <el-tag
            v-if="row.trackState"
            :type="dictTrackState[~~row.trackState + ''].color"
            >{{ dictTrackState[~~row.trackState + ""].name }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="addMethod" label="添加方式" align="center">
        <template slot-scope="{ row }">{{
          dictAddType[row.addMethod + ""]
        }}</template>
      </el-table-column>
      <el-table-column prop="firstAddTime" label="添加时间" align="center">
      </el-table-column>

      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="{ row }">
          <!-- v-hasPermi="['customerManage:customer:view']" -->
          <el-button @click="goRoute(row)" type="text" size="small"
            >查看</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()"
    />
  </div>
</template>

<script>
// import * as api from "@/api/customer";
import { popDetails } from "@/api/marketStrategy/journey.js";
import { dictAddType, dictTrackState } from "@/utils/dictionary";
export default {
  props: ["perdetail"],
  data() {
    return {
      dictTrackState,
      dictAddType,
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      list: [], // 客户列表
      total: 0,
      loading: false,
      dateRange: [], // 查询日期
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList(page) {
      // console.log(this.dateRange);
      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0];
        this.query.endTime = this.dateRange[1];
      } else {
        this.query.beginTime = "";
        this.query.endTime = "";
      }
      page && (this.query.pageNum = page);
      //   this.query.tagIds = this.queryTag.map((d) => d.tagId) + "";
      //   this.query.userIds = this.queryUser.map((d) => d.userId) + "";
      this.loading = true;
        popDetails(this.perdetail)
        .then(({ rows, total }) => {
          rows.forEach((element) => {
            if (element.tagIds && element.tagNames) {
              element.tagIds = element.tagIds.split(",");
              element.tagNames = element.tagNames.split(",");
              element.tags = [];
              element.tagIds.forEach((unit, index) => {
                element.tags.push({
                  tagId: unit,
                  tagName: element.tagNames[index],
                });
              });
            }
          });
          this.list = rows;
          this.total = +total;
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    goRoute(row) {
      let { externalUserid, firstUserId: id } = row;
      this.$router.push({
        name: "CustomerDetail",
        query: { externalUserid, id },
      });
    },
  },
};
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
}</style>
