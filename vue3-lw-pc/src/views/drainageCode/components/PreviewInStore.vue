<template>
  <div class="preview">
    <div class="title">{{ name }}</div>
    <div class="content">
      <el-select style="width: 100%" disabled v-model="pro">
        <el-option label="安徽省合肥市蜀山区" :value="1"></el-option>
      </el-select>
      <el-select style="margin-top: 10px; width: 100%" disabled v-model="store" placeholder="请选择门店">
        <el-option :value="1" label="蜀山区分店"></el-option>
      </el-select>
      <template v-if="showTip">
        <div class="tip">
          {{ value.outOfRangeTip }}
        </div>
        <div class="code_content">
          <img class="code_img" v-if="value.codeState === 1" src="../../../assets/drainageCode/no_code.svg" alt="" />
          <img class="code_img" v-else-if="value.storeCodeConfigQr" :src="value.storeCodeConfigQr" alt="" />
          <img class="code_img" v-else src="../../../assets/drainageCode/code.png" alt="" />
        </div>
        <div class="sub-des">长按识别二维码添加客服</div>
      </template>
      <template v-if="showGuide">
        <div class="tip" style="text-align: center">
          <el-icon-location-outline class="el-icon-location-outline"></el-icon-location-outline>
          国家健康大数据产业园C2-01栋
        </div>
        <div class="code_content">
          <!-- <img class="code_img" v-if="value.codeState === 1" src="../../../assets/drainageCode/no_code.svg" alt=""> -->
          <img class="code_img" v-if="value.storeCodeConfigQr" :src="value.storeCodeConfigQr" alt="" />
          <img class="code_img" v-else src="../../../assets/drainageCode/code.png" alt="" />
        </div>
        <div class="sub-des">长按识别二维码添加门店导购</div>
      </template>
      <template v-if="showStore">
        <div class="tip">
          {{ value.welcomeMsg }}
        </div>
        <div class="code_content">
          <!-- <img class="code_img" v-if="value.codeState === 1" src="../../../assets/drainageCode/no_code.svg" alt=""> -->
          <img class="code_img" v-if="value.storeCodeConfigQr" :src="value.storeCodeConfigQr" alt="" />
          <img class="code_img" v-else src="../../../assets/drainageCode/code.png" alt="" />
        </div>
        <div class="sub-des">长按识别二维码添加门店群</div>
        <div class="tip" style="text-align: center">
          <el-icon-location-outline class="el-icon-location-outline"></el-icon-location-outline>
          国家健康大数据产业园C2-01栋
        </div>
      </template>
    </div>
  </div>
</template>
<script>
export default {
  name: 'preview-client',
  components: {},
  props: {
    name: {
      type: String,
      default: '专属门店群',
    },
    value: {
      type: Object,
      default: () => {
        return {
          outOfRangeTip: '',
          codeState: 1,
          storeCodeConfigQr: '',
          welcomeMsg: '',
        }
      },
    },
    showTip: {
      type: Boolean,
      default: false,
    },
    showGuide: {
      type: Boolean,
      default: false,
    },
    showStore: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      pro: 1,
      store: 1,
    }
  },
  computed: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>
<style lang="scss" scoped>
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

    font-weight: 400;
    color: var(--font-black);
  }

  .content {
    // text-align: center;
    position: absolute;
    height: 545px;
    width: 280px;
    overflow-y: auto;
    top: 70px;
    left: 50%;
    transform: translateX(-50%);
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 20px;
    padding: 20px 10px;
    .tip {
      font-size: 12px;
      margin-top: 30px;
      text-align: center;
    }
    .code_content {
      margin-top: 10px;
      text-align: center;
      .code_img {
        height: 180px;
        width: 180px;
        margin: 10px auto;
      }
    }
  }
}
.sub-des {
  text-align: center;
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
