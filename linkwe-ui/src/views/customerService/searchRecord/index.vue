<template>
  <div class="g-card g-pad20">
    <el-form :inline="true" label-width="80px" label-position="left">
      <el-form-item label="所属客服" prop="">
        <el-select>
          <el-option value="" label="全部状态"></el-option>
          <el-option value="0" label="接待中"></el-option>
          <el-option value="0" label="停止接待"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="咨询场景" prop="">
        <el-select>
          <el-option value="" label="全部场景"></el-option>
          <el-option value="0" label="场景1"></el-option>
          <el-option value="0" label="场景2"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="是否企业客户" prop="" label-width="100px">
        <el-select>
          <el-option value="" label="全部"></el-option>
          <el-option value="0" label="是"></el-option>
          <el-option value="0" label="否"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="选择员工" prop="name">
        <el-input :value="search.name" readonly @focus="dialogVisible = true" placeholder="请选择员工" />
      </el-form-item>
      <el-form-item label-width="0">
        <!-- <el-button v-hasPermi="['wecom:code:list']" type="cyan" @click="getList(1)">查询</el-button> -->
        <el-button type="primary" @click="search()">查询</el-button>
        <el-button @click="resetQuery" type="info" plain>清空</el-button>
      </el-form-item>
    </el-form>
    <div class="operation">
      <div class="item">
      </div>
      <div class="item">
        <el-button type="primary" plain size="mini">导出Excel</el-button>
      </div>
    </div>
    <el-table v-loading="loading" :data="list" style="margin-top:20px;width: 100%">
      <el-table-column label="咨询客户" align="center" prop="" min-width="140">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.url' :name='row.test'></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="是否是企业客户" align="center" min-width="100" prop="name" show-overflow-tooltip />
      <el-table-column label="咨询场景" align="center" min-width="100" prop="name" show-overflow-tooltip />
      <el-table-column label="所属客服" align="center" min-width="160" prop="list">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.url' :name='row.test' showicon></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="接待方式" align="center" min-width="140" prop=""></el-table-column>
      <el-table-column label="接待员工" align="center" min-width="140" prop=""></el-table-column>
      <el-table-column label="接待客户数" align="center" min-width="140" prop=""></el-table-column>
      <el-table-column label="咨询开始时间" align="center" prop="updateTime" width="180"></el-table-column>
      <el-table-column label="咨询结束时间" align="center" prop="updateTime" width="180"></el-table-column>
      <el-table-column label="咨询时长" align="center" prop="updateTime" width="100"></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="230" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <el-button type="text">咨询记录</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination :total="total" :page.sync="search.pageNum" :limit.sync="search.pageSize" @pagination="getList()" />
    <SelectUser :visible.sync="dialogVisible" title="组织架构" :defaultValues="userArray" @success="getSelectUser"></SelectUser>
  </div>
</template>
<script>
  import SelectUser from '@/components/SelectUser'
  import ShowCustomerService from "../components/ShowCustomerSevice.vue"
  export default {
    name: 'search-record',
    components: {
      ShowCustomerService,
      SelectUser
    },
    data () {
      return {
        loading: false,
        list: [{ url: '123', test: '测试新建客服', name: 'DDD', list: ['姜鹏凯', '姜鹏凯', '姜鹏凯', '姜鹏凯'], list2: ['场景一', '场景23', '场景3'] }],
        search: {
          pageSize: 10,
          pageNum: 1,
          name: ''
        },
        total: 0,
        form: {},
        formRules: {},
        dialogVisible: false,
        userArray: []
      }
    },
    methods: {
      getSelectUser (data) {
        this.userArray = data
        this.search.name = this.userArray.map(function (obj, index) {
          return obj.name
        }).join(",")
      },
      search () {

      },
      resetQuery () {

      },
      getList () {

      },
      deleteFn (data) {
        this.$confirm('是否确定删除当前场景？该操作不可恢复，请谨慎操作', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            // return remove(ids)
          })
          .then(() => {
            // this.search()
            this.msgSuccess('删除成功')
          })
          .catch(function () { })
      }
    },
    created () {
      this.$store.dispatch(
        'app/setBusininessDesc',
        `
        <div>查看所有客服场景中客户咨询的详细记录</div>
      `
      )
    }
  }
</script>
<style lang="scss">
  .operation {
    margin-top: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .item {
      display: flex;
      .sub {
        font-size: 12px;
        color: #999;
        margin-left: 10px;
        align-self: flex-end;
      }
    }
  }
</style>
