<template>
  <div class="index">
    <div class="index_l whitebg">
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
              <el-row type="flex" class="row-bg" justify="space-between" style="margin-top: 15px; text-align: center;">
                <el-col :span="6" class="col_style" v-for="(item, index) in pannelList" :key="index"
                  ><span>{{ item.title }}</span>
                  <el-popover trigger="hover" :content="item.content" placement="top-start">
                    <i slot="reference" class="el-icon-question"></i> </el-popover
                ></el-col>
              </el-row>
              <el-row
                type="flex"
                class="row-bg"
                justify="space-between"
                style="margin-top: 10px; font-size: 35px; font-weight: bold; color: #0079de; text-align: center;"
              >
                <el-col :span="6">
                  <count-to :start-val="0" :end-val="table.customerTotalNumber" :duration="durationCount" />
                </el-col>
                <el-col :span="6">
                  <count-to :start-val="0" :end-val="table.groupTotalNumber" :duration="durationCount" />
                </el-col>
                <el-col :span="6">
                  <count-to :start-val="0" :end-val="table.groupMemberTotalNumber" :duration="durationCount" />
                </el-col> </el-row
            ></el-col>
          </el-row>
        </div>
        <div class="up-time">
          <span>?????????????????????{{ table.synchTime }}</span>
        </div>
      </div>
      <div class="dataall" style="margin-top: 10px;">
        <div class="title">????????????</div>
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <TabContent
          type="realDataChart"
          :legend="['????????????', '????????????', '????????????', '????????????']"
          :request="api.getRealCnt"
        ></TabContent>
      </div>
      <div class="dataall" style="margin-top: 10px;">
        <div class="title">????????????</div>
        <CardGroupIndex :data="groupCardData"></CardGroupIndex>
        <TabContent
          type="groupMemberChart"
          :legend="['????????????', '????????????']"
          :request="api.getRealCntMember"
        ></TabContent>
      </div>
    </div>
    <div class="index_r whitebg">
      <div class="content_right">
        <div class="qy_R">
          <div class="inedx_r_top_t">
            <p class="p1">{{ $store.state.user.companyName }}</p>
            <p class="p2">
              ????????????<span class="fr">{{ table.currentEdition }}</span>
            </p>
            <p class="p2">
              ????????????<span class="fr">{{ table.userNumbers }}</span>
            </p>
            <p class="p2">
              ????????????<span class="fr">{{ table.dueDate }}</span>
            </p>
            <!-- <el-row type="flex" class="row-bg" justify="center">
              <el-button :type="buttonColor" @click="submit" class="mt20">{{ buttomText }}</el-button>
            </el-row> -->
          </div>
        </div>
        <!-- ?????????????????? -->
        <div class="dt_R">
          <div class="enterprise-card-item">
            <div class="card-item"></div>
            <div class="card-content">
              <div class="card-title">
                <span></span>
                <span>????????????</span>
                <div class="search-all" @click="searchAll">
                  <div v-if="this.dynamicsOutList.length">
                    ????????????
                    <svg-icon class="right-icon" iconClass="right"></svg-icon>
                  </div>
                </div>
              </div>
              <div class="card-box">
                <div class="enterprise-dynamics" v-if="this.dynamicsOutList.length">
                  <div class="dynamics-item" v-for="(item, index) in dynamicsOutList" :key="index">
                    <div class="dynamics-left">
                      <div class="top">
                        <span :class="item.operatorType === 1 ? 'customer' : 'staff'">{{
                          item.operatorType === 1 ? '??????' : '??????'
                        }}</span>
                        <span>{{ item.operatorName }}</span>
                      </div>
                      <div class="bottom">
                        <span
                          :class="
                            item.action === '????????????' || item.action === '????????????' || item.action === '????????????'
                              ? 'unnomal'
                              : 'nomal'
                          "
                          >{{ item.action }}&nbsp;&nbsp;</span
                        >
                        <span>{{ item.operatoredObjectName }}</span>
                      </div>
                    </div>
                    <div class="dynamics-right">
                      <span>{{
                        item.trajectoryType === 1 ? '????????????' : item.trajectoryType === 5 ? '????????????' : ''
                      }}</span>
                      <span>{{ item.createTime }}</span>
                    </div>
                  </div>
                </div>
                <div class="sub-text-color ac" v-else>????????????</div>
              </div>
            </div>
          </div>
        </div>
        <!-- ?????????????????? -->
        <div class="enterprise-card-item">
          <div class="card-item"></div>
          <div class="card-content">
            <div class="card-title">
              <span></span>
              <span>????????????</span>
            </div>
            <div class="card-box">
              <div class="enterprise-dynamics help-center">
                <!-- <a
                  class="dynamics-item"
                  v-for="(item, index) in helpCenterList"
                  :key="index"
                  :href="item.url"
                  target="_blank"
                >
                  <div>
                    <svg-icon
                      class="left-icon"
                      :iconClass="item.icon"
                    ></svg-icon>
                    <span>{{ item.title }}</span>
                  </div>

                  <svg-icon class="right-icon" iconClass="right"></svg-icon>
                </a> -->
                <a class="dynamics-item" href="https://www.yuque.com/linkwechat/help/ozzxus" target="_blank">
                  <div>
                    <svg-icon class="left-icon" iconClass="latest-progress"></svg-icon>
                    <span>????????????</span>
                  </div>
                  <svg-icon class="right-icon" iconClass="right"></svg-icon>
                </a>
                <el-tooltip class="item" effect="light" content="???????????????????????????" placement="top">
                  <div class="dynamics-item">
                    <div>
                      <svg-icon class="left-icon" iconClass="product-manual"></svg-icon>
                      <span>????????????</span>
                    </div>
                    <svg-icon class="right-icon" iconClass="right"></svg-icon>
                  </div>
                </el-tooltip>
                <el-tooltip class="item" effect="light" content="???????????????????????????" placement="top">
                  <div class="dynamics-item">
                    <div>
                      <svg-icon class="left-icon" iconClass="problem"></svg-icon>
                      <span>????????????</span>
                    </div>
                    <svg-icon class="right-icon" iconClass="right"></svg-icon>
                  </div>
                </el-tooltip>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="30%">
      <div class="dialog-content" v-if="dialogTitle === '????????????/??????'">
        <img :src="customerServiceQr" alt="" />
        <span>???????????????????????????????????????</span>
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
          currentEdition: '-', // ????????????
          userNumbers: 0, // ????????????
          dueDate: '-', // ????????????
          dueDay: 0, // ????????????
          customerTotalNumber: 0, // ????????????
          groupTotalNumber: 0, // ????????????
          groupMemberTotalNumber: 0, // ??????????????????
          synchTime: '-' // ??????????????????
        },
        uptime: '',
        durationCount: 2600,

        greetings: '?????????',
        user: '', // ????????????
        roleGroup: '',
        dialogVisible: false,
        pannelList: [
          {
            title: '????????????',
            content: '????????????????????????????????????????????????(?????????)???'
          },
          {
            title: '????????????',
            content: '???????????????????????????????????????????????????'
          },
          {
            title: '??????????????????',
            content: '????????????????????????????????????????????????(?????????)(?????????)???'
          }
        ],
        dynamicsOutList: [], // ??????????????????
        dynamicsFrom: {
          trajectoryType: '',
          // dataScope: false,
          pageSize: 5,
          pageNum: 1
        },
        dialogTitle: '',
        helpCenterList: [
          {
            icon: 'latest-progress',
            title: '????????????',
            url: 'https://www.yuque.com/linkwechat/help/ozzxus'
          },
          {
            icon: 'product-manual',
            title: '????????????',
            url: ''
          },
          {
            icon: 'problem',
            title: '????????????',
            url: ''
          }
        ],
        cardData: [],
        groupCardData: [],
        loading: false,
        groupLoading: false,
        customerServiceQr: '',
        buttonColor: 'primary',
        buttomText: '????????????/??????'
      }
    },
    mounted() {
      // this.erchatInfo();
      this.tableInfo()
      this.getDynamicsData()
      let date = new Date()
      let hour = date.getHours()
      if (0 <= hour && hour < 8) {
        this.greetings = '?????????'
      } else if (8 <= hour && hour < 12) {
        this.greetings = '?????????'
      } else if (12 <= hour && hour < 14) {
        this.greetings = '?????????'
      } else if (14 <= hour && hour < 18) {
        this.greetings = '?????????'
      } else if (18 <= hour && hour < 24) {
        this.greetings = '?????????'
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
                title: '??????????????????',
                tips: '???????????????????????????????????????????????????(??????????????????)',
                value: data.tdCnt
              },
              {
                title: '??????????????????',
                tips: '??????????????????????????????????????????????????????????????????(?????????)',
                value: data.tdGjCnt
              },
              {
                title: '??????????????????',
                tips: '???????????????????????????????????????????????????(?????????????????????)',
                value: data.tdNetCnt
              },
              {
                title: '??????????????????',
                tips: '?????????????????????????????????????????????????????????',
                value: data.tdLostCnt
              },
              {
                title: '??????????????????',
                tips: '???????????????????????????????????????????????????????????????',
                value: data.ydNewApplyCnt
              }
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
                title: '??????????????????',
                tips: '???????????????????????????????????????????????????',
                value: data.tdGroupAddCnt
              },
              {
                title: '??????????????????',
                tips: '???????????????????????????????????????????????????',
                value: data.tdGroupDissolveCnt
              },
              {
                title: '??????????????????',
                tips: '??????????????????????????????????????????????????????(?????????)',
                value: data.tdMemberAddCnt
              },
              {
                title: '??????????????????',
                tips: '??????????????????????????????????????????????????????(?????????)',
                value: data.tdMemberQuitCnt
              }
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
        this.dialogTitle = '????????????/??????'
      },
      // ????????????
      searchAll() {
        this.dialogVisible = true
        this.dialogTitle = '????????????'
      },
      // ??????????????????
      getDynamicsData() {
        api.getCompanyDynamicsData(this.dynamicsFrom).then((res) => {
          if (res.code === 200) {
            this.dynamicsOutList = res.rows
            this.dynamicsOutList.forEach((item) => {
              item.operatoredObjectType =
                item.operatoredObjectType === 1 ? '??????' : item.operatoredObjectType === 2 ? '??????' : '??????'
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
            this.buttomText = '????????????/??????'
            this.buttonColor = 'primary'
          } else if (this.table.dueDay <= 10) {
            this.buttomText = '??????' + this.table.dueDay + '??????????????????'
            this.buttonColor = 'danger'
          }
        })
      }
      // ?????????????????????
      // getCustomerServiceQrUrl() {
      //   getCustomerServiceQrUrl().then((res) => {
      //     this.customerServiceQr = res.data;
      //   });
      // },
    }
  }
