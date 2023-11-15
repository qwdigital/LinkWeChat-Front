<template>
  <div>
    <!-- 分享统计 -->
    <div class="flex">
      <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
        <div class="g-card">
          <div class="g-card-title">直播预约人数</div>
          <div class="fxbw">
            <div>
              <div style="display: flex">
                <span class="titleColor">发送员工：</span>
                <div v-if="topData.sendWeuserNames === null">
                  <span>{{ targetType === 1 ? '全部员工' : '全部群主' }}</span>
                </div>
                <div v-else>
                  <el-popover
                    placement="bottom"
                    trigger="hover"
                    :disabled="topData.sendWeuserNames ? topData.sendWeuserNames.length < 3 : false">
                    <div>
                      <el-tag v-for="(unit, unique) in topData.sendWeuserNames" :key="unique">
                        {{ unit }}
                      </el-tag>
                    </div>
                    <template #reference>
                      <div>
                        <el-tag v-for="(item, index) in sendWeuserNames" :key="index">{{ item }}</el-tag>
                        <el-tag v-if="topData.sendWeuserNames && topData.sendWeuserNames.length > 2">...</el-tag>
                      </div>
                    </template>
                  </el-popover>
                </div>
              </div>
              <div class="mt10">
                <div style="display: flex">
                  <span class="titleColor">{{ targetType === 1 ? '发送客户：' : '发送客群：' }}</span>
                  <div v-if="topData.tagNamesOrGroupOwners === null">
                    <span>{{ targetType === 1 ? '全部客户' : '全部群主' }}</span>
                  </div>
                  <div v-else>
                    <el-popover
                      placement="bottom"
                      trigger="hover"
                      :disabled="topData.tagNamesOrGroupOwners ? topData.tagNamesOrGroupOwners.length < 3 : false">
                      <div>
                        <el-tag v-for="(unit, unique) in topData.tagNamesOrGroupOwners" :key="unique">
                          {{ unit }}
                        </el-tag>
                      </div>
                      <template #reference>
                        <div>
                          <el-tag v-for="(item, index) in tagNamesOrGroupOwners" :key="index">
                            {{ item }}
                          </el-tag>
                          <el-tag v-if="topData.tagNamesOrGroupOwners && topData.tagNamesOrGroupOwners.length > 2">
                            ...
                          </el-tag>
                        </div>
                      </template>
                    </el-popover>
                  </div>
                </div>
              </div>
            </div>
            <div class="numStyle">{{ topData.subscribeCount }}</div>
          </div>
        </div>
        <div class="g-card">
          <el-button type="primary" @click="oneStep" class="fr" :loading="stepLoading">同步</el-button>
          <el-tabs v-model="activeName">
            <el-tab-pane label="员工详情" name="first">
              <div v-if="activeName === 'first'">
                <CardGroupIndex :data="cardData"></CardGroupIndex>
                <el-form label-position="left" inline label-width="70px">
                  <el-form-item label="">
                    <el-input
                      placeholder="请输入员工名称"
                      v-model="firstQuery.userName"
                      style="width: 260px"></el-input>
                  </el-form-item>
                  <el-form-item label="">
                    <el-button type="primary" @click="getFirstList(0)">查询</el-button>
                    <el-button @click="resetFirstQuery">重置</el-button>
                  </el-form-item>
                </el-form>
                <el-table class="mt0" v-loading="loading" :data="firstList">
                  <el-table-column label="发送员工" align="center" show-overflow-tooltip>
                    <template #default="scope">
                      {{ coverContent(scope.row.userName) }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    :label="targetType === 1 ? '预计发送客户' : '预计发送客群'"
                    align="center"
                    show-overflow-tooltip>
                    <template #default="scope">
                      {{ coverContent(scope.row.estimateSendNumber) }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    :label="targetType === 1 ? '实际发送客户' : '实际发送客群'"
                    align="center"
                    show-overflow-tooltip>
                    <template #default="scope">
                      {{ coverContent(scope.row.actualSendNumber) }}
                    </template>
                  </el-table-column>
                </el-table>
                <div class="bottom">
                  <pagination
                    :total="firstTotal"
                    v-model:page="firstQuery.pageNum"
                    v-model:limit="firstQuery.pageSize"
                    @pagination="getFirstList()" />
                </div>
              </div>
            </el-tab-pane>
            <el-tab-pane :label="targetType === 1 ? '客户详情' : '客群详情'" name="second">
              <div v-if="activeName === 'second'">
                <CardGroupIndex :data="targetType === 1 ? customerCardData : groupCardData"></CardGroupIndex>
                <el-form label-position="left" inline label-width="80px">
                  <el-form-item label-width="0">
                    <el-input
                      :placeholder="targetType === 1 ? '请输入员工名称' : '请输入群主'"
                      v-model="query.userName"
                      style="width: 260px"></el-input>
                  </el-form-item>
                  <el-form-item label-width="0">
                    <el-select v-model="query.sendState" placeholder="请选择送达状态">
                      <el-option
                        v-for="item in status"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"></el-option>
                    </el-select>
                  </el-form-item>
                  <el-form-item label-width="0">
                    <el-button type="primary" @click="getList(0)">查询</el-button>
                    <el-button @click="resetQuery">重置</el-button>
                  </el-form-item>
                </el-form>
                <el-table class="mt0" v-loading="loading" :data="secondList">
                  <el-table-column
                    :label="targetType === 1 ? '客户名称' : '客群名称'"
                    align="center"
                    show-overflow-tooltip>
                    <template #default="scope">
                      {{ coverContent(scope.row.customerOrGroupName) }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    :label="targetType === 1 ? '所属员工' : '所属群主'"
                    align="center"
                    show-overflow-tooltip>
                    <template #default="scope">
                      {{ coverContent(scope.row.userName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="送达时间" prop="updateTime" align="center"></el-table-column>
                  <el-table-column label="送达状态" align="center">
                    <template #default="scope">
                      {{ dealState(scope.row.sendState) }}
                    </template>
                  </el-table-column>
                </el-table>
                <pagination
                  :total="secondTotal"
                  v-model:page="query.pageNum"
                  v-model:limit="query.pageSize"
                  @pagination="getList()" />
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
      </div>
      <div class="g-card" style="width: 425px; margin-top: 0">
        <PreviewInPhone
          :templateInfo="templateInfo"
          :originList="topData.weLiveAttachments"
          :liveUrl="topData.shareOrJoinUrl" />
      </div>
    </div>
  </div>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import {
  detailLive,
  userDetail,
  customerDetail,
  userDetailTab,
  customerDetailTab,
  liveOneStep,
} from '@/api/operateCenter/liveBroadcast'

export default {
  components: {
    PreviewInPhone,
  },
  data() {
    return {
      topData: '',
      activeName: 'first',
      cardData: [
        {
          title: '应执行员工数 ',
          value: 0,
          noArrow: true,
        },
        {
          title: '已发送员工数 ',
          value: 0,
        },
        {
          title: '未发送员工数 ',
          value: 0,
        },
      ],
      customerCardData: [
        {
          title: '目标触达客户数 ',
          value: 0,
          noArrow: true,
        },
        {
          title: '已送达客户数 ',
          value: 0,
        },
        {
          title: '未送达客户数 ',
          value: 0,
        },
      ],
      groupCardData: [
        {
          title: '目标触达客群数',
          value: 0,
          noArrow: true,
        },
        {
          title: '已送达客群数',
          value: 0,
        },
        {
          title: '未送达客群数 ',
          value: 0,
        },
      ],
      firstQuery: {
        pageNum: 1,
        pageSize: 10,
      },
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      status: [
        {
          value: 0,
          label: '非送达',
        },
        {
          value: 1,
          label: '已送达',
        },
        {
          value: 2,
          label: '非好友',
        },
        {
          value: 3,
          label: '接收达上线',
        },
      ],
      firstTotal: 0,
      secondTotal: 0,
      firstList: [],
      secondList: [],
      loading: false,
      tabForm: {},
      templateInfo: '',
      stepLoading: false,
      targetType: 1, //1客户，2客群
      sendWeuserNames: [],
      tagNamesOrGroupOwners: [],
    }
  },
  created() {
    this.getDeatil(this.$route.query.id)
  },
  mounted() {
    this.query.liveId = this.$route.query.id
    this.firstQuery.liveId = this.$route.query.id
    this.getUserDetailTab()
  },
  methods: {
    oneStep() {
      this.$confirm('确认同步?', '提示', {
        confirmButtonText: '确认同步',
        cancelButtonText: '放弃',
        type: 'warning',
      }).then(() => {
        this.stepLoading = true
        liveOneStep(this.query.liveId)
          .then((res) => {
            if (res.code === 200) {
              this.getUserDetailTab()
              this.getList()
              this.getFirstList()
              this.stepLoading = false
              this.$message.success('同步成功')
            }
          })
          .catch()
      })
    },
    // tabClick() {
    //   this.resetQuery()
    //   this.getUserDetailTab()
    // },
    resetQuery() {
      let pageSize = this.query.pageSize
      let sendTargetType = this.query.sendTargetType
      this.query = {}
      this.query.pageNum = 1
      this.query.pageSize = pageSize
      this.query.sendTargetType = sendTargetType
      // this.query.userName = ''
      // this.query.sendState = null
      this.getList()
    },
    resetFirstQuery() {
      let sendTargetType = this.firstQuery.sendTargetType
      this.firstQuery.pageNum = 1
      this.firstQuery.userName = ''
      this.firstQuery.sendTargetType = sendTargetType
      this.getFirstList()
    },
    // 获取直播详情
    getDeatil(id) {
      detailLive(id)
        .then((res) => {
          this.topData = res.data
          this.query.sendTargetType = res.data.targetType
          this.firstQuery.sendTargetType = res.data.targetType
          this.targetType = res.data.targetType
          this.getList()
          this.getFirstList()
          this.templateInfo = res.data.weLiveAttachments[0].content
          this.topData.weLiveAttachments = res.data.weLiveAttachments
          this.topData.sendWeuserNames = res.data.sendWeuserNames
            ? res.data.sendWeuserNames.split(',')
            : res.data.sendWeuserNames
          this.sendWeuserNames = this.dealTage(res.data.sendWeuserNames)
          this.topData.tagNamesOrGroupOwners = res.data.tagNamesOrGroupOwners
            ? res.data.tagNamesOrGroupOwners.split(',')
            : res.data.tagNamesOrGroupOwners
          this.tagNamesOrGroupOwners = this.dealTage(res.data.tagNamesOrGroupOwners)
        })
        .catch(() => {})
    },
    dealTage(arrList) {
      let arr = JSON.parse(JSON.stringify(arrList))
      if (arr && arr.length > 2) {
        return arr.splice(0, 2)
      } else {
        return arr
      }
    },
    /** 查询 */
    getFirstList(page) {
      page && (this.firstQuery.pageNum = page)
      this.loading = true
      this.firstQuery.liveId = this.$route.query.id
      userDetail(this.firstQuery)
        .then((res) => {
          this.firstList = res.rows
          this.firstTotal = +res.total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.query.liveId = this.$route.query.id
      this.loading = true
      customerDetail(this.query)
        .then((res) => {
          this.secondList = res.rows
          this.secondTotal = +res.total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    //
    // 超过20个。。。展示
    coverContent(str) {
      if (str && str.length > 20) {
        str = str.substr(0, 20) + '...'
      }
      return str
    },
    getUserDetailTab() {
      this.tabForm.liveId = this.$route.query.id
      // this.tabForm.isUserLat = 'true'
      userDetailTab(this.tabForm).then((res) => {
        this.cardData[0].value = res.data.estimateSendNumber
        this.cardData[1].value = res.data.actualSendNumber
        this.cardData[2].value = res.data.noSendNumber
      })
      // this.tabForm.isUserLat = 'false'
      customerDetailTab(this.tabForm).then((res) => {
        this.customerCardData[0].value = res.data.estimateSendNumber
        this.customerCardData[1].value = res.data.actualSendNumber
        this.customerCardData[2].value = res.data.noSendNumber
        this.groupCardData[0].value = res.data.estimateSendNumber
        this.groupCardData[1].value = res.data.actualSendNumber
        this.groupCardData[2].value = res.data.noSendNumber
      })
    },
    // 处理类型
    dealState(type) {
      switch (type) {
        case 0:
          return '非送达'
          break
        case 1:
          return '已送达'
          break
        case 2:
          return '非好友'
          break
        case 3:
          return '接收达上线'
          break
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.operation {
  display: flex;
  justify-content: flex-end;
  span {
    font-size: 12px;
    color: var(--font-black-6);
  }
}
.numStyle {
  font-size: 48px;
  color: var(--font-black);
  font-weight: 700;
}
.titleColor {
  color: var(--font-black-7);
}
.el-tag:nth-of-type(2) {
  margin-right: 10px;
}
</style>
