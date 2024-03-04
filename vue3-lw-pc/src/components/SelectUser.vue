<script>
import { getDeptTree, getDeptUser } from '@/api/organization'
export default {
  name: 'SelectUser',
  components: {},
  props: {
    // 是否使用 weUserId 代替 userId
    isWechat: {
      type: Boolean,
      default: true,
    },
    // 添加标签显隐
    visible: {
      type: Boolean,
      default: false,
    },
    title: {
      type: String,
      default: '组织架构',
    },
    // 是否 只选择部门节点，true时将不再加载人员节点
    isOnlyDepart: {
      type: Boolean,
      default: false,
    },
    // 是否 只选择叶子节点（人员节点）/禁止选择父节点（部门节点）
    isOnlyLeaf: {
      type: Boolean,
      default: true,
    },
    // 是否单选
    isSigleSelect: {
      type: Boolean,
      default: false,
    },
    // 默认选中的节点
    defaultValues: {
      type: Array,
      default: () => [],
      // 必须含有userId和name属性, 只有userId不可行，name用于右侧列表回显
      validator(val) {
        return val.every((e) => e.userId && e.name)
      },
    },
    // 禁止选中的节点
    disabledValues: {
      type: Array,
      default: () => [],
    },
    destroyOnClose: Boolean,
    // 子级全部选中时，右侧选中列表是否只显示父级, 仅在 isOnlyLeaf 为 false 时有效
    departReplaceUser: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      treeData: [],
      userList: [],
      defaultKeys: [],
      deptId: '', //根部门Id
      keywords: '',
      searchResult: [],
      searchState: false,
      checked: [],
      loading: false,
    }
  },
  watch: {
    defaultValues: {
      handler(value) {
        const checkedUserList = []
        if (!Array.isArray(value) || value.length == 0) {
          this.userList = []
        } else {
          value.forEach((i) => {
            const id = i.userId || i.id
            if (id) {
              checkedUserList.push(i)
            }
          })
          this.userList = checkedUserList
        }
        // setTimeout(() => {
        //   this.Pvisible && this.$refs.tree?.setCheckedKeys(value.map((e) => e.userId || e.id))
        // }, 300)
      },
      immediate: true,
      deep: true,
    },
    Pvisible(val) {
      // val && this.$refs.tree?.setCheckedKeys(this.defaultValues.map((e) => e.userId || e.id))
      // if (!this.$refs.tree) {
      this.keywords = ''
      this.searchState = false
      setTimeout(() => {
        val && this.$refs.tree?.setCheckedKeys(this.defaultValues.map((e) => e.userId || e.id))
      }, 0)
      // }
    },
  },
  computed: {
    Pvisible: {
      get() {
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
    defaultProps() {
      let that = this
      return {
        label: 'name',
        children: 'children',
        disabled(data, node) {
          return (that.isOnlyLeaf && data.isParty) || that.disabledValues.some((e) => e == (data.userId || data.id))
        },
        isLeaf(data, node) {
          return !data.id
        },
      }
    },
    dealedUserList() {
      if (this.isOnlyLeaf || !this.departReplaceUser) {
        return this.userList
      }
      // 提取所有部门
      let arr = this.userList.filter((e) => e.isParty)
      // 提取所有非选中部门的人员
      let userList = this.userList.filter((e) => !e.isParty && !arr.some((e2) => e.userDepts[0]?.deptId == e2.deptId))
      // 提取无父级部门
      arr = arr.filter((e) => !arr.some((e2) => e.parentId == e2.id))
      arr.push(...userList)
      return arr
    },
  },
  created() {
    // console.log(this.$attrs)
  },
  mounted() {},
  methods: {
    setChange(e) {
      if (!e) {
        this.searchState = false
        this.$refs.tree.setCheckedKeys(this.userList.map((e) => e.userId || e.id))
      }
    },
    setSearch() {
      if (!this.keywords) return
      this.searchState = true
      this.loading = true
      this.checked = this.userList.map((dd) => {
        return dd.userId
      })
      getDeptUser({
        // deptId: this.deptId,
        userName: this.keywords,
      })
        .then((res) => {
          this.searchResult = this.handleUser(res.rows) || []
        })
        .finally(() => {
          this.loading = false
        })
    },
    setSelectChange(e, index) {
      if (e) {
        if (this.isSigleSelect) {
          this.userList[0] = this.searchResult[index]
        } else {
          this.userList.push(this.searchResult[index])
        }
        this.checked = this.userList.map((dd) => {
          return dd.userId
        })
        // this.$forceUpdate()
      } else {
        this.cancle(this.searchResult[index].userId)
      }
      // setTimeout(() => {
      //   this.keywords = ''
      //   this.setChange()
      // }, 500)
    },
    treeFormat(list) {
      let dealOptions = []
      list.forEach((one) => {
        let findIndex = list.findIndex((item) => {
          return item.id === one.parentId
        })
        if ((!one.parentId && one.parentId !== 0 && one.parentId !== false) || findIndex === -1) {
          dealOptions.push(one)
        } else {
          if (!list[findIndex].children) {
            list[findIndex].children = []
            list[findIndex].children.push(one)
          } else {
            list[findIndex].children.push(one)
          }
        }
      })
      return dealOptions
    },
    loadNode(node, resolve) {
      if (node.level === 0) {
        if (!Array.isArray(this.defaultValues) || this.defaultValues.length == 0) {
          this.userList = []
        }
        getDeptTree().then(({ data }) => {
          let _data = this.handleDepart(data)
          let value = this.treeFormat(_data)
          if (value.length) {
            this.deptId = value[0].deptId
          }
          resolve(value)
        })
      } else {
        this.isOnlyDepart
          ? resolve(node.data.children)
          : getDeptUser({ deptId: node.data.id }).then(({ rows }) => {
              let arr = this.handleUser(rows)
              node.data.children && arr.push(...node.data.children)
              // 懒加载选中状态的子节点不会触发子节点的选中事件，需要手动触发
              if (node.checked) {
                setTimeout(() => {
                  arr.forEach((e) => {
                    this.handleCheckChange(e, true)
                  })
                }, 200)
              }
              resolve(arr)
            })
      }
    },
    handleDepart(data) {
      return data.map((i) => {
        if (i.deptId) {
          i.userId = i.deptId
          i.name = i.deptName
          i.id = i.deptId
          i.isParty = true
        }
        return i
      })
    },
    handleUser(data) {
      return data.map((i) => {
        if (i.userName) {
          i.userIdOrigin = i.userId
          i.userId = this.isWechat ? i.weUserId : i.userId
          i.name = i.userName
        }
        return i
      })
    },
    // 选择变化
    handleCheckChange(data, checked, indeterminate) {
      if (checked) {
        if (this.isSigleSelect) {
          // 单选情况
          this.$refs.tree.setCheckedKeys([data.userId])
        }
        if (this.isOnlyLeaf) {
          if (data.userId && !data.isParty) {
            this.userList.push(data)
          }
        } else {
          const isExist = this.userList.findIndex((i) => i.userId === data.userId) > -1
          !isExist && this.userList.push(data)
        }
      } else {
        let index = this.userList.findIndex((i) => i.userId === data.userId)
        index > -1 && this.userList.splice(index, 1)
      }
      this.userList = this.unique(this.userList)
    },
    unique(arr) {
      for (var i = 0; i < arr.length; i++) {
        for (var j = i + 1; j < arr.length; j++) {
          if (arr[i].userId.split('_')[0] == arr[j].userId.split('_')[0]) {
            arr.splice(j, 1)
            j--
          }
        }
      }
      return arr
    },
    // 确 定
    submit() {
      this.Pvisible = false
      this.$emit('success', [...this.dealedUserList])
    },
    // 取消选择
    cancle(key) {
      this.$refs.tree.setChecked(key, false)
      let index = this.userList.findIndex((i) => i.userId === key)
      index > -1 && this.userList.splice(index, 1)
      let order = this.defaultValues.findIndex((i) => i.userId === key)
      order > -1 && this.defaultValues.slice().splice(order, 1)
    },
  },
}
</script>
<template>
  <el-dialog
    v-bind="$attrs"
    :title="title"
    v-model="Pvisible"
    :close-on-click-modal="false"
    :destroy-on-close="destroyOnClose">
    <div class="content">
      <div class="left">
        <div class="search-input">
          <el-input
            v-model="keywords"
            @keyup.enter="setSearch"
            placeholder="请输入员工名称"
            clearable
            @change="setChange">
            <template #append><el-button icon="el-icon-search" @click="setSearch"></el-button></template>
          </el-input>
        </div>
        <div class="search-list" v-show="searchState" v-loading="loading">
          <el-checkbox-group v-model="checked">
            <div v-for="(item, index) in searchResult" :key="index">
              <el-checkbox :label="item.userId" :key="index" @change="setSelectChange($event, index)">
                {{ item.name }}
              </el-checkbox>
            </div>
          </el-checkbox-group>
          <div class="ac" v-if="!searchResult?.length && !loading">暂无数据</div>
        </div>
        <transition name="fade">
          <div class="head-container" v-show="!searchState">
            <el-tree
              node-key="userId"
              ref="tree"
              lazy
              accordion
              show-checkbox
              :check-on-click-node="false"
              :expand-on-click-node="true"
              :load="loadNode"
              :props="defaultProps"
              :check-strictly="isOnlyLeaf"
              @check-change="handleCheckChange"></el-tree>
          </div>
        </transition>
      </div>
      <div class="right user-list">
        <div>已选列表</div>
        <div v-for="(item, index) in dealedUserList" :key="index" class="flex aic">
          <el-icon-UserFilled class="el-icon-UserFilled"></el-icon-UserFilled>
          <span class="user-name">{{ item.name }}</span>
          <el-icon-minus class="el-icon-minus cp" title="取消选择" @click="cancle(item.userId)"></el-icon-minus>
        </div>
      </div>
    </div>
    <template #footer>
      <el-button @click="Pvisible = false">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </template>
  </el-dialog>
</template>

<style lang="scss" scoped>
.content {
  display: flex;
  justify-content: space-between;
}
.left,
.right {
  width: 49%;
  max-height: calc(100vh - 170px);
  overflow: auto;
}
.search-input {
  margin-top: 5px;
  margin-bottom: 10px;
}
.user-list {
  line-height: 26px;
  padding-right: 10px;
  .user-name {
    margin: 0 5px;
    flex: auto;
  }
}
.search-list {
  line-height: 26px;
  padding: 0 10px;
}
.fade-enter-active {
  transition: opacity 0.5s;
}
.fade-enter {
  opacity: 0;
}
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-leave-to {
  opacity: 0;
}
</style>
