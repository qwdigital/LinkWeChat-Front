<template>
  <div class="index">
    <div class="index-l">
      <div class="flex">
        <div class="userinfo">
          <div v-html="bgSvg" class="bgSvg"></div>
          <div class="portrait">
            <img class="portrait-img" :src="$store.user.avatar" alt="" v-if="$store.user.avatar" />
            <!-- <svg-icon icon="user" class="code-user" v-else></svg-icon> -->
          </div>
          <el-tooltip :content="$store.user.name" placement="top-end" effect="light">
            <div class="wel toe">{{ greetings }}，{{ $store.user.name }}</div>
          </el-tooltip>
          <div class="role toe g-bg-lg">{{ roleGroup || '管理员' }}</div>
        </div>

        <div class="g-card data-view">
          <div class="g-card-title fxbw">
            数据总览
            <span class="desc">更新时间：{{ table.synchTime }}</span>
          </div>
          <div class="data-view-wrap">
            <div class="data-view-item" v-for="(item, index) in pannelList" :key="index">
              <div class="view-item-icon fl" :style="{ backgroundImage: `url(${getImg(index)})` }"></div>
              <div class="view-item-title">
                <span>{{ item.title }}</span>
                <el-popover trigger="hover" :content="item.content" placement="top-start">
                  <template #reference>
                    <el-icon-warning class="el-icon-warning ml5"></el-icon-warning>
                  </template>
                </el-popover>
              </div>
              <CountTo class="view-item-num" :start-val="0" :end-val="item.num" :duration="durationCount" />
            </div>
          </div>
        </div>
        <!-- <div class="data-view">
        </div> -->
      </div>

      <div class="g-card">
        <div class="g-card-title">客户数据</div>
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <TabContent
          type="realDataChart"
          :legend="['新增客户', '流失客户', '净增客户', '跟进客户']"
          :request="api.getRealCnt"></TabContent>
      </div>

      <div class="g-card">
        <div class="g-card-title">客群数据</div>
        <CardGroupIndex :data="groupCardData"></CardGroupIndex>
        <TabContent
          type="groupMemberChart"
          :legend="['新增成员', '退出成员']"
          bgLinearGradient
          :request="api.getRealCntMember"></TabContent>
      </div>
    </div>

    <!-- 右侧 -->
    <div class="index-r">
      <div class="content-right">
        <div class="g-card inedx-r-top" v-if="lwConfig.IS_LINKWECHAT">
          <div class="companyName">{{ $store.user.companyName }}</div>
          <div class="info">
            当前版本：
            <span class="fr">{{ table.currentEdition }}</span>
          </div>
          <div class="info">
            使用人数：
            <span class="fr">{{ table.userNumbers }}</span>
          </div>
          <div class="info">
            到期时间：
            <span class="fr">{{ table.dueDate }}</span>
          </div>
          <!-- <el-button :type="buttonColor" @click="submit" class="mt20">{{ buttomText }}</el-button> -->
        </div>

        <!-- 企业动态开始 -->
        <div class="g-title-sub fxbw card-title">
          <span>企业动态</span>
          <span class="title-right-icon cp" v-show="this.dynamicsOutList.length" @click="searchAll">
            ➔
            <!-- <svg-icon class="right-icon" icon="right"></svg-icon> -->
          </span>
        </div>
        <div class="g-card enterprise-card-item">
          <template v-if="this.dynamicsOutList.length">
            <div class="dynamics-item" v-for="(item, index) in dynamicsOutList" :key="index">
              <div class="info fcbw bfc-o">
                <div class="toe">
                  <span :class="[item.operatorType === 1 ? 'customer' : 'staff', 'type lh1']">
                    {{ item.operatorType === 1 ? '客户' : '员工' }}
                  </span>
                  <span class="operatorName">{{ item.operatorName }}</span>
                </div>

                <span :class="[item.operatorType === 1 ? 'customer' : 'staff', 'type1 fr lh1']">
                  {{ item.trajectoryType === 1 ? '客户动态' : item.trajectoryType === 5 ? '客群动态' : '' }}
                </span>
              </div>

              <div class="operator bfc-o">
                <span
                  :class="
                    item.action === '删除员工' || item.action === '解散群聊' || item.action === '退出群聊'
                      ? 'unnomal'
                      : 'nomal'
                  ">
                  {{ item.action }}
                </span>
                <span class="name">{{ item.operatoredObjectName }}</span>
                <span class="time fr">{{ item.createTime }}</span>
              </div>
            </div>
          </template>

          <div class="g-tip-color ac" v-else>暂无数据</div>
        </div>

        <!-- 帮助中心 -->
        <div class="g-card help-center" v-if="lwConfig.IS_LINKWECHAT">
          <div class="g-card-title fxbw">
            <span>帮助中心</span>
            <a
              class="title-right-icon"
              style="color: var(--font-white) !important; background: var(--bg-black)"
              href="https://www.yuque.com/linkwechat/help"
              target="_blank">
              ➔
            </a>
          </div>
          <a class="help-item" href="https://www.yuque.com/linkwechat/help/ozzxus" target="_blank">
            <div>
              <svg-icon class="left-icon" icon="latest-progress"></svg-icon>
              <span>最新进展</span>
            </div>
            <svg-icon class="right-icon" icon="right"></svg-icon>
          </a>
          <a class="help-item" href="https://www.yuque.com/linkwechat/help" target="_blank">
            <div>
              <svg-icon class="left-icon" icon="product-manual"></svg-icon>
              <span>产品手册</span>
            </div>
            <svg-icon class="right-icon" icon="right"></svg-icon>
          </a>
          <a class="help-item" href="https://www.yuque.com/linkwechat/help/qk5gl6" target="_blank">
            <div>
              <svg-icon class="left-icon" icon="problem"></svg-icon>
              <span>常见问题</span>
            </div>
            <svg-icon class="right-icon" icon="right"></svg-icon>
          </a>
        </div>
      </div>
    </div>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="30%">
      <div class="dialog-content" v-if="dialogTitle === '立即续费/升级'">
        <img :src="customerServiceQr" alt="" />
        <span>扫码联系专属客服，极速服务</span>
      </div>
      <Dynamics v-else />
    </el-dialog>
  </div>
