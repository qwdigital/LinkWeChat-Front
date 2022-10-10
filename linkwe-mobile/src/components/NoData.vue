<template>
  <div class="no-data">
    <div class="no-data-content">
      <!-- <img src="@/assets/no-data.png" alt="" /> -->
      <svg-icon class="no-data-icon" name="no-data"></svg-icon>
      <span>对不起，暂无数据。</span>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style lang="less" scoped>
.no-data {
  width: 100%;
  height: 180px;
  display: flex;
  justify-content: center;
  align-items: center;
  .no-data-content {
    width: 120px;
    display: flex;
    flex-direction: column;
    align-items: center;
    // img {
    //   width: 100px;
    //   height: 100px;
    // }
    .no-data-icon {
      width: 100px;
      height: 100px;
    }
    span {
      font-size: 12px;
      font-family: "PingFang SC-中等", "PingFang SC";
      font-weight: normal;
      color: #cccccc;
      line-height: 12px;
    }
  }
}
</style>
