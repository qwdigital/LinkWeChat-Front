<script>
export default {
  name: '',
  components: {},
  data() {
    return {
      list: [],
      loading: false,
      visible: false,
      finished: false,
      type: 'personal',
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    onLoad() {
      // 异步更新数据
      // setTimeout 仅做示例，真实场景中一般为 ajax 请求
      setTimeout(() => {
        for (let i = 0; i < 10; i++) {
          this.list.push(this.list.length + 1)
        }

        // 加载状态结束
        this.loading = false

        // 数据全部加载完成
        if (this.list.length >= 40) {
          this.finished = true
        }
      }, 1000)
    },
    showDialog(type) {
      this.type = type
      this.visible = true
    },
  },
}
</script>

<template>
  <div class="red-packet">
    <div class="personal">
      <van-button type="info" size="mini" @click="showDialog('personal')"
        >+ 发送个人红包</van-button
      >
    </div>
    <div>
      <div class="title">企业红包</div>
      <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
        <div v-for="item in 5" :key="item" :title="item" class="fxbw red-packet-list">
          <div class="red-packet-message">红包名称</div>
          <div class="ar red-packet-list--right">
            <div class="money">￥50.00</div>
            <van-button type="info" size="small" @click="showDialog('enterprise')">发送</van-button>
          </div>
        </div>
      </van-list>
    </div>

    <van-action-sheet
      v-model="visible"
      :title="(type === 'personal' ? '个人' : '企业') + '红包'"
      show-cancel-button
      @confirm="submitNewPersonTag"
    >
      <van-form @submit="onSubmit">
        <van-field
          v-model="newPersonTag"
          label="红包金额(元)"
          placeholder="请输入金额"
          required
          :rules="[{ required: true, message: '请输入标签(不超过15字)' }]"
        />
        <div class="sub-des">精确到小数点后两位，可输入1~200</div>

        <van-field
          v-model="newPersonTag"
          label="红包名称"
          placeholder="请输入金额"
          required
          :rules="[{ required: true, message: '请输入标签(不超过16字)' }]"
        />
        <div class="sub-des">精确到小数点后两位，可输入1~200</div>

        <div style="width: 90%;margin: 20px auto 40px">
          <van-button round block size="small" type="info" native-type="submit">保存</van-button>
        </div>
      </van-form>
    </van-action-sheet>
  </div>
</template>

<style lang="less" scoped>
.personal {
  background: #eee;
  padding: 15px;
}
.title {
  font-weight: 500;
  margin: 15px;
}
.red-packet-list {
  margin: 10px;
  padding: 10px 20px;
  border: 1px solid #eee;
  align-items: stretch;

  .money {
    font-size: 30px;
    font-weight: 600;
  }
  .red-packet-list--right {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    justify-content: space-between;
  }
}
.red-packet-message {
  display: inline-block;
  width: 175px;
  height: 75px;
  padding: 15px 0 0 50px;
  color: #fff;
  line-height: 1.15;
  font-size: 16px;
  font-weight: 500;
  background: url('../../assets/red-packet-1.png') 0 0 no-repeat;
  background-size: 100%;
}
</style>
