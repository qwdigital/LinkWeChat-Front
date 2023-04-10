<template>
  <div>
    <div class="g-card">
      <el-row type="flex" justify="space-between">
        <el-col :span="5" class="left pad20">
          <div class="title">
            <div class="title-name">角色列表</div>
            <div class="title-btn" @click="addFn">新建</div>
          </div>
          <div class="item-list">
            <div
              class="item"
              :class="{ active: activeIndex == key }"
              v-for="(role, key) in roles"
              :key="role.id"
              @click="switchRole(key, role)">
              <div class="name">
                {{ role.roleName }}
                <span style="margin-left: 10px">({{ role.userCount }})</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :span="19" class="pad20">
          <div class="title-name">
            {{ currentStatus === 'detail' ? '角色详情' : currentStatus === 'add' ? '新建角色' : '编辑角色' }}
          </div>
          <div v-if="currentStatus === 'detail'">
            <div style="margin-top: 20px">
              <el-form ref="codeForm" label-position="right" label-width="80px">
                <el-form-item label="角色员工">
                  <template v-for="(item, index) in roleObj.users">
                    <el-tag v-if="item.userName" size="medium" :key="index">{{ item.userName }}</el-tag>
                  </template>
                </el-form-item>
                <el-form-item label="管理范围">
                  <template v-if="roleObj.dataScope != 2">
                    {{ setName() }}
                  </template>

                  <template v-for="(item, index) in roleObj.depts">
                    <el-tag v-if="item.deptName" size="medium" :key="index">{{ item.deptName }}</el-tag>
                  </template>
                </el-form-item>
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
            <div class="bottom" v-if="roles[activeIndex]">
              <el-button plain type="danger">删除</el-button>
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
        </el-col>
      </el-row>
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
      activeIndex: 0,
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
      if (this.currentStatus === 'edit') {
        this.currentStatus = 'detail'
        getRolesList().then((res) => {
          this.roles = res.rows
        })
        this.getRoleDetailFn(this.roles[this.activeIndex].roleId)
      } else {
        this.currentStatus = 'detail'
        this.getList()
      }
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
    getList() {
      getRolesList().then((res) => {
        this.roles = res.rows
        if (this.roles && this.roles.length) {
          this.activeIndex = 0
          this.getRoleDetailFn(this.roles[0].roleId)
        }
      })
    },
    getRoleDetailFn(id) {
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
    switchRole(index, data) {
      if (this.currentStatus !== 'detail') {
        this.$confirm(`是否确认取消${this.currentStatus === 'add' ? '新建' : '编辑'}角色？取消后不可恢复。`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            this.currentStatus = 'detail'
            this.activeIndex = index
            this.getRoleDetailFn(data.roleId)
          })
          .catch(function () {})
      } else {
        this.activeIndex = index
        this.getRoleDetailFn(data.roleId)
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
  color: #333333;
  display: flex;
  align-items: center;
}
.bottom {
  display: flex;
  justify-content: flex-end;
  border-radius: 5px;
  padding: 20px;
  background-color: #f5f5f5;
}
.left {
  border-right: 1px solid #f1f1f1;
  .title {
    color: var(--color);
    display: flex;
    justify-content: space-between;
    align-items: center;
    // padding-right: 20px;

    .title-btn {
      cursor: pointer;
      display: flex;
      align-items: center;
      font-size: 14px;

      font-weight: 400;
      color: var(--color);

      &:hover {
        opacity: 0.7;
      }
    }
  }

  .item-list {
    max-height: 800px;
    padding-top: 20px;
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow-x: hidden;
    overflow-y: auto;

    .item {
      cursor: pointer;
      display: flex;
      // justify-content: space-between;
      align-items: center;
      font-size: 12px;
      color: #000;
      height: 40px;
      line-height: 40px;
      width: 100%;
      padding-left: 20px;
      border-radius: 5px;
      .name {
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
      }

      .dropdown {
        .dot {
          cursor: pointer;
          width: 14px;
          height: 14px;
          line-height: 14px;
          font-size: 14px;
          font-family: JMT-Font, JMT;
          font-weight: normal;
          color: var(--color);
          margin-right: 20px;
          margin-left: 5px;
        }
      }

      &:hover {
        color: var(--color);
        background: #f5f8fe;
        opacity: 0.8;
      }
    }

    .active {
      color: var(--color);
      background: #f5f8fe;
    }
  }
}
</style>
