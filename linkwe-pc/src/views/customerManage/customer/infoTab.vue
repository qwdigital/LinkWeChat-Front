<script>
  import { getSummary, getFollowUpRecord, getCustomerInfoByUserId, getRecordList, getFieldFn } from '@/api/customer'
  import { dictTrackState } from '@/utils/dictionary'
  import record from './record'
  import RecordTable from './record-table'
  export default {
    name: '',
    props: {
      stageList: {
        type: Array,
        default: []
      },
      // 当前跟进人id
      userId: {
        type: String,
        default: ''
      },
      trackUsers: {
        type: Array,
        default: []
      }
    },
    components: {
      record,
      RecordTable
    },
    data() {
      return {
        portrayalSum: { companyTags: [], personTags: [], trackStates: [], trackUsers: [] }, // 客户画像汇总
        trajectoryType: {
          0: '全部',
          1: '客户动态',
          2: '员工动态',
          3: '互动动态',
          4: '商机阶段'
        },
        recod: [],
        active: '0',
        openedTabs: ['0'],
        openTrack: ['0'],
        lastSyncTime: null,
        dictTrackState,
        fieldList: [],
        stage: []
      }
    },
    computed: {},
    watch: {
      stageList: {
        immediate: true,
        handler(val) {
          if (val) {
            this.stage = val
          }
        }
      }
    },
    created() {
      this.userId ? this.getCustomerInfoByUserId() : this.getSummary()
    },
    mounted() {},
    methods: {
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
        getCustomerInfoByUserId({ externalUserid: this.$route.query.externalUserid, weUserId: this.userId }).then(
          ({ data }) => {
            this.portrayalSum = data
            getFieldFn({ externalUserId: this.$route.query.externalUserid, weUserId: this.userId }).then((dd) => {
              // this.fieldList = dd.data
              this.setData(dd.data)
            })
          }
        )
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
          value: data.type !== 3 ? '' : data.typeSub == 1 ? '' : []
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
      changeTrack(type) {
        this.openTrack.includes(type) || this.openTrack.push(type)
        this.active = type
      },
      sync() {
        this.$refs['record'][this.active].sync()
      },
      // 根据生日计算年龄
      jsGetAge(strBirthday) {
        if (strBirthday === null) {
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
      }
    }
  }
</script>

<template>
  <div>
    <el-row :gutter="10">
      <el-col :span="14">
        <div class="left">
          <el-card class="mb10" shadow="never">
            <div slot="header" class="card-title">企业标签</div>
            <template v-if="portrayalSum.companyTags && portrayalSum.companyTags.length">
              <div
                v-for="(item, index) of portrayalSum.companyTags"
                :key="index"
                :class="['flex ait', index && 'mt20']"
              >
                <!-- 汇总的场景显示名字 -->
                <template v-if="!userId">
                  <div class="name oe bglg">{{ item.userName }}</div>
                </template>
                <template v-if="item.tagNames">
                  <el-tag v-for="(unit, unique) in item.tagNames.split(',')" :key="unique">{{ unit }}</el-tag>
                </template>
                <div v-else class="g-tip-color ac">暂无标签</div>
              </div>
            </template>
            <div v-else class="g-tip-color ac">暂无标签</div>
          </el-card>

          <el-card class="mb10" shadow="never">
            <div slot="header" class="card-title">个人标签</div>
            <template v-if="portrayalSum.personTags && portrayalSum.personTags.length">
              <div v-for="(item, index) of portrayalSum.personTags" :key="index" :class="['flex aic', index && 'mt20']">
                <!-- 汇总的场景显示名字 -->
                <template v-if="!userId">
                  <div class="name oe bglg">{{ item.userName }}</div>
                </template>
                <template v-if="item.tagNames">
                  <el-tag v-for="(unit, unique) in item.tagNames.split(',')" :key="unique">{{ unit }}</el-tag>
                </template>
                <div v-else class="g-tip-color ac">暂无标签</div>
              </div>
            </template>
            <div v-else class="g-tip-color ac">暂无标签</div>
          </el-card>

          <template v-if="userId">
            <el-card class="mb10" shadow="never">
              <div slot="header" class="card-title">共同群聊</div>
              <template v-if="portrayalSum.commonGroupChat">
                <el-tag type="info" v-for="(unit, unique) in portrayalSum.commonGroupChat.split(',')" :key="unique">
                  {{ unit }}
                </el-tag>
              </template>
              <div v-else class="g-tip-color ac">暂无数据</div>
            </el-card>

            <el-card class="mb10" shadow="never">
              <div slot="header" class="card-title">详细资料</div>
              <el-row :gutter="20" type="type" class="pad10" justify="space-between">
                <div style="max-height: 450px; overflow: hidden auto;">
                  <template v-for="(item, index) in fieldList">
                    <el-col :span="12" v-if="item.isDefault == 1" :key="index">
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'remarkMobiles'">
                        <el-col :span="6">手机号</el-col>
                        <el-col :span="18">{{ portrayalSum.phone || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'age'">
                        <el-col :span="6">年龄</el-col>
                        <el-col :span="18">{{ jsGetAge(portrayalSum.birthday) }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'birthday'">
                        <el-col :span="6">生日</el-col>
                        <el-col :span="18">{{ portrayalSum.birthday || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'email'">
                        <el-col :span="6">邮箱</el-col>
                        <el-col :span="18">{{ portrayalSum.email || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'area'">
                        <el-col :span="6">地址</el-col>
                        <el-col :span="18">{{ portrayalSum.address || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'qq'">
                        <el-col :span="6">QQ</el-col>
                        <el-col :span="18">{{ portrayalSum.qq || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'position'">
                        <el-col :span="6">职业</el-col>
                        <el-col :span="18">{{ portrayalSum.position || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'remarkCorpName'">
                        <el-col :span="6">公司</el-col>
                        <el-col :span="18">{{ portrayalSum.corpName || '无' }}</el-col>
                      </el-row>
                      <el-row class="baseinfo-row" v-if="item.labelVal == 'otherDescr'">
                        <el-col :span="6">其他描述</el-col>
                        <el-col :span="18">
                          {{ portrayalSum.otherDescr || '无' }}
                        </el-col>
                      </el-row>
                    </el-col>
                    <el-col :span="12" v-else :key="index">
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
                </div>
              </el-row>
            </el-card>
          </template>

          <el-card class="mb10" shadow="never">
            <div slot="header" class="card-title">商机阶段</div>
            <template v-if="trackUsers && trackUsers.length">
              <div v-for="(item, index) of trackUsers" :key="index" :class="['flex aic', index && 'mt20']">
                <!-- 汇总的场景显示名字 -->
                <template v-if="!userId">
                  <div class="name oe bglg">{{ item.userName }}</div>
                </template>
                <template v-if="item.trackState === 1">
                  <el-steps style="flex: auto;" :active="1">
                    <el-step title="待跟进"></el-step>
                  </el-steps>
                </template>
                <template v-else-if="item.trackState === 3 || item.trackState === 4 || item.trackState === 5">
                  <el-steps style="flex: auto;" :active="setActive(item.trackState)">
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
                  <el-steps style="flex: auto;" :active="setList(item.trackState)">
                    <template v-for="(data, or) in stage">
                      <el-step :title="data.stageKey" :key="or" v-if="setList(item.trackState) <= or + 1"></el-step>
                    </template>
                  </el-steps>
                </template>
                  <!-- </el-steps> -->
                <!-- </template> -->
                <div v-else class="g-tip-color ac">暂无数据</div>
              </div>
            </template>
            <div v-else class="g-tip-color ac">暂无数据</div>
          </el-card>

          <el-card shadow="never">
            <div slot="header" class="card-title">跟进记录</div>
            <!-- 单个人的场景 -->
            <record-table v-if="userId" :stageList="stage" :userId="userId"></record-table>
            <!-- 汇总的场景 -->
            <el-tabs v-else-if="trackUsers && trackUsers.length" value="0" @tab-click="changeTab">
              <el-tab-pane v-for="(item, index) in trackUsers" :key="index" :label="item.userName">
                <record-table
                  :stageList="stage"
                  v-if="openedTabs.includes(index + '')"
                  :userId="item.trackUserId"
                ></record-table>
              </el-tab-pane>
            </el-tabs>
            <div v-else class="g-tip-color ac">暂无数据</div>
          </el-card>
        </div>
      </el-col>

      <el-col :span="10">
        <el-card>
          <div slot="header" class="fcbw">
            <span class="card-title" @click="sync">客户轨迹</span>

            <ButtonSync class="btn-sync" :lastSyncTime="lastSyncTime" @click="sync">同步</ButtonSync>
          </div>
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
          <template v-for="(item, index) in openTrack">
            <record
              ref="record"
              v-show="item === active"
              :key="index"
              :userId="userId"
              :userIdAll="trackUsers.map((e) => e.trackUserId).join()"
              :lastSyncTime.sync="lastSyncTime"
              :trajectoryType="item == 0 ? null : item"
            ></record>
          </template>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<style lang="scss" scoped>
  .name {
    width: 65px;
    flex: none;
    text-align: center;
    line-height: 24px;
    padding: 0 5px;
    margin-right: 10px;
    color: #fff;
    border-radius: var(--border-radius-small);
  }
  .el-card {
    .el-tag {
      margin-bottom: 5px;
    }
    .el-card {
      .el-tag {
        margin-bottom: 5px;
      }
    }
    .track-tab-wrap {
      .track-tab {
        background: #ddd;
        border-radius: 50px;
        padding: 5px 10px;
        cursor: pointer;
        & + .track-tab {
          margin-left: 10px;
        }
        &.active {
          background: var(--color);
          color: #fff;
        }
      }
    }
    .btn-sync {
      position: relative;
      float: right;
      top: -11px;
    }
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
          color: #999;
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
