<!-- 选择部门，岗位，人员组合组件 -->
<script>
import { getDeptTree, getDeptUserAll } from '@/api/organization'
import SelectPost from '@/components/SelectPost'
export default {
  components: { SelectPost },
  props: {
    modelValue: {
      type: Object,
      default: () => ({
        selectedUserList: {
          select: false,
          weUserIds: [],
        },
        selectedDeptList: {
          select: false,
          deptIds: [],
        },
        selectedPostList: {
          select: false,
          posts: [],
        },
      }),
    },
    // 是否必选，至少一项
    required: {
      type: Boolean,
      default: true,
    },
  },
  data() {
    return {
      dialogVisibleSelectUser: false,
      dialogVisibleSelectDept: false,
      dialogVisibleSelectPost: false,
      selectedUserList: [],
      selectedDeptList: [],
      // selectedPostList: [],
    }
  },
  computed: {},
  watch: {
    modelValue: {
      handler(val) {
        // 设置默认值
        val.selectedUserList || (val.selectedUserList = {})
        val.selectedDeptList || (val.selectedDeptList = {})
        val.selectedPostList || (val.selectedPostList = {})

        if (val.selectedUserList?.weUserIds?.length && !this.selectedUserList.length) {
          this.setEditUser()
        }
        if (val.selectedDeptList?.deptIds?.length && !this.selectedDeptList.length) {
          this.setEditDept()
        }
        this.$emit('update:modelValue', val)
      },
      deep: true,
      immediate: true,
    },
  },
  created() {},
  mounted() {},
  methods: {
    // 提交校验
    validate() {
      if (
        this.required &&
        !this.modelValue.selectedUserList?.select &&
        !this.modelValue.selectedDeptList?.select &&
        !this.modelValue.selectedPostList?.select
      ) {
        this.msgError('请选择成员！')
        return false
      }
      if (this.modelValue.selectedUserList?.select) {
        if (!this.modelValue.selectedUserList?.weUserIds?.length) {
          this.msgError('请选择员工！')
          return false
        }
      }
      if (this.modelValue.selectedDeptList?.select) {
        if (!this.modelValue.selectedDeptList.deptIds.length) {
          this.msgError('请选择部门！')
          return false
        }
      }
      if (this.modelValue.selectedPostList?.select) {
        if (!this.modelValue.selectedPostList.posts?.length) {
          this.msgError('请选择岗位！')
          return false
        }
      }
      return true
    },

    // ------ 选中事件 ------
    // 选中员工
    selectedUser(data) {
      this.selectedUserList = data
      this.modelValue.selectedUserList.weUserIds = data.map((dd) => {
        return dd.userId
      })
      // this.changeFn()
    },
    // 选中部门
    selectedDept(data) {
      this.selectedDeptList = data
      this.modelValue.selectedDeptList.deptIds = data.map((dd) => {
        return dd.deptId
      })
      // this.changeFn()
    },
    // 选中岗位
    selectedPost(data) {
      // this.selectedPostList = data
      this.modelValue.selectedPostList.posts = data
      // this.changeFn()
    },

    // ------ 清空选中 ------
    clearUserData(data) {
      if (!data) {
        this.selectedUserList = []
        this.modelValue.selectedUserList.weUserIds = []
        // this.changeFn()
      }
    },
    clearDeptData(data) {
      if (!data) {
        this.selectedDeptList = []
        this.modelValue.selectedDeptList.deptIds = []
        // this.selectedPostList = []
        // this.modelValue.selectedDeptList.posts = []
        // this.changeFn()
      }
    },
    clearPostData(data) {
      if (!data) {
        // this.selectedPostList = []
        this.modelValue.selectedPostList.posts = []
        // this.changeFn()
      }
    },

    // changeFn() {
    // this.$emit('update', this.modelValue)
    // },

    // ------ 根据选中的 id 回显 数据 -------
    setEditUser() {
      if (this.modelValue.selectedUserList?.weUserIds) {
        getDeptUserAll().then(({ data }) => {
          this.selectedUserList = []
          this.modelValue.selectedUserList.weUserIds.forEach((element) => {
            let traget = data.find((item) => item.weUserId == element)
            if (traget) {
              traget.userId = element
              traget.name = traget.userName
              this.selectedUserList.push(traget)
            }
          })
        })
      }
    },
    setEditDept() {
      if (this.modelValue.selectedDeptList?.deptIds?.length) {
        getDeptTree().then(({ data }) => {
          this.selectedDeptList = []
          this.modelValue.selectedDeptList.deptIds.forEach((element) => {
            let traget = data.find((item) => item.deptId == element)
            if (traget) {
              traget.userId = element
              traget.name = traget.deptName
              this.selectedDeptList.push(traget)
            }
          })
        })
      }
    },
  },
}
</script>

<template>
  <div>
    <!-- 选择成员 -->
    <div>
      <el-checkbox v-model="modelValue.selectedUserList.select" @change="clearUserData" label="选择成员"></el-checkbox>
      <template v-if="modelValue.selectedUserList.select">
        <el-button type="primary" @click="dialogVisibleSelectUser = true">选择成员</el-button>
        <TagEllipsis :list="selectedUserList" limit="10" type="info" style="display: block" />
      </template>
    </div>

    <!-- 选择部门 -->
    <div class="mt10">
      <el-checkbox v-model="modelValue.selectedDeptList.select" @change="clearDeptData" label="选择部门"></el-checkbox>
      <template v-if="modelValue.selectedDeptList.select">
        <el-button type="primary" @click="dialogVisibleSelectDept = true">选择部门</el-button>
        <TagEllipsis :list="selectedDeptList" limit="10" type="info" style="display: block" />
      </template>
    </div>

    <!-- 选择岗位 -->
    <div class="mt10">
      <el-checkbox v-model="modelValue.selectedPostList.select" @change="clearPostData" label="选择岗位"></el-checkbox>
      <template v-if="modelValue.selectedPostList.select">
        <el-button type="primary" @click="dialogVisibleSelectPost = true">选择岗位</el-button>
        <TagEllipsis :list="modelValue.selectedPostList.posts" limit="10" type="info" style="display: block" />
      </template>
    </div>

    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      append-to-body
      width="600px"
      title="选择员工"
      :defaultValues="selectedUserList"
      @success="selectedUser"></SelectUser>
    <SelectUser
      v-model:visible="dialogVisibleSelectDept"
      append-to-body
      width="600px"
      title="选择部门"
      :isOnlyDepart="true"
      :departReplaceUser="true"
      :isOnlyLeaf="false"
      :defaultValues="selectedDeptList"
      @success="selectedDept"></SelectUser>
    <SelectPost
      v-model:visible="dialogVisibleSelectPost"
      append-to-body
      width="600px"
      title="选择岗位"
      :defaultValues="modelValue.selectedPostList.posts"
      @success="selectedPost"></SelectPost>
  </div>
</template>

<style lang="scss" scoped>
.el-checkbox {
  vertical-align: middle;
  margin-right: 10px;
}
</style>
