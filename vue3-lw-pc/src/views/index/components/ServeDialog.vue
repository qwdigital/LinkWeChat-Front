<script setup>
import { reactive } from 'vue'

let $datas = reactive({
  dialogVisible: true,
  activeIndex: 0,
  list: [
    {
      title: '开源超级服务包',
      priceNow: '299',
      priceOrigin: '499',
      desc: '专属团队 极速响应',
      img: new URL('../asstes/vip.png', import.meta.url).href,
    },
    {
      title: '开源尊享服务包',
      priceNow: '899',
      priceOrigin: '1299',
      desc: '快速部署 服务升级',
      img: new URL('../asstes/svip.png', import.meta.url).href,
    },
  ],
})
</script>

<template>
  <div class="mask" v-if="$datas.dialogVisible" @click.self="$datas.dialogVisible = false">
    <div class="serveDialog cc">
      <div class="main">
        <div
          v-for="(item, index) in $datas.list"
          :key="index"
          :class="['card cp', index == 1 && 'svip', index == $datas.activeIndex && 'active']"
          @click="$datas.activeIndex = index">
          <div class="cardTitle">{{ item.title }}</div>
          <div class="cardPrice mt5">
            <span class="priceUnit">￥</span>
            <span class="priceNow">{{ item.priceNow }}</span>
            <span class="priceTime">/永久</span>
            <span class="priceOrigin ml5">￥{{ item.priceOrigin }}</span>
          </div>
          <div class="cardDesc mt5">{{ item.desc }}</div>
        </div>

        <template v-for="(item, index) in $datas.list" :key="index">
          <img v-show="index == $datas.activeIndex" class="mainImg" :src="item.img" alt="" />
        </template>

        <div class="bottom" ref="bottom" :style="{ '--color': $datas.activeIndex == 0 ? '#07c160' : '#7e5d25' }">
          <img class="qrcode" :src="lwConfig.QRCODE_CUSTOMER_SERVICE" alt="" />
          <div>
            <div>
              <span class="desc">限时优惠 永久服务</span>
              <span class="know">
                购买须知
                <el-popover placement="top-start" title="温馨提示：" trigger="hover">
                  <div>
                    <p>1、LinkWeChat开源服务包权益仅限本人/本企业使用；</p>
                    <p>2、因项目开源的特殊性，服务包一经购买，不支持退款；</p>
                    <p>3、若已经购买开源超级服务包，仅需补充差价即可升级为开源尊享服务包；</p>
                    <p>
                      4、若购买服务包用户/企业以任何不正当形式（包括但不限于剽窃、恶意诋毁等）扰乱LinkWeChat社区的正常运营，LinkWeChat有权收回其所有权益；
                    </p>
                    <p>
                      5、LinkWeChat根据项目实际情况，在法律允许的范围内，有权对本服务权益进行调整，相关调整会公布在LinkWeChat开源社区；
                    </p>
                    <p>
                      6、如因不可抗力因素（包括但不限于重大自然灾害事件、重大的社会非正常事件等）LinkWeChat有权决定暂定或终止相关服务权益。
                    </p>
                  </div>
                  <template #reference>
                    <el-icon-InfoFilled class="el-icon-InfoFilled"></el-icon-InfoFilled>
                  </template>
                </el-popover>
              </span>
            </div>
            <div class="update">扫码立即升级</div>
            <div class="more">还有更多权益即将上线...</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.mask {
  z-index: 2000;
}
.serveDialog {
  width: 800px;
  height: 668px;
  background: url(../asstes/serveDialogBg.png) 100%;
  .main {
    position: relative;
    top: 200px;
    padding: 0 40px;
  }
  // 卡片样式
  .card {
    position: relative;
    display: inline-block;
    overflow: hidden;
    width: 268px;
    height: 120px;
    padding: var(--card-margin);
    margin-right: var(--card-margin);
    border-radius: var(--border-radius-big);
    border: 1px solid var(--color);
    background: var(--color-light-10);
    &.active {
      &::before {
        content: ' ';
        position: absolute;
        display: inline-block;
        right: -15px;
        bottom: 0px;
        width: 50px;
        height: 20px;
        background: var(--color);
        transform: rotate(-45deg);
      }
      &::after {
        content: ' ';
        position: absolute;
        display: inline-block;
        border: 3px solid #fff;
        border-radius: 1px;
        width: 12px;
        height: 7px;
        border-top: 0;
        border-right: 0;
        transform: rotate(-45deg);
        right: 5px;
        bottom: 8px;
      }
    }
    .cardTitle {
      font-size: 18px;
      font-weight: 500;
      line-height: 26px;
    }
    .priceUnit,
    .priceTime {
      font-size: 16px;
      font-weight: 400;
      color: var(--color);
    }
    .priceNow {
      font-size: 32px;
      font-weight: 700;
      color: var(--color);
    }

    .priceOrigin,
    .cardDesc {
      font-size: 12px;
      line-height: 22px;
      font-weight: 400;
      color: var(--font-black-6);
    }
    .priceOrigin {
      line-height: 1;
      text-decoration: line-through;
    }

    //
    &.svip {
      border: 1px solid #d6b885;
      background: #fff5e1;
      .priceUnit,
      .priceNow,
      .priceTime {
        color: #7e5d25;
      }
      &.active {
        &::before {
          background: #7e5d25;
        }
      }
    }
  }
  .mainImg {
    width: 100%;
    margin: var(--card-margin) 0;
  }

  .bottom {
    display: flex;
    align-items: center;
    padding: 16px 24px;
    background: var(--bg-black-11);
    border-radius: var(--border-radius-big);
    .qrcode {
      width: 80px;
      height: 80px;
      margin-right: 16px;
      padding: 1px;
      border: 1.5px solid var(--color);
    }
    .desc {
      font-size: 18px;
      font-weight: 700;
      color: var(--color);
      line-height: 27px;
    }
    .more {
      color: var(--color);
      font-size: 12px;
    }
    .know,
    .update {
      font-size: 12px;
      line-height: 22px;
      font-weight: 400;
      color: var(--font-black-6);
    }
  }
}
</style>
