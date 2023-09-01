<template>
  <div class="customer">
    <el-row type="flex" align="center" :gutter="10">
      <el-col :span="6">
        <div class="ct_box">
          <div class="name pd15">客户列表（{{ customerTotal }}）</div>
          <el-input
            class="mb10"
            placeholder="搜索客户名称"
            clearable
            v-model="customerQuery.name"
            @keyup.enter="getCustomerList(1)"
          >
            <template #append><el-button icon="el-icon-search" @click="getCustomerList(1)"></el-button></template>
          </el-input>
          <div v-loading="customerLoading">
            <ul v-if="init" v-infinite-scroll="getCustomerList" infinite-scroll-distance="1" class="customer-wrap">
              <template v-if="customerList.length">
                <el-row
                  v-for="(item, index) in customerList"
                  :key="index"
                  tag="li"
                  @click="choiceCustomer(item, index)"
                  :class="['customer-li', { active: index == personIndex }]"
                  :gutter="20"
                  type="flex"
                  align="middle"
                >
                  <el-col :span="4">
                    <img v-if="item.avatar" :src="item.avatar" alt="头像" />
                  </el-col>
                  <el-col :span="10" v-if="item" class="toe">
                    <span style="line-height: 40px;">{{ item.customerName }}</span>
                  </el-col>
                  <el-col :span="10" class="ar">
                    <span :style="{ color: item.customerType === 1 ? '#4bde03' : '#f9a90b' }">
                      {{ { 1: '@微信', 2: '@企业微信' }[item.customerType] }}
                    </span>
                    <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[item.gender]]"></el-icon-Avatar>
                  </el-col>
                </el-row>
                <div class="ac mt10 mb15">
                  {{ customerList.length !== customerTotal ? '下拉加载更多' : '看到底了～' }}
                </div>
              </template>
              <el-empty v-else :image-size="100"></el-empty>
            </ul>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="ct_box">
          <template v-if="talkName">
            <div class="name pd15">{{ talkName }}</div>
            <el-input
              class="mb5"
              placeholder="搜索联系人"
              prefix-icon="el-icon-search"
              v-model="chatContent"
              @keyup.enter="getChatList()"
            ></el-input>
            <el-tabs v-model="activeName" @tab-change="getChatList()">
              <el-tab-pane label="单聊" name="0">
                <userList
                  v-if="activeName == 0"
                  :personList="personList"
                  :loading="loading"
                  @chatFn="chatFn"
                ></userList>
              </el-tab-pane>
              <el-tab-pane label="群聊" name="2">
                <grouplist
                  v-if="activeName == 2"
                  :personList="personList"
                  :loading="loading"
                  @groupFn="groupFn"
                ></grouplist>
              </el-tab-pane>
            </el-tabs>
          </template>
          <el-empty v-else :image-size="100" description="请选择客户"></el-empty>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="ct_box">
          <chatListClass v-show="queryChat.receiveName" :queryChat="queryChat"></chatListClass>
          <el-empty v-if="!queryChat.receiveName" :image-size="100" description="请选择联系人"></el-empty>
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  import chatListClass from './component/chatListClass.vue'
  import userList from './component/userList.vue'
  import grouplist from './component/groupList.vue'
  import * as api from '@/api/conversation/content.js'
  import * as apiCustomer from '@/api/customer/index'
  export default {
    components: {
      userList,
      grouplist,
      chatListClass
    },
    data() {
      return {
        init: true,
        customerLoading: false,
        customerQuery: {
          pageNum: 1,
          pageSize: 10,
          name: '',
          noRepeat: true
        },
        customerList: [],
        customerTotal: 0,

        talkName: '',
        chatContent: '',
        personIndex: undefined,
        activeName: '0',
        personList: [],
        loading: false,
        fromId: '',

        queryChat: {}
      }
    },
    created() {
      // this.customerList()
    },
    methods: {
      chatFn(data) {
        this.queryChat = {
          fromId: this.fromId,
          receiveName: data.name,
          toList: data.receiver
        }
      },
      groupFn(data) {
        console.log(data.name)
        this.queryChat = {
          // fromId: this.fromId,
          receiveName: data.name,
          roomId: data.receiver
        }
      },
      choiceCustomer(data, index) {
        this.personIndex = index
        this.talkName = data.customerName
        this.fromId = data.externalUserid
        this.getChatList()
      },
      getChatList(flag) {
        if (!this.fromId) {
          return
        }
        if (flag) {
          this.loading = true
        }
        this.personList = []
        if (this.activeName == '0') {
          api
            .selectAloneChatList({
              fromId: this.fromId,
              contact: this.chatContent
            })
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
      getCustomerList(page) {
        if (!this.customerLoading) {
          if (page) {
            this.init = false
            this.customerQuery.pageNum = page
            this.customerList = []
            this.customerTotal = 0
          }
          if (this.customerList.length < this.customerTotal) {
            this.customerLoading = true
            this.customerQuery.pageNum++
            apiCustomer.getListNew(this.customerQuery).then((res) => {
              this.customerList.push(...res.rows)
              this.customerTotal = ~~res.total
              this.customerLoading = false
            })
          } else {
            if (this.customerTotal === 0) {
              this.customerLoading = true
              this.customerQuery.pageNum = 1
              apiCustomer.getListNew(this.customerQuery).then((res) => {
                this.init = true
                this.customerList = res.rows
                this.customerTotal = ~~res.total
                this.customerLoading = false
              })
            }
          }
        }
      }
    }
  }
</script>
<style lang="scss" scoped>
  ::v-deep.el-tabs__nav-scroll {
    padding-left: 15px;
  }

  .customer {
    // background: var(--bg-black-11);
    text-align: center;

    .el-tabs {
      background: var(--bg-white);
    }
    ::v-deep .el-tabs__header {
      margin: 0;
    }

    .name {
      font-size: 16px;
      font-weight: 600;
      margin-bottom: 20px;
    }
    .ct_box {
      height: calc(100vh - 197px);
      border-radius: 5px;
      background: var(--bg-white);
      padding: 20px;
    }

    .customer-wrap {
      position: relative;
      height: calc(100vh - 320px);
      overflow-y: auto;
      overflow-x: hidden;
      color: var(--font-black-6);
      text-align: center;
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
  }

  .el-icon-Avatar {
    font-size: 16px;
    margin-left: 4px;
    color: var(--font-black-6);
    &.man {
      color: #13a2e8;
    }
    &.woman {
      color: #f753b2;
    }
  }

  .userList {
    height: calc(100vh - 328px);
  }
</style>
