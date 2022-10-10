<template>
  <el-popover placement="right" width="300" trigger="hover">
    <div class="hover-class">
      <span>扫码联系专属客服</span>
      <img :src="customerServiceQr" alt="" />
      <span>立马扫码一对一答疑</span>
    </div>
    <div class="side-box" slot="reference">
      <svg-icon class="right-icon" iconClass="customer-service"></svg-icon>
    </div>
  </el-popover>
</template>

<script>
  // import { getCustomerServiceQrUrl } from '@/api/login'
  export default {
    data() {
      return {
        customerServiceQr: ''
      }
    },
    created() {
      // getCustomerServiceQrUrl().then((res) => {
      // this.customerServiceQr = res.data;
      // localStorage.setItem('customerServiceQr',res.data)
      // });
    }
  }
</script>

<style lang="scss" scoped>
  .hover-class {
    display: flex;
    flex-direction: column;
    align-items: center;
    span:nth-child(1) {
      font-size: 18px;
      font-weight: bold;
      line-height: 36px;
      margin-bottom: 10px;
    }
    img {
      width: 160px;
      height: 160px;
    }
    span:nth-child(3) {
      font-size: 14px;
      line-height: 16px;
      margin-top: 20px;
    }
  }
  .side-box {
    width: 50px;
    height: 50px;
    background-color: #0079de;
    border-radius: 4px;
    display: flex;
    justify-content: center;
    align-items: center;
    .right-icon {
      font-size: 40px;
    }
  }
  .side-box:hover {
    cursor: pointer;
  }
</style>
