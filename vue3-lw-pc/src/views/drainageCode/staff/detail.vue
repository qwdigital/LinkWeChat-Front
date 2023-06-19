<template>
  <div>
    <el-row style="margin-top: 10px" type="flex" :gutter="10">
      <el-col>
        <div class="g-card">
          <div class="g-card-title">基本信息</div>
          <div class="pad20">
            <el-form label-position="right" label-width="100px">
              <el-form-item style="margin-bottom: 10px" label="活码名称">{{ form.name }}</el-form-item>
              <el-form-item style="margin-bottom: 10px" label="活码分组">{{ form.qrGroupName }}</el-form-item>
              <el-form-item style="margin-bottom: 10px" label="自动通过好友">
                <el-switch :value="form.autoAdd" :active-value="1" :inactive-value="0" disabled></el-switch>
              </el-form-item>
              <el-form-item style="margin-bottom: 10px" label="新客户标签">
                <el-tag v-for="(data, key) in form.qrTags" :key="key">{{ data.tagName }}</el-tag>
              </el-form-item>
            </el-form>
          </div>
        </div>
        <div class="g-card">
          <div class="g-card-title">活码员工</div>
          <!-- <template v-if="form.ruleType === 1">
            <div class="pad20">
              <div class="content pad20">
                <el-form label-position="right" label-width="100px">
                  <el-form-item style="margin-bottom: 10px" label="排班员工">
                    <el-tag v-for="(data, key) in form.qrUserInfos" :key="key">{{data.businessName}}</el-tag>
                  </el-form-item>
                  <el-form-item style="margin-bottom: 10px" label="工作周期">
                    <el-checkbox-group v-model="checkList">
                      <el-checkbox label="周一" disabled></el-checkbox>
                      <el-checkbox label="周二" disabled></el-checkbox>
                      <el-checkbox label="周三" disabled></el-checkbox>
                      <el-checkbox label="周四" disabled></el-checkbox>
                      <el-checkbox label="周五" disabled></el-checkbox>
                      <el-checkbox label="周六" disabled></el-checkbox>
                      <el-checkbox label="周日" disabled></el-checkbox>
                    </el-checkbox-group>
                  </el-form-item>
                  <el-form-item style="margin-bottom: 10px" label="在线时间">
                    <el-time-select disabled value="00:00" placeholder="任意时间点">
                    </el-time-select>
                    <el-time-select arrow-control disabled value="23:59" placeholder="任意时间点">
                    </el-time-select>
                  </el-form-item>
                </el-form>
              </div>
            </div>
          </template>-->

          <div class="pad20" v-for="(unit, index) in form.qrUserInfos" :key="index">
            <div class="content pad20">
              <el-form label-position="right" label-width="100px">
                <el-form-item style="margin-bottom: 10px" label="排班员工">
                  <el-tag v-for="(data, key) in unit.weQrUserList" :key="key">{{ data.userName }}</el-tag>
                </el-form-item>
                <el-form-item style="margin-bottom: 10px" label="工作周期">
                  <el-checkbox-group v-if="unit.type === 0" v-model="checkList">
                    <el-checkbox label="周一" disabled></el-checkbox>
                    <el-checkbox label="周二" disabled></el-checkbox>
                    <el-checkbox label="周三" disabled></el-checkbox>
                    <el-checkbox label="周四" disabled></el-checkbox>
                    <el-checkbox label="周五" disabled></el-checkbox>
                    <el-checkbox label="周六" disabled></el-checkbox>
                    <el-checkbox label="周日" disabled></el-checkbox>
                  </el-checkbox-group>
                  <el-checkbox-group v-else v-model="unit.weekday">
                    <el-checkbox label="1" disabled>周一</el-checkbox>
                    <el-checkbox label="2" disabled>周二</el-checkbox>
                    <el-checkbox label="3" disabled>周三</el-checkbox>
                    <el-checkbox label="4" disabled>周四</el-checkbox>
                    <el-checkbox label="5" disabled>周五</el-checkbox>
                    <el-checkbox label="6" disabled>周六</el-checkbox>
                    <el-checkbox label="7" disabled>周日</el-checkbox>
                  </el-checkbox-group>
                </el-form-item>
                <el-form-item v-if="unit.type === 0" v-model="checkList" style="margin-bottom: 10px" label="在线时间">
                  <el-time-select disabled value="00:00" placeholder="任意时间点"></el-time-select>
                  <el-time-select disabled value="23:59" placeholder="任意时间点"></el-time-select>
                </el-form-item>
                <el-form-item v-else style="margin-bottom: 10px" label="在线时间">
                  <el-time-select disabled :value="unit.beginTime" placeholder="任意时间点"></el-time-select>
                  <el-time-select disabled :value="unit.endTime" placeholder="任意时间点"></el-time-select>
                </el-form-item>
              </el-form>
            </div>
          </div>
        </div>
        <div class="g-card">
          <div class="g-card-title">活码统计</div>
          <CardGroupIndex :data="cardData"></CardGroupIndex>

          <div class="">
            <el-button-group>
              <el-button type="primary" :plain="timeRange != 7" @click="setTime(7)">近7日</el-button>
              <el-button type="primary" :plain="timeRange != 30" @click="setTime(30)">近30日</el-button>
            </el-button-group>
            <el-date-picker
              v-model="dateRange"
              class="ml20"
              style="width: 260px"
              value-format="YYYY-MM-DD"
              type="daterange"
              :clearable="false"
              range-separator="-"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              @change="getList"></el-date-picker>
          </div>
          <div ref="chart" id="mychart" style="width: 100%; height: 400px"></div>
        </div>
      </el-col>
      <el-col style="flex-basis: auto">
        <div style="height: 100%; display: flex; flex-direction: column">
          <div class="g-card">
            <div class="right-title pad20">
              <div class="right-title-name">员工活码</div>
              <div class="right-title-edit" @click="editFn">
                <!-- <img style="margin-right:5px;height: 12px;width: 12px;" :src="('@/assets/drainageCode/code-add.png')" alt=""> -->
                编辑
              </div>
            </div>
            <div class="pad20">
              <div class="code-show">
                <el-image
                  :src="form.qrCode"
                  fit="fill"
                  :preview-src-list="[form.qrCode]"
                  style="width: 124px; height: 124px"></el-image>
                <div>
                  <el-button text @click="download()">下载二维码</el-button>
                </div>
              </div>
            </div>
          </div>
          <div class="g-card" style="flex: 1">
            <preview-client :list="form"></preview-client>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import PreviewClient from '@/components/previewInMobileClient.vue'
