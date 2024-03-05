<template>
  <div class="flex">
    <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
      <div class="g-card">
        <div class="fxbw mb10">
          <div class="flex">
            <div class="title">{{ form.materialName }}</div>
            <div class="group">
              {{ form.categoryId === '1' ? '默认分组' : form.categoryName }}
            </div>
          </div>
          <el-button text @click="dialogVisible = true">编辑</el-button>
          <!-- 修改素材对话框 -->
          <AddOrEditMaterialDialog
            :type="type"
            :data="form"
            title="编辑"
            v-model="dialogVisible"
            @success="getDeatil()"></AddOrEditMaterialDialog>
        </div>
        <!-- 文本 -->
        <div v-if="type === '4'">
          <el-input v-model="form.content" type="textarea" disabled :rows="4"></el-input>
        </div>
        <!-- 图片 -->
        <el-image
          v-if="type === '0'"
          style="width: 200px; height: 200px; flex: none"
          :src="form.materialUrl"
          :preview-src-list="[form.materialUrl]"
          fit="fill"></el-image>
        <!-- 图文 -->
        <div class="cp flex" v-if="type === '9'">
          <el-image
            style="width: 200px; height: 200px; flex: none"
            :src="form.coverUrl"
            fit="fill"
            v-if="form.coverUrl"
            :preview-src-list="[form.coverUrl]"></el-image>
          <svg-icon v-else class="icon-style" icon="imgText"></svg-icon>
          <div class="ml10">
            <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">
              {{ form.content && form.content.toString() }}
            </div>
            <div>
              <a class="previewStyle" :href="form.materialUrl" target="_blank">{{ form.materialUrl }}</a>
            </div>
          </div>
        </div>
        <!-- 小程序 -->
        <div class="cp flex" v-if="type === '11'">
          <el-image style="width: 200px; height: 200px; flex: none" :src="form.coverUrl" fit="fill"></el-image>
          <div class="ml10">
            <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">小程序ID：{{ form.digest }}</div>
            <span>页面路径：{{ form.materialUrl }}</span>
          </div>
        </div>
      </div>
      <div class="g-card">
        <div class="g-card-title">数据趋势</div>
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <search-title @search="getLineData"></search-title>
        <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
      </div>
      <div class="g-card">
        <div class="g-card-title">
          数据明细
          <!-- <el-popover
              trigger="hover"
              content="仅统计话术中轨迹素材被查看情况统计，排行权重：查看总人数 > 查看总次数 > 发送总次数"
              placement="top-start"
            >
              <el-icon-QuestionFilled  slot="reference" class="el-icon-QuestionFilled"/>
            </el-popover> -->
        </div>
        <search-title :showToday="true" @search="getTableData" style="margin-top: 20px"></search-title>
        <el-table v-loading="loading" :data="tableList" style="width: 100%">
          <el-table-column label="发送员工" align="center" min-width="100" prop="sendBy" show-overflow-tooltip />
          <el-table-column label="发送次数" align="center" min-width="100" prop="sendTotalNum" show-overflow-tooltip />
        </el-table>
        <!-- <div class="bottom"> -->
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getTableChangeSize()" />
        <!-- </div> -->
      </div>
    </div>
    <div class="g-card" style="width: 425px; margin-top: 0">
      <PreviewInPhone :list="mobForm" />
    </div>
  </div>
</template>

<script>
import { getCount, getTableDetail } from '@/api/contentCenter/common.js'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getList } from '@/api/material'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'
import AddOrEditMaterialDialog from '../components/AddOrEditMaterialDialog'

export default {
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
    PreviewInPhone,
    AddOrEditMaterialDialog,
  },
  data() {
    return {
      dialogVisible: false,
      mobForm: [{}],
      form: {}, // 素材表单
      legend: ['发送次数'],
      xdata: [],
      series: [],
      activeName: 'first',
      cardData: [
        {
          title: '发送总次数 ',
          value: 0,
          noArrow: true,
        },
        {
          title: '今日发送次数',
          value: 0,
        },
      ],
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
        detailsType: 1,
      },
      tableList: [],
      loading: false,
      // tableSearch: {},
      type: '',
    }
  },
  created() {
    this.mobForm[0] = this.form
    this.type = this.$route.query.type
    this.getDeatil()
  },
  mounted() {},
  watch: {},
  methods: {
    // 获取详情
    getDeatil() {
      this.loading = true
      getList({ mediaType: this.type, materialId: this.$route.query.id })
        .then(({ rows, total }) => {
          // console.log(rows)
          this.form = rows[0]
          this.mobForm = []
          this.mobForm.push(this.form)
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    getTableData(data) {
      this.query.contentId = this.$route.query.id
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
    getLineData(data) {
      data.contentId = this.$route.query.id
      data.moduleType = 1
      data.resourceType = 1
      this.legend = ['发送次数']
      // this.$forceUpdate()
      getCount(data).then((res) => {
        this.cardData[0].value = res.data.sendTotalNum
        this.cardData[1].value = res.data.sendTodayNum
        this.xdata = []
        this.series = []
        let arr1 = []
        if (res.data && res.data.contentAxisVoList.length) {
          res.data.contentAxisVoList.forEach((dd) => {
            this.xdata.push(dd.dateStr)
            arr1.push(dd.sendNum)
          })
          this.series = [arr1]
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      if (this.activeName === 'second') {
        this.query.detailsType = 2
      } else {
        this.query.detailsType = 1
      }
      getTableDetail(this.query).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    // getTableFn(data) {
    //   this.loading = true
    //   this.tableSearch = data
    //   getTableTotal(Object.assign({}, this.query, data)).then((res) => {
    //     this.tableList = res.rows
    //     this.total = Number(res.total)
    //     this.loading = false
    //   })
    // },
  },
}
</script>

<style lang="scss" scoped>
.icon-style {
  margin-right: 10px;
  width: 120px;
  height: 120px;
  flex: none;
}
.previewStyle {
  color: var(--color);
}
.group {
  font-size: 12px;
  background: var(--color);
  color: var(--font-white, #fff);
  display: block;
  padding: 0 5px;
  height: 24px;
  line-height: 24px;
  border-radius: 5px;
  text-align: center;
  margin-left: 20px;
}

.total-list {
  .item {
    padding: 10px;
    background: var(--bg-white);
  }
}
.title {
  font-size: 16px;
  color: var(--font-black);
  font-weight: 600;
  max-width: 500px;
  word-break: break-all;
}
</style>
