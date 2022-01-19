<template>
  <div>
    <div class="total-list">
      <CardGroupIndex :data="cardData"></CardGroupIndex>
    </div>
    <div class="g-card g-pad20" style="margin-top: 0;">
      <div class="title">
        数据概览
      </div>
      <div class="data-content">
        <el-tabs v-model="activeName">
          <el-tab-pane label="客户总数" name="first">
          </el-tab-pane>
          <el-tab-pane label="实时数据" name="second">
          </el-tab-pane>
        </el-tabs>
        <div class="chart-content">
          <search-title :showScene='true'></search-title>
          <chart-line style="height: 300px;" :legend="legend" :xData="xdata" :series="series"></chart-line>
        </div>
      </div>
    </div>
    <div class="g-card g-pad20" style="margin-top: 20px;">
      <div class="title">
        访问场景top5
      </div>
      <div class="data-content" style="margin-top: 20px;">
        <div class="chart-content">
          <search-title></search-title>
          <div class="column">
            <div class="column-item">
              <chart-bar style="height: 300px;" :legend="barLegend1"></chart-bar>
            </div>
            <div class="column-item">
              <chart-bar style="height: 300px;" :legend="barLegend2"></chart-bar>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="g-card g-pad20" style="margin-top: 20px;">
      <div class="title">
        数据报表
      </div>
      <div class="data-content" style="margin-top: 20px;">
        <div class="search-content">
          <search-title :showScene='true'></search-title>
          <el-button type="primary" size="mini">导出Excel</el-button>
        </div>
        <div class="table-content">
          <el-table v-loading="loading" :data="tableList" @selection-change="handleSelectionChange" style="width: 100%">
            <el-table-column label="日期" align="center" min-width="100" prop="" show-overflow-tooltip />
            <el-table-column label="访问客户总数" align="center" min-width="100" prop="" show-overflow-tooltip />
            <el-table-column label="咨询客户总数" align="center" prop="" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="接待客户总数" align="center" prop="" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="今日新增访问客户" align="center" prop="" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="今日新增咨询客户" align="center" prop="" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="今日新增接待客户" align="center" prop="" min-width="100" show-overflow-tooltip></el-table-column>
          </el-table>
          <!-- <div class="bottom"> -->
          <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
          <!-- </div> -->
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import ChartBar from '@/components/ChartBar.vue'
  import ChartLine from '@/components/ChartLine.vue'
  import SearchTitle from '../components/SearchTitle.vue'
  import CardGroupIndex from '@/components/CardGroupIndex.vue'
  export default {
    name: 'scene-statistics-scene',
    components: {
      CardGroupIndex,
      SearchTitle,
      ChartLine,
      ChartBar
    },
    data () {
      return {
        barLegend1: ['访问客户总数'],
        barLegend2: ['咨询客户总数'],
        legend: ['访问客户总数', '咨询客户总数', '接待客户总数'],
        xdata: [12, 13, 14],
        series: [[34, 35, 26], [22, 23, 33], [77, 57, 55]],
        activeName: 'first',
        cardData: [
          {
            title: '访问客户总数',
            tips: '进入咨询页面的客户总数(包含重复)',
            value: 1234,
            noArrow: true
          },
          {
            title: '咨询客户总数',
            tips: '发送咨询消息的客户总数(包含重复)',
            value: 12345,
          },
          {
            title: '接待客户总数',
            tips: '人工客服接待的客户总数(包含重复)',
            value: 1222453,
          },
          {
            title: '今日新增访问客户',
            tips: '今日进入咨询页面的客户数(包含重复)',
            value: 1222453,
            title1: '较前日',
            value1: 344
          },
          {
            title: '今日新增咨询客户',
            tips: '今日发送咨询消息的客户数(包含重复)',
            value: 1222453,
            title1: '较前日',
            value1: 344
          },
          {
            title: '今日新增接待客户',
            tips: '今日人工客服接待的客户数(包含重复)',
            value: 1222453,
            title1: '较前日',
            value1: 344
          }
        ],
        total: 0,
        query: {
          pageSize: 10,
          pageNum: 1
        },
        tableList: [],
        loading: false
      }
    },
    methods: {
      handleSelectionChange () {

      },
      getList () {

      }
    },
    created () {

    }
  }
</script>
<style lang="scss" scoped>
  .total-list {
    .item {
      padding: 10px;
      background-color: #fff;
    }
  }
  .title {
    font-size: 16px;
    color: #333;
    font-weight: 500;
  }
  .data-content {
    margin-top: 10px;
    .chart-content {
      margin-top: 10px;
      .my_button {
        float: right;
      }
      .column {
        display: flex;
        .column-item {
          flex: 1;
        }
      }
    }
    .search-content {
      display: flex;
      justify-content: space-between;
    }
    .table-content {
      margin-top: 10px;
    }
  }
</style>