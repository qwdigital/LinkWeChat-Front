<script>
import {
  getSummary,
  getFollowUpRecord,
  getCustomerInfoByUserId,
  getRecordList,
  getFieldFn,
  orderDetail,
  orderList,
  orderStatus,
} from '@/api/customer'
import { dictTrackState } from '@/utils/dictionary'
import record from './record'
import RecordTable from './record-table'
import Detail from './detail'
import chatListClassTab from './chatListClassTab.vue'
export default {
  name: '',
  props: {
    stageList: {
      type: Array,
      default: [],
    },
    // 当前跟进人id
    userId: {
      type: String,
      default: '',
    },
    trackUsers: {
      type: Array,
      default: [],
    },
  },
  components: {
    record,
    RecordTable,
    Detail,
    chatListClassTab,
  },
  data() {
    return {
      portrayalSum: { companyTags: [], personTags: [], trackStates: [], trackUsers: [] }, // 客户画像汇总
      trajectoryType: {
        0: '全部',
        1: '客户动态',
        2: '员工动态',
        3: '互动动态',
        4: '商机阶段',
      },
      recod: [],
      active: '0',
      openedTabs: ['0'],
      openTrack: ['0'],
      lastSyncTime: null,
      dictTrackState,
      fieldList: [],
      stage: [],
      activeName: 'first',
      query: {
        pageNum: 1,
        pageSize: 10,
        orderStatus: '',
      },
      orderStateList: [],
      loading: false,
      total: 0,
      list: [],
      visible: false,
      orderId: undefined,
      chatTab: [
        { checked: true, lable: '全部', type: 'all' },
        { checked: false, lable: '图片&视频', type: 'image,video' },
        { checked: false, lable: '文件', type: 'file' },
        { checked: false, lable: '链接', type: 'link' },
        { checked: false, lable: '语音', type: 'voice,meeting_voice_call' },
      ],
      queryChat: {},
      tabType: 'all',
    }
  },
  computed: {},
  watch: {
    stageList: {
      deep: true,
      immediate: true,
      handler(val) {
        if (val) {
          this.stage = val
        }
      },
    },
  },
  created() {
    this.userId ? this.getCustomerInfoByUserId() : this.getSummary()
    this.getOrderStatus()
    this.getList()
    this.getChatList()
  },
  mounted() {},
  methods: {
    resetFn() {
      ;(this.query = {
        pageNum: 1,
        pageSize: 10,
        orderStatus: '',
      }),
        this.getList()
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    getList() {
      this.loading = true
      this.query.userId = this.userId
      this.query.externalUserid = this.$route.query.externalUserid
      orderList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = Number(total)
          this.loading = false
        })
        .catch(() => {})
    },
    getOrderStatus() {
      orderStatus().then((res) => {
        this.orderStateList = res.data
      })
    },
    getChatList() {
      this.queryChat = { fromId: this.userId, toList: this.$route.query.externalUserid }
    },
    setList(key) {
      let order = 0
      this.stage.forEach((dd, index) => {
        if (dd.stageVal == key) {
          order = index
        }
      })
      return order + 1
    },
    setActive(key) {
      let arr = this.stage.map((dd) => {
        return dd.stageState == 2
      })
      return arr.length + 2
    },
    /**
     *客户画像汇总
     * @param {*}
     * externalUserid	是	当前客户id
     */
    getSummary() {
      getSummary(this.$route.query).then(({ data }) => {
        //          {
        //   'companyTags':[{ //企业标签
        //      'userName':'',//添加人
        //      'tagsNames':'',//标签名多个标签使用逗号隔开
        //      'tagIds':''//多个标签id使用逗号隔开
        // }],
        // 'personTags':[{ //个人标签
        //      'userName':'',//添加人
        //      'tagsNames':'',//标签名多个标签使用逗号隔开
        //      'tagIds':''//多个标签id使用逗号隔开
        // }],
        // 'trackStates':[{
        //       'userName':'',//跟进人
        //       'trackStateList':[{ //跟进状态列表
        //       'trackState':'',//跟进状态
        //       'trackTime':''//跟进时间
        // }]
        // }]
        // }
        this.portrayalSum = data
      })
    },
    /**
     *客户画像单个跟进人
     */
    getCustomerInfoByUserId() {
      getCustomerInfoByUserId({
        externalUserid: this.$route.query.externalUserid,
        weUserId: this.userId,
      }).then(({ data }) => {
        this.portrayalSum = data
        getFieldFn({
          externalUserId: this.$route.query.externalUserid,
          weUserId: this.userId,
        }).then((dd) => {
          // this.fieldList = dd.data
          this.setData(dd.data)
        })
      })
    },
    setData(data) {
      let arr = data
      arr.forEach((dd, index) => {
        if (dd.isDefault == 0) {
          let obj = this.getEditValue(dd)
          let ff = { ...dd, ...obj }
          arr[index] = ff
        }
      })
      this.fieldList = arr
    },
    getEditValue(data) {
      let obj = {
        value: data.type !== 3 ? '' : data.typeSub == 1 ? '' : [],
      }
      this.portrayalSum.weCustomerInfoExpands &&
        this.portrayalSum.weCustomerInfoExpands.forEach((dd, index) => {
          if (dd.fieldTemplateId === data.id) {
            // dd.id
            if (dd.fieldCustomerInfoVal && dd.fieldCustomerInfoVal.length) {
              if (data.type !== 3) {
                obj.value = dd.fieldCustomerInfoVal[0].infoVal
              } else {
                obj.value = dd.fieldCustomerInfoVal.map((item) => {
                  return item.infoVal
                })
                if (data.typeSub == 1) {
                  obj.value = obj.value[0]
                }
              }
            }
          }
        })
      return obj
    },
    changeTab(tab) {
      this.openedTabs.includes(tab.index) || this.openedTabs.push(tab.index)
    },
    // changeTrack(type) {
    //   this.openTrack.includes(type) || this.openTrack.push(type)
    //   this.active = type
    // },
    // sync() {
    //   this.$refs['record'][this.active].sync()
    // },
    // 根据生日计算年龄
    jsGetAge(strBirthday) {
      if (!strBirthday) {
        return '无'
      }
      let returnAge
      let strBirthdayArr = strBirthday.split('-')
      let birthYear = strBirthdayArr[0]
      let birthMonth = strBirthdayArr[1]
      let birthDay = strBirthdayArr[2]
      let d = new Date()
      let nowYear = d.getFullYear()
      let nowMonth = d.getMonth() + 1
      let nowDay = d.getDate()

      if (nowYear == birthYear) {
        returnAge = 0 //同年 则为0岁
      } else {
        let ageDiff = nowYear - birthYear //年之差
        if (ageDiff > 0) {
          if (nowMonth == birthMonth) {
            let dayDiff = nowDay - birthDay //日之差
            if (dayDiff < 0) {
              returnAge = ageDiff - 1
            } else {
              returnAge = ageDiff
            }
          } else {
            let monthDiff = nowMonth - birthMonth //月之差
            if (monthDiff < 0) {
              returnAge = ageDiff - 1
            } else {
              returnAge = ageDiff
            }
          }
        } else {
          returnAge = -1 //返回-1 表示出生日期输入错误 晚于今天
        }
      }
      return returnAge //返回周岁年龄
    },
    getDetail(id) {
      this.visible = true
      this.orderId = id
    },
    chatTabClick(i, type) {
      this.tabType = type
      this.chatTab = this.chatTab.map((item, j) => {
        item.checked = false
        if (i === j) {
          item.checked = true
        }
        return item
      })
    },
  },
}
</script>

