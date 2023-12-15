<template>
  <div style="padding-bottom: 30px">
    <div class="g-card">
      <div class="mid-action">
        <search-title :id="$route.query.id" :showScene="true" @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <!-- <div v-if="tableList&&tableList.length!=0">
              {{tableList[0].answer}}
            </div> -->
      <template v-if="!tableList[0]">
        <el-table v-loading="loading1" :data="tableList" style="width: 100%">
          <el-table-column label="日期" align="center" min-width="100" show-overflow-tooltip>
            <template #default="{ row }">
              <div style="display: flex; justify-content: center">
                {{ row.updateTime.substring(0, 10) }}
              </div>
            </template>
          </el-table-column>
        </el-table>
      </template>
      <template v-if="tableList[0]">
        <el-table v-loading="loading1" :data="tableList" style="width: 100%">
          <el-table-column align="center" label="序号" width="50">
            <template #default="scope">
              {{ scope.$index + 1 }}
            </template>
          </el-table-column>

          <el-table-column label="日期" align="center" min-width="100" show-overflow-tooltip>
            <template #default="{ row }">
              <div style="display: flex; justify-content: center">
                {{ row.updateTime.substring(0, 10) }}
              </div>
            </template>
          </el-table-column>
          <template v-if="tableList && tableList[0]">
            <el-table-column
              v-for="(item, index) in tableList[0].answer"
              :label="item.label"
              align="center"
              min-width="100"
              show-overflow-tooltip
              :key="index">
              <template #default="{ row }">
                <div class="toe">
                  <span v-if="![8, 9, 10, 6].includes(row.answer[index].formCodeId)">
                    {{ row.answer[index].defaultValue }}
                  </span>
                  <span v-else-if="[8, 6].includes(row.answer[index].formCodeId)">
                    {{ multipleTrans(row.answer[index]) }}
                  </span>
                  <span v-else-if="row.answer[index].formCodeId == 9">
                    {{ row.answer[index].ssq }}
                  </span>
                  <span v-else-if="row.answer[index].formCodeId == 10">
                    {{ row.answer[index].timeS }}
                  </span>
                </div>
              </template>
            </el-table-column>
          </template>
          <!--  <el-table-column label="总访问数" align="center" min-width="100" prop="visitTotalCnt" show-overflow-tooltip />
                <el-table-column label="总访问用户" align="center" prop="consultTotalCnt" min-width="100" show-overflow-tooltip></el-table-column>
                <el-table-column label="有效收集量" align="center" prop="EffectiveCollectionQuantity" min-width="100" show-overflow-tooltip></el-table-column>
                <el-table-column label="收集量" align="center" prop="CollectionQuantity" min-width="100" show-overflow-tooltip></el-table-column>
                <el-table-column label="平均完成时间" align="center" prop="average" min-width="100" show-overflow-tooltip></el-table-column> -->
        </el-table>
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getTableChangeSize(query.pageNum, query.pageSize)" />
      </template>
    </div>

    <!-- <div class="dataStatistics_optionGraph_ul"> -->
    <!-- <div class="g-card mt0" v-for="(item, index) in baseList" :key="index">
        <div class="g-card-title">{{ item.label }}</div>
        <PieChart :Data="item"></PieChart>
      </div> -->
    <!-- <div class="" v-for="(item, index) in baseListMap" :key="index">
        <div style="font-size: 20xp; font-weight: 700">{{ item.label }}</div>
        <div
          style="margin-left: 30%; font-weight: 700; font-size: 22px; cursor: pointer"
          v-if="item.hidden == 2"
          @click="toBackMap(item)">
          返回
        </div>
        <div v-show="item.hidden == 1" @click="btnFparams(item, index)">
          <ChinaMap @Fparams="Fparams" :Datas="item"></ChinaMap>
        </div>
        <div v-if="item.hidden == 2" @click="btnFparams(item, index)">
          <MarketMap :params="item.params"></MarketMap>
        </div>
      </div> -->
    <!-- </div> -->
    <div class="g-card" v-if="baseListMap.label">
      <div class="g-card-title">{{ baseListMap.label }}</div>
      <ChinaMap style="height: 600px" :Datas="baseListMap"></ChinaMap>
    </div>
  </div>
</template>

<script>
// import PieChart from '../components/PieChart.vue'
import ChinaMap from '../components/ChinaMap.vue'
// import MarketMap from '../components/MarketMap.vue'
// import { getProvinceCityTree } from '@/utils/index'

