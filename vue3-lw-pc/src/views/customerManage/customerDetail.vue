<script>
import { updateBirthday, getDetail, getSummary, getFollowUpRecord, getCustomerInfoByUserId } from '@/api/customer'
import { getList } from '@/api/salesCenter/businessConver.js'

import { dictAddType, dictJoinGroupType, dictTrackState } from '@/utils/dictionary'
import InfoTab from './customer/infoTab.vue'
import record from './customer/record'

export default {
  name: 'CustomerDetail',
  components: { InfoTab, record },
  data() {
    return {
      datePickerVisible: false,
      customer: {
        // weFlowerCustomerRels: [{}]
      },
      birthday: '',
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now()
        },
      },
      dictAddType,
      dictJoinGroupType,
      dictTrackState,

      active: '0',
      // openedTabs: ['0'],
      lastSyncTime: null,
      openTrack: ['0'],
      trajectoryType: {
        0: '全部',
        1: '客户动态',
        2: '员工动态',
        3: '互动动态',
        4: '商机阶段',
      },
    }
  },
  created() {
    dictAddType().then((res) => (this.dictAddType = res))
    this.getDetail()
    this.getStage()
  },
  methods: {
    getStage() {
      getList().then((res) => {
        this.stageList = res.data
      })
    },
    setValue(data) {
      let str = ''
      this.stageList.forEach((dd) => {
        if (dd.stageVal == data) {
          str = dd.stageKey
        }
      })
      return str
    },
    // updateBirthday() {
    //   if (!this.birthday || this.birthday == this.customer.birthday) {
    //     return
    //   }
    //   let data = {
    //     externalUserid: this.customer.externalUserid,
    //     birthday: this.birthday,
    //     firstUserId: this.customer.firstUserId
    //   }
    //   updateBirthday(data).then((response) => {
    //     this.msgSuccess('操作成功')
    //     // this.getDetail()
    //     this.customer['birthday'] = this.birthday
    //     // this.datePickerVisible = false
    //   })
    // },
    /**
     *客户详情基础(基础信息+社交关系)
     * @param {*}
     * externalUserid	是	当前客户id
     * userId	是	当前跟进人id
     */
    getDetail() {
      getDetail({ ...this.$route.query, delFlag: this.$route.query.isDelete ? 1 : 0 }).then(({ data }) => {
        data.companyTags && (data.companyTags = data.companyTags.split(','))
        this.customer = data

        // if (data.trackUsers && data.trackUsers.length === 1) {
        //   this.openedTabs = [data.trackUsers[0].trackUserId]
        // }
        this.birthday = data.birthday
      })
    },
    // changeTab(tab) {
    //   this.openedTabs.includes(tab.paneName) || this.openedTabs.push(tab.paneName)
    // },

    // remark(item) {
    //   return (
    //     item.remark ||
    //     this.customer.customerName + (item.remarkCorpName ? '-' + item.remarkCorpName : '')
    //   )
    // }
    changeTrack(type) {
      this.openTrack.includes(type) || this.openTrack.push(type)
      this.active = type
    },
    sync() {
      this.$refs['record'][this.active].sync()
    },
  },
}
</script>

