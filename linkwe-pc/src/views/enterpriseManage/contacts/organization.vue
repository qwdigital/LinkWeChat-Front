
<template>
  <div class="g-card g-pad20">
    <el-form class="top-search" :model="query" ref="queryForm" label-position="left" :inline="true" label-width="80px">
      <el-form-item label="员工姓名" prop="title">
        <el-input v-model="query.userName" placeholder="请输入" clearable />
      </el-form-item>
      <el-form-item label="角色">
        <el-select v-model="query.roleId">
          <el-option label="全部" value=""></el-option>
          <el-option v-for="(data, key) in roleList" :key="data.roleId" :label="data.roleName" :value="data.roleId"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label>
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button type="primary" @click="resetFn()">清空</el-button>
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="space-between" style="margin-top: 10px;">
      <!--部门数据-->
      <el-col :span="4">
        <div class="head-container">
          <!-- <div>部门架构</div> -->
          <!-- :filter-node-method="filterNode" -->
          <!-- default-expand-all -->
          <div class="title" style="margin-bottom: 20px;">
            <div class="title-name">
              组织列表
            </div>
            <div class="title-btn">
              <el-button type="primary" @click="syncOrganization">同步</el-button>
            </div>
          </div>
          <el-tree node-key="deptId" :default-expanded-keys="defaultShowNodes" highlight-current accordion class="left-tree" :data="treeData" :props="defaultProps" :expand-on-click-node="false" ref="tree" @node-click="handleNodeClick">
            <div class="custom-tree-node" slot-scope="{ node, data }">
              <span>
                <i class="el-icon-folder-opened" style="color: #0079de;" /> {{ node.label }}</span>
            </div>
          </el-tree>
        </div>
      </el-col>
      <!--用户数据-->
      <el-col :span="19">
        <el-table v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="员工姓名" align="center" prop="userName" :show-overflow-tooltip="true" />
          <el-table-column label="所属部门" align="center" prop="userDepts" width="150">
            <template slot-scope="{row}" v-if="row.userDepts">
              <show-tag :list="row.userDepts" keyStr="deptName" />
            </template>
          </el-table-column>
          <el-table-column label="职务" align="center" prop="position" />
          <el-table-column label="手机" align="center" prop="phoneNumber" />
          <el-table-column label="所属角色" align="center" prop="role" width="250">
            <template slot-scope="{row}" v-if="row.roles">
              <show-tag :list="row.roles" keyStr="roleName" />
            </template>
          </el-table-column>
          <el-table-column label="管理范围" align="center" prop="roleDepts" width="150">
            <template slot-scope="{row}" v-if="row.rolesDepts">
              <show-tag :list="row.rolesDepts" keyStr="roleName" />
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" fixed="right" width="100" class-name="small-padding fixed-width">
            <template slot-scope="{ row }">
              <!-- v-hasPermi="['contacts:organization:view']" -->
              <el-button type="text" @click="editRoles(row)" :disabled="setDisabled(row)">修改角色</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
      </el-col>
    </el-row>
    <el-dialog title="设置角色" :visible.sync="modalStatus" append-to-body width="400px">
      <el-form class="top-search" label-position="left" :inline="true" label-width="80px">
        <el-form-item label="角色">
          <el-select multiple v-model="editRolesList">
            <el-option v-for="(data, key) in roleList" :key="data.roleId" :label="data.roleName" v-if="data.roleKey !== 'SUPPER_ADMIN'" :value="data.roleId"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancelEdit">取 消</el-button>
        <el-button type="primary" @click="submitEdit">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
  import * as api from '@/api/organization'
  import ShowTag from '@/components/common/ShowTag.vue'
  export default {
    name: 'manage-center-organization',
    props: {},
    data () {
      return {
        query: {
          pageNum: 1,
          pageSize: 10,
          deptId: 1,
          roleId: '',
          userName: ''
        },
        loading: false,
        treeData: [],
        userList: [],
        total: 0,
        defaultProps: {
          label: 'deptName',
          children: 'children',
        },
        roleList: [],
        modalStatus: false,
        defaultShowNodes: [],
        editRolesList: [],
        editUser: {}
      }
    },
    components: {
      ShowTag
    },
    computed: {},
    created () {
      this.getTree()
      this.getRoleList()
    },
    mounted () { },
    methods: {
      resetFn () {
        this.query.userName = ''
        this.query.roleId = ''
        this.getList(1)
      },
      setDisabled (data) {
        let pass = false
        if (data.roles && data.roles.length) {
          data.roles.forEach(dd => {
            if (dd.roleName === '超级管理员') {
              pass = true
            }
          })
        }
        return pass
      },
      editRoles (data) {
        this.editUser = data
        if (data.roles) {
          this.editRolesList = data.roles.map((i) => {
            return i.roleId
          })
        }
        this.modalStatus = true
      },
      cancelEdit () {
        this.modalStatus = false
        this.editRolesList = []
      },
      submitEdit () {
        if (!this.editRolesList.length) {
          this.msgInfo('请至少选择一个角色！')
          return
        }
        this.$confirm('是否确认更改当前成员角色？确认后即时生效', '提示', {
          type: 'warning',
        })
          .then(() => {
            let params = {
              roleIds: this.editRolesList,
              userId: this.editUser.userId,
              userName: this.editUser.userName
            }
            return api.editUserRoles(params)
          })
          .then(() => {
            this.getList()
            this.modalStatus = false
            this.msgSuccess('操作成功！')
          })
      },
      syncOrganization () {
        api.setOragnize().then(res => {
          if (res.code === 200) {
            this.getTree()
          }
        })
      },
      getTree () {
        api.getDeptTree().then(({ data }) => {
          this.treeData = this.handleTree(data, "deptId")
          this.query.deptId = this.treeData[0].deptId
          this.getList()
          this.$nextTick(() => {
            this.$refs.tree.setCurrentKey(this.query.deptId)
          })
          this.defaultShowNodes.push(this.query.deptId)
        })
      },
      getList (page) {
        page && (this.query.pageNum = page)
        this.loading = true
        api.getDeptUser(this.query)
          .then(({ rows, total }) => {
            this.userList = rows
            this.total = +total
            this.loading = false
          })
          .catch(() => {
            this.loading = false
          })
      },
      handleNodeClick (data) {
        this.query.deptId = data.deptId
        this.getList(1)
      },
      handleSelectionChange (val) {
        this.multipleSelection = val
      },
      departRemove (id) {
        this.$confirm('是否确认删除吗?', '警告', {
          type: 'warning',
        })
          .then(function () {
            return api.removeDepart(id)
          })
          .then(() => {
            this.getTree()
            this.msgSuccess('删除成功')
          })
      },
      getRoleList () {
        api.getRoleOption().then(res => {
          this.roleList = res.data
        })
      }
    },
  }
</script>

<style lang="scss" scoped>
  .el-tree {
    overflow: auto;
  }
  ::v-deep {
    .el-tree-node {
      min-width: 100%!important;
      display:block!important;
      float: left;
    }
  }
  .title-name {
    font-size: 14px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 600;
    color: #333333;
    display: flex;
    align-items: center;
  }
  .title {
    color: #3c88f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    // padding-right: 20px;

    .title-btn {
      cursor: pointer;
      display: flex;
      align-items: center;
      font-size: 14px;
      font-family: PingFangSC-Regular, PingFang SC;
      font-weight: 400;
      color: #3c88f0;

      &:hover {
        opacity: 0.7;
      }
    }
  }
  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 14px;
    padding-right: 8px;
  }
  .avatar-wrap {
    height: 200px;
    border: 1px solid #eee;
    border-radius: 5px;
    position: relative;
    overflow: hidden;
  }
  .avatar {
    height: 100%;
  }
  .avatar-uploader-icon {
    font-size: 58px;
    color: #ddd;
  }
  .img-wrap {
    height: 340px;
    overflow: auto;
    ::v-deep.el-radio__input {
      position: absolute;
      right: 0;
    }
  }
  .img-li {
    width: 115px;
    height: 160px;
  }
</style>
