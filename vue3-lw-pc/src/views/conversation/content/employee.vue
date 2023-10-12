<template>
  <div class="employ">
    <el-row type="flex" align="center" :gutter="10">
      <el-col :span="6">
        <div class="ct_box" style="height: calc(100vh - 197px)">
          <el-input
            class="mb10"
            placeholder="搜索员工名称"
            clearable
            v-model.trim="keywords"
            @keyup.enter="getDeptUser">
            <template #append><el-button icon="el-icon-search" @click="getDeptUser"></el-button></template>
          </el-input>

          <div class="search-list" v-show="keywords">
            <div
              v-for="(item, index) in searchResult"
              :key="index"
              :class="['customer-li', { active: index == personIndex }]"
              @click="handleNodeClick(item)">
              {{ item.name }}
            </div>
          </div>

          <el-tree
            v-show="!keywords"
            ref="tree"
            class="filter-tree"
            :props="defaultProps"
            :filter-node-method="filterNode"
            highlight-current
            node-key="id"
            @node-click="handleNodeClick"
            :default-expanded-keys="defaultExpandedKeys"
            :load="loadNode"
            lazy></el-tree>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="ct_box" style="height: calc(100vh - 197px)">
          <template v-if="talkName">
            <div class="name pd15">{{ talkName }}</div>
            <el-tabs v-model="activeName" @tab-change="tabClick(true)">
              <el-tab-pane label="内部联系人" name="0">
                <userList
                  v-if="activeName == 0"
                  :personList="personList"
                  :loading="loading"
                  @chatFn="chatFn"></userList>
              </el-tab-pane>
              <el-tab-pane label="外部联系人" name="1">
                <userList
                  v-if="activeName == 1"
                  :personList="personList"
                  :loading="loading"
                  @chatFn="chatFn"></userList>
              </el-tab-pane>
              <el-tab-pane label="群聊" name="2">
                <grouplist
                  v-if="activeName == 2"
                  :personList="personList"
                  :loading="loading"
                  @groupFn="groupFn"></grouplist>
              </el-tab-pane>
            </el-tabs>
          </template>
          <el-empty v-else :image-size="100" description="请选择员工"></el-empty>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="ct_box" style="height: calc(100vh - 197px)">
          <chatListClass v-show="queryChat.receiveName" :queryChat="queryChat"></chatListClass>
          <el-empty v-if="!queryChat.receiveName" description="请选择联系人" :image-size="100"></el-empty>
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import chatListClass from './component/chatListClass.vue'
import userList from './component/userList.vue'
import grouplist from './component/groupList.vue'
import * as apiOrg from '@/api/organization'
import * as api from '@/api/conversation/content.js'

export default {
  components: {
    grouplist,
    userList,
    chatListClass,
  },
  data() {
    return {
      keywords: '',
      searchResult: [],
      fromId: '',
      // employName: '',
      talkName: '',
      // treeData: [],
      defaultExpandedKeys: [],
      defaultProps: {
        label: 'name',
        children: 'children',
        isLeaf: 'isLeaf',
      },
      activeName: '0',
      chat: {},

      personList: [],
      loading: false,
      queryChat: {},
    }
  },
  watch: {
    // employName(val) {
    //   this.$refs.tree.filter(val)
    // }
  },
  mounted() {
    // this.getTree()
    //this.getAmount()
  },
  methods: {
    chatFn(data) {
      this.queryChat = {
        fromId: this.fromId,
        receiveName: data.name,
        toList: data.receiver,
      }
    },
    groupFn(data) {
      this.queryChat = {
        // fromId: this.fromId,
        receiveName: data.name,
        roomId: data.receiver,
      }
    },
    // getTree() {
    //   apiOrg.getTree().then(({ data }) => {
    //     let treeData = (this.treeData = this.handleDepart(data))
    //     this.handleNodeClick(this.treeData[0], true)
    //   })
    // },
    tabClick(flag) {
      this.personList = []
      if (!this.fromId) {
        return
      }
      if (flag) {
        this.loading = true
      }
      if (this.activeName == 0) {
        api
          .getInternalChatList(this.fromId)
          .then(({ data }) => {
            this.loading = false
            this.personList = data
          })
          .catch((err) => {
            this.loading = false
          })
      } else if (this.activeName == 1) {
        api
          .getExternalChatList(this.fromId)
          .then(({ data }) => {
            this.loading = false
            this.personList = data
          })
          .catch((err) => {
            this.loading = false
          })
      } else {
        api
          .getGroupChatList(this.fromId)
          .then(({ data }) => {
            this.loading = false
            this.personList = data
          })
          .catch((err) => {
            this.loading = false
          })
      }
    },
    filterNode(value, data) {
      console.log(value, data)
      if (!value) return true
      return data.name.indexOf(value) !== -1
    },
    loadNode(node, resolve) {
      if (node.level == 0) {
        apiOrg.getDeptTree().then(({ data }) => {
          let treeData = this.treeFormat(this.handleDepart(data))
          // this.handleNodeClick(this.treeData[0], true)
          treeData[0] && (this.defaultExpandedKeys = [treeData[0].id])
          resolve(treeData)
        })
      } else {
        if (node.data.userId) {
          resolve([])
        } else {
          let querys = {
            pageNum: '1',
            pageSize: '999',
            isActivate: '',
            deptId: node.data.id,
          }
          apiOrg.getDeptUser(querys).then(({ rows }) => {
            // if (!data.children) {
            //   data['children'] = []
            // }
            // data.children.push(...rows)
            // let arr = node.data.children ? node.data.children.concat(rows || []) : rows || []
            let arr = this.handleUser(rows)
            node.data.children && arr.push(...node.data.children)
            arr.forEach((element) => {
              element.isLeaf = !!element.userId
            })
            resolve(arr)
          })
        }
      }
    },
    getDeptUser() {
      if (!this.keywords) return
      this.searchResult = []
      apiOrg
        .getDeptUser({
          // deptId: this.defaultExpandedKeys[0],
          userName: this.keywords,
        })
        .then((res) => {
          this.searchResult = this.handleUser(res.rows)
        })
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
    handleUser(data) {
      return data.map((i) => {
        if (i.userName) {
          i.userId = i.weUserId
          i.name = i.userName
        }
        return i
      })
    },
    handleDepart(data) {
      return data.map((i) => {
        if (i.deptId) {
          // i.userId = i.deptId
          i.name = i.deptName
          i.id = i.deptId
          i.isParty = true
        }
        return i
      })
    },
    handleNodeClick(data) {
      if (!data.userId) {
      } else {
        this.talkName = data.name
        this.fromId = data.userId
        this.tabClick()

        this.queryChat = {
          fromId: data.userId,
        }
      }
    },
  },
}
</script>
<style lang="scss" scoped>
::v-deep.el-tabs__nav-scroll {
  padding-left: 15px;
}

::v-deep .el-tabs__header {
  margin: 0;
}
.employ {
  .el-tabs {
    background: var(--bg-white);
  }
  .name {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 10px;
  }
  .ct_box {
    border-radius: 5px;
    background: var(--bg-white);
    height: calc(100vh - 286px);
    padding: 20px;
    overflow-y: auto;
    text-align: center;

    ::-webkit-scrollbar {
      display: none;
    }
  }

  .customer-li {
    padding: 10px;
    text-align: left;
    cursor: pointer;
    border-bottom: 1px solid var(--border-black-10);

    &:hover {
      background: var(--bg-black-10);
    }

    img {
      width: 40px;
    }
    &.active {
      background: var(--color-light-10);
    }
  }
}
</style>