<template>
  <div>
    <!-- <el-button slot="append" circle icon="el-icon-back" @click="$router.back()"></el-button>返回 -->
    <div class="g-card flex aic mb20">
      <el-image class="avatar" :src="customer.avatar" fit="fill"></el-image>
      <div class="ml10">
        <div>
          {{ customer.customerName + (customer.corpName ? '-' + customer.corpName : '') }}

          <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[customer.gender]]" />
        </div>
        <div class="mt10">
          <span :style="{ color: customer.customerType === 1 ? '#4bde03' : '#f9a90b' }">
            {{ { 1: '@微信', 2: '@企业微信' }[customer.customerType] }}
          </span>
        </div>
        <div class="mt10 gap10">
          <template v-if="customer.tagNames">
            <el-tag v-for="(unit, unique) in customer.tagNames.split(',')" :key="unique">
              {{ unit }}
            </el-tag>
          </template>
          <div v-else>暂无标签</div>
        </div>
      </div>
    </div>
    <div class="flex">
      <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
        <div class="g-card">
          <div class="g-card-title">社交关系</div>
          <el-tabs model-value="1">
            <el-tab-pane :label="`跟进员工(${customer.trackUsers ? customer.trackUsers.length : 0})`" name="1">
              <el-table :data="customer.trackUsers">
                <el-table-column label="员工" align="center" prop="userName" />
                <el-table-column prop="addMethod" label="添加方式" align="center">
                  <template #default="{ row }">{{ dictAddType[row.addMethod + ''] }}</template>
                </el-table-column>
                <el-table-column label="添加时间" align="center" prop="firstAddTime" />
                <el-table-column prop="trackState" label="商机阶段" align="center">
                  <template #default="{ row }">
                    <!-- <el-tag v-if="row.trackState" :type="dictTrackState[~~row.trackState + ''].color">
                  {{ dictTrackState[~~row.trackState + ''].name }}
                </el-tag> -->
                    <el-tag v-if="row.trackState">
                      {{ setValue(row.trackState) }}
                    </el-tag>
                  </template>
                </el-table-column>
              </el-table>
            </el-tab-pane>
            <el-tab-pane :label="`所在客群(${customer.groups ? customer.groups.length : 0})`" name="2">
              <el-table :data="customer.groups">
                <el-table-column label="群名" align="center" prop="groupName" />
                <el-table-column label="群主" align="center" prop="leaderName" />
                <el-table-column label="入群时间" align="center" prop="joinTime" />
                <el-table-column prop="joinScene" label="入群方式" align="center">
                  <template #default="{ row }">{{ dictJoinGroupType[row.joinScene + ''] }}</template>
                </el-table-column>
              </el-table>
            </el-tab-pane>
          </el-tabs>
        </div>

        <div class="g-card">
          <div class="g-card-title">客户画像</div>
          <el-tabs model-value="0">
            <!-- <el-tab-pane
              v-if="customer.trackUsers && customer.trackUsers.length > 1"
              label="客户画像汇总"
              lazy
              data-id="0"
            >
              <info-tab :stageList="stageList" :trackUsers="customer.trackUsers"></info-tab>
            </el-tab-pane> -->
            <el-tab-pane
              v-for="(item, index) of customer.trackUsers"
              :key="index"
              :label="item.userName"
              lazy
              :data-id="item.trackUserId">
              <info-tab :stageList="stageList" :userId="item.trackUserId"></info-tab>
            </el-tab-pane>
          </el-tabs>
        </div>
      </div>
      <div style="width: 425px; margin-top: 0">
        <el-card class="g-card" style="padding: 0">
          <template #header>
            <div class="g-card-title fcbw">
              <span class="card-title">客户轨迹</span>
              <ButtonSync class="btn-sync" :lastSyncTime="lastSyncTime" @click="sync">同步</ButtonSync>
            </div>
          </template>
          <div class="flex track-tab-wrap mb15">
            <!-- <div
              v-for="(value, type) of trajectoryType"
              :key="type"
              :class="['track-tab', type == active && 'active']"
              @click="changeTrack(type)"
            >
              {{ value }}
              {{ type }}
            </div> -->
            <el-select v-model="active" placeholder="请选择" @change="changeTrack">
              <el-option v-for="(value, type) of trajectoryType" :key="type" :label="value" :value="type"></el-option>
            </el-select>
          </div>
          <template v-for="(item, index) in openTrack" :key="index">
            <record
              ref="record"
              v-show="item === active"
              v-if="customer.trackUsers"
              :userId="userId"
              :userIdAll="customer.trackUsers.map((e) => e.trackUserId).join()"
              v-model:lastSyncTime="lastSyncTime"
              :trajectoryType="item == 0 ? null : item"></record>
          </template>
        </el-card>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.avatar {
  width: 80px;
  height: 80px;
  border-radius: var(--border-radius-big);
  flex: none;
}
.info-wrap {
  margin-left: 20px;
  .info {
    color: var(--font-black-7);
    line-height: 32px;
  }
}

.el-icon-s-custom {
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
.g-card-title {
  margin-bottom: 5px;
}
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
</style>
