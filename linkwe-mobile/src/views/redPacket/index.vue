<script>
import { getList, setState } from '@/api/redPacket.js'
export default {
  name: '',
  components: {},
  data() {
    return {
      loading: false,
      finished: false,
      loadFail: false,
      list: [],
      visible: false,
      type: 'personal',
      form: {
        money: 1,
        type: 1,
        num: 1,
        name: '',
      },
      rules: {
        money: [
          {
            required: true,
            formatter: (value) => value.toFixed(2),
            pattern: /(^[1]?[0-9]?[0-9]{1}(\.\d{1,2})?$|^200$)/,
            message: '',
            trigger: 'onChange',
          },
        ],
        num: [
          {
            required: true,
            formatter: (value) => Math.round(value.replace(/\D/g, '')),
            pattern: /(^[1-9]{1}[0-9]*$)/,
            message: '',
            trigger: 'onChange',
          },
        ],
      },
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      this.finished = false
      getList({
        pageSize: 10,
        pageNum: this.pageNum,
      })
        .then(({ rows, total }) => {
          this.total = total
          this.list.push(...rows)

          this.loading = false
          this.refreshing = false

          // 数据全部加载完成
          if (this.list.length >= +total) {
            this.finished = true
          } else {
            this.pageNum++
          }
          if (this.list.length == 0) {
            this.pageNum = 1
          }
        })
        .catch(() => {
          this.loadFail = true
        })
    },
    showDialog(type, row) {
      this.form = Object.assign({ money: 1, type: '1', num: 1, name: '' }, row || {})
      this.type = type
      this.visible = true
    },
    onSubmit() {},
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
      <van-list
        v-model="loading"
        :finished="finished"
        finished-text="没有更多了"
        :error.sync="loadFail"
        error-text="请求失败，点击重新加载"
        @load="getList"
      >
        <div v-for="(item, index) in list" :key="index" class="fxbw red-packet-list">
          <div class="red-packet-message">{{ item.name }}</div>
          <div class="ar red-packet-list--right">
            <div class="money">￥{{ item.money }}</div>
            <van-button type="info" size="small" @click="showDialog('enterprise', item)"
              >发送</van-button
            >
          </div>
        </div>
      </van-list>
    </div>

    <van-action-sheet
      v-model="visible"
      :description="(type === 'personal' ? '个人' : '企业') + '红包'"
    >
      <van-form colon @submit="onSubmit">
        <van-field
          v-if="type === 'enterprise'"
          label="红包金额(元)"
          :value="'￥' + form.money"
          readonly
        />

        <van-field name="radio" label="红包类型" required>
          <template #input>
            <van-radio-group v-model="form.type" direction="horizontal">
              <van-radio name="1">拼手气红包</van-radio>
              <van-radio name="2">普通红包</van-radio>
            </van-radio-group>
          </template>
        </van-field>

        <template v-if="type === 'personal'">
          <van-field
            v-model="form.money"
            type="digit"
            :label="{ 1: '红包总额(元)', 2: '单个红包金额(元)' }[form.type]"
            placeholder="请输入金额"
            required
            :rules="rules.money"
          />
          <div class="sub-des">精确到小数点后两位，可输入1~200</div>
        </template>

        <van-field
          v-model="form.num"
          type="digit"
          label="红包个数"
          placeholder="请输入大于1的正整数"
          required
          :rules="rules.num"
        />
        <van-field
          v-model="form.name"
          type="text"
          label="红包名称"
          placeholder="请输入名称"
          maxlength="16"
          show-word-limit
        />

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
.sub-des {
  color: #888;
  margin: 10px 100px 0;
  font-size: 12px;
}
</style>