<template>
  <div>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-tabs v-model="activeName" @tab-click="handleClick">
          <el-tab-pane label="资料" name="first">
            <template v-if="userId">
              <!-- <el-card class="mb10" shadow="never">
              <template #header><div class="card-title">共同群聊</div></template>
              <template v-if="portrayalSum.commonGroupChat">
                <el-tag
                  type="info"
                  v-for="(unit, unique) in portrayalSum.commonGroupChat.split(',')"
                  :key="unique"
                >
                  {{ unit }}
                </el-tag>
              </template>
              <div v-else class="g-tip-color ac">暂无数据</div>
            </el-card> -->

              <el-card class="mb10" shadow="never">
                <template #header><div class="card-title">详细资料</div></template>
                <div style="max-height: 450px; overflow: hidden auto">
                  <el-row :gutter="20" type="type" class="pad10" justify="space-between" style="flex-wrap: wrap">
                    <template v-for="(item, index) in fieldList" :key="index">
                      <template v-if="!['address', 'customerFullName'].includes(item.labelVal)">
                        <el-col :span="12" v-if="item.isDefault == 1">
                          <!-- <el-row class="baseinfo-row" v-if="item.labelVal == 'customerFullName'">
                          <!- 姓名 ->
                          <el-col :span="6">{{ item.labelName }}</el-col>
                          <el-col :span="18">{{ portrayalSum.customerFullName || '无' }}</el-col>
                        </el-row> -->
                          <el-row class="baseinfo-row" v-if="item.labelVal == 'remarkMobiles'">
                            <!-- 手机号 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.phone || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'age'">
                            <!-- 年龄 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ jsGetAge(portrayalSum.birthday) }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'birthday'">
                            <!-- 生日 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.birthday || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'email'">
                            <!-- 邮箱 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.email || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'area'">
                            <!-- 地址 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.address || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'qq'">
                            <!-- QQ -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.qq || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'position'">
                            <!-- 职业 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.position || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'remarkCorpName'">
                            <!-- 公司 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.corpName || '无' }}</el-col>
                          </el-row>
                          <el-row class="baseinfo-row" v-else-if="item.labelVal == 'otherDescr'">
                            <!-- 其他描述 -->
                            <el-col :span="6">{{ item.labelName }}</el-col>
                            <el-col :span="18">{{ portrayalSum.otherDescr || '无' }}</el-col>
                          </el-row>
                        </el-col>
                        <el-col :span="12" v-else>
                          <template v-if="item.type !== 3">
                            <el-row class="baseinfo-row">
                              <el-col :span="6">{{ item.labelName }}</el-col>
                              <el-col :span="18">
                                {{ item.value || '无' }}
                              </el-col>
                            </el-row>
                          </template>
                          <template v-else>
                            <template v-if="item.typeSub == 1">
                              <el-row class="baseinfo-row">
                                <el-col :span="6">{{ item.labelName }}</el-col>
                                <el-col :span="18">
                                  {{ item.value || '无' }}
                                </el-col>
                              </el-row>
                            </template>
                            <template v-else>
                              <el-row class="baseinfo-row">
                                <el-col :span="6">{{ item.labelName }}</el-col>
                                <el-col :span="18">
                                  {{ item.value.join(',') || '无' }}
                                </el-col>
                              </el-row>
                            </template>
                          </template>
                        </el-col>
                      </template>
                    </template>
                  </el-row>
                </div>
              </el-card>
            </template>
          </el-tab-pane>
          <el-tab-pane label="跟进" name="second">
            <el-card class="mb10" shadow="never">
              <template #header><div class="card-title">商机阶段</div></template>
              <template v-if="trackUsers && trackUsers.length">
                <div v-for="(item, index) of trackUsers" :key="index" :class="['flex aic', index && 'mt20']">
                  汇总的场景显示名字
                  <template v-if="!userId">
                    <div class="name oe g-bg-lg">{{ item.userName }}</div>
                  </template>
                  <template v-if="item.trackState === 1">
                    <el-steps style="flex: auto" :active="1">
                      <el-step title="待跟进"></el-step>
                    </el-steps>
                  </template>
                  <template v-else-if="item.trackState === 3 || item.trackState === 4 || item.trackState === 5">
                    <el-steps style="flex: auto" :active="setActive(item.trackState)">
                      <el-step title="待跟进"></el-step>
                      <template v-for="(data, or) in stage">
                        <el-step :title="data.stageKey" :key="or" v-if="data.stageState == 2"></el-step>
                      </template>
                      <template v-for="(data, or) in stage">
                        <el-step :title="data.stageKey" :key="or" v-if="item.trackState == data.stageVal"></el-step>
                      </template>
                    </el-steps>
                  </template>
                  <template v-else-if="item.trackState">
                    <el-steps style="flex: auto" :active="setList(item.trackState)">
                      <template v-for="(data, or) in stage">
                        <el-step :title="data.stageKey" :key="or" v-if="setList(item.trackState) <= or + 1"></el-step>
                      </template>
                    </el-steps>
                  </template>
                  <div v-else class="g-tip-color ac">暂无数据</div>
                </div>
              </template>
              <div v-else class="g-tip-color ac">暂无数据</div>
            </el-card>

            <el-card shadow="never">
              <template #header><div class="card-title">跟进记录</div></template>
              <!-- 单个人的场景 -->
              <record-table v-if="userId" :stageList="stage" :userId="userId"></record-table>
              <!-- 汇总的场景 -->
              <el-tabs v-else-if="trackUsers && trackUsers.length" model-value="0" @tab-click="changeTab">
                <el-tab-pane v-for="(item, index) in trackUsers" :key="index" :label="item.userName">
                  <record-table
                    :stageList="stage"
                    v-if="openedTabs.includes(index + '')"
                    :userId="item.trackUserId"></record-table>
                </el-tab-pane>
              </el-tabs>
              <div v-else class="g-tip-color ac">暂无数据</div>
            </el-card>
          </el-tab-pane>
          <el-tab-pane label="订单" name="third">
            <el-form :inline="true" label-width="80px" label-position="left" class="top-search mt20">
              <el-form-item label="" label-width="0px">
                <el-select v-model="query.orderStatus" :popper-append-to-body="false">
                  <el-option label="全部状态" value=""></el-option>
                  <el-option
                    :label="item"
                    :value="item"
                    v-for="(item, index) in orderStateList"
                    :key="index"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label-width="0">
                <el-button type="primary" @click="search">查询</el-button>
                <el-button @click="resetFn">清空</el-button>
                <!-- <el-button @click="getDetail('1694259619920498688')">详情</el-button> -->
              </el-form-item>
            </el-form>
            <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange" style="width: 100%">
              <el-table-column label="商品名称" align="center" min-width="100" prop="productName" show-overflow-tooltip>
                <template #default="{ row }">
                  <div class="flex">
                    <el-image :src="row.productUrl" class="code-image"></el-image>
                    <span class="code-content">{{ row.productName }}</span>
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="商品数量" align="center" min-width="120" prop="amount" show-overflow-tooltip />
              <el-table-column label="订单状态" align="center" prop="orderStatus" width="180"></el-table-column>
              <el-table-column label="订单金额(元)" align="center" prop="totalPrice" width="180"></el-table-column>
              <el-table-column label="购买人/下单时间" align="center" min-width="100" show-overflow-tooltip>
                <template #default="{ row }">
                  {{ row.purchaser }}
                  {{ row.orderTime }}
                </template>
              </el-table-column>
              <el-table-column label="操作" align="center" fixed="right" width="180">
                <template #default="{ row }">
                  <el-button text @click="getDetail(row.id)">详情</el-button>
                </template>
              </el-table-column>
            </el-table>
            <pagination
              :total="total"
              v-model:page="query.pageNum"
              v-model:limit="query.pageSize"
              @pagination="getList()" />
            <Detail :visible="visible" @close="visible = false" :id="orderId" />
          </el-tab-pane>
          <el-tab-pane label="会话" name="fourth">
            <div class="flex track-tab-wrap mb15">
              <div
                :class="['track-tab', item.checked && 'active']"
                v-for="(item, i) in chatTab"
                :key="i"
                @click="chatTabClick(i, item.type)">
                {{ item.lable }}
              </div>
            </div>
            <chatListClassTab :queryChat="queryChat" :type="tabType"></chatListClassTab>
          </el-tab-pane>
        </el-tabs>

        <!-- <div class="left">
          <el-card class="mb10" shadow="never">
            <template #header><div class="card-title">企业标签</div></template>
            <template v-if="portrayalSum.companyTags && portrayalSum.companyTags.length">
              <div
                v-for="(item, index) of portrayalSum.companyTags"
                :key="index"
                :class="['flex  ait', index && 'mt20']"
              >
                汇总的场景显示名字
                <template v-if="!userId">
                  <div class="name oe g-bg-lg">{{ item.userName }}</div>
                </template>
                <div v-if="item.tagNames" class="gap10">
                  <el-tag v-for="(unit, unique) in item.tagNames.split(',')" :key="unique">{{
                    unit
                  }}</el-tag>
                </div>
                <div v-else class="g-tip-color ac">暂无标签</div>
              </div>
            </template>
            <div v-else class="g-tip-color ac">暂无标签</div>
          </el-card>

          <el-card class="mb10" shadow="never">
            <template #header><div class="card-title">个人标签</div></template>
            <template v-if="portrayalSum.personTags && portrayalSum.personTags.length">
              <div
                v-for="(item, index) of portrayalSum.personTags"
                :key="index"
                :class="['flex aic', index && 'mt20']"
              >
                汇总的场景显示名字
                <template v-if="!userId">
                  <div class="name oe g-bg-lg">{{ item.userName }}</div>
                </template>
                <div v-if="item.tagNames" class="gap10">
                  <el-tag v-for="(unit, unique) in item.tagNames.split(',')" :key="unique">{{
                    unit
                  }}</el-tag>
                </div>
                <div v-else class="g-tip-color ac">暂无标签</div>
              </div>
            </template>
            <div v-else class="g-tip-color ac">暂无标签</div>
          </el-card>
        </div> -->
      </el-col>

      <!-- <el-col :span="10">
        <el-card>
          <template #header>
            <div class="fcbw">
              <span class="card-title" @click="sync">客户轨迹</span>
              <ButtonSync class="btn-sync" :lastSyncTime="lastSyncTime" @click="sync"
                >同步</ButtonSync
              >
            </div>
          </template>
          <div class="flex track-tab-wrap mb15">
            <div
              v-for="(value, type) of trajectoryType"
              :key="type"
              :class="['track-tab', type === active && 'active']"
              @click="changeTrack(type)"
            >
              {{ value }}
            </div>
          </div>
          <template v-for="(item, index) in openTrack" :key="index">
            <record
              ref="record"
              v-show="item === active"
              :userId="userId"
              :userIdAll="trackUsers.map((e) => e.trackUserId).join()"
              v-model:lastSyncTime="lastSyncTime"
              :trajectoryType="item == 0 ? null : item"
            ></record>
          </template>
        </el-card>
      </el-col> -->
    </el-row>
  </div>