import { getDetail, getTotal, downloadBatch } from '@/api/drainageCode/staff'

//

export default {
  name: 'CodeDetail',
  components: {
    PreviewClient,
  },
  data() {
    return {
      form: {},
      checkList: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
      // 遮罩层
      loading: false,
      // 选中数组
      ids: [],
      // 表格数据
      list: [],
      // 日期范围
      dateRange: [],
      // 表单参数
      form: {},
      // 查询参数
      query: {
        qrId: '',
        beginTime: undefined,
        endTime: undefined,
      },
      type: {
        1: '单人',
        2: '多人',
        3: '批量单人',
      },
      timeRange: 7,

      cardData: [],
    }
  },
  created() {
    let id = this.$route.query.id
    this.query.qrId = id
    id && this.getDetail(id)
    // this.getList()
  },
  mounted() {
    // var clipboard = new this.ClipboardJS('.copy-btn')
  },
  methods: {
    editFn() {
      this.$router.push({
        path: '/drainageCode/qrCode/staff/' + 'staffAdd',
        query: {
          id: this.form.id,
        },
      })
    },
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id).then((res) => {
        this.form = res.data
        if (this.form.qrAttachments && this.form.qrAttachments.length) {
          this.form.welcomeMsg = this.form.qrAttachments[0].content
          this.form.materialMsgList = this.setEditList(this.form.qrAttachments)
        }
        this.form.qrUserInfos.forEach((dd) => {
          if (dd.workCycle) {
            dd.weekday = dd.workCycle.split(',')
          } else {
            dd.weekday = []
          }
        })
        this.loading = false
        this.setTime(7)
      })
    },
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              msgType: '8',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              msgType: '9',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    getList() {
      this.query.beginTime = this.dateRange[0]
      this.query.endTime = this.dateRange[1]
      getTotal(this.query).then(({ data }) => {
        this.cardData = [
          {
            title: '今日扫码次数',
            value: data.total,
          },
          {
            title: '累计扫码次数',
            value: data.today,
          },
        ]
        let option = {
          xAxis: {
            type: 'category',
            data: data.xaxis,
          },
          yAxis: {
            type: 'value',
          },
          series: [
            {
              data: data.yaxis,
              type: 'line',
            },
          ],
        }
        var myChart = echarts.init(document.getElementById('mychart'))
        myChart.setOption(option)
        this.$nextTick(() => {
          myChart.resize()
        })
      })
    },
    setTime(days) {
      this.timeRange = days
      let date = new Date()
      date.setDate(date.getDate() - days)
      this.dateRange = [this.getTime(date), this.getTime()]
      this.getList()
    },
    getHandledValue(num) {
      return num < 10 ? '0' + num : num
    },
    getTime(datePar) {
      const d = datePar ? new Date(datePar) : new Date()
      const year = d.getFullYear()
      const month = this.getHandledValue(d.getMonth() + 1)
      const date = this.getHandledValue(d.getDate())
      return year + '-' + month + '-' + date
    },
    downloadByBlob(url, name) {
      let image = new Image()
      image.setAttribute('crossOrigin', 'anonymous')
      image.src = url
      image.onload = () => {
        let canvas = document.createElement('canvas')
        canvas.width = image.width
        canvas.height = image.height
        let ctx = canvas.getContext('2d')
        ctx.drawImage(image, 0, 0, image.width, image.height)
        canvas.toBlob((blob) => {
          let url = URL.createObjectURL(blob)
          this.downloadFn(url, name)
          // 用完释放URL对象
          URL.revokeObjectURL(url)
        })
      }
    },
    downloadFn(href, name) {
      let eleLink = document.createElement('a')
      eleLink.download = name
      eleLink.href = href
      eleLink.click()
      eleLink.remove()
    },
    download() {
      let name = this.form.name + '.png'
      this.downloadByBlob(this.form.qrCode, name)
    },
  },
}
</script>

<style lang="scss" scoped>
.top {
  align-items: flex-start;
}

.title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 20px;
}

.crumb {
  font-size: 12px;

  font-weight: 400;
  color: #666666;
  display: flex;
}

.crumb- {
  // 一级 页面标题
  &title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 90px; // line-height: 90px;
    font-size: 18px;
    font-weight: 500;
    color: #333;
    padding: 0 20px;
    background: var(--bg-white);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }
}

.content {
  margin-top: 20px;
  border-radius: 4px;
  border: 1px solid #f1f1f1;
  &:first-child {
    margin-top: 0;
  }
}

.right-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  .right-title-name {
    font-size: 16px;

    font-weight: 500;
    color: #333333;
  }
  .right-title-edit {
    font-size: 12px;

    font-weight: 400;
    color: var(--color);
    display: flex;
    align-items: center;
    cursor: pointer;
    &:hover {
      opacity: 0.8;
    }
  }
}

.code-show {
  text-align: center; // .download-btn {
  // 	font-size: 12px;
  //
  // 	font-weight: 400;
  // 	color: var(--color);
  // }
}
</style>
