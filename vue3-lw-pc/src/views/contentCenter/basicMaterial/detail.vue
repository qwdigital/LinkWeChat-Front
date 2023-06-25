<template>
  <div>
    <div class="flex">
      <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
        <div class="g-card">
          <el-form ref="form" :model="form" :rules="rules" label-width="100px">
            <div style="display: flex; justify-content: space-between; margin-bottom: 10px">
              <div style="display: flex">
                <el-form-item :label="typeTitle[type] + '标题'" prop="materialName" v-if="!disabled && type !== '0'">
                  <el-input
                    v-model="form.materialName"
                    placeholder="请输入标题"
                    :maxlength="titleLength"
                    show-word-limit
                    :disabled="disabled"></el-input>
                </el-form-item>
                <el-form-item :label="typeTitle[type] + '标题'" prop="materialName" v-if="!disabled && type === '0'">
                  <el-input v-model="form.materialName" placeholder="请输入标题" :disabled="true"></el-input>
                </el-form-item>
                <div class="title" v-else-if="disabled">{{ form.materialName }}</div>
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
              </div>
              <el-button text @click="saveInfo" v-loading="submitLoading">
                {{ disabled ? '编辑' : '保存' }}
              </el-button>
            </div>
            <!-- 文本 -->
            <div v-if="type === '4'">
              <el-form-item prop="content" label="文本内容" v-if="!disabled">
                <TextareaExtend
                  v-model="form.content"
                  :autosize="{ minRows: 2, maxRows: 4 }"
                  placeholder="请输入内容"
                  maxlength="1000"
                  show-word-limit
                  :disabled="disabled"
                  :rows="4"></TextareaExtend>
              </el-form-item>
              <el-input v-model="form.content" type="textarea" :disabled="disabled" :rows="4" v-else></el-input>
            </div>
            <!-- 图片 -->
            <div v-if="type === '0'">
              <div v-if="!disabled">
                <!-- <el-form-item label="图片">
                  <Upload
                     v-model:fileUrl="form.materialUrl"
                     v-model:fileName="form.materialName"
                    :maxSize="20"
                    type="0"
                  >
                    <div slot="tip">
                      支持jpg/jpeg/png格式，图片大小不超过20M，支持最多10张批量上传
                    </div>
                  </Upload>
                </el-form-item> -->
              </div>
              <div v-else>
                <div class="cp flex">
                  <el-image
                    style="width: 200px; height: 200px; flex: none"
                    :src="form.materialUrl"
                    fit="fill"></el-image>
                </div>
              </div>
            </div>
            <!-- 图文 -->
            <div v-if="type === '9'">
              <div v-if="!disabled">
                <el-form-item label="图文封面">
                  <Upload v-model:fileUrl="form.coverUrl" type="0">
                    <template #tip><div>支持jpg/jpeg/png格式，建议200*200</div></template>
                  </Upload>
                </el-form-item>
                <el-form-item label="图文描述">
                  <el-input
                    v-model="form.content"
                    type="textarea"
                    :maxlength="128"
                    show-word-limit
                    :autosize="{ minRows: 3, maxRows: 50 }"
                    placeholder="请输入图文描述"></el-input>
                </el-form-item>
                <el-form-item label="图文地址" prop="materialUrl">
                  <el-input
                    v-model="form.materialUrl"
                    type="text"
                    placeholder="请输入图文地址，以http://或https://开头"></el-input>
                </el-form-item>
              </div>
              <div v-else>
                <div class="cp flex">
                  <el-image
                    style="width: 200px; height: 200px; flex: none"
                    :src="form.coverUrl"
                    fit="fill"
                    v-if="form.coverUrl"></el-image>
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
              </div>
            </div>
            <!-- 小程序 -->
            <div v-if="type === '11'">
              <div v-if="!disabled">
                <el-form-item label="封面" prop="coverUrl">
                  <Upload v-model:fileUrl="form.coverUrl" type="0">
                    <template #tip><div>支持jpg/jpeg/png格式，建议520*416</div></template>
                  </Upload>
                </el-form-item>
                <el-form-item label="小程序ID" prop="digest">
                  <el-input v-model="form.digest" placeholder="小程序AppID"></el-input>
                </el-form-item>
                <el-form-item label="页面路径" prop="materialUrl" :rules="rules.html">
                  <el-input v-model="form.materialUrl" placeholder="请输入小程序路径，必须以 html 作为后缀"></el-input>
                </el-form-item>
              </div>
              <div v-else>
                <div class="cp flex">
                  <el-image style="width: 200px; height: 200px; flex: none" :src="form.coverUrl" fit="fill"></el-image>
                  <div class="ml10">
                    <div style="text-align: left; over-flow: hidden; margin-bottom: 20px">
                      小程序ID：{{ form.digest }}
                    </div>
                    <span>页面路径：{{ form.materialUrl }}</span>
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
import { getTree, update, getList } from '@/api/material'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '../components/SearchTitle.vue'