import { selectAnswerInfo, areaStatistic, pieChart, answerExport } from '@/api/drainageCode/smartForms.js'
import SearchTitle from '../components/SearchTitle.vue'
export default {
  props: ['formId'],
  components: {
    SearchTitle,
    // PieChart,
    ChinaMap,
    // MarketMap,
  },
  data() {
    return {
      params: '',
      loading1: false,
      total: 0,
      baseList: '',
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      baseListMap: {},
      tableList: [],
      exportLoading: false,
    }
  },
  methods: {
    toBackMap(item) {
      item.hidden = 1
      // this.$forceUpdate()
    },
    // async btnFparams(item, index) {
    //   if (this.params) {
    //     item.params = this.params
    //     item.params.formId = this.formId
    //     let regionalLinkage = await getProvinceCityTree()
    //     for (let i = 0; i < regionalLinkage.length; i++) {
    //       if (regionalLinkage[i].name.substring(0, 2) == item.params.name.substring(0, 2)) {
    //         item.params.parentCode = regionalLinkage[i].id
    //       }
    //     }
    //     item.hidden = 2
    //     this.params = ''
    //     // this.$forceUpdate()
    //   }
    // },
    // Fparams(data) {
    //   this.params = data.data
    //   console.log('点击返回值', data.data)
    // },
    exportFn() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          return answerExport(
            Object.assign(
              {
                belongId: this.$route.query.id,
              },
              this.tableSearch,
            ),
          )
        })
        .then((res) => {
          if (res != null) {
            let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '数据统计.xlsx' //指定下载文件名
            link.click()
            URL.revokeObjectURL(url) // 释放内存
          }
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    // pieChart() {
    //   let that = this
    //   let data = {
    //     formId: this.formId,
    //   }
    //   pieChart(data).then((res) => {
    //     // console.log('扇形统计图返回值', res)
    //     for (let i = 0; i < res.data.length; i++) {
    //       let optionss = []
    //       for (let q = 0; q < res.data[i].data.length; q++) {
    //         optionss.push(res.data[i].data[q].name)
    //       }
    //       res.data[i].optionss = optionss
    //     }
    //     that.baseList = res.data
    //   })
    // },
    getTableChangeSize(a, b) {
      let that = this
      this.loading = true
      let data = this.tableSearch
      data.pageNum = a
      data.pageSize = b
      console.log('data', data)
      selectAnswerInfo(data).then(({ rows, total }) => {
        that.loading1 = false
        console.log('数据统计返回值', rows)
        let b = []
        if (rows && rows.length) {
          that.tableList = []
          for (let i = 0; i < rows.length; i++) {
            if (rows[i].answer) {
              rows[i].answer = that.uniq(JSON.parse(rows[i].answer))
              b.push(rows[i])
            }
            // let a={
            //   xtime:xAxis.data[i],
            //   visitTotalCnt:series[0].data[i],
            //   consultTotalCnt:series[1].data[i],
            //   EffectiveCollectionQuantity:series[2].data[i],
            //   CollectionQuantity:series[3].data[i],
            //   average:series[4].data[i],
            // }
          }
          that.tableList = b
        } else {
          that.tableList = []
        }
        console.log('that.tableList', that.tableList)
        // this.tableList = xAxis.data.length
        this.total = Number(total)
      })
    },
    //数组去重,重组
    uniq(array) {
      for (let i = 0; i < array.length; i++) {
        for (let q = i + 1; q < array.length; q++) {
          if (array[i].questionNumber == array[q].questionNumber) {
            array[i].defaultValue = array[i].defaultValue + ',' + array[q].defaultValue
            array.splice(q, 1)
            q--
          }
        }
      }
      return array
    },
    getTableFn(data) {
      console.log('渠道', data)
      let that = this
      this.loading1 = true
      data.belongId = this.$route.query.id
      if (!data.dataSource) {
        that.loading1 = false
        return
      }
      this.tableSearch = data
      // getTableTotal(Object.assign({}, this.query, data)).then(res => {
      //   this.tableList = res.rows
      //   this.total = Number(res.total)
      //   this.loading = false
      // })
      that.getTableChangeSize(1, 10)
    },
    // 地图
    areaStatisticF(data) {
      areaStatistic(data).then((res) => {
        // console.log('地图统计图返回值', res)
        // res = [{data:[{name,value}],label:''},{data:[{name,value}],label:''}
        let _data = res.data[0].data
        let cities = res.data.map((e) => e.data.find((e2) => e2.value))
        cities.forEach((element) => {
          let city = _data.find((e) => element.name === e.name)
          Object.assign(city, element)
        })
        this.baseListMap = {
          data: _data,
          label: res.data[0].label,
          hidden: 1,
        }
        // this.baseListMap = [{
        //   data: _data,
        //   label: res.data[0].label,
        //   hidden: 1,
        // }]
        // for (let i = 0; i < this.baseListMap.length; i++) {
        //   this.baseListMap[i].hidden = 1
        // }
        // this.baseList= res.data;
      })
    },
    // transDefaultValueToView(data) {
    //   debugger
    //   data = JSON.parse(JSON.stringify(data))
    //   let option = data.options.filter((e, index) => data.defaultValue.includes(index + ''))
    //   return option.map((e) => e.value).join(',')
    // },
    multipleTrans(data) {
      data = JSON.parse(JSON.stringify(data))
      data.viewValue = []
      data.defaultValue += ''
      // if (typeof data.defaultValue === 'string') {
      data.defaultValue = data.defaultValue.split(',')
      data.options = data.options.split(',')
      data.viewValue = data.options.filter((e, index) => data.defaultValue.includes(index + ''))
      // }
      return data.viewValue.join()
    },
  },
  mounted() {
    // this.pieChart()
    let data = {
      areaType: 1,
      formId: this.formId,
    }
    console.log('4')
    this.areaStatisticF(data)
  },
}
</script>

<style lang="scss" scoped>
.dataStatistics_optionGraph_ul {
  margin-top: var(--card-margin);
  display: grid;
  grid: auto/1fr 1fr;
  gap: var(--card-margin);
}
</style>
