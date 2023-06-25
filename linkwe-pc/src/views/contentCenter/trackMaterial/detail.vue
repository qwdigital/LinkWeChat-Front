<template>
  <div>
    <el-row type="flex" justify="space-between">
      <el-col :span="18" class="left" style="padding: 0 10px 0 0">
        <div class="g-card">
          <el-form ref="form" :model="form" :rules="rules" label-width="80px">
            <div style="display: flex; justify-content: space-between; margin-bottom: 10px">
              <div style="display: flex">
                <el-form-item :label="typeTitle[type] + '标题'" prop="materialName" v-if="!disabled">
                  <el-input
                    v-model="form.materialName"
                    placeholder="请输入标题"
                    :maxlength="titleLength"
                    show-word-limit
                    :disabled="disabled"
                    :autosize="{ minRows: 3, maxRows: 10 }"></el-input>
                </el-form-item>
                <div class="title" v-else>{{ form.materialName }}</div>
                <el-form-item prop="categoryId" label="选择分组" v-if="!disabled">
                  <el-cascader
                    v-model="form.categoryId"
                    :options="treeData[0].children"
                    :props="groupProps"
                    :disabled="disabled"></el-cascader>
                </el-form-item>
                <div v-else class="group">
                  {{ form.categoryId === '1' ? '默认分组' : form.categoryName }}
                </div>
                <div v-if="disabled && type === '5'" class="group groupred">
                  {{ form.type === '1' ? '通用海报' : '裂变海报' }}
                </div>
              </div>
              <el-button type="text" @click="saveInfo" v-loading="submitLoading">
                {{ disabled ? '编辑' : '保存' }}
              </el-button>
            </div>
            <!-- 视频 -->
            <div v-if="type === '2'">
              <div v-if="!disabled">
                <!-- <el-form-item label="上传视频" prop="materialUrl">
                  <Upload
                    :fileUrl.sync="form.materialUrl"
                    :fileName.sync="form.materialName"
                    :type="type"
                  >
                    <div slot="tip">支持mp4/mov格式，视频大小不超过100M</div>
                  </Upload>
                </el-form-item> -->
                <el-form-item label="视频描述">
                  <el-input
                    v-model="form.digest"
                    type="textarea"
                    placeholder="请输入视频描述"
                    :autosize="{ minRows: 3, maxRows: 10 }"
                    :maxlength="128"
                    show-word-limit></el-input>
                </el-form-item>
              </div>
              <div v-else>
                <div class="cp flex">
                  <el-image style="width: 200px; height: 200px; flex: none" :src="form.coverUrl" fit="fit"></el-image>
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
            </div>
            <!-- 文件 -->
            <div v-if="type === '3'">
              <div v-if="!disabled">
                <!-- <el-form-item label="上传文件" prop="materialUrl">
                  <Upload
                    :fileUrl.sync="form.materialUrl"
                    :fileName.sync="form.materialName"
                    :type="type"
                  >
                    <div slot="tip">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
                  </Upload>
                </el-form-item> -->
                <el-form-item label="文件描述">
                  <el-input
                    v-model="form.digest"
                    type="textarea"
                    placeholder="请输入文件描述"
                    :maxlength="100"
                    show-word-limit
                    :autosize="{ minRows: 3, maxRows: 10 }"></el-input>
                </el-form-item>
              </div>
              <div v-else>
                <div class="cp flex">
                  <!-- <el-image
                    style="width: 200px; height: 200px; flex: none"
                    :src="form.coverUrl"
                    fit="fit"
                  ></el-image> -->
                  <svg-icon
                    class="icon-style"
                    :iconClass="form.materialUrl ? filType(form.materialUrl) : ''"
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
              </div>
            </div>
            <!-- 文章 -->
            <div v-if="type === '12'">
              <div class="cp flex">
                <el-image
                  style="width: 200px; height: 200px; flex: none"
                  :src="form.coverUrl"
                  fit="fit"
                  v-if="form.coverUrl"></el-image>
                <svg-icon class="icon-style" iconClass="article" v-else></svg-icon>
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
            </div>
            <!-- 海报 -->
            <div v-if="type === '5'">
              <div v-if="!disabled">
                <el-form-item label="封面" prop="materialUrl">
                  <Upload :fileUrl.sync="form.materialUrl" :fileName.sync="form.materialName" :type="type">
                    <div slot="tip">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
                  </Upload>
                </el-form-item>
                <el-form-item label="文件描述">
                  <el-input
                    v-model="form.digest"
                    type="textarea"
                    placeholder="请输入文件描述"
                    :maxlength="100"
                    show-word-limit
                    :autosize="{ minRows: 3, maxRows: 10 }"></el-input>
                </el-form-item>
              </div>
              <div v-else>
                <div class="cp flex">
                  <el-image
                    style="width: 200px; height: 200px; flex: none"
                    :src="form.materialUrl"
                    fit="fit"></el-image>
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
            </div>
          </el-form>
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
              <i slot="reference" class="el-icon-question"></i>
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
                  :page.sync="query.pageNum"
                  :limit.sync="query.pageSize"
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
                    <template slot-scope="scope">
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
                  <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
                    <template slot-scope="scope">
                      <el-button type="text" @click="goDetail(scope.row)" v-if="scope.row.isCustomer">
                        客户详情
                      </el-button>
                    </template>
                  </el-table-column>
                </el-table>
                <pagination
                  :total="total"
                  :page.sync="query.pageNum"
                  :limit.sync="query.pageSize"
                  @pagination="getTableChangeSize()" />
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
      </el-col>
      <el-col :span="6" class="g-card" style="margin-top: 0"><PreviewInPhone :list="mobForm" /></el-col>
    </el-row>
  </div>
</template>