</template>
<script>
import { getUserProfile } from '@/api/system/user'
import * as api from '@/api/index'
// import { getCustomerServiceQrUrl } from '@/api/login'
import { CountTo } from 'vue3-count-to'
import bgSvg from './asstes/bg.svg?raw'
export default {
  name: 'Index',
  components: {
    CountTo,
    Dynamics: defineAsyncComponent(() => import('./components/dynamics')),
    TabContent: defineAsyncComponent(() => import('./components/TabContent')),
  },
  data() {
    return {
      api,
      bgSvg,
      table: {
        currentEdition: '-', // 当前版本
        userNumbers: 0, // 使用人数
        dueDate: '-', // 到期时间
        dueDay: 0, // 到期天数
        customerTotalNumber: 0, // 客户总数
        groupTotalNumber: 0, // 客群总数
        groupMemberTotalNumber: 0, // 客群成员总数
        synchTime: '-', // 数据更新时间
      },
      uptime: '',
      durationCount: 2600,

      greetings: '早上好',
      user: '', // 用户信息
      roleGroup: '',
      dialogVisible: false,
      pannelList: [
        {
          title: '客户总数',
          content: '当前员工权限范围内的全部客户数量(含重复)；',
        },
        {
          title: '客群总数',
          content: '当前员工权限范围内的全部客群数量；',
        },
        {
          title: '客群成员总数',
          content: '当前员工权限范围内客群成员的总数(含员工)(含重复)；',
        },
      ],
      dynamicsOutList: [], // 企业动态列表
      dynamicsFrom: {
        trajectoryType: '',
        // dataScope: false,
        pageSize: 10,
        pageNum: 1,
      },
      dialogTitle: '',
      helpCenterList: [
        {
          icon: 'latest-progress',
          title: '最新进展',
          url: 'https://www.yuque.com/linkwechat/help/ozzxus',
        },
        {
          icon: 'product-manual',
          title: '产品手册',
          url: '',
        },
        {
          icon: 'problem',
          title: '常见问题',
          url: '',
        },
      ],
      cardData: [],
      groupCardData: [],
      loading: false,
      groupLoading: false,
      customerServiceQr: '',
      buttonColor: 'primary',
      buttomText: '立即续费/升级',
    }
  },
  mounted() {
    // this.erchatInfo();
    this.tableInfo()
    this.getDynamicsData()
    let date = new Date()
    let hour = date.getHours()
    if (0 <= hour && hour < 8) {
      this.greetings = '早上好'
    } else if (8 <= hour && hour < 12) {
      this.greetings = '上午好'
    } else if (12 <= hour && hour < 14) {
      this.greetings = '中午好'
    } else if (14 <= hour && hour < 18) {
      this.greetings = '下午好'
    } else if (18 <= hour && hour < 24) {
      this.greetings = '晚上好'
    }
    this.getUser()
    this.getList()
    this.getgroupList()
    // this.getCustomerServiceQrUrl()
    // console.log(this.$store.user);
    // this.customerServiceQr = localStorage.getItem("customerServiceQr");
  },
  methods: {
    getList() {
      this.loading = true
      api
        .getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '今日新增客户',
              tips: '当前员工权限范围内今日添加的客户数(含重复及流失)',
              value: data.tdCnt,
            },
            {
              title: '今日跟进客户',
              tips: '当前员工权限范围内今日处于跟进中状态的客户数(含重复)',
              value: data.tdGjCnt,
            },
            {
              title: '今日净增客户',
              tips: '当前员工权限范围内今日添加的客户数(不含重复及流失)',
              value: data.tdNetCnt,
            },
            {
              title: '今日流失客户',
              tips: '当前员工权限范围内的流失的全部客户数量',
              value: data.tdLostCnt,
            },
            {
              title: '昨日发送申请',
              tips: '当前员工数权限范围内主动向客户发起的申请数',
              value: data.ydNewApplyCnt,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    getgroupList() {
      this.groupLoading = true
      api
        .getGroupAnalysis()
        .then(({ data }) => {
          this.groupCardData = [
            {
              title: '今日新增客群',
              tips: '当前员工权限范围内今日创建的客群数',
              value: data.tdGroupAddCnt,
            },
            {
              title: '今日解散客群',
              tips: '当前员工权限范围内今日解散的客群数',
              value: data.tdGroupDissolveCnt,
            },
            {
              title: '今日新增成员',
              tips: '当前员工权限范围内今日新增客群成员数(含员工)',
              value: data.tdMemberAddCnt,
            },
            {
              title: '今日退出成员',
              tips: '当前员工权限范围内今日退出客群成员数(含员工)',
              value: data.tdMemberQuitCnt,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.groupLoading = false
        })
    },

    submit() {
      this.dialogVisible = true
      this.dialogTitle = '立即续费/升级'
    },
    // 查看全部
    searchAll() {
      this.dialogVisible = true
      this.dialogTitle = '企业动态'
    },
    // 获取企业轨迹
    getDynamicsData() {
      api.getCompanyDynamicsData(this.dynamicsFrom).then((res) => {
        if (res.code === 200) {
          this.dynamicsOutList = res.rows
          this.dynamicsOutList.forEach((item) => {
            item.operatoredObjectType =
              item.operatoredObjectType === 1 ? '客户' : item.operatoredObjectType === 2 ? '员工' : '客群'
          })
        }
      })
    },

    getUser() {
      getUserProfile().then((response) => {
        // console.log(response.data);
        // this.user = response.data;
        this.roleGroup = response.roleGroup
      })
    },
    tableInfo() {
      api.indexInfo().then(({ data }) => {
        this.table = data
        this.pannelList[0].num = data.customerTotalNumber
        this.pannelList[1].num = data.groupTotalNumber
        this.pannelList[2].num = data.groupMemberTotalNumber
        if (this.table.dueDay > 10) {
          this.buttomText = '立即续费/升级'
          this.buttonColor = 'primary'
        } else if (this.table.dueDay <= 10) {
          this.buttomText = '仅剩' + this.table.dueDay + '天，立即续费'
          this.buttonColor = 'danger'
        }
      })
    },
    // 获取客服二维码
    // getCustomerServiceQrUrl() {
    //   getCustomerServiceQrUrl().then((res) => {
    //     this.customerServiceQr = res.data;
    //   });
    // },

    getImg(index) {
      return new URL(`./asstes/${index}.png`, import.meta.url).href
    },
  },
}
</script>
<style lang="scss" scoped>
.index {
  display: flex;
  padding-top: 38px;
}
.index-l {
  width: 76%;
  .userinfo {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 218px;
    border-radius: var(--border-radius-big);
    padding: 0px 20px 20px;
    margin-top: -38px;
    .bgSvg {
      color: var(--bg-white);
      position: absolute;
    }
    .portrait {
      position: relative;
      padding: 10px;
      .portrait-img {
        display: block;
        margin: 0 auto;
        width: 90px;
        height: 90px;
        border-radius: 50%;
        border: 1px solid var(--border-black-11);
      }
    }
    .wel {
      position: relative;
      font-size: 22px;
      font-weight: bold;
      margin: 2px 0 16px;
      width: 100%;
    }
    .role {
      position: relative;
      color: white;
      padding: 6px 8px;
      font-size: 12px;
      line-height: 1;
      border-radius: var(--border-radius-small);
    }
  }
  .data-view {
    margin: 0 0 0 16px;
    flex: auto;
    .data-view-wrap {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      margin: 30px -20px 0;
    }
    .data-view-item {
      border-left: 1px solid var(--bg-black-9);
      &:first-child {
        border: 0;
      }
    }
    .view-item-icon {
      width: 54px;
      height: 54px;
      overflow: hidden;
      background: var(--bg-black-11) center no-repeat;
      // background-repeat: no-repeat;
      border-radius: var(--border-radius-big);
      margin: 0 16px;
    }

    .view-item-title {
      color: var(--font-black-4);
      margin-bottom: 10px;
    }
    .view-item-num {
      font-size: 24px;
      font-weight: 500;
      color: var(--font-black);
      font-family: Bahnschrift-Regular, Bahnschrift;
    }
  }
}

.index-r {
  width: 23%;
  margin-left: 1%;

  .inedx-r-top {
    .companyName {
      line-height: 36px;
      font-size: 18px;
      font-weight: 500;
      color: var(--font-black);
      font-weight: bold;
    }

    .info {
      line-height: 24px;
      margin-top: 10px;
      color: var(--font-black-4);
      .fr {
        color: var(--font-black);
        font-weight: bold;
      }
    }
  }
  //   企业动态
  .card-title {
    background: linear-gradient(270deg, var(--color) 0%, var(--color-sub) 100%);
    padding-bottom: 10px;
  }
  .title-right-icon {
    width: 16px;
    height: 16px;
    line-height: 15px;
    background: var(--bg-white);
    border-radius: 50%;
    font-size: 12px;
    text-align: center;
  }
  .enterprise-card-item {
    overflow: hidden;
    border-radius: var(--border-radius-big);
    margin-top: -10px;
    padding-top: 0;
    .dynamics-item {
      border-bottom: 1px solid var(--border-black-10);
      padding: 16px 0;

      .info {
        span {
          vertical-align: middle;
        }
        .type {
          display: inline-block;
          max-width: 80px;
          padding: 4px 5px 3px;
          border-radius: 4px;
          font-size: 12px;
          margin-right: 8px;
        }
        .customer {
          background: #ecf5ff;
          color: #1869ff;
          border-color: #1869ff;
        }
        .staff {
          background: var(--color-light-10);
          color: var(--color);
          border-color: var(--color);
        }
        .type1 {
          padding: 5px 8px 4px;
          border-radius: 4px;
          background: none;
          font-size: 12px;
          border: 1px solid;
          flex: none;
        }
        .operatorName {
          font-size: 16px;
          color: var(--font-black);
          font-weight: 600;
        }
      }

      .operator {
        font-size: 12px;
        color: var(--font-black-4);
        margin-top: 10px;
        .nomal {
          color: var(--color);
        }
        .unnomal {
          color: #e34d59;
        }
      }
    }

    .g-tip-color {
      text-align: center;
      width: 100%;
      margin-top: 20px;
    }
  }

  .help-center {
    .help-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid var(--border-black-10);
      padding: 16px 0;
      // font-size: 12px;
      &:first-of-type {
        margin-top: -16px;
      }
      span {
        vertical-align: middle;
      }
      .left-icon {
        font-size: 26px;
        vertical-align: middle;
        margin-right: 10px;
      }
      .right-icon {
        font-size: 20px;
      }
    }
  }
}

.dialog-content {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  img {
    width: 260px;
    height: 260px;
  }
  span {
    font-size: 20px;
    line-height: 50px;
  }
}
</style>
