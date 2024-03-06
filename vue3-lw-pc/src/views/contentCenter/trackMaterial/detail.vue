<template>
  <div>
    <div class="flex">
      <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
        <div class="g-card">
          <div class="fxbw mb10">
            <div class="flex">
              <div class="title">{{ form.materialName }}</div>
              <div class="group">
                {{ form.categoryId === '1' ? '默认分组' : form.categoryName }}
              </div>
              <div v-if="type === '5'" class="group groupred">
                {{ form.type === '1' ? '通用海报' : '裂变海报' }}
              </div>
            </div>
            <el-button text @click="saveInfo">编辑</el-button>
            <!-- 修改素材对话框 -->
            <AddOrEditMaterialDialog
              :type="type"
              :data="form"
              title="编辑"
              v-model="dialogVisible"
              @success="getDeatil()"></AddOrEditMaterialDialog>
          </div>
          <!-- 视频 -->
          <div class="cp flex" v-if="type === '2'">
            <el-image style="width: 200px; height: 200px; flex: none" :src="form.coverUrl" fit="fill"></el-image>
            <div class="ml10">
              <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">
                {{ form.digest && form.digest.toString() }}
              </div>
              <a style="color: var(--color)" :href="H5Url(form.id)" target="_blank">
                {{ H5Url(form.id) }}
              </a>
            </div>
          </div>
          <!-- 文件 -->
          <div class="cp flex" v-if="type === '3'">
            <!-- <el-image
                    style="width: 200px; height: 200px; flex: none"
                    :src="form.coverUrl"
                    fit="fill"
                  ></el-image> -->
            <svg-icon
              class="icon-style"
              :icon="form.materialUrl ? filType(form.materialUrl) : ''"
              v-if="form.materialUrl"></svg-icon>
            <div class="ml10">
              <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">
                {{ form.digest && form.digest.toString() }}
              </div>
              <a style="color: var(--color)" :href="H5Url(form.id)" target="_blank">
                {{ H5Url(form.id) }}
              </a>
            </div>
          </div>
          <!-- 文章 -->
          <div class="cp flex" v-if="type === '12'">
            <el-image
              style="width: 200px; height: 200px; flex: none"
              :src="form.coverUrl"
              fit="fill"
              v-if="form.coverUrl"></el-image>
            <svg-icon class="icon-style" icon="article" v-else></svg-icon>
            <div class="ml10">
              <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">
                {{ form.digest && form.digest.toString() }}
              </div>
              <a style="color: var(--color)" :href="H5Url(form.id)" target="_blank">
                {{ H5Url(form.id) }}
                <!-- H5链接要支持点击在新页面中直接打开 -->
              </a>
            </div>
          </div>
          <!-- 海报 -->
          <div class="cp flex" v-if="type === '5'">
            <el-image style="width: 200px; height: 200px; flex: none" :src="form.materialUrl" fit="fill"></el-image>
            <div class="ml10">
              <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">
                {{ form.digest && form.digest.toString() }}
              </div>
              <a style="color: var(--color)" :href="H5Url(form.id)" target="_blank">
                {{ H5Url(form.id) }}
              </a>
            </div>
          </div>
        </div>
        <div class="g-card">
          <div class="g-card-title">数据趋势</div>
          <CardGroupIndex :data="cardData"></CardGroupIndex>
          <search-title @search="getLineData"></search-title>
          <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
        </div>
        <div class="g-card mt10">
          <div class="g-card-title">
            数据明细
            <!-- <el-popover
              trigger="hover"
              content="仅统计话术中轨迹素材被查看情况统计，排行权重：查看总人数 > 查看总次数 > 发送总次数"
              placement="top-start"
            >
              <template #reference><el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled></template>
            </el-popover> -->
          </div>
          <el-tabs v-model="activeName">
            <el-tab-pane label="发送明细" name="first">
              <div v-if="activeName === 'first'">
                <search-title :showToday="true" @search="getTableData"></search-title>
                <el-table v-loading="loading" :data="tableList" style="width: 100%">
                  <el-table-column
                    label="发送员工"
                    align="center"
                    min-width="100"
                    prop="sendBy"
                    show-overflow-tooltip />
                  <el-table-column
                    label="发送次数"
                    align="center"
                    min-width="100"
                    prop="sendTotalNum"
                    show-overflow-tooltip />
                </el-table>
                <!-- <div class="bottom"> -->
                <pagination
                  :total="total"
                  v-model:page="query.pageNum"
                  v-model:limit="query.pageSize"
                  @pagination="getTableChangeSize()" />
                <!-- </div> -->
              </div>
            </el-tab-pane>
            <el-tab-pane label="查看明细" name="second">
              <div v-if="activeName === 'second'">
                <search-title :showToday="true" @search="getTableData"></search-title>
                <el-table v-loading="loading" :data="tableList" style="width: 100%">
                  <el-table-column
                    label="查看用户"
                    align="center"
                    min-width="100"
                    prop="viewBy"
                    show-overflow-tooltip />
                  <el-table-column
                    label="是否是企业客户"
                    align="center"
                    min-width="100"
                    prop="isCustomer"
                    show-overflow-tooltip>
                    <template #default="scope">
                      {{ scope.row.isCustomer ? '是' : '否' }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    label="查看次数"
                    align="center"
                    min-width="100"
                    prop="viewTotalNum"
                    show-overflow-tooltip />
                  <el-table-column
                    label="查看时长"
                    align="center"
                    min-width="100"
                    prop="viewDurationCpt"
                    show-overflow-tooltip />
                  <el-table-column label="操作" align="center">
                    <template #default="scope">
                      <el-button text @click="goDetail(scope.row)" v-if="scope.row.isCustomer">客户详情</el-button>
                    </template>
                  </el-table-column>
                </el-table>
                <pagination
                  :total="total"
                  v-model:page="query.pageNum"
                  v-model:limit="query.pageSize"
                  @pagination="getTableChangeSize()" />
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
      </div>
      <div class="g-card" style="width: 425px; margin-top: 0">
        <PreviewInPhone :list="mobForm" />
      </div>
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
      mobForm: {
        // welcomeMsg: '',
        // materialMsgList: [],
        // userIds: '',
        // userNames: '',
      },
      form: {}, // 素材表单
      legend: ['发送次数', '查看次数', '查看人数'],
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
          title: '查看总次数',
          value: 0,
        },
        {
          title: '查看总人数',
          value: 0,
        },
        {
          title: '今日发送次数',
          value: 0,
        },
        {
          title: '今日查看次数',
          value: 0,
        },
        {
          title: '今日查看人数',
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
      type: '',
    }
  },
  mounted() {},
  created() {
    this.type = this.$route.query.type
    this.getDeatil()
  },
  watch: {},
  methods: {
    H5Url(id) {
      return window.lwConfig.DOMAIN_MOBILE + '/#/metrialDetail?materiaId=' + id
    },
    // preview(row) {
    //   let obj = {
    //     materialName: row.materialName,
    //     content: row.content,
    //   }
    //   return window.document.location.origin + '/#/preview?obj=' + encodeURIComponent(JSON.stringify(obj))
    // },
    // 处理文件类型
    filType(file) {
      if (file) {
        let filecontent = JSON.parse(JSON.stringify(file))
        filecontent = filecontent.split('.')
        let type = filecontent[filecontent.length - 1]
        if (type === 'pdf') {
          return 'pdf'
        } else if (type === 'doc' || type === 'docx') {
          return 'word'
        } else if (type === 'ppt' || type === 'pptx' || type === 'pps' || type === 'pptsx') {
          return 'ppt'
        } else {
          return ''
        }
      }
    },
    saveInfo() {
      if (this.type === '12') {
        // 文章
        this.$router.push({
          path: 'articleAdd',
          query: {
            type: this.type,
            id: this.$route.query.id,
          },
        })
      } else if (this.type === '5') {
        // 海报
        this.$router.push({
          path: 'posterAdd',
          query: {
            type: this.type,
            id: this.$route.query.id,
            detail: true,
          },
        })
      } else {
        this.dialogVisible = true
      }
    },
    // 获取详情
    getDeatil() {
      this.loading = true
      getList({ mediaType: this.type, materialId: this.$route.query.id })
        .then(({ rows, total }) => {
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
      this.legend = ['发送次数', '查看次数', '查看人数']
      // this.$forceUpdate()
      getCount(data).then((res) => {
        this.cardData[0].value = res.data.sendTotalNum
        this.cardData[1].value = res.data.viewTotalNum
        this.cardData[2].value = res.data.viewByTotalNum
        this.cardData[3].value = res.data.sendTodayNum
        this.cardData[4].value = res.data.viewTotalTodayNum
        this.cardData[5].value = res.data.viewByTotalTodayNum
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        let arr3 = []
        if (res.data && res.data.contentAxisVoList.length) {
          res.data.contentAxisVoList.forEach((dd) => {
            this.xdata.push(dd.dateStr)
            arr1.push(dd.sendNum)
            arr2.push(dd.viewNum)
            arr3.push(dd.viewByNum)
          })
          this.series = [arr1, arr2, arr3]
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      if (this.activeName === 'second') {
        this.query.detailsType = 2
        this.query.resourceType = 1
      } else {
        this.query.detailsType = 1
        this.query.resourceType = 1
      }
      getTableDetail(this.query).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    goDetail(row) {
      let { externalUserid, firstUserId: userId } = row
      this.$router.push({
        name: window.lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
        query: { externalUserid, userId },
      })
    },
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
.groupred {
  background: rgba(217, 0, 27, 1);
}
.title {
  font-size: 16px;
  color: var(--font-black);
  font-weight: 600;
  max-width: 500px;
  word-break: break-all;
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
