<template>
  <div>
    <div style="margin-top: 20px">
      <el-form ref="form" label-position="right" label-width="80px">
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="form.roleName" maxlength="10" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item label="角色顺序" prop="roleSort">
          <el-input-number v-model="form.roleSort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="角色员工" prop="users">
          <template v-for="(item, index) in selectedUserList" :key="index">
            <el-tag v-if="item.name">{{ item.name }}</el-tag>
          </template>
          <div>
            <el-button type="primary" icon="el-icon-plus" @click="onSelectUser">
              {{ form.users.length == 0 ? '添加' : '编辑' }}
            </el-button>
          </div>
        </el-form-item>
        <!-- <el-form-item label="管理范围" prop="dataScope">
          <el-select v-model="form.dataScope">
            <el-option
              v-for="item in dataScopeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"></el-option>
          </el-select>
          <div v-show="form.dataScope == 2">
            <template v-for="(item, index) in selectedDeptList" :key="index">
              <el-tag v-if="item.deptName" >{{ item.deptName }}</el-tag>
            </template>
            <div>
              <el-button  type="primary" icon="el-icon-plus" @click="onSelectDept">
                {{ selectedDeptList.length == 0 ? '添加' : '编辑' }}
              </el-button>
            </div>
          </div>
        </el-form-item> -->
        <el-form-item label="功能权限">
          <el-tree
            :data="list"
            show-checkbox
            ref="menu"
            node-key="id"
            empty-text="加载中，请稍后"
            :props="defaultProps"></el-tree>
        </el-form-item>
      </el-form>
    </div>
    <div class="bottom">
      <el-button plain @click="cancelFn">取消</el-button>
      <el-button type="primary" @click="submitFn">确定</el-button>
    </div>
    <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      @success="selectedUser"></SelectUser>
    <SelectDept
      :defaultValues="selectedDeptList"
      v-model:visible="dialogVisibleSelectDept"
      title="选择部门"
      :isOnlyLeaf="false"
      @success="selectedDept"></SelectDept>
  </div>
</template>
<script>
import SelectDept from '@/components/SelectDept'
import { addRole, editRole } from '@/api/organization'
export default {
  name: 'roles-add-edit',
  components: {
    SelectDept,
  },
  data() {
    return {
      form: {
        dataScope: '1',
        users: [],
        menuIds: [],
        depts: [],
        roleName: '',
        roleSort: 12,
        roleSort: 0,
        status: '0',
      },
      dialogVisibleSelectUser: false,
      dialogVisibleSelectDept: false,
      defaultProps: {
        children: 'children',
        label: 'label',
      },
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
      rules: {
        roleName: [{ required: true, message: '角色名称不能为空', trigger: 'blur' }],
        roleSort: [{ required: true, message: '角色顺序不能为空', trigger: 'blur' }],
      },
      selectedUserList: [],
      selectedDeptList: [],
    }
  },
  props: {
    list: {
      type: Array,
      default: () => [],
    },
    status: {
      type: String,
      default: '',
    },
    data: {
      type: Object,
      defaultL: () => {},
    },
  },
  mounted() {
    if (this.status === 'edit') {
      this.setData()
    }
  },
  created() {
    this.setDisabledTreeData(this.list)
  },
  methods: {
    setDisabledTreeData(data) {
      data.map((item) => {
        if (item.labelKey == 'roles') {
          item['disabled'] = true
        }
        let isFatherNode = item.children && item.children.length > 0
        isFatherNode && this.setDisabledTreeData(item.children)
        // let isHadDisabledChild = isFatherNode && item.children.some((it) => it.disabled && it.disabled == val);
        // if (isHadDisabledChild) item["disabled"] = val;
      })
    },
    setData() {
      this.form = this.data
      if (this.form.users && this.form.users.length) {
        let arr = []
        this.selectedUserList = this.form.users.map((i) => {
          arr.push(i.userId)
          return {
            name: i.userName,
            userId: i.weUserId,
            userIdOrigin: i.userId,
          }
        })
        this.form.users = arr
      }
      if (this.form.depts && this.form.depts.length) {
        let arr2 = []
        this.selectedDeptList = this.form.depts.map((i) => {
          arr2.push(i.deptId)
          return {
            deptName: i.deptName,
            deptId: i.deptId,
          }
        })
        this.form.deptIds = arr2
        delete this.form.depts
      }
      if (this.form.menus && this.form.menus.length) {
        let arr = this.form.menus.map((i) => {
          return i.menuId
        })
        if (this.$refs.menu) {
          this.$refs.menu.setCheckedKeys(arr)
        }
      }
    },
    onSelectDept() {
      this.dialogVisibleSelectDept = true
    },
    onSelectUser() {
      this.dialogVisibleSelectUser = true
    },
    selectedUser(users) {
      this.selectedUserList = users
      let arr = users.map((i) => {
        return i.userIdOrigin
      })
      this.form.users = arr
    },
    selectedDept(depts) {
      this.selectedDeptList = depts
      if (depts && depts.length) {
        let arr = depts.map((i) => {
          return i.deptId
        })
        this.form.deptIds = arr
      }
    },
    // 所有菜单节点数据
    getMenuAllCheckedKeys() {
      let checkedKeys = this.$refs.menu.getHalfCheckedKeys()
      let halfCheckedKeys = this.$refs.menu.getCheckedKeys()
      checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys)
      return checkedKeys
    },
    submitFn() {
      if (this.status === 'add') {
        this.form.menuIds = this.getMenuAllCheckedKeys()
        this.form.roleKey = '11'
        addRole(this.form).then((res) => {
          this.$emit('update')
        })
      } else {
        this.$confirm('是否确认修改当前角色？修改后即时生效。', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        })
          .then(() => {
            this.form.menuIds = this.getMenuAllCheckedKeys()
            delete this.form.menus
            editRole(this.form).then((res) => {
              this.$emit('update')
            })
          })
          .catch(function () {})
      }
    },
    cancelFn() {
      this.$emit('cancel')
    },
  },
}
</script>
<style lang="scss" scoped>
.bottom {
  display: flex;
  justify-content: flex-end;
  border-radius: 5px;
  padding: 20px;
  background-color: var(--bg-black-11);
}
</style>
