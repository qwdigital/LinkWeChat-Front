<script>
import TimeSearchTitle from '@/components/common/TimeSearchTitle'
import ChartLine from '@/components/ChartLine.vue'
import * as api from '@/api/commodityCenter/commodityManage'
export default {
  name: '',
  components: { TimeSearchTitle, ChartLine },
  data() {
    return {
      loading: false,
      list: [],
      legend: ['订单总额', '退款总额', '净收入'],
      xData: [],
      series: [],
      cardData: [],
      active: 0,
      api,
      form: {
        picture: '',
        price: 1,
        describe: '',
        attachments: [],
      },
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getDetail()
    this.getList()
    this.getTop5Fn()
  },
  mounted() {},
  methods: {
    getDetail() {
      api.getDetail(this.$route.query.id).then((res) => {
        this.form = res.data
        this.form.attachments = this.form.attachments.split(',')
      })
    },
    getTop5Fn() {
      this.loading = true
      api.getDetailTable(this.$route.query.id).then((res) => {
        if (res.code === 200) {
          this.list = res.data
        }
        this.loading = false
      })
    },
    getList() {
      this.loading = true
      api
        .getDetailTotal(this.$route.query.id)
        .then(({ data }) => {
          this.cardData = [
            {
              title: '订单总数',
              tips: '所有商品全部的订单总数',
              value: data.orderNum,
            },
            {
              title: '订单总额(元)',
              tips: '所有商品全部的订单总额，精确到两位小数点',
              value: data.orderFee,
            },
            {
              title: '退款总额(元)',
              tips: '所有商品全部的退款总额，精确到两位小数点',
              value: data.refundFee,
            },
            {
              title: '净收入(元)',
              tips: '订单总额-退款总额，精确到两位小数点',
              value: data.netIncome,
            },
          ]
        })
        .catch((e) => {})
        .finally(() => {})
    },
    getLineData(data) {
      let val = {
        type: 'customization',
        startDate: data.beginTime,
        endDate: data.endTime,
        productId: this.$route.query.id,
      }
      api.getDetailChart(val).then((res) => {
        this.xData = res.data.xAxis.data
        this.legend = res.data.legend.data
        let arr1 = []
        let arr2 = []
        let arr3 = []
        if (res.data.series && res.data.series.length) {
          arr1 = res.data.series[0].data
          arr2 = res.data.series[1].data
          arr3 = res.data.series[2].data
        }
        this.series = [arr1, arr2, arr3]
      })
    },
  },
}
</script>

<template>
  <div>
    <el-row :gutter="10" type="flex">
      <el-col :span="18">
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <div class="g-card">
          <div class="g-card-title">数据趋势</div>
          <time-search-title @search="getLineData"></time-search-title>
          <chart-line style="height: 300px" :legend="legend" :xData="xData" :series="series"></chart-line>
        </div>
        <div class="g-card">
          <div class="g-card-title">员工订单Top5</div>
          <el-table v-loading="loading" :data="list" style="width: 100%">
            <el-table-column label="员工" align="center" min-width="100" prop="weUserName" />
            <el-table-column label="订单总数" align="center" prop="orderNum" min-width="100"></el-table-column>
            <el-table-column label="订单总额（元）" align="center" prop="totalFee" min-width="100"></el-table-column>
          </el-table>
        </div>
      </el-col>
      <el-col :span="6" style="min-width: 320px; display: flex; justify-content: space-around">
        <PhoneTemplate>
          <div class="phone-content">
            <el-image
              class="commodity-img commodity-thumb"
              style="width: 100%; height: 100px"
              :src="form.picture"></el-image>
            <div class="price">￥{{ form.price }}</div>
            <div class="content">{{ form.describe }}</div>
            <el-image
              v-for="(item, index) in form.attachments"
              class="commodity-img"
              :src="item"
              :key="index"></el-image>
          </div>
        </PhoneTemplate>
      </el-col>
    </el-row>
  </div>
</template>

<style lang="scss" scoped>
.phone-content {
  padding: 10px;
}
.price {
  font-weight: 500;
  font-size: 20px;
  margin: 10px 0;
}
.content {
  margin: 10px 0;
}
.commodity-img {
  width: 100%;
}
</style>
