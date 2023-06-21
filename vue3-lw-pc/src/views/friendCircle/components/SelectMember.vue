<template>
  <div>
    <div class="select_content">
      <!-- 部门与岗位开始 -->
      <div class="flex">
        <div class="lable_text">选择成员来源：</div>
        <div>
          <div class="select_unit">
            <el-button @click="dialogVisibleSelectDept = true" v-show="!isDetail"
              >{{ selectedDeptList.length ? '修改' : '选择' }}部门范围</el-button
            >
            <!-- <el-popover
            style="display: inline-block; margin-left: 10px"
            placement="top"
            trigger="hover"
          >
            <div slot="reference">
              <i class="el-icon-question"></i>
            </div>
            <div>可根据地域行政管理规划/组织架构部门，与岗位的组合条件来筛选执行成员。</div>
          </el-popover>-->
            <div v-if="selectedDeptList.length > 0">
              <el-tag size="small" v-for="(item, index) in selectedDeptList" :key="index">
                {{ item.deptName }}
              </el-tag>
            </div>
            <span class="tips" v-else-if="isDetail">未选择标签</span>
          </div>
          <div class="select_unit">
            <el-button @click="dialogVisibleSelectPost = true" v-show="!isDetail">
              {{ selectedPostList.length ? '修改' : '选择' }}岗位
            </el-button>
            <div v-if="selectedPostList.length > 0">
              <el-tag size="small" v-for="(item, index) in selectedPostList" :key="index">{{
                item
              }}</el-tag>
            </div>
            <span class="tips" v-else-if="isDetail">未选择标签</span>
          </div>
        </div>
      </div>
      <!-- 部门与岗位结束 -->
      <div class="flex">
        <div class="lable_text"></div>
        <div class="select_unit">
          <el-button @click="dialogVisibleSelectUser = true" v-show="!isDetail"
            >{{ selectedUserList.length ? '修改' : '选择' }}员工</el-button
          >
          <div v-if="selectedUserList.length > 0">
            <el-tag size="small" v-for="(item, index) in selectedUserList" :key="index">
              {{ item.name }}
            </el-tag>
          </div>
          <span class="tips" v-else-if="isDetail">未选择标签</span>
        </div>
      </div>
      <!-- 选择客户标签 -->
      <div class="flex mt10">
        <div class="lable_text">选择客户标签：</div>
        <div class="select_unit">
          <el-button plain @click="dialogVisibleSelectTag = true" v-show="!isDetail"
            >{{ selectedTagList.length ? '修改' : '选择' }}标签</el-button
          >
          <div v-if="selectedTagList.length > 0">
            <el-tag sizi="mini" v-for="(unit, key) in selectedTagList" :key="key">{{
              unit.name
            }}</el-tag>
          </div>
          <span class="tips" v-else-if="isDetail">未选择标签</span>
        </div>
      </div>
      <SelectDept
        :defaultValues="selectedDeptList"
        v-model:visible="dialogVisibleSelectDept"
        title="选择部门"
        @success="selectedDept"
      ></SelectDept>
      <SelectPost
        :defaultValues="selectedPostList"
        v-model:visible="dialogVisibleSelectPost"
        title="选择岗位"
        @success="selectedPost"
      ></SelectPost>
      <SelectWeUser
        :defaultValues="selectedUserList"
        v-model:visible="dialogVisibleSelectUser"
        title="选择使用员工"
        :isOnlyLeaf="true"
        @success="selectedUser"
      ></SelectWeUser>
      <SelectTag
        v-model:visible="dialogVisibleSelectTag"
        :defaultValues="selectedTagList"
        @success="submitSelectTag"
      ></SelectTag>
    </div>
  </div>
