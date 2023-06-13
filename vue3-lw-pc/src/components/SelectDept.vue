<script>
import { getDeptTree, getDeptUser } from '@/api/organization'

import { createUniqueString } from '@/utils'
export default {
  name: 'SelectDept',
  components: {},
  props: {
    // 添加标签显隐
    visible: {
      type: Boolean,
      default: false,
    },
    title: {
      type: String,
      default: '组织架构',
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
      validator(val) {
        return val.every((e) => e.deptId && e.deptName)
      },
    },
    // 禁止选中的节点
    disabledValues: {
      type: Array,
      default: () => [],
    },
    destroyOnClose: Boolean,
  },
  data() {
    return {
      treeData: [],
      userList: [],
      defaultKeys: [],
    }
  },
  watch: {
    defaultValues: {
      deep: true,
      handler(value) {
        const checkedUserList = []
        if (!Array.isArray(value) || value.length == 0) {
          this.userList = []
        } else {
          value.forEach((i) => {
            const id = i.deptId
            if (id) {
              checkedUserList.push(i)
            }
          })
          console.log(checkedUserList)
          this.userList = checkedUserList
        }
      },
    },
    Pvisible(val) {
      val && this.$refs.tree && this.$refs.tree.setCheckedKeys(this.defaultValues.map((e) => e.deptId))
      if (!this.$refs.tree) {
        setTimeout(() => {
          this.$refs.tree && this.$refs.tree.setCheckedKeys(this.defaultValues.map((e) => e.deptId))
        }, 300)
      }
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
        label: 'deptName',
        children: 'children',
        isLeaf(data, node) {
          return !data.id
        },
      }
    },
  },
  created() {
    this.loadNode()
  },
  mounted() {},
  methods: {
    treeFormat(list) {
      let dealOptions = []
      list.forEach((one) => {
        let findIndex = list.findIndex((item) => {
          return item.deptId === one.parentId
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
    loadNode() {
      getDeptTree().then(({ data }) => {
        this.treeData = this.treeFormat(data)
      })
    },
    // 选择变化
    handleCheckChange(data, checked, indeterminate) {
      // console.log(arguments)
      if (checked) {
        if (this.isSigleSelect) {
          // 单选情况
          this.$refs.tree.setCheckedKeys([data.deptId])
        }
        const isExist = this.userList.findIndex((i) => i.deptId === data.deptId) > -1
        !isExist && this.userList.push(data)
      } else {
        // let index = this.userList.indexOf(data)
        let index = this.userList.findIndex((i) => i.deptId === data.deptId)
        index > -1 && this.userList.splice(index, 1)
      }
      // console.log(data, checked, indeterminate);
      this.userList = this.unique(this.userList)
    },
    unique(arr) {
      for (var i = 0; i < arr.length; i++) {
        for (var j = i + 1; j < arr.length; j++) {
          if (arr[i].deptId.split('_')[0] == arr[j].deptId.split('_')[0]) {
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
      console.log(key)
      this.$refs.tree.setChecked(key, false)
      let index = this.userList.findIndex((i) => i.deptId === key)
      index > -1 && this.userList.splice(index, 1)
      let order = this.defaultValues.findIndex((i) => i.deptId === key)
      order > -1 && this.defaultValues.slice().splice(order, 1)
    },
  },
}
</script>
<template>
  <el-dialog :title="title" v-model="Pvisible" :close-on-click-modal="false" :destroy-on-close="destroyOnClose">
    <el-row :gutter="20">
      <el-col :span="12" :xs="24">
        <div class="head-container">
          <el-tree
            node-key="deptId"
            :data="treeData"
            ref="tree"
            accordion
            show-checkbox
            :check-on-click-node="false"
            :expand-on-click-node="true"
            :props="defaultProps"
            :check-strictly="true"
            @check-change="handleCheckChange"></el-tree>
          <!-- :default-checked-keys="
              defaultValues.map((e) => (isOnlyLeaf ? e.userId : e.userId || e.id))
            " -->
        </div>
      </el-col>
      <el-col :span="12" :xs="24" class="user-list">
        <div :gutter="10">选择部门列表</div>
        <div v-for="(item, index) in userList" :key="index">
          <el-icon-UserFilled class="el-icon-UserFilled"></el-icon-UserFilled>
          {{ item.deptName }}
          <el-icon-minus class="el-icon-minus fr cp" title="取消选择" @click="cancle(item.deptId)"></el-icon-minus>
        </div>
      </el-col>
    </el-row>
    <template #footer>
      <div>
        <el-button @click="Pvisible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<style lang="scss" scoped>
.user-list {
  .el-row {
    line-height: 26px;
  }
}
</style>
