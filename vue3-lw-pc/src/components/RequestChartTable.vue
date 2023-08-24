<!-- 查询数据表格或图表展示 -->
<script>
export default {
  components: {
    ChartLine: defineAsyncComponent(() => import('@/components/ChartLine')),
    ChartBar: defineAsyncComponent(() => import('@/components/ChartBar')),
  },
  props: {
    // 标题
    title: {},
    // 数据展示图表类型
    type: {
      type: String, // lineChart, barChart, table
      default: 'lineChart',
    },
    // 接口请求
    request: {
      type: Function,
    },

    // 自定义的查询参数处理方法，可用于添加和修改查询参数
    dealQueryFun: {
      type: Function,
      default: null,
    },
    // 自定义的返回数据处理方法，可用于添加和修改查询参数
    dealDataFun: {
      type: Function,
      default: null,
    },

    // 导出接口请求
    requestExport: {
      type: Function,
      default: null,
    },
    // 导出文件名(需包含后缀名)
    exportFileName: { type: String },

    // 图表图例; 单个图例可传字符串，多个图例传数组
    legend: {
      type: [Array, String],
      default: null,
    },
    // 自定义图表配置项，使用loadsh.merge(origin, option)和原有的配置进行覆盖合并
    // loadsh.merge: https://www.html.cn/doc/lodash/#_mergeobject-sources
    option: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      loading: false,
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
      },

      // 表格列表数据，或图表的series数据
      data: [],
      xData: [],

      total: 0,
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    getList(page) {
      this.loading = true
      if (this.type == 'table') {
        this.query.pageSize || (this.query.pageSize = 10)
        page && (this.query.pageNum = page)
      }

      this.dealQueryFun && this.dealQueryFun(this.query)

      this.request(this.query)
        .then(({ rows, total, data }) => {
          data = data || rows
          // if (!data) return
          if (this.type == 'table') {
            // 表格
            this.data = data
            this.total = +total
          } else {
            // 自定义echarts图表数据处理
            // this.data = data
            this.dealDataFun && this.dealDataFun(data, this.data, this.xData)
          }
        })
        .catch((e) => {
          console.error(e)
        })
        .finally(() => {
          this.loading = false
        })
    },

    exprotTable() {
      this.$confirm('是否确认导出吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.loading = true
          let query = Object.assign({}, this.query, { pageNum: undefined, pageSize: undefined })
          return this.requestExport(query)
        })
        .then((resBlob) => {
          this.downloadBlob(resBlob, this.exportFileName)
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <div class="RequestChartTable g-card">
    <div class="g-card-title" v-if="title">{{ title }}}</div>

    <div class="RequestChartTable-operation" v-if="requestExport || $slots.query">
      <slot name="operation" v-bind="query"></slot>

      <el-button v-if="requestExport" style="position: absolute; right: 0" type="primary" @click="exprotTable">
        导出 Excel
      </el-button>
    </div>

    <div v-loading="loading">
      <!-- 折线图 -->
      <ChartLine v-if="type == 'lineChart'" :xData="xData" :legend="legend" :series="data" :option="option"></ChartLine>

      <!-- 柱状图 -->
      <ChartBar v-else-if="'barChart'.includes(type)" :xData="xData" :series="data" :option="option"></ChartBar>

      <!-- 表格 -->
      <template v-else-if="type == 'table'">
        <slot name="table" :data="data"></slot>

        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </template>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.RequestChartTable-operation {
  position: relative;
  // display: flex;
  // align-items: center;
  margin-bottom: var(--card-margin, 16px);
}
</style>
