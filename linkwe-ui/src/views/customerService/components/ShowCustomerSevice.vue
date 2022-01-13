<template>
  <div class="show">
    <div class="show_img">
      <el-image :src="url" fit="fit" :preview-src-list="[url]" style="width: 40px; height: 40px"></el-image>
    </div>
    <div class="show_name" :style="showicon ? '' : showiconStyle">
      <div>{{name}}</div>
      <div class="company" v-if="showicon">@合肥xxxxx有限公司</div>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'show-customer-service',
    props: {
      url: {
        type: String,
        default: '测试'
      },
      name: {
        type: String,
        default: '测试'
      },
      showicon: {
        type: Boolean,
        default: false
      }
    },
    data () {
      return {
        showiconStyle: {
          'justify-content': 'center'
        }
      }
    }
  }
</script>
<style lang="scss" scoped>
  .show {
    height: 40px;
    display: flex;
    align-items: center;
    .show_img {
      margin-right: 7px;
    }
    .show_name {
      height: 40px;
      line-height: normal;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: space-between;
      font-size: 12px;
      .company {
        color: #ffcf0e;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  }
</style>