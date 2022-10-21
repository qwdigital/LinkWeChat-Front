<script>
import RemoteDataView from '@/components/RemoteDataView'
import CardGroupIndex from '@/components/CardGroupIndex'
import * as api from '@/api/commodityCenter/commodityManage'
export default {
  name: '',
  components: { RemoteDataView, CardGroupIndex },
  data() {
    return {
      cardData: [],
      active: 0,
      api,
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      api
        .getDetail()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '订单总数',
              value: data.totalCnt,
            },
            {
              title: '订单总额(元)',
              value: data.tdCnt,
            },
            {
              title: '退款总额(元)',
              value: data.tdLostCnt,
            },
            {
              title: '净收入(元)',
              value: data.tdNetCnt,
            },
            {
              title: '昨日发送申请',
              value: data.ydNewApplyCnt,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    dealDataFun(res, series, xData) {
      xData = res.map((e) => e.xtime)
      series.push(res.map((e) => e.addCnt))
      series.push(res.map((e) => e.lostCnt))
      series.push(res.map((e) => e.lostCnt))
    },
  },
}
</script>

<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div class="g-card g-pad20" style="margin-top: 0">
      <div class="title">数据趋势</div>
      <RemoteDataView
        type="lineChart"
        :legend="['订单总额(', '退款总额', '净收入']"
        :request="api.getTotalCnt"
        :dealDataFun="dealDataFun"
      ></RemoteDataView>
    </div>

    <div class="g-card g-pad20" style="margin-top: 20px">
      <div class="title">员工订单Top5</div>
      <RemoteDataView type="table" :request="api.getRankCnt"></RemoteDataView>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.title {
  font-size: 16px;
  color: #333;
  font-weight: 600;
  margin-bottom: 20px;
}
</style>