</template>

<style lang="scss" scoped>
.track-tab-wrap {
  .track-tab {
    background: var(--bg-black-8);
    border-radius: 50px;
    padding: 5px 10px;
    cursor: pointer;
    & + .track-tab {
      margin-left: 30px;
    }
    &.active {
      background: var(--color);
      color: var(--font-white, #fff);
    }
  }
}
.content-box {
  width: 80%;
  border: 1px solid var(--bg-black-8);
}
.code-image {
  width: 50px;
  height: 50px;
}
.code-content {
  color: var(--font-black-7);
  font-size: 12px;
}

.name {
  width: 65px;
  flex: none;
  text-align: center;
  line-height: 24px;
  padding: 0 5px;
  margin-right: 10px;
  color: var(--font-white, #fff);
  border-radius: var(--border-radius-small);
}
.el-card {
  // .el-tag {
  //   margin-bottom: 5px;
  // }
  // .el-card {
  //   .el-tag {
  //     margin-bottom: 5px;
  //   }
  // }
  .track-tab-wrap {
    .track-tab {
      background: var(--bg-black-8);
      border-radius: 50px;
      padding: 5px 10px;
      cursor: pointer;
      & + .track-tab {
        margin-left: 10px;
      }
      &.active {
        background: var(--color);
        color: var(--font-white, #fff);
      }
    }
  }
  // .btn-sync {
  //   position: relative;
  //   float: right;
  //   top: -11px;
  // }
  .g-tip-color {
    flex: auto;
  }

  .baseinfo-row {
    position: relative;
    padding-left: 10px;
    line-height: 50px;
    .el-col {
      box-shadow: 0px 1px 0px 0px #f1f1f1;
      &:first-child {
        color: var(--font-black-6);
      }
    }
    &::before {
      content: '';
      position: absolute;
      top: 22.5px;
      left: 0;
      width: 5px;
      height: 5px;
      background: #76abf4;
      border-radius: 50%;
    }
    > .el-col:last-child {
      text-align: right;
    }
  }
}
</style>