</template>
<script>
import { getDeptTree, getDeptUserAll } from '@/api/organization'
import { getList } from '@/api/customer/tag'
export default {
  name: 'select-member',
  components: {
    SelectDept: defineAsyncComponent(() => import('@/components/SelectDept')),
    SelectWeUser: defineAsyncComponent(() => import('@/components/SelectUser')),
    SelectPost: defineAsyncComponent(() => import('@/components/SelectPost')),
    SelectTag: defineAsyncComponent(() => import('@/components/SelectTag')),
  },
  props: {
    initData: {
      type: Object,
      default: {
        userIds: [],
        deptIds: [],
        posts: [],
        customerTag: [],
      },
    },
    // 是否显示标题（选择成员来源：）
    // show: {
    //   type: Boolean,
    //   default: false,
    // },
    userWithout: {
      type: Boolean,
      default: false,
    },
    // 查询账号类型：null:企微，非企微  1:企微  0:非企微
    accountType: { type: [String, Number], default: 1 },
    isDetail: {
      type: Boolean,
      default: false,
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
      dialogVisibleSelectTag: false,
      selectedTagList: [],
      selectedPostList: [],
      form: {
        userIds: [],
        deptIds: [],
        posts: [],
        customerTag: [],
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
          if (this.form) {
            this.setEditUser()
            this.setEditDept()
            this.setEditTag()
          }
        }
      },
    },
  },
  methods: {
    validateFn() {
      // if (!this.form.executeUserCondit.change && !this.form.executeDeptCondit.change) {
      //   this.msgError('请选择添加成员！')
      //   return false
      // }
      if (
        !(this.form.userIds && this.form.userIds.length) &&
        !(this.form.posts && this.form.posts.length) &&
        !(this.form.deptIds && this.form.deptIds.length)
      ) {
        this.msgError('请选择发送范围的条件！')
        return false
      } else {
        return true
      }
    },
    selectedPost(data) {
      this.selectedPostList = data
      this.form.posts = data
      this.changeFn()
    },
    selectedUser(data) {
      this.selectedUserList = data
      this.form.userIds = data.map((dd) => {
        return dd.userId
      })
      this.changeFn()
    },
    selectedDept(data) {
      this.selectedDeptList = data
      this.form.deptIds = data.map((dd) => {
        return dd.deptId
      })
      this.changeFn()
    },
    submitSelectTag(data) {
      this.selectedTagList = data
      this.form.customerTag = data.map((dd) => {
        return dd.tagId
      })
      this.changeFn()
    },
    changeFn() {
      this.$emit('update', this.form)
    },
    setEditUser() {
      if (this.form.userIds && this.form.userIds.length) {
        this.selectedUserList = []
        getDeptUserAll().then(({ data }) => {
          this.form.userIds.forEach((dd) => {
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
      if (this.form.deptIds && this.form.deptIds.length) {
        this.selectedDeptList = []
        getDeptTree().then(({ data }) => {
          this.form.deptIds.forEach((dd) => {
            let index = data.findIndex((item) => item.deptId === dd)
            this.selectedDeptList.push(data[index])
          })
        })
      }
      if (this.form.posts && this.form.posts.length) {
        this.selectedPostList = this.form.posts
      }
    },
    setEditTag() {
      if (this.form.customerTag && this.form.customerTag.length) {
        getList({ groupTagType: 1 }).then(({ rows }) => {
          this.form.customerTag.forEach((dd) => {
            rows.forEach((inx) => {
              let index = inx.weTags.findIndex((item) => item.tagId === dd)
              if (inx.weTags[index] !== undefined) {
                this.selectedTagList.push(inx.weTags[index])
              }
            })
          })
        })
      }
    },
  },
  created() {},
}
</script>
<style lang="scss" scoped>
.tips {
  color: #aaa;
  font-size: 12px;
  line-height: 30px;
}
.customer-num {
  span {
    font-size: 12px;
    line-height: 30px;
  }
  span:nth-child(1) {
    color: #aaa;
  }
  span:nth-child(2) {
    color: #07c160;
  }
}
.select_content {
  .select_unit {
    padding-bottom: 16px;
    padding-top: 6px;
    max-width: 400px;
    .el-icon-question {
      color: #86909c;
    }
  }
}
.lable_text {
  width: 116px;
  text-align: right;
  // line-height: 52px;
  font-size: 14px;
  font-weight: 400;
  color: #1d2129;
  span {
    color: #eb5e12;
    line-height: 30px;
    padding: 4px;
  }
}
</style>
