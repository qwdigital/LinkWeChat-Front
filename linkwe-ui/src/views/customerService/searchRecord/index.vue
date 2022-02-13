<template>
  <div class="g-card g-pad20">
    <el-form :inline="true" label-width="80px" label-position="left">
      <el-form-item label="所属客服" prop="">
        <el-select v-model="search.openKfId">
          <el-option value="" label="全部客服"></el-option>
          <el-option v-for="(data, key) in customerList" :key="key" :value="data.openKfId" :label="data.name"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="咨询场景">
        <el-select v-model="search.scene">
          <el-option value="" label="全部场景"></el-option>
          <el-option v-for="(data, index) in sceneList" :key="index" :value="data.id" :label="data.name"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="是否企业客户" label-width="100px">
        <el-select v-model="search.isQyCustomer">
          <el-option value="" label="全部"></el-option>
          <el-option :value=0 label="是"></el-option>
          <el-option :value=1 label="否"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="选择员工" prop="name">
        <el-input :value="search.name" readonly @focus="dialogVisible = true" placeholder="请选择员工" />
      </el-form-item>
      <el-form-item label-width="0">
        <!-- <el-button v-hasPermi="['wecom:code:list']" type="cyan" @click="getList(1)">查询</el-button> -->
        <el-button type="primary" @click="searchFn()">查询</el-button>
        <el-button @click="resetQuery" type="info" plain>清空</el-button>
      </el-form-item>
    </el-form>
    <div class="operation">
      <div class="item">
      </div>
      <div class="item">
        <el-button type="primary" plain size="mini" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
    </div>
    <el-table v-loading="loading" :data="list" style="margin-top:20px;width: 100%">
      <el-table-column label="咨询客户" align="center" prop="" min-width="120">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.customerAvatar' :name='row.customerName'></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="是否企业客户" align="center" min-width="100" prop="isQyCustomer" show-overflow-tooltip>
        <template slot-scope="{ row }">
          {{row.isQyCustomer === 0 ? '是':'否'}}
        </template>
      </el-table-column>
      <el-table-column label="咨询场景" align="center" min-width="100" prop="sceneName" show-overflow-tooltip />
      <el-table-column label="所属客服" align="center" min-width="160" prop="list">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.kfAvatar' :name='row.kfName' showicon></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="接待方式" align="center" min-width="100" prop="receptionType">
        <template slot-scope="{ row }">
          {{row.receptionType === 1 ? '人工客服': '智能助手'}}
        </template>
      </el-table-column>
      <el-table-column label="接待员工" align="center" min-width="100" prop="userName">
        <template slot-scope="{ row }">
          {{row.receptionType === 1 ? userName: '-'}}
        </template>
      </el-table-column>
      <el-table-column label="咨询开始时间" align="center" prop="sessionStartTime" width="180"></el-table-column>
      <el-table-column label="咨询结束时间" align="center" prop="sessionEndTime" width="180"></el-table-column>
      <el-table-column label="咨询时长" align="center" prop="duration" width="140"></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="100" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <el-button type="text" @click="showResultList(row)">咨询记录</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination :total="total" :page.sync="search.pageNum" :limit.sync="search.pageSize" @pagination="getList()" />
    <SelectUser :visible.sync="dialogVisible" title="组织架构" :defaultValues="userArray" @success="getSelectUser"></SelectUser>
    <el-dialog title="咨询记录" :visible.sync="showPreviewDialog" width="50%">
      <div>
        <!-- <preview-client :list="previewData"></preview-client> -->
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="showPreviewDialog = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
  import SelectUser from '@/components/SelectUser'
  import ShowCustomerService from "../components/ShowCustomerSevice.vue"
  import { getResultList, getList, getSceneList, exportResult } from '@/api/drainageCode/customerService.js'
  import { download } from '@/utils/common'

  export default {
    name: 'search-record',
    components: {
      ShowCustomerService,
      SelectUser
    },
    data () {
      return {
        loading: false,
        exportLoading: false,
        list: [],
        search: {
          pageSize: 10,
          pageNum: 1,
          isQyCustomer: '', //0-是 1-否,
          openKfId: '',
          scene: '',
          userId: ''
        },
        total: 0,
        form: {},
        formRules: {},
        dialogVisible: false,
        userArray: [],
        customerList: [],
        sceneList: [],
        showPreviewDialog: false
      }
    },
    methods: {
      showResultList (data) {
        this.showPreviewDialog = true
      },
      exportFn () {
        this.$confirm('确认导出吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            this.exportLoading = true
            return exportResult({
              isQyCustomer: this.search.isQyCustomer,
              openKfId: this.search.openKfId,
              scene: this.search.scene,
              userId: this.search.userId
            })
          })
          .then((res) => {
            console.log(res)
            download(res.msg)
          })
          .catch((error) => {
            console.error(error)
          })
          .finally(() => {
            this.exportLoading = false
          })
      },
      getSelectUser (data) {
        this.userArray = data
        this.search.userId = this.userArray.map(function (obj, index) {
          return obj.userId
        }).join(",")
      },
      searchFn () {
        this.search.pageNum = 1
        this.getList()
      },
      resetQuery () {
        this.search = {
          pageSize: 10,
          pageNum: 1,
          isQyCustomer: '', //0-是 1-否,
          openKfId: '',
          scene: '',
          userId: ''
        }
        this.getList()
      },
      getList () {
        console.log(this.search)
        getResultList(this.search).then(res => {
          this.list = res.rows
          this.total = Number(res.total)
        })
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
    mounted () {
      this.getList()
      getList().then(res => {
        this.customerList = res.rows
      })
      getSceneList({ pageSize: 1000 }).then(dd => {
        this.sceneList = dd.rows
      })
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
