<template>
  <div class="preview">
    <div class="title">{{name}}</div>
    <div class="content">
      <div class="none" v-if="def === 'welcome' ||  def === 'detail'">
        <div class="none" v-if="data.receptionType === 1">
          <div class="time">
            {{time}}
          </div>
          <div class="item" v-if="data.splitTime === 1">
            <div class="avatar-current"><img class="img-st" :src="avatar"></div>
            <div class="msg">
              <div class="word">
                {{data.welcome[0].content}}
              </div>
            </div>
          </div>
          <div class="none" v-else>
            <div class="item" v-for="(unit, key) in data.welcome">
              <div class="avatar-current"><img class="img-st" :src="avatar"></div>
              <div class="msg">
                <div class="word">
                  {{unit.content}}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-else>
          <div class="time">
            {{time}}
          </div>
          <div class="item">
            <div class="avatar-current"><img class="img-st" :src="avatar"></div>
            <div class="msg">
              <div class="word">
                {{data.welcome[0].content}}
              </div>
              <div class="menu-list">
                <div class="menu" v-for="(item, key) in data.welcome[0].menuList" @click="setClick(item)">
                  {{item.name}}
                </div>
              </div>
            </div>
          </div>
          <div v-if="list.length">
            <template v-for="(unit,key) in list">
              <div class="item right">
                <div class="right-msg">
                  <div class="word">
                    {{unit.name}}
                  </div>
                </div>
                <div class="avatar-current"><img class="img-st" src="../../../assets/drainageCode/header.png"></div>
              </div>
              <div v-if="key === 0" class="text-sub">已接入智能助手</div>
              <div class="item">
                <div class="avatar-current"><img class="img-st" :src="avatar"></div>
                <div class="msg" v-if="unit.type === 'click'">
                  <div class="word">
                    {{unit.content}}
                  </div>
                </div>
                <div class="msg" v-else-if="unit.type === 'view'">
                  <div class="word-and-image">
                    <div class="sub-content">
                      <div>
                        <!-- {{data.materialUrl}} -->
                      </div>
                      <div>
                        <img src="../../../assets/drainageCode/default_icon.png" />
                      </div>
                    </div>
                  </div>
                </div>
                <div class="msg" v-else>
                  <div class="miniprogram">
                    <div class="mini-header">
                      <img src="../../../assets/drainageCode/miniprogram-icon.png" alt="">
                    </div>
                    <img class="mini-img" src="../../../assets/drainageCode/miniprogram-img.png">
                    <div class="mini-footer">
                      <img src="../../../assets/drainageCode/miniprogram-link.png" /> 小程序
                    </div>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
      <div v-if="def === 'detail' || def==='rules'">
        <div class="time">
          {{time}}
        </div>
        <div class="item">
          <div class="avatar-current"><img class="img-st" :src="avatar"></div>
          <div class="msg">
            <div class="word">
              {{data.queueNoticeContent}}
            </div>
          </div>
        </div>
        <div class="time" style="margin-top: 20px;">
          {{time}}
        </div>
        <div class="item">
          <div class="avatar-current"><img class="img-st" :src="avatar"></div>
          <div class="msg">
            <div class="word">
              {{data.timeOutContent}}
            </div>
          </div>
        </div>
        <div class="time" style="margin-top: 20px;">
          {{time}}
        </div>
        <div class="item">
          <div class="avatar-current"><img class="img-st" :src="avatar"></div>
          <div class="msg">
            <div class="word">
              {{data.endContent}}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import moment from 'moment'
  export default {
    name: 'customer-preview-client-welcome',
    components: {},
    props: {
      def: {
        type: String,
        default: 'welcome'
      },
      name: {
        type: String,
        default: ""
      },
      avatar: {
        type: String,
        default: ""
      },
      data: {
        type: Object,
        default: {}
      },
      show: {
        type: Boolean,
        default: false
      }
    },
    watch: {
      show: 'setList',
    },
    data () {
      return {
        list: [],
        time: moment().format('HH:mm')
      }
    },
    computed: {},
    created () { },
    mounted () { },
    methods: {
      setClick (item) {
        this.list.push(item)
      },
      setList () {
        this.list = []
      }
    },
  }