var validateHtml = (rule, value, callback) => {
  if (/\.html$/gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 html 作为后缀'))
  }
}
var validateHttp = (rule, value, callback) => {
  if (/^https?:\/\//gi.test(value)) {
    callback()
  } else {
    callback(new Error('必须以 http://或 https://开头'))
  }
}
export default {
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
    PreviewInPhone,
  },
  data() {
    return {
      titleLength: 30,
      materialUrls: [], // 多个图片地址
      materialNames: [], // 多个图片名称
      detailForm: {}, //详情请求参数
      submitLoading: false,
      disabled: true,
      mobForm: [{}],
      exportLoading: false,
      // barLegend1: ['访问客户总数'],
      // barLegend2: ['咨询客户总数'],
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
        html: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHtml, trigger: 'blur' },
        ],
        http: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: validateHttp, trigger: 'blur' },
        ],
      }),
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
        '企业话术',
        '客服话术',
      ],
    }
  },
  methods: {
    dealLength() {
      switch (this.type) {
        case '4':
          this.titleLength = 50
          break
        case '0':
          this.titleLength = 50
          break
        case '9':
          this.titleLength = 32
          break
        case '11':
          this.titleLength = 16
          break
        default:
          break
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
              if (this.materialUrls) {
                // 新增
                this.form.weMaterialImgAoList = []
                this.materialUrls.forEach((item, index) => {
                  this.form.weMaterialImgAoList.push({ materialUrl: item, materialName: '' })
                })
                this.materialNames.forEach((item, index) => {
                  this.form.weMaterialImgAoList[index].materialName = item
                })
              }
              let form = JSON.parse(JSON.stringify(this.form))
              form.mediaType = this.type
              ;(form.id ? update : add)(form)
                .then(() => {
                  this.msgSuccess('操作成功')
                  this.disabled = !this.disabled
                  this.dialogVisible = false
                  this.picReset()
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
        // 点击编辑
        // let name = this.form.materialName
        // let url = this.form.materialUrl
        // let form = { materialName: name, materialUrl: url }
        // if (this.form.weMaterialImgAoList === null) {
        //   this.form.weMaterialImgAoList = []
        // }
        // this.form.weMaterialImgAoList.push(form)
        // this.materialNames.push(name)
        // this.materialUrls.push(url)
        // console.log(537, this.form)
        // console.log(this.materialNames)
        // console.log(this.materialUrls)
        this.disabled = !this.disabled
      }
    },
    // 图片清空
    picReset() {
      this.form = {} // 素材表单
      this.materialUrls = [] // 多个图片地址
      this.materialNames = [] // 多个图片名称
      this.mobForm = [{}]
    },
    // 获取详情
    getDeatil() {
      this.loading = true
      this.detailForm.mediaType = this.type
      this.detailForm.materialId = JSON.parse(decodeURIComponent(this.$route.query.obj)).id
      getList(this.detailForm)
        .then(({ rows, total }) => {
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
    // numClick(id) {
    //   this.$router.push({
    //     url: '',
    //     id,
    //   })
    // },
    getTableData(data) {
      this.query.contentId = this.form.id
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
    getLineData(data) {
      // this.searchData = data
      data.contentId = this.form.id
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
  created() {
    this.form = JSON.parse(decodeURIComponent(this.$route.query.obj))
    // this.mobForm[0].msgType = this.$route.query.type
    this.mobForm[0] = this.form
    this.type = this.$route.query.type
    // this.form = JSON.parse(decodeURIComponent(this.$route.query.obj))
    this.getDeatil()
    this.getTree()
  },
  mounted() {
    this.dealLength()
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
    materialUrls: {
      handler(val) {
        this.mobForm = []
        val.forEach((item) => {
          let from = { mediaType: '0', materialUrl: item }
          this.mobForm.push(from)
        })
        // console.log(669, this.mobForm)
      },
      immediate: true,
      deep: true,
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
