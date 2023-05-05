<script>
  import { getDeptTree, getDeptUser } from '@/api/organization'
  export default {
    name: 'SelectWeUser',
    components: {},
    props: {
      // 添加标签显隐
      visible: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: '组织架构'
      },
      // 是否 只选择叶子节点（人员节点）/禁止选择父节点（部门节点）
      isOnlyLeaf: {
        type: Boolean,
        default: true
      },
      // 是否单选
      isSigleSelect: {
        type: Boolean,
        default: false
      },
      // 默认选中的节点
      defaultValues: {
        type: Array,
        default: () => [],
        // 必须含有userId和name属性
        validator(val) {
          return val.every((e) => e.userId && e.name)
        }
      },
      // 禁止选中的节点
      disabledValues: {
        type: Array,
        default: () => []
      },
      destroyOnClose: Boolean
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
        checked: []
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
        },
        immediate: true
      },
      Pvisible(val) {
        val && this.$refs.tree && this.$refs.tree.setCheckedKeys(this.defaultValues.map((e) => e.userId || e.id))
        if (!this.$refs.tree) {
          setTimeout(() => {
            this.$refs.tree && this.$refs.tree.setCheckedKeys(this.defaultValues.map((e) => e.userId || e.id))
          }, 300)
        }
      }
    },
    computed: {
      Pvisible: {
        get() {
          return this.visible
        },
        set(val) {
          this.$emit('update:visible', val)
        }
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
          }
        }
      }
    },
    created() {},
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
        this.searchResult = []
        this.searchState = true
        this.checked = this.userList.map((dd) => {
          return dd.userId
        })
        getDeptUser({
          // deptId: this.deptId,
          userName: this.keywords
        }).then((res) => {
          this.searchResult = this.handleName(res.rows)
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
          this.$forceUpdate()
        } else {
          this.cancle(this.searchResult[index].userId)
        }
        setTimeout(() => {
          this.keywords = ''
          this.setChange()
        }, 500)
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
            let _data = this.handleTree(data)
            let value = this.treeFormat(_data)
            if (value.length) {
              this.deptId = value[0].deptId
            }
            resolve(value)
          })
        } else {
          getDeptUser({ deptId: node.data.id }).then(({ rows }) => {
            let arr = this.handleName(rows)
            node.data.children && arr.push(...node.data.children)
            resolve(arr)
          })
        }
      },
      handleTree(data) {
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
      handleName(data) {
        return data.map((i) => {
          if (i.userName) {
            i.userId = i.weUserId
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
        this.$emit('success', [...this.userList])
      },
      // 取消选择
      cancle(key) {
        this.$refs.tree.setChecked(key, false)
        let index = this.userList.findIndex((i) => i.userId === key)
        index > -1 && this.userList.splice(index, 1)
        let order = this.defaultValues.findIndex((i) => i.userId === key)
        order > -1 && this.defaultValues.slice().splice(order, 1)
      }
    }
  }
</script>
<template>
  <el-dialog
    v-bind="$attrs"
    :title="title"
    :visible.sync="Pvisible"
    :close-on-click-modal="false"
    :destroy-on-close="destroyOnClose"
  >
    <el-row :gutter="20" class="content">
      <el-col :span="12" :xs="24">
        <div class="search-input">
          <el-input
            size="mini"
            v-model="keywords"
            @keyup.enter.native="setSearch"
            placeholder="请输入员工名称"
            clearable
            @change="setChange"
          >
            <el-button slot="append" icon="el-icon-search" @click="setSearch"></el-button>
          </el-input>
        </div>
        <div class="search-list user-list" v-show="searchState">
          <el-checkbox-group v-model="checked">
            <el-row v-for="(item, index) in searchResult" :key="index">
              <el-checkbox :label="item.userId" :key="index" @change="setSelectChange($event, index)">
                <div>{{ item.name }} - {{ item.userDepts[0].deptName }}</div>
              </el-checkbox>
            </el-row>
          </el-checkbox-group>
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
              @check-change="handleCheckChange"
            ></el-tree>
          </div>
        </transition>
      </el-col>
      <el-col :span="12" :xs="24" class="user-list">
        <el-row :gutter="10">选择人员列表</el-row>
        <el-row v-for="(item, index) in userList" :key="index">
          <i class="el-icon-user-solid"></i>
          {{ item.name }}
          <i class="el-icon-minus fr cp" title="取消选择" @click="cancle(item.userId)"></i>
        </el-row>
      </el-col>
    </el-row>
    <div slot="footer">
      <el-button @click="Pvisible = false">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </div>
  </el-dialog>
</template>

<style lang="scss" scoped>
  .content {
    min-height: 400px;
  }
  .search-input {
    margin-top: 5px;
    margin-bottom: 10px;
  }
  .user-list {
    .el-row {
      line-height: 26px;
    }
  }
  .search-list {
    margin-top: 20px;
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