</script>
<style lang="scss" scoped>
  .menu-list {
    margin: 10px;
    .menu {
      margin: 10px 0;
      color: #2c8cf0;
      cursor: pointer;
    }
  }
  .none {
    display: inline-block;
  }
  .text-sub {
    margin: 10px 0;
    text-align: center;
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #999999;
  }
  .img-st {
    height: 24px;
    width: 24px;
  }
  .preview {
    margin: 0 auto;
    position: relative;
    width: 300px;
    height: 640px;
    background: url(../../../assets/drainageCode/preview-bg.png);
    background-repeat: no-repeat;
    background-size: 100% 100%;

    .title {
      position: absolute;
      top: 37px;
      left: 50%;
      transform: translateX(-50%);
      font-size: 14px;
      font-family: PingFangSC-Regular, PingFang SC;
      font-weight: 400;
      color: #333333;
    }

    .content {
      position: absolute;
      height: 545px;
      width: 280px;
      overflow-y: auto;
      top: 70px;
      left: 50%;
      transform: translateX(-50%);
      border-bottom-left-radius: 20px;
      border-bottom-right-radius: 20px;
      padding: 10px;
      .time {
        margin-top:10px;
        width: 100%;
        text-align: center;
        // margin-bottom: 10px;
      }
      .item {
        font-size: 12px;
        font-family: PingFangSC-Regular, PingFang SC;
        font-weight: 400;
        color: #666666;
        display: flex;
        margin-top: 20px;
      }
      .right {
        display: flex;
        justify-content: flex-end;
      }
      .avatar-current {
        margin-right: 5px;
      }
      .msg {
        position: relative;
        min-height: 26px;
        background: #ffffff;
        box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
        border: 1px solid #e1edfc;
        display: inline-block;
        border-radius: 4px;
        box-sizing: border-box;
        word-break: break-all;
        margin-left: 5px;
        &:before {
          content: " ";
          display: block;
          position: absolute;
          left: -5px;
          box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
          border-width: 5px;
          border-left: 0;
          width: 0;
          border-style: solid;
          border-color: transparent;
          border-right-color: #fff;
          top: 8px;
          z-index: 888;
        }
      }
      .right-msg {
        position: relative;
        min-height: 26px;
        background: #ffffff;
        box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
        border: 1px solid #e1edfc;
        display: inline-block;
        border-radius: 4px;
        box-sizing: border-box;
        word-break: break-all;
        margin-right: 5px;
        &:before {
          content: " ";
          display: block;
          position: absolute;
          right: -5px;
          box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
          border-width: 5px;
          border-right: 0;
          width: 0;
          border-style: solid;
          border-color: transparent;
          border-left-color: #fff;
          top: 8px;
          z-index: 888;
        }
      }

      .word {
        padding: 5px 12px;
      }

      .image {
        padding: 12px;

        img {
          width: 94px;
          height: 90px;
        }
      }

      .word-and-image {
        padding: 12px;
        .sub-content {
          margin-top: 10px;
          display: flex;
          justify-content: space-between;
          font-size: 12px;
          font-family: PingFangSC-Regular, PingFang SC;
          font-weight: 400;
          color: #999999;
          img {
            height: 40px;
            width: 40px;
          }
        }
      }
      .miniprogram {
        padding: 12px;
        .mini-header {
          display: flex;
          align-items: center;
          img {
            height: 18px;
            width: 18px;
            margin-right: 5px;
          }
        }
        .mini-img {
          margin: 10px 0;
          width: 143px;
          height: 120px;
        }
        .mini-footer {
          display: flex;
          align-items: center;
          img {
            height: 14px;
            width: 14px;
            margin-right: 5px;
          }
        }
      }
    }
  }
</style>
