<template>
  <div class="select_content">
    <div>
      <el-checkbox v-model="form.executeUserCondit.change" @change="clearUserData" label="选择成员"></el-checkbox>
      <div class="select_unit" v-if="form.executeUserCondit.change">
        <div v-if="selectedUserList.length > 0">
          <el-tag v-for="(item, index) in selectedUserList" :key="index">{{ item.name }}</el-tag>
        </div>
        <el-button icon="el-icon-plus" type="primary" plain @click="dialogVisibleSelectUser = true">
          {{ selectedUserList.length ? '修改' : '选择' }}员工
        </el-button>
      </div>
    </div>
    <div>
      <el-checkbox
        v-model="form.executeDeptCondit.change"
        @change="clearDeptsData"
        label="选择部门范围与岗位"></el-checkbox>
      <el-popover placement="top" trigger="hover">
        <template #reference>
          <el-icon-QuestionFilled class="el-icon-QuestionFilled ml5"></el-icon-QuestionFilled>
        </template>
        <div>可根据地域行政管理规划/组织架构部门，与岗位的组合条件来筛选执行成员。</div>
      </el-popover>
      <div class="select_unit" v-if="form.executeDeptCondit.change">
        <div v-if="selectedDeptList.length > 0">
          <el-tag v-for="(item, index) in selectedDeptList" :key="index">{{ item.deptName }}</el-tag>
        </div>
        <el-button icon="el-icon-plus" type="primary" plain @click="dialogVisibleSelectDept = true">
          {{ selectedDeptList.length ? '修改' : '选择' }}部门
        </el-button>
      </div>
      <div class="select_unit" v-if="form.executeDeptCondit.change">
        <div v-if="selectedPostList.length > 0">
          <el-tag v-for="(item, index) in selectedPostList" :key="index">{{ item }}</el-tag>
        </div>
        <el-button icon="el-icon-plus" type="primary" plain @click="dialogVisibleSelectPost = true">
          {{ selectedPostList.length ? '修改' : '选择' }}岗位
        </el-button>
      </div>
    </div>
    <SelectDept
      :defaultValues="selectedDeptList"
      v-model:visible="dialogVisibleSelectDept"
      title="选择部门"
      @success="selectedDept"></SelectDept>
    <SelectPost
      :defaultValues="selectedPostList"
      v-model:visible="dialogVisibleSelectPost"
      title="选择岗位"
      @success="selectedPost"></SelectPost>
    <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      :isOnlyLeaf="true"
      @success="selectedUser"></SelectUser>
  </div>
</template>
<script>
import { getDeptTree, getDeptUserAll } from '@/api/organization'
import SelectDept from '@/components/SelectDept'
import SelectPost from '@/components/SelectPost'
export default {
  name: 'select-member',
  components: {
    SelectDept,
    SelectPost,
  },
  props: {
    initData: {
      type: Object,
      default: {
        executeUserCondit: {
          change: false,
          weUserIds: [],
        },
        executeDeptCondit: {
          change: false,
          deptIds: [],
          posts: [],
        },
      },
    },
  },
  data() {
    return {
      selectMember: false,
      selectDept: false,
      selectedUserList: [],
      dialogVisibleSelectUser: false,
      selectedDeptList: [],
      dialogVisibleSelectDept: false,
      dialogVisibleSelectPost: false,
      selectedPostList: [],
      form: {
        executeUserCondit: {
          change: false,
          weUserIds: [],
        },
        executeDeptCondit: {
          change: false,
          deptIds: [],
          posts: [],
        },
      },
    }
  },
  watch: {
    initData: {
      deep: true,
      immediate: true,
      handler(newData, old) {
        if (this.initData) {
          this.form = JSON.parse(JSON.stringify(this.initData))
          if (this.form && this.form.executeUserCondit.change) {
            this.setEditUser()
          }
          if (this.form && this.form.executeDeptCondit.change) {
            this.setEditDept()
          }
        }
      },
    },
  },
  methods: {
    validateFn() {
      if (!this.form.executeUserCondit.change && !this.form.executeDeptCondit.change) {
        this.msgError('请选择添加成员！')
        return false
      }
      if (this.form.executeUserCondit.change) {
        if (!this.form.executeUserCondit.weUserIds || !this.form.executeUserCondit.weUserIds.length) {
          this.msgError('请选择成员！')
          return false
        }
      }
      if (this.form.executeDeptCondit.change) {
        if (!this.form.executeDeptCondit.posts.length && !this.form.executeDeptCondit.deptIds.length) {
          this.msgError('请选择部门范围与岗位！')
          return false
        }
      }
      return true
    },
    selectedPost(data) {
      this.selectedPostList = data
      this.form.executeDeptCondit.posts = data
      this.changeFn()
    },
    selectedUser(data) {
      this.selectedUserList = data
      this.form.executeUserCondit.weUserIds = data.map((dd) => {
        return dd.userId
      })
      this.changeFn()
    },
    selectedDept(data) {
      this.selectedDeptList = data
      this.form.executeDeptCondit.deptIds = data.map((dd) => {
        return dd.deptId
      })
      this.changeFn()
    },
    clearUserData(data) {
      if (!data) {
        this.selectedUserList = []
        this.form.executeUserCondit.weUserIds = []
        this.changeFn()
      }
    },
    clearDeptsData(data) {
      if (!data) {
        this.selectedDeptList = []
        this.form.executeDeptCondit.deptIds = []
        this.selectedPostList = []
        this.form.executeDeptCondit.posts = []
        this.changeFn()
      }
    },
    changeFn() {
      this.$emit('update', this.form)
    },
    setEditUser() {
      if (this.form.executeUserCondit.weUserIds) {
        this.selectedUserList = []
        getDeptUserAll().then(({ data }) => {
          this.form.executeUserCondit.weUserIds.forEach((dd) => {
            let index = data.findIndex((item) => item.weUserId === dd)
            if (index != -1) {
              data[index].userId = dd
              data[index].name = data[index].userName
              this.selectedUserList.push(data[index])
            }
          })
        })
      }
    },
    setEditDept() {
      if (this.form.executeDeptCondit.deptIds.length) {
        this.selectedDeptList = []
        getDeptTree().then(({ data }) => {
          this.form.executeDeptCondit.deptIds.forEach((dd) => {
            let index = data.findIndex((item) => item.deptId === dd)
            this.selectedDeptList.push(data[index])
          })
        })
      }
      if (this.form.executeDeptCondit.posts.length) {
        this.selectedPostList = this.form.executeDeptCondit.posts
      }
    },
  },
  created() {},
}
</script>
<style lang="scss" scoped>
.select_content {
  background-color: var(--bg-black-11);
  padding: 20px;
  border-radius: 5px;
  .select_unit {
    padding: 10px 25px;
  }
}
</style>
