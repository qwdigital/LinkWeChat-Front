<template>
  <div class="g-card g-pad20">
    <div class="operation">
      <div class="item">
        <el-button type="primary" size="mini" :disabled="list.length === 10" @click="addFn()">新建客服</el-button>
        <span class="sub" v-if="list.length < 11">还可以添加{{10 -list.length}}个客服</span>
      </div>
      <div class="item">

        <el-button type="primary" size="mini" v-loading="asyncLoading" @click="setAsyncFn">同步客服</el-button>
        <el-button type="primary" plain size="mini" @click="showDialog = true">升级服务</el-button>
      </div>
    </div>
    <el-table v-loading="tableLoading" :data="list" style="margin-top:20px;width: 100%">
      <el-table-column label="客服" align="center" prop="" min-width="120">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.avatar' :name='row.name' showicon></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="接待方式" align="center" min-width="100" prop="name" show-overflow-tooltip>
        <template slot-scope="{ row }">
          <div>{{row.receptionType === 1 ? '人工客服': row.receptionType === 2 ?'智能助手':''}}</div>
        </template>
      </el-table-column>
      <el-table-column label="接待员工" align="center" min-width="140" prop="userIdList">
        <template slot-scope="{ row }" v-if="row.userIdList">
          <template v-if="row.userIdList.length < 2">
            <el-tag v-for="(data, key) in row.userIdList" :key="key" size="mini">{{data.userName}}</el-tag>
          </template>
          <template v-else>
            <template v-for="(data, key) in row.userIdList">
              <el-tag v-if="key < 2 && data" :key="key" size="mini">{{data.userName}}</el-tag>
            </template>
            <el-tag style="cursor:pointer;" size="mini" @click="moreMemberFn(row)">等{{row.userIdList.length}}人</el-tag>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="接待场景" align="center" min-width="140" prop="list2">
        <template slot-scope="{ row }" v-if="row.scenesList">
          <template v-if="row.scenesList.length < 2">
            <el-tag style="cursor:pointer;" v-for="(data, key) in row.scenesList" @click="gotoScene(row)" :key="key" size="mini">{{data.scenesName}}</el-tag>
          </template>
          <template v-else>
            <template v-for="(data, key) in row.scenesList">
              <el-tag style="cursor:pointer;" v-if="key < 2 && data" :key="key" size="mini" @click="gotoScene(row)">{{data.scenesName}}</el-tag>
            </template>
            <el-tag style="cursor:pointer;" size="mini" @click="gotoScene(row)">等{{row.scenesList.length}}个</el-tag>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180">
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="180" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <el-button type="text" @click="gotoDetail(row.id)">详情</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="addFn(row.id)">编辑</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="deleteFn(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog title="升级服务" :visible.sync="showDialog">
      <p>请前往企业微信后台->应用管理->微信客服详情页面，点击升级服务中的配置按钮，将专员服务及客户群服务根据需求配置好即可。</p>
      <p style="margin: 20px 0;">企业配置后，接待人员可发送添加服务专员或加入客户群的邀请给客户，让客户享受更好的服务。</p>
      <img src="@/assets/drainageCode/service.png" fit="fit" style="width:100%;height:100%;"></img>
      <div slot="footer" class="dialog-footer">
        <!-- <el-button @click="showDialog = false">取 消</el-button> -->
        <el-button type="primary" @click="showDialog = false">我知道了</el-button>
      </div>
    </el-dialog>
    <el-dialog title="接待员工" :visible.sync="showMemberDialog" width="600px">
      <el-form label-position="right" label-width="100px">
        <el-form-item label="接待状态">
          <el-select v-model="memberPage.status" @change="changeList()">
            <el-option value="" label="全部状态"></el-option>
            <el-option :value="0" label="接待中"></el-option>
            <el-option :value="1" label="停止接待"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div style="max-height: 400px;overflow-y:auto;">
        <el-table v-loading="loading" :data="memberList" style="margin-top:20px;width: 100%">
          <el-table-column label="员工" align="center" prop="userName" show-overflow-tooltip />
          <el-table-column label="所属部门" align="center" prop="deptName" show-overflow-tooltip />
          <el-table-column label="接待状态" align="center" prop="status" width="120px;">
            <template slot-scope="{ row }">
              {{row.status === 0 ? '接待中': '停止接待'}}
            </template>
          </el-table-column>
        </el-table>
      </div>
      <pagination :total="memberPage.total" :page.sync="memberPage.pageNum" :limit.sync="memberPage.pageSize" @pagination="getMemberList()" />
      <div slot="footer" class="dialog-footer">
        <el-button @click="showMemberDialog = false">取 消</el-button>
        <el-button type="primary" @click="showMemberDialog = false">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
  import ShowCustomerService from "../components/ShowCustomerSevice.vue"
  import pic from '@/assets/drainageCode/service.png'
  import { getList, remove, setAsync, getMemeberInCustomer } from '@/api/drainageCode/customerService.js'
  export default {
    name: 'customer-service-manage',
    components: {
      ShowCustomerService
    },
    data () {
      return {
        asyncLoading: false,
        loading: false,
        tableLoading: false,
        list: [],
        memberList: [],
        showDialog: false,
        showMemberDialog: false,
        memberPage: {
          pageSize: 10,
          pageNum: 1,
          total: 0,
          status: '',
          openKfId: '',
          kfId: ''
        }
      }
    },
    methods: {
      setAsyncFn () {
        this.asyncLoading = true
        setAsync().then(res => {
          this.asyncLoading = false
          this.getData()
        })
      },
      gotoDetail (data) {
        this.$router.push({
          path: '/drainageCode/customerService/detail',
          query: {
            id: data
          }
        })
      },
      addFn (data) {
        if (data) {
          this.$router.push({
            path: '/drainageCode/customerService/add',
            query: {
              id: data
            }
          })
        } else {
          this.$router.push({
            path: '/drainageCode/customerService/add',
          })
        }
      },
      getData () {
        this.tableLoading = true
        getList().then(res => {
            this.list = res.rows
            this.tableLoading = false
          })
      },
      changeList () {
        this.memberPage.pageNum = 1
        this.getMemberList()
      },
      moreMemberFn (data) {
        this.memberPage.openKfId = data.openKfId
        this.memberPage.kfId = data.kfId
        this.showMemberDialog = true
        this.getMemberList()
      },
      getMemberList () {
        this.loading = true
        getMemeberInCustomer(this.memberPage).then(res => {
          this.loading = false
          this.memberList = res.rows
          this.memberPage.total = Number(res.total)
        })
      },
      gotoScene (data) {
        this.$router.push({
          path: '/drainageCode/customerService/sceneManage',
          query: {
            openKfId: data.openKfId
          }
        })
      },
      deleteFn (data) {
        if (data.scenesList && data.scenesList.length) {
          this.$confirm('请删除当前客服下所有关联场景后，再删除当前客服。', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          })
            .then(() => {
            })
            .then(() => {
            })
            .catch(function () { })
        } else {
          this.$confirm('是否确定删除当前客服？该操作不可恢复，请谨慎操作', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            return remove(data.id)
          }).then(() => {
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
            this.getData()
          }).catch((res) => {
          })
        }
      }
    },
    created () {
      this.getData()
      this.$store.dispatch(
        'app/setBusininessDesc',
        `
        <div>微信客服支持企业在微信内、外各个场景中接入，由用户发起咨询，企业进行回复</div>
      `
      )
    }
  }
</script>
<style lang="scss" scoped>
  .operation {
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
