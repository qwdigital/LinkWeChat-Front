<template>
  <div class="index bgnone">
    <div class="index_l">
      <div class="tables">
        <div>
          <el-row type="flex" class="row-bg" justify="space-between">
            <el-col :span="6">
              <div class="userinfo">
                <div class="portrait">
                  <img :src="$store.state.user.avatar" alt="" v-if="$store.state.user.avatar" />
                  <svg-icon icon-class="user" class="code-user" v-else></svg-icon>
                </div>
                <div class="info">
                  <span>{{ greetings + ',' }}</span>
                  <span>{{ $store.state.user.name }}</span>
                  <span>{{ roleGroup }}</span>
                </div>
              </div>
            </el-col>
            <el-col :span="14">
              <el-row type="flex" class="row-bg" justify="space-between" style="margin-top: 15px; text-align: center">
                <el-col :span="6" class="col_style" v-for="(item, index) in pannelList" :key="index">
                  <span>{{ item.title }}</span>
                  <el-popover trigger="hover" :content="item.content" placement="top-start">
                    <i slot="reference" class="el-icon-question"></i>
                  </el-popover>
                </el-col>
              </el-row>
              <el-row
                type="flex"
                class="row-bg"
                justify="space-between"
                style="margin-top: 10px; font-size: 35px; font-weight: bold; color: #0079de; text-align: center">
                <el-col :span="6">
                  <count-to :start-val="0" :end-val="table.customerTotalNumber" :duration="durationCount" />
                </el-col>
                <el-col :span="6">
                  <count-to :start-val="0" :end-val="table.groupTotalNumber" :duration="durationCount" />
                </el-col>
                <el-col :span="6">
                  <count-to :start-val="0" :end-val="table.groupMemberTotalNumber" :duration="durationCount" />
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </div>
        <div class="up-time">
          <span>数据更新时间：{{ table.synchTime }}</span>
        </div>
      </div>
      <div class="g-title-sub">客户数据</div>
      <div class="g-card">
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <TabContent
          type="realDataChart"
          :legend="['新增客户', '流失客户', '净增客户', '跟进客户']"
          :request="api.getRealCnt"></TabContent>
      </div>

      <div class="g-title-sub">客群数据</div>
      <div class="g-card">
        <CardGroupIndex :data="groupCardData"></CardGroupIndex>
        <TabContent
          type="groupMemberChart"
          :legend="['新增成员', '退出成员']"
          :request="api.getRealCntMember"></TabContent>
      </div>
    </div>
    <div class="index_r">
      <div class="content_right">
        <div class="g-card inedx_r_top_t">
          <p class="companyName">{{ $store.state.user.companyName }}</p>
          <p class="info">
            当前版本：
            <span class="fr">{{ table.currentEdition }}</span>
          </p>
          <p class="info">
            使用人数：
            <span class="fr">{{ table.userNumbers }}</span>
          </p>
          <p class="info">
            到期时间：
            <span class="fr">{{ table.dueDate }}</span>
          </p>
          <!-- <el-button :type="buttonColor" @click="submit" class="mt20">{{ buttomText }}</el-button> -->
        </div>

        <!-- 企业动态开始 -->
        <div class="g-title-sub fxbw card-title">
          <span>企业动态</span>
          <span class="title-right-icon cp" v-show="this.dynamicsOutList.length" @click="searchAll">
            ➔
            <!-- <svg-icon class="right-icon" iconClass="right"></svg-icon> -->
          </span>
        </div>
        <div class="g-card enterprise-card-item">
          <template v-if="this.dynamicsOutList.length">
            <div class="dynamics-item" v-for="(item, index) in dynamicsOutList" :key="index">
              <div class="info fxbw aic bfc-o">
                <div>
                  <span :class="[item.operatorType === 1 ? 'customer' : 'staff', 'type']">
                    {{ item.operatorType === 1 ? '客户' : '员工' }}
                  </span>
                  <span class="operatorName">{{ item.operatorName }}</span>
                </div>

                <span :class="[item.operatorType === 1 ? 'customer' : 'staff', 'type type1 fr']">
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

          <div class="sub-text-color ac" v-else>暂无数据</div>
        </div>

        <!-- 帮助中心 -->
        <div class="g-title-sub fxbw">
          <span>帮助中心</span>
          <a
            class="title-right-icon"
            style="color: #fff !important; background: #000"
            href="https://www.yuque.com/linkwechat/help"
            target="_blank">
            ➔
          </a>
        </div>
        <div class="g-card help-center">
          <a class="help-item" href="https://www.yuque.com/linkwechat/help/ozzxus" target="_blank">
            <div>
              <svg-icon class="left-icon" iconClass="latest-progress"></svg-icon>
              <span>最新进展</span>
            </div>
            <svg-icon class="right-icon" iconClass="right"></svg-icon>
          </a>
          <a class="help-item" href="https://www.yuque.com/linkwechat/help" target="_blank">
            <div>
              <svg-icon class="left-icon" iconClass="product-manual"></svg-icon>
              <span>产品手册</span>
            </div>
            <svg-icon class="right-icon" iconClass="right"></svg-icon>
          </a>
          <a class="help-item" href="https://www.yuque.com/linkwechat/help/qk5gl6" target="_blank">
            <div>
              <svg-icon class="left-icon" iconClass="problem"></svg-icon>
              <span>常见问题</span>
            </div>
            <svg-icon class="right-icon" iconClass="right"></svg-icon>
          </a>
        </div>
      </div>
    </div>
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="30%">
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
import Dynamics from './components/dynamics.vue'
import TabContent from './components/TabContent'
import * as api from '@/api/index'
// import * as echarts from "echarts";
import CardGroupIndex from '@/components/CardGroupIndex'
import { getCustomerServiceQrUrl } from '@/api/login'
import CountTo from 'vue-count-to'
export default {
  name: 'Index',
  components: { CountTo, Dynamics, TabContent, CardGroupIndex },
  data() {
    return {
      api,
      table: {
        // userCount: 0,
        // customerCount: 0,
        // groupCount: 0,
        // groupMemberCount: 0,
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
        pageSize: 5,
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
    // console.log(this.$store.state.user);
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
      api.indexInfo().then((res) => {
        this.table = res.data
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
  },
}
</script>
<style lang="scss" scoped>
.userinfo {
  display: flex;
  .portrait {
    flex-shrink: 0;
    width: 120px;
    height: 120px;
    border-radius: 120px;
    // border: 1px solid #eaeaea;
    margin-right: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
    img {
      width: 100%;
      height: 100%;
    }
    .code-user {
      width: 80%;
      height: 80%;
      color: #999;
    }
  }
  .info {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 10px 0;
    max-width: 200px;
    span {
      white-space: nowrap; /*强制单行显示*/
      text-overflow: ellipsis; /*超出部分省略号表示*/
      overflow: hidden; /*超出部分隐藏*/
    }
    span:nth-child(1) {
      font-size: 16px;
    }
    span:nth-child(2) {
      font-size: 20px;
      font-weight: bold;
    }
    span:nth-child(3) {
      font-size: 12px;
      background: #0079de;
      color: #fff;
      display: block;
      padding: 0 5px;
      height: 24px;
      line-height: 24px;
      border-radius: 5px;
      text-align: center;
    }
  }
}
.sub-text-color {
  text-align: center;
  width: 100%;
  margin-top: 20px;
}
.up-time {
  margin-top: -10px;
  margin-right: 20px;
  text-align: right;
  color: #999;
  font-size: 14px;
  font-weight: 200;
}
.col_style {
  display: flex;
  justify-content: space-around;
}
.el-icon-question {
  color: #999;
  font-size: 14px;
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
.index {
  display: flex;
  .col_style {
    font-size: 18px;
    font-weight: 500;
    color: #666;
  }

  .tables {
    width: 100%;
    height: 154px;
    background: #fff;
    border-radius: 5px;
    padding: 15px;
    font-size: 16px;
  }

  .index_l {
    width: 76%;
  }

  .index_r {
    width: 23%;
    margin-left: 1%;

    .inedx_r_top_t {
      line-height: 24px;
      p {
        padding-top: 9px;
      }

      .companyName {
        line-height: 36px;
        font-size: 18px;
        font-weight: 500;
        color: #333;
        font-weight: bold;
      }

      .info {
        color: #4e5969;
        .fr {
          color: var(--font-black);
          font-weight: bold;
        }
      }
    }
    //   企业动态
    .card-title {
      background: linear-gradient(270deg, #07c160 0%, #90de45 100%);
      padding-bottom: 10px;
    }
    .title-right-icon {
      width: 16px;
      height: 16px;
      line-height: 15px;
      background: white;
      border-radius: 50%;
      font-size: 12px;
      text-align: center;
    }
    .enterprise-card-item {
      overflow: hidden;
      border-radius: var(--border-radius-big);
      margin-top: -10px;
      .dynamics-item {
        border-bottom: 1px solid #f1f1f1;
        padding: 16px 0;
        .info {
          span {
            vertical-align: middle;
          }
        }
        .type {
          display: inline-block;
          max-width: 80px;
          padding: 3px 5px;
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
          background: #effffa;
          color: var(--color);
          border-color: var(--color);
        }
        .type1 {
          padding: 4px 8px;
          background: none;
          border: 1px solid;
          border-color: inherit;
        }

        .operatorName {
          font-size: 16px;
          color: #222222;
          font-weight: 600;
        }
        .operator {
          font-size: 12px;
          color: #4e5969;
          margin-top: 5px;
          .nomal {
            color: var(--color);
          }
          .unnomal {
            color: #e34d59;
          }
        }
      }
    }

    .help-center {
      .help-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #f1f1f1;
        padding: 16px 0;
        // font-size: 12px;
        &:first-child {
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

  .box {
    width: 100%;
  }

  .titlebox {
    height: 80px;
    padding: 10px 0;
    background: #f1f1f1;

    p {
      line-height: 30px;
      margin: 0;
      padding: 0;
    }
  }

  .adminname {
    font-size: 20px;
    font-weight: bold;
  }

  .dataall {
    width: 100%;
    background: #fff;
    border-radius: 5px;
    padding: 20px;
    font-size: 20px;
    .title {
      margin-bottom: 20px;
      font-weight: bold;
    }
  }

  .car {
    line-height: 70px;

    .grid-content {
      overflow: hidden;
      background: #fff;
      border-radius: 5px;
      padding: 10px 30px;

      .craname {
        line-height: 50px;
        font-size: 16px;
      }

      img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: #eee;
      }
    }
  }
}

.card {
  margin-top: 40px;
  background: #fff;
  border-radius: 5px;
  padding: 20px;
  font-size: 16px;
}
</style>
