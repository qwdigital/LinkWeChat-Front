<script>
  import * as api from '@/api/commodityCenter/commodityManage'
  export default {
    components: {},
    props: {},
    data() {
      return {
        query: {
          pageNum: 1,
          pageSize: 10,
          name: ''
        },
        loading: false,
        dialogVisible: false,
        total: 0,
        list: [],
        lastSyncTime: 0
      }
    },
    computed: {},
    created() {
      this.getList()
    },
    methods: {
      resetForm() {
        this.query.name = 1
        this.getList(1)
      },
      getList(page) {
        page && (this.query.pageNum = page)
        this.loading = true
        api
          .getList(this.query)
          .then(({ rows, total, lastSyncTime }) => {
            this.list = rows
            this.total = +total
            this.lastSyncTime = lastSyncTime
            this.loading = false
          })
          .catch(() => {
            this.loading = false
          })
      },

      sync() {
        const loading = this.$loading({
          lock: true,
          text: 'Loading',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        })
        api
          .sync()
          .then(() => {
            loading.close()
            this.msgSuccess('后台开始同步数据，请稍后关注进度')
            this.getList()
          })
          .catch(() => {
            loading.close()
          })
      },
      goRoute(row) {
        this.$router.push({
          path: './detail',
          query: {
            id: row.id
          }
        })
      }
    }
  }
</script>
<template>
  <div class="">
    <el-form ref="queryForm" :inline="true" :model="query" label-width="110px" class="top-search">
      <el-form-item label="商品名称或描述" prop="name">
        <el-input v-model="query.name" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label=" ">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button type="success" @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="mid-action">
      <el-button type="primary" class="mr10" @click="sync()">同步订单</el-button>
      <el-button :disabled="!ids.length" type="danger">导出Excel</el-button>
    </div>
    <el-table v-loading="loading" :data="list">
      <el-table-column label="商品" align="center" prop="" width="200">
        <div slot-scope="{ row }">
          <div style="display: flex;">
            <el-image
              style="width: 50px; height: 50px; margin-right: 3px; flex-shrink: 0;"
              :src="row.picture"
            ></el-image>
            <span class="limit_span">{{ row.describe }}</span>
          </div>
        </div>
      </el-table-column>
      <el-table-column label="单价(元)" align="center" prop="price" />
      <el-table-column label="订单总数" align="center" prop="orderNum" />
      <el-table-column label="订单总额(元)" align="center" prop="orderTotalAmount" />
      <el-table-column label="创建人" align="center" prop="createBy" />
      <el-table-column label="最近操作时间" align="center" prop="updateTime" width="180"> </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="{ row, index }">
          <!-- <el-button type="text" @click="goRoute(row)">详情</el-button>
          <el-button type="text" @click="edit(row, index)">编辑</el-button> -->
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
    <!-- 弹窗 -->
    <el-dialog
      :title="form.id ? '修改' : '新建'"
      :visible.sync="dialogVisible"
      width="800px"
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form ref="form" :model="form" :rules="rules" label-width="100px"> </el-form>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer ar">
        <el-button type="primary" v-loading="submitLoading" @click="submit">确 定</el-button>
        <el-button @click="dialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<style lang="scss" scoped>
  .tip {
    color: #aaa;
    font-size: 12px;
    line-height: 20px;
  }
  .phone-content {
    padding: 10px;
  }
  .price {
    font-weight: 500;
    font-size: 20px;
    margin: 10px 0;
  }
  .content {
    margin: 10px 0;
  }
  .commodity-img {
    width: 100%;
  }
  .limit_span {
    // width: 250px;
    // overflow: hidden;
    // text-overflow: ellipsis;
    // // white-space: nowrap;
    // display: inline-block;

    white-space: pre-wrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
</style>
