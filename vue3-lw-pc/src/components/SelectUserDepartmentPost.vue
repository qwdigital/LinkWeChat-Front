<!-- 选择部门，岗位，人员组合组件 -->
<script>
import { getDeptTree, getDeptUserAll } from '@/api/organization'
import SelectPost from '@/components/SelectPost'

// 缓存接口数据，避免重复请求
const pageCache = {
  getDeptTreeData: undefined,
  getDeptUserAllData: undefined,
}
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

      selectData: {},
    }
  },
  computed: {},
  watch: {
    modelValue: {
      handler(val) {
        // 设置数据结构
        this.selectData = JSON.parse(JSON.stringify(val))
        val.selectedUserList || (this.selectData.selectedUserList = {})
        val.selectedDeptList || (this.selectData.selectedDeptList = {})
        val.selectedPostList || (this.selectData.selectedPostList = {})

        if (val.selectedUserList?.weUserIds?.length && !this.selectedUserList.length) {
          this.setEditUser()
        }
        if (val.selectedDeptList?.deptIds?.length && !this.selectedDeptList.length) {
          this.setEditDept()
        }
        // this.$emit('update:modelValue', val)
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
        !this.selectData.selectedUserList?.select &&
        !this.selectData.selectedDeptList?.select &&
        !this.selectData.selectedPostList?.select
      ) {
        this.msgError('请选择成员！')
        return false
      }
      if (this.selectData.selectedUserList?.select) {
        if (!this.selectData.selectedUserList?.weUserIds?.length) {
          this.msgError('请选择员工！')
          return false
        }
      }
      if (this.selectData.selectedDeptList?.select) {
        if (!this.selectData.selectedDeptList.deptIds.length) {
          this.msgError('请选择部门！')
          return false
        }
      }
      if (this.selectData.selectedPostList?.select) {
        if (!this.selectData.selectedPostList.posts?.length) {
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
      this.selectData.selectedUserList.weUserIds = data.map((dd) => {
        return dd.userId
      })
      this.changeFn()
    },
    // 选中部门
    selectedDept(data) {
      this.selectedDeptList = data
      this.selectData.selectedDeptList.deptIds = data.map((dd) => {
        return dd.deptId
      })
      this.changeFn()
    },
    // 选中岗位
    selectedPost(data) {
      // this.selectedPostList = data
      this.selectData.selectedPostList.posts = data
      this.changeFn()
    },

    // ------ 清空选中 ------
    clearUserData(data) {
      if (!data) {
        this.selectedUserList = []
        this.selectData.selectedUserList.weUserIds = []
        this.changeFn()
      }
    },
    clearDeptData(data) {
      if (!data) {
        this.selectedDeptList = []
        this.selectData.selectedDeptList.deptIds = []
        // this.selectedPostList = []
        // this.selectData.selectedDeptList.posts = []
        this.changeFn()
      }
    },
    clearPostData(data) {
      if (!data) {
        // this.selectedPostList = []
        this.selectData.selectedPostList.posts = []
        this.changeFn()
      }
    },

    changeFn() {
      this.$emit('update:modelValue', this.selectData)
    },

    // ------ 根据选中的 id 回显 数据 -------
    setEditUser() {
      if (this.modelValue.selectedUserList?.weUserIds) {
        ;(pageCache.getDeptUserAllData
          ? Promise.resolve({ data: pageCache.getDeptUserAllData })
          : getDeptUserAll()
        ).then(({ data }) => {
          pageCache.getDeptUserAllData = data
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
        ;(pageCache.getDeptTreeData ? Promise.resolve({ data: pageCache.getDeptTreeData }) : getDeptTree()).then(
          ({ data }) => {
            pageCache.getDeptTreeData = data
            this.selectedDeptList = []
            this.modelValue.selectedDeptList.deptIds.forEach((element) => {
              let traget = data.find((item) => item.deptId == element)
              if (traget) {
                traget.userId = element
                traget.name = traget.deptName
                this.selectedDeptList.push(traget)
              }
            })
          },
        )
      }
    },
  },
}
</script>

<template>
  <div>
    <!-- 选择成员 -->
    <div>
      <el-checkbox v-model="selectData.selectedUserList.select" @change="clearUserData" label="选择成员"></el-checkbox>
      <template v-if="selectData.selectedUserList.select">
        <el-button type="primary" @click="dialogVisibleSelectUser = true">选择成员</el-button>
        <TagEllipsis :list="selectedUserList" limit="10" type="info" style="display: block" />
      </template>
    </div>

    <!-- 选择部门 -->
    <div class="mt10">
      <el-checkbox v-model="selectData.selectedDeptList.select" @change="clearDeptData" label="选择部门"></el-checkbox>
      <template v-if="selectData.selectedDeptList.select">
        <el-button type="primary" @click="dialogVisibleSelectDept = true">选择部门</el-button>
        <TagEllipsis :list="selectedDeptList" limit="10" type="info" style="display: block" />
      </template>
    </div>

    <!-- 选择岗位 -->
    <div class="mt10">
      <el-checkbox v-model="selectData.selectedPostList.select" @change="clearPostData" label="选择岗位"></el-checkbox>
      <template v-if="selectData.selectedPostList.select">
        <el-button type="primary" @click="dialogVisibleSelectPost = true">选择岗位</el-button>
        <TagEllipsis :list="selectData.selectedPostList.posts" limit="10" type="info" style="display: block" />
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
      :defaultValues="selectData.selectedPostList.posts"
      @success="selectedPost"></SelectPost>
  </div>
</template>

<style lang="scss" scoped>
.el-checkbox {
  vertical-align: middle;
  margin-right: 10px;
}
</style>