<script>
import { getCount, getTableDetail, exprotWeLiveWatchUser } from '@/api/contentCenter/common.js'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getTree, update, getList } from '@/api/material'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '../components/SearchTitle.vue'

export default {
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
    PreviewInPhone,
  },
  data() {
    return {
      titleLength: 60,
      detailForm: {}, //详情请求参数
      submitLoading: false,
      typeTitle: [
        '图片',
        '语音',
        '视频',
        '文件',
        '文本',
        '海报',
        '活码',
        '人群',
        '旅程',
        '图文',
        '链接',
        '小程序',
        '文章',
      ],
      disabled: true,
      mobForm: {
        // welcomeMsg: '',
        // materialMsgList: [],
        // userIds: '',
        // userNames: '',
      },
      exportLoading: false,
      // barLegend1: ['访问客户总数'],
      // barLegend2: ['咨询客户总数'],
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
      searchData: {},
      bar1: [],
      bar2: [],
      value1: [],
      value2: [],
      tableSearch: {},
      // 分组props
      groupProps: {
        expandTrigger: 'hover',
        checkStrictly: true,
        children: 'children',
        label: 'name',
        value: 'id',
        emitPath: false,
      },
      treeData: [{}], // 树
      type: '',
      // 表单校验
      rules: Object.freeze({
        categoryId: [{ required: true, message: '不能为空', trigger: 'change' }],
        content: [{ required: true, message: '不能为空', trigger: 'blur' }],
        materialUrl: [{ required: true, message: '不能为空', trigger: 'change' }],
        materialName: [{ required: true, message: '不能为空', trigger: 'blur' }],
        digest: [{ required: true, message: '不能为空', trigger: 'blur' }],
        coverUrl: [{ required: true, message: '不能为空', trigger: 'blur' }],
        // html: [
        //   { required: true, message: '不能为空', trigger: 'blur' },
        //   { validator: validateHtml, trigger: 'blur' },
        // ],
        // http: [
        //   { required: true, message: '不能为空', trigger: 'blur' },
        //   { validator: validateHttp, trigger: 'blur' },
        // ],
      }),
    }
  },
  methods: {
    dealLength() {
      switch (this.type) {
        case '12':
          this.titleLength = 30
          break
        case '2':
          this.titleLength = 32
          break
        case '3':
          this.titleLength = 32
          break
        case '5':
          this.titleLength = 60
          break
        default:
          break
      }
    },
    H5Url(id) {
      let linkUrl = window.document.location.origin + '/mobile/#/metrialDetail?materiaId=' + id
      return linkUrl
    },
    preview(row) {
      let obj = {
        materialName: row.materialName,
        content: row.content,
      }
      return window.document.location.origin + '/#/preview?obj=' + encodeURIComponent(JSON.stringify(obj))
    },
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
      if (!this.disabled) {
        // 点击保存
        this.submitLoading = true
        if (this.times) {
          clearTimeout(this.times)
        }
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this.times = setTimeout(() => {
              let form = JSON.parse(JSON.stringify(this.form))
              form.mediaType = this.type
              ;(form.id ? update : add)(form)
                .then(() => {
                  this.msgSuccess('操作成功')
                  this.disabled = !this.disabled
                  this.dialogVisible = false
                  this.getDeatil()
                  this.$refs['form'].resetFields()
                  this.submitLoading = false
                })
                .catch(() => {
                  this.dialogVisible = false
                  this.submitLoading = false
                })
            }, 300)
          } else {
            this.submitLoading = false
          }
        })
      } else {
        if (this.type === '12') {
          // 文章
          this.$router.push({
            path: 'articleAdd',
            query: {
              type: this.type,
              id: JSON.parse(decodeURIComponent(this.$route.query.obj)).id,
            },
          })
        } else if (this.type === '5') {
          // 海报
          this.$router.push({
            path: 'posterAdd',
            query: {
              type: this.type,
              id: JSON.parse(decodeURIComponent(this.$route.query.obj)).id,
              detail: true,
            },
          })
        } else {
          this.disabled = !this.disabled
        }
      }
    },
    // 获取详情
    getDeatil() {
      this.loading = true
      this.detailForm.mediaType = this.type
      this.detailForm.materialId = JSON.parse(decodeURIComponent(this.$route.query.obj)).id
      getList(this.detailForm)
        .then(({ rows, total }) => {
          // debugger
          // console.log(rows)
          this.form = rows[0]
          // 此处需要后端返回详情的值
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 获取类目树
    getTree() {
      getTree(this.type).then(({ data }) => {
        data.forEach((item) => {
          item.children = null
        })
        this.treeData = [
          {
            id: '',
            name: '全部',
            parentId: '0',
            hasParent: false,
            hasChildren: true,
            children: data || [],
          },
        ]
      })
    },
    numClick(id) {
      this.$router.push({
        url: '',
        id,
      })
    },
    getTableData(data) {
      this.query.contentId = JSON.parse(decodeURIComponent(this.$route.query.obj)).id
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
    getLineData(data) {
      // this.searchData = data
      data.contentId = JSON.parse(decodeURIComponent(this.$route.query.obj)).id
      data.moduleType = 1
      this.legend = ['发送次数', '查看次数', '查看人数']
      this.$forceUpdate()
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
        name: 'CustomerDetail',
        query: { externalUserid, userId },
      })
    },
  },
  mounted() {
    this.dealLength()
  },
  created() {
    this.type = this.$route.query.type
    // this.form = JSON.parse(decodeURIComponent(this.$route.query.obj))
    this.getDeatil()
    this.getTree()
  },
  watch: {
    form: {
      handler(val) {
        this.mobForm = []
        this.mobForm.push(val)
      },
      deep: true,
      immediate: true,
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
  color: #fff;
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
  color: #333;
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
