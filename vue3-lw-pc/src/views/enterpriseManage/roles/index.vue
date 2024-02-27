<template>
  <div class="g-left-right">
    <div class="left g-card">
      <div class="title">
        <div class="title-name">角色列表</div>
        <div class="title-btn" @click="addFn">新建</div>
      </div>
      <div class="mt20">
        <el-input v-model="keywords" @keyup.enter="getList" placeholder="请输入角色名称" clearable @change="getList">
          <template #append><el-button icon="el-icon-search" @click="getList"></el-button></template>
        </el-input>
      </div>
      <div class="item-list" v-loading="loading">
        <template v-if="roles?.length">
          <div
            class="item"
            :class="{ active: activeId == item.roleId }"
            v-for="(item, index) in roles"
            :key="index"
            @click="switchRole(item)">
            <div class="name">
              {{ item.roleName }}
              <span style="margin-left: 10px">({{ item.userCount }})</span>
            </div>
          </div>
        </template>
        <Empty v-else description="暂无相关数据" />
      </div>
    </div>
    <div class="right g-card mt0">
      <div class="title-name">
        {{
          currentStatus === 'detail'
            ? `角色详情 -- ${roleObj.roleName}`
            : currentStatus === 'add'
            ? '新建角色'
            : '编辑角色'
        }}
      </div>
      <div v-if="currentStatus === 'detail'">
        <div style="margin-top: 20px">
          <el-form ref="codeForm" label-position="right" label-width="80px">
            <el-form-item label="角色员工">
              <template v-for="(item, index) in roleObj.users" :key="index">
                <el-tag v-if="item.userName">{{ item.userName }}</el-tag>
              </template>
            </el-form-item>
            <!-- <el-form-item label="管理范围">
              <template v-if="roleObj.dataScope != 2">
                {{ setName() }}
              </template>

              <template v-for="(item, index) in roleObj.depts" :key="index">
                <el-tag v-if="item.deptName" >{{ item.deptName }}</el-tag>
              </template>
            </el-form-item> -->
            <el-form-item label="功能权限">
              <el-tree
                :data="menuOptions"
                show-checkbox
                ref="menu"
                node-key="id"
                disabled
                empty-text="加载中，请稍后"
                :props="defaultProps"></el-tree>
            </el-form-item>
          </el-form>
        </div>
        <div class="g-footer-sticky bottom">
          <el-button plain type="danger" @click="deleteFn">删除</el-button>
          <el-button type="primary" @click="edtiFn">编辑</el-button>
        </div>
      </div>
      <div v-else-if="currentStatus === 'add'">
        <add-or-edit key="1" :status="currentStatus" @update="updateFn" @cancel="cancel" :list="menuOptions" />
      </div>
      <div v-else>
        <add-or-edit
          key="2"
          :status="currentStatus"
          :data="roleObj"
          @update="updateFn"
          @cancel="cancel"
          :list="menuOptions" />
      </div>
    </div>
  </div>
</template>
<script>
import { getRolesList, getRoleDetail, treeselect, deleteRole } from '@/api/organization'
import AddOrEdit from './add.vue'
export default {
  name: 'manage-center-roles',
  data() {
    return {
      roles: [],
      activeId: undefined,
      roleObj: {
        users: [],
      },
      currentStatus: 'detail',
      defaultProps: {
        children: 'children',
        label: 'label',
        disabled: this.isDisabled,
      },
      menuOptions: [],
      dataScopeOptions: [
        {
          value: '1',
          label: '全部数据权限',
        },
        {
          value: '2',
          label: '自定数据权限',
        },
        {
          value: '3',
          label: '本部门数据权限',
        },
        {
          value: '4',
          label: '本部门及以下数据权限',
        },
        {
          value: '5',
          label: '仅本人数据权限',
        },
      ],
      keywords: '',
      loading: false,
    }
  },
  components: {
    AddOrEdit,
  },
  created() {
    this.getList()
    this.getMenuTreeselect()
  },
  methods: {
    isDisabled() {
      return true
    },
    setName() {
      let str = ''
      this.dataScopeOptions.map((data) => {
        if (data.value == this.roleObj.dataScope) {
          str = data.label
        }
      })
      return str
    },
    updateFn() {
      this.getList(this.currentStatus === 'edit')
      this.currentStatus = 'detail'
    },
    cancel() {
      this.$confirm(`是否确认取消${this.currentStatus === 'add' ? '新建' : '编辑'}角色？取消后不可恢复。`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.currentStatus = 'detail'
          this.getRoleDetailFn(this.roleObj.roleId)
        })
        .catch(function () {})
    },
    getList(isGetDetail) {
      this.loading = true
      getRolesList(this.keywords)
        .then(({ rows }) => {
          this.roles = rows
          if (this.activeId == undefined && this.roles?.length) {
            this.activeId = rows[0].roleId
            isGetDetail = true
          }
          isGetDetail === true && this.getRoleDetailFn(this.activeId)
        })
        .finally(() => {
          this.loading = false
        })
    },
    getRoleDetailFn(id) {
      id &&
        getRoleDetail(id).then((res) => {
          this.roleObj = res.data
          if (this.roleObj.menus) {
            let arr = this.roleObj.menus.map((data) => {
              return data.menuId
            })
            this.$refs.menu.setCheckedKeys(arr)
          }
        })
    },
    addFn() {
      if (this.currentStatus !== 'detail') {
        this.$confirm(`是否确认取消${this.currentStatus === 'add' ? '新建' : '编辑'}角色？取消后不可恢复。`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            this.currentStatus = 'add'
          })
          .catch(function () {})
      } else {
        this.currentStatus = 'add'
      }
    },
    switchRole(data) {
      if (this.currentStatus !== 'detail') {
        this.$confirm(`是否确认取消${this.currentStatus === 'add' ? '新建' : '编辑'}角色？取消后不可恢复。`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            this.currentStatus = 'detail'
            this.getRoleDetailFn((this.activeId = data.roleId))
          })
          .catch(function () {})
      } else {
        this.getRoleDetailFn((this.activeId = data.roleId))
      }
    },
    edtiFn() {
      this.currentStatus = 'edit'
    },
    deleteFn() {
      this.$confirm('是否确认删除角色？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          deleteRole(this.roleObj.roleId).then((res) => {
            this.activeId = undefined
            this.getList()
          })
        })
        .catch(function () {})
    },
    /** 查询菜单树结构 */
    getMenuTreeselect() {
      treeselect().then((response) => {
        this.menuOptions = response.data
      })
    },
  },
}
</script>
<style lang="scss" scoped>
.title-name {
  font-size: 14px;

  font-weight: 600;
  color: var(--font-black);
  display: flex;
  align-items: center;
}
.bottom {
  justify-content: flex-end;
  padding: 20px;
}
</style>