</script>
<style lang="scss" scoped>
  .userinfo {
    display: flex;
    .portrait {
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
    margin: 0;
    width: 100%;
    background: #f1f1f1;
    .col_style {
      font-size: 18px;
      font-weight: 500;
      color: #666;
    }

    //   .fontgay {
    //     text-indent: 4em;
    //     color: #999;
    //     font-size: 14px;
    //     font-weight: 200;
    //   }

    //   #fatherbox {
    //     padding-top: 30px;
    //     height: 380px;
    //     overflow-y: scroll;
    //     overflow: hidden;
    //     border-radius: 5px;
    //     font-size: 16px;
    //     background: #fff;
    //   }

    //   #echart {
    //     width: 100%;
    //     height: 100%;
    //   }

    .fr {
      float: right;
    }

    //   .descend {
    //     color: #ff0000;
    //   }

    //   .ascend {
    //     color: green;
    //   }

    .tables {
      width: 100%;
      height: 154px;
      background: #fff;
      border-radius: 5px;
      padding: 15px;
      font-size: 16px;
    }

    .whitebg {
      min-height: 1000px;
      float: left;
      border-radius: 5px;
    }

    .index_l {
      width: 76%;
    }

    .circle {
      width: 80px;
      height: 80px;
      background: #999;
      border-radius: 50%;
      margin: 0 auto;

      img {
        border-radius: 50%;
        width: 80px;
        height: 80px;
      }
    }

    .index_r {
      width: 23%;
      margin-left: 1%;
      // .content_right {
      //     display: flex;
      //     flex-direction: column;
      //     justify-content: space-between;
      // }

      .qy_R {
        background: #fff;
        //   min-height: 1267px;
        min-height: 270px;
        border-radius: 5px;

        .inedx_r_top_t {
          border-radius: 5px;
          height: 280px;
          background-size: 100% 100%;
          // background: url("../assets/index/yd.png") no-repeat;
          background-size: cover;
          padding: 20px 30px;
          color: #fff;
          margin-bottom: 20px;
          line-height: 36px;

          .flexspan {
            height: 40px;
            line-height: 40px;
            background: #fff;
            color: #0079de;
            border-radius: 4px;
            margin-top: 30px;
          }

          .margint20 {
            margin-top: 31px;
          }

          p {
            padding-top: 9px;
          }

          .p1 {
            font-size: 18px;
            font-weight: 500;
            color: #333;
            font-weight: bold;
          }

          .p2 {
            font-size: 16px;
            font-weight: 400;
            color: #666;
          }
          .p3 {
            font-size: 18px;
          }

          .p4 {
            color: #ffffff;
            padding-top: 10px;
          }
        }

        .img {
          margin: 30px;
          width: 175px;
          height: 175px;
        }

        .inedx_r_top_bottom {
          padding: 10px 30px;
          margin-top: 29px;

          .inedx_r_top_bottomp1 {
            font-size: 16px;
            color: #333333;
          }

          ul {
            margin-top: 20px;
          }

          ul li {
            font-size: 14px;
            line-height: 35px;
            font-weight: 500;
            color: #666;

            span {
              color: #999999;
            }
          }
        }
      }
      .dt_R {
        background: #fff;
        min-height: 370px;
        border-radius: 5px;
        margin-bottom: 10px;
        //   ????????????
        .enterprise-card-item {
          // box-shadow: 0px 2px 6px -3px rgba(0, 0, 0, 0.04);
          // border-radius: 8px 8px 8px 8px;
          position: relative;
          // margin-bottom: 8px;
          // overflow: hidden;
          .card-item {
            width: 100%;
            height: 100%;
            //   background: linear-gradient(
            //     180deg,
            //     #0079de 0%,
            //     rgba(0, 121, 222, 0.2) 100%
            //   );
            background: linear-gradient(60deg, #0079de, #fff);
            opacity: 0.3;
            border-radius: 8px 8px 8px 8px;
            width: 180%;
            //   filter: blur(306px);
            position: absolute;
            top: 0;
            left: 0;
          }
          .card-content {
            width: 100%;
            .card-title {
              display: flex;
              align-items: center;
              height: 65px;
              padding: 10px 17px;
              position: relative;
              top: 0;
              span:nth-child(1) {
                display: block;
                width: 4px;
                height: 14px;
                background: #0079de;
                border-radius: 1px 1px 1px 1px;
                margin-right: 7px;
              }
              span:nth-child(2) {
                font-size: 18px;
                font-family: 'PingFang SC-??????', 'PingFang SC';
                font-weight: normal;
                color: #222222;
                line-height: 22px;
                font-weight: 600;
                display: inline-block;
                width: 30%;
              }
              .search-all {
                width: 70%;
                div {
                  cursor: pointer;
                  font-size: 12px;
                  font-family: 'PingFang SC-??????', 'PingFang SC';
                  font-weight: normal;
                  color: #b5b8c0;
                  line-height: 45px;
                  float: right;
                  display: flex;
                  align-items: center;
                  .right-icon {
                    width: 18px;
                    height: 18px;
                    background: rgba(255, 255, 255, 0.01);
                  }
                }
              }
            }
            .card-box {
              position: relative;
              bottom: 0;
              width: 100%;
              background: #ffffff;
              box-shadow: 0px 2px 6px -3px rgba(0, 0, 0, 0.04);
              border-radius: 0px 0px 8px 8px;
              display: flex;
              flex-wrap: wrap;
              // padding-top: 24px;
              .enterprise-dynamics {
                padding: 30px 16px 8px 16px;
                width: 100%;
                .dynamics-item {
                  border-bottom: 1px solid #f1f1f1;
                  display: flex;
                  justify-content: space-between;
                  padding-bottom: 20px;
                  margin-bottom: 30px;
                  .el-icon-edit {
                    font-size: 26px;
                    color: #0079de;
                    margin-right: 20px;
                  }
                  .dynamics-left {
                    .top {
                      margin-bottom: 7px;
                      span:nth-child(1) {
                        display: inline-block;
                        max-width: 80px;
                        padding: 0 2px;
                        //   height: 18px;
                        border-radius: 4px;
                        font-size: 12px;
                        line-height: 20px;
                        text-align: center;
                        margin-right: 8px;
                      }
                      .customer {
                        background: #ecf5ff;
                        color: #0079de;
                      }
                      .staff {
                        background: #effffa;
                        color: #00d695;
                      }
                      span:nth-child(2) {
                        font-size: 16px;
                        font-family: 'PingFang SC-??????', 'PingFang SC';
                        color: #222222;
                        line-height: 30px;
                        font-weight: 600;
                      }
                    }
                    .bottom {
                      span {
                        font-size: 14px;
                        font-family: 'PingFang SC-??????', 'PingFang SC';
                        font-weight: normal;
                        color: #666666;
                        line-height: 28px;
                      }
                      .nomal {
                        color: #0079de;
                      }
                      .unnomal {
                        color: #e34d59;
                      }
                    }
                  }
                  .dynamics-right {
                    display: flex;
                    flex-direction: column;
                    text-align: right;
                    span {
                      font-size: 14px;
                      font-family: 'PingFang SC-??????', 'PingFang SC';
                      font-weight: normal;
                      line-height: 28px;
                    }
                    span:nth-child(1) {
                      color: #666666;
                      margin-bottom: 9px;
                    }
                    span:nth-child(2) {
                      color: #999999;
                    }
                  }
                }
              }
            }
          }
        }
      }
      .enterprise-card-item {
        margin-top: 20px;
        position: relative;
        .card-item {
          width: 100%;
          height: 100%;
          //   background: linear-gradient(
          //     180deg,
          //     #0079de 0%,
          //     rgba(0, 121, 222, 0.2) 100%
          //   );
          background: linear-gradient(60deg, #0079de, #fff);
          opacity: 0.3;
          border-radius: 8px 8px 8px 8px;
          width: 180%;
          //   filter: blur(306px);
          position: absolute;
          top: 0;
          left: 0;
        }
        .card-content {
          width: 100%;
          .card-title {
            display: flex;
            align-items: center;
            height: 65px;
            padding: 10px 17px;
            position: relative;
            top: 0;
            span:nth-child(1) {
              display: block;
              width: 4px;
              height: 14px;
              background: #0079de;
              border-radius: 1px 1px 1px 1px;
              margin-right: 7px;
            }
            span:nth-child(2) {
              font-size: 18px;
              font-family: 'PingFang SC-??????', 'PingFang SC';
              font-weight: normal;
              color: #222222;
              line-height: 22px;
              font-weight: 600;
              display: inline-block;
              width: 30%;
            }
          }
          .card-box {
            position: relative;
            bottom: 0;
            width: 100%;
            background: #ffffff;
            box-shadow: 0px 2px 6px -3px rgba(0, 0, 0, 0.04);
            border-radius: 0px 0px 8px 8px;
            display: flex;
            flex-wrap: wrap;
            // padding-top: 24px;
            .enterprise-dynamics {
              padding: 30px 16px 8px 16px;
              width: 100%;
              .dynamics-item {
                display: flex;
                justify-content: space-between;
                padding-bottom: 9px;
              }
            }
            .help-center {
              .dynamics-item {
                line-height: 50px;
                margin-bottom: 30px;
                .left-icon {
                  font-size: 26px;
                  vertical-align: middle;
                  margin-right: 10px;
                }
                .right-icon {
                  font-size: 20px;
                  margin-top: 20px;
                }
                span {
                  font-size: 16px;
                }
              }
              .dynamics-item:hover {
                cursor: pointer;
              }
            }
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
      ::v-deep.card-index-li {
        background-color: #f9f9f9;
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
