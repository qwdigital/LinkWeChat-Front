<template>
  <div class="g-card g-pad20">
    <el-form :inline="true" label-width="80px" label-position="left">
      <el-form-item label="场景名称">
        <el-input placeholder="请输入场景名称" clearable @keyup.enter.native="search()" />
      </el-form-item>
      <el-form-item label="所属客服" prop="">
        <el-select>
          <el-option value="" label="全部"></el-option>
          <el-option value="0" label="客服1"></el-option>
          <el-option value="0" label="客服2"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="场景类型" prop="">
        <el-select>
          <el-option value="" label="全部场景"></el-option>
          <el-option value="0" label="接待中"></el-option>
          <el-option value="0" label="停止接待"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <!-- <el-button v-hasPermi="['wecom:code:list']" type="cyan" @click="getList(1)">查询</el-button> -->
        <el-button type="primary" @click="search()">查询</el-button>
        <el-button @click="resetQuery" type="info" plain>清空</el-button>
      </el-form-item>
    </el-form>
    <div class="operation">
      <div class="item">
        <el-button type="primary" size="mini" @click="addFn()">新建场景</el-button>
      </div>
      <div class="item">
        <el-button type="primary" plain size="mini">批量下载</el-button>
        <el-button type="primary" plain size="mini">批量删除</el-button>
      </div>
    </div>
    <el-table v-loading="loading" :data="list" style="margin-top:20px;width: 100%">
      <el-table-column label="场景名称" align="center" prop="" min-width="100"></el-table-column>
      <el-table-column label="场景分类" align="center" min-width="100" prop="name" show-overflow-tooltip />
      <el-table-column label="所属客服" align="center" min-width="160" prop="list">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.url' :name='row.test'></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="访问客户数" align="center" min-width="140" prop=""></el-table-column>
      <el-table-column label="咨询客户数" align="center" min-width="140" prop=""></el-table-column>
      <el-table-column label="接待客户数" align="center" min-width="140" prop=""></el-table-column>
      <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="230" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <el-button type="text">复制链接</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text">下载二维码</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="addFn(row)">编辑</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="deleteFn(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination :total="total" :page.sync="search.pageNum" :limit.sync="search.pageSize" @pagination="getList()" />
    <el-dialog :title="state + '场景'" :visible.sync="showDialog" width="500px">
      <div>
        <el-form ref="form" :rules="formRules" :model="form" label-position="right" label-width="100px">
          <el-form-item label="场景名称" prop="">
            <el-input placeholder="请输入场景名称" show-word-limit clearable maxlength="15" />
          </el-form-item>
          <el-form-item label="场景类型">
            <el-select>
              <el-option value="" label="全部状态"></el-option>
              <el-option value="0" label="接待中"></el-option>
              <el-option value="0" label="停止接待"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="选择客服" class="my-select">
            <el-select>
              <el-option style="height:50px;padding-top: 5px;" value="" label="全部状态">
                <div style="height: 40px;">
                  <show-customer-service url='12333' name='测试'></show-customer-service>
                </div>
              </el-option>
              <el-option style="height:50px;padding-top: 5px;" value="" label="全部状态">
                <div style="height: 40px;">
                  <show-customer-service url='12333' name='测试'></show-customer-service>
                </div>
              </el-option>
              <el-option style="height:50px;padding-top: 5px;" value="" label="全部状态">
                <div style="height: 40px;">
                  <show-customer-service url='12333' name='测试'></show-customer-service>
                </div>
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showDialog = false">取 消</el-button>
        <el-button type="primary" @click="showDialog = false">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
  import ShowCustomerService from "../components/ShowCustomerSevice.vue"
  export default {
    name: 'scene-manage',
    components: {
      ShowCustomerService
    },
    data () {
      return {
        loading: false,
        list: [{ url: '123', test: '测试新建客服', name: 'DDD', list: ['姜鹏凯', '姜鹏凯', '姜鹏凯', '姜鹏凯'], list2: ['场景一', '场景23', '场景3'] }],
        showDialog: false,
        search: {
          pageSize: 10,
          pageNum: 1,
        },
        total: 0,
        state: '新建',
        editData: {},
        form: {},
        formRules: {

        }
      }
    },
    methods: {
      search () {

      },
      resetQuery () {

      },
      addFn (data) {
        console.log(data)
        if (data) {
          this.editData = data
          this.state = '编辑'
        } else {
          this.state = '新建'
        }
        this.showDialog = true
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
        <div>可将客服链接或二维码可配置到公众号菜单、商城小程序等渠道场景，客服一键咨询</div>
      `
      )
    }
  }
</script>
<style lang="scss" >
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
