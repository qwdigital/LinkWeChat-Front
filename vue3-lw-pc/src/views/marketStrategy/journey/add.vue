<script>
// import Flow from './Flow'
import { getCodeCategoryList } from '@/api/drainageCode/staff'
import { getDetail, setAdd, setUpdate } from '@/api/marketStrategy/journey.js'
export default {
  name: '',
  components: {
    // Flow,
    Flow: () => import('./Flow.vue'),
  },
  data() {
    return {
      active: process.env.NODE_ENV === 'development' ? 0 : 0,
      rules: {
        name: [{ required: true, message: '必填项', trigger: 'blur' }],
        groupId: [{ required: true, message: '必填项', trigger: 'change' }],
        type: [{ required: true, message: '必填项', trigger: 'change' }],
        cycleCode: [{ required: true, message: '必填项', trigger: 'change' }],
        dataValue: [{ required: true, message: '必填项', trigger: 'change' }],
        timeValue: [{ required: true, message: '必填项', trigger: 'change' }],
        executeTime: [{ required: true, message: '必填项', trigger: 'change' }],
        cycleValue: [{ required: true, message: '必填项', trigger: 'change' }],
      },
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < new Date().setDate(new Date().getDate() - 1)
        },
      },
      textContent: '当前策略旅程新建完成后，系统立即开始执行该旅程',
      textList: [
        '当前策略旅程新建完成后，系统立即开始执行该旅程',
        '当前策略旅程新建完成后，按照设置的开始执行时间执行',
        '当前策略旅程新建完成后，按照设置的时间进行周期执行',
      ],
      selectedGroup: {},
      //   dialogTitle: "定时执行",
      dialogFormVisible: false,
      form: {
        groupId: '1', // 分组id
        cycleCode: 1,
        cycleValue: 1,
        type: 1, // 执行方式
        executeTime: '', // 执行时间
        timeValue: '', // 时分
        dataValue: '', // 年月日
      },
      weekList: [],
      monthList: [],
      showWeek: false,
      showMonth: false,
      //   timeValue: "",
      //   dataValue: "",
      groupList: [],
      isEdit: false, // 是否为编辑页面
      minTime: '',
    }
  },
  computed: {
    // disabled() {
    //   return this.$route.query.type == "view";
    // },
    defaultTime() {
      let date = new Date()
      date.setMinutes(date.getMinutes() - date.getTimezoneOffset() + 60)
      return date.toJSON().substring(11, 19)
    },
  },
  watch: {
    'form.dataValue': {
      handler(newVal, oldVal) {
        console.log(newVal)
        let date = new Date()
        let year = date.getFullYear()
        let mouth = this.get0(date.getMonth() + 1)
        let day = this.get0(date.getDate())
        let hours = this.get0(date.getHours())
        let mutations = this.get0(date.getMinutes())
        let value = year + '-' + mouth + '-' + day
        // console.log(this.form.timeValue);
        if (newVal === value) {
          this.minTime = hours + ':' + day
          this.form.timeValue = ''
        } else {
          this.minTime = ''
        }
      },
      // 深度监听 属性的变化
      deep: true,
    },
  },
  created() {},
  mounted() {
    this.setDate()
    this.setMonth()
    getCodeCategoryList({ mediaType: 8 }).then((res) => {
      if (res.code == 200) {
        this.groupList = res.data
      }
    })
    // 判断是否为编辑页面
    let id = +this.$route.query.id
    if (id === 0 || id) {
      this.isEdit = true
      this.getJourneyDetail(id)
    }
  },
  methods: {
    // 补零
    get0(num) {
      if (num < 10) {
        num = '0' + num
      }
      return num
    },
    // 获取详情
    getJourneyDetail(id) {
      getDetail(id).then((res) => {
        if (res.code == 200) {
          //   res.data = {
          //     cycleCode: 2,
          //     cycleValue: 3,
          //     executeTime: "2022-10-07 16:00",
          //     groupId: "1",
          //     type: 2,
          //     name: "张三",
          //   };
          this.form = res.data
          if (res.data.type == 2) {
            // 定时执行
            let dataList = this.form.executeTime.split(' ')
            this.form.dataValue = dataList[0]
            this.form.timeValue = dataList[1]
          }
        }
      })
    },
    next() {
      this.$refs.form.validate((value) => {
        if (value) {
          //   if (
          //     !this.disabled &&
          //     this.form.deadline &&
          //     this.form.deadline < +new Date()
          //   ) {
          //     this.$message.error("任务结束时间不能小于当前时间");
          //   } else {
          //     this.active = 1;
          //   }
          if (this.form.type == 2) {
            this.form.executeTime = this.form.dataValue + ' ' + this.form.timeValue
          }
          //   console.log(this.form.executeTime);
          this.active = 1
        }
      })
    },
    changeCycle(value) {
      if (value === 2) {
        this.showWeek = true
        this.showMonth = false
      } else if (value === 3) {
        this.showWeek = false
        this.showMonth = true
      } else {
        this.showWeek = false
        this.showMonth = false
      }
      this.form.cycleValue = 1
    },
    // 周一到周日
    setDate() {
      this.weekList = []
      for (let i = 1; i < 8; i++) {
        let week = '周一'
        switch (i) {
          case 1:
            week = '周一'
            break
          case 2:
            week = '周二'
            break
          case 3:
            week = '周三'
            break
          case 4:
            week = '周四'
            break
          case 5:
            week = '周五'
            break
          case 6:
            week = '周六'
            break
          case 7:
            week = '周日'
            break

          default:
            break
        }
        let obj = { value: i, lable: week }
        this.weekList.push(obj)
      }
    },
    // 1号到31号
    setMonth() {
      this.monthList = []
      for (let i = 1; i < 32; i++) {
        let week = i + '号'
        let obj = { value: i, lable: week }
        this.monthList.push(obj)
      }
    },
    timeChange(value) {
      //   this.timeValue = value
    },
  },
}
</script>

<template>
  <div>
    <div class="g-card">
      <div class="">
        <el-steps :active="active" align-center>
          <el-step title="基础信息"></el-step>
          <el-step title="旅程画布"></el-step>
        </el-steps>
      </div>
    </div>
    <div class="g-card bottom-card" v-show="active == 0">
      <div class="bottom-box">
        <span class="base-info">基础信息</span>
        <div class="from-style">
          <!-- <el-form
            label-width="120px"
            ref="form"
            :model="form"
            :rules="rules"
            :disabled="disabled"
          > -->
          <el-form label-width="120px" ref="form" :model="form" :rules="rules">
            <el-form-item label="旅程名称" prop="name">
              <div class="w260">
                <el-input
                  v-model="form.name"
                  size="mini"
                  placeholder="请输入旅程名称"
                  maxlength="30"
                  show-word-limit></el-input>
              </div>
            </el-form-item>
            <el-form-item label="旅程分组" prop="groupId">
              <div class="w260">
                <el-select v-model="form.groupId" placeholder="请选择" size="mini">
                  <!-- <el-option label="默认分组" value></el-option> -->
                  <el-option
                    v-for="(item, index) in groupList"
                    :key="index"
                    :label="item.name"
                    :value="item.id"></el-option>
                </el-select>
              </div>
            </el-form-item>
            <el-form-item label="执行方式" prop="type">
              <el-radio-group v-model="form.type">
                <el-radio :label="1">立即执行</el-radio>
                <el-radio :label="2">定时执行</el-radio>
                <el-radio :label="3">重复执行</el-radio>
              </el-radio-group>
            </el-form-item>
            <span class="bottom-text">{{ textContent }}</span>
            <!-- 重复执行 -->
            <div v-if="form.type === 3 ? true : false">
              <el-form-item label="执行周期" required>
                <div class="time-style">
                  <el-form-item prop="cycleCode">
                    <el-select v-model="form.cycleCode" size="mini" @change="changeCycle">
                      <el-option label="每天" :value="1"></el-option>
                      <el-option label="每周" :value="2"></el-option>
                      <el-option label="每月" :value="3"></el-option>
                    </el-select>
                  </el-form-item>
                  <el-form-item prop="cycleValue" v-if="showWeek || showMonth">
                    <el-select v-model="form.cycleValue" size="mini" v-if="showWeek">
                      <el-option
                        v-for="(item, index) in weekList"
                        :key="index"
                        :label="item.lable"
                        :value="item.value"></el-option>
                    </el-select>
                    <el-select v-model="form.cycleValue" v-if="showMonth">
                      <el-option
                        v-for="(item, index) in monthList"
                        :key="index"
                        :label="item.lable"
                        :value="item.value"></el-option>
                    </el-select>
                  </el-form-item>
                </div>
              </el-form-item>
              <el-form-item label="执行时间" label-width="120px" prop="executeTime">
                <el-time-select
                  v-model="form.executeTime"
                  size="mini"
                  style="width: 330px"
                  :picker-options="{
                    start: '00:00',
                    step: '00:30',
                    end: '23:59',
                  }"
                  placeholder="选择时分"
                  @change="timeChange"></el-time-select>
              </el-form-item>
            </div>
            <!-- 定时执行 -->
            <el-form-item label="执行时间" label-width="120px" v-if="form.type === 2 ? true : false" required>
              <div class="pickerStyle">
                <el-form-item prop="dataValue">
                  <el-date-picker
                    size="mini"
                    v-model="form.dataValue"
                    :default-time="defaultTime"
                    :picker-options="pickerOptions"
                    type="date"
                    placeholder="选择年月日"
                    style="width: 150px; margin-right: 30px"
                    format="yyyy-MM-dd"
                    value-format="yyyy-MM-dd"></el-date-picker>
                </el-form-item>
                <el-form-item prop="timeValue">
                  <el-time-select
                    v-model="form.timeValue"
                    size="mini"
                    style="width: 150px"
                    :picker-options="{
                      start: '00:00',
                      step: '00:30',
                      end: '23:59',
                      minTime: minTime,
                    }"
                    placeholder="选择时分"></el-time-select>
                </el-form-item>
              </div>
            </el-form-item>
          </el-form>
        </div>
        <div class="button-style">
          <el-button size="mini" type="primary" @click="next">下一步</el-button>
          <el-button size="mini" @click="$router.back()">取消</el-button>
        </div>
      </div>
    </div>
    <keep-alive>
      <div class="" v-if="active == 1">
        <Flow :form="form" @cancel="active = 0"></Flow>
      </div>
    </keep-alive>
  </div>
</template>

<style lang="scss" scoped>
.pickerStyle {
  display: flex;
  .el-form-item {
    padding: 0 !important;
  }
}
.base-info {
  font-size: 16px;
  font-family: 'PingFang SC-粗体', 'PingFang SC';
  font-weight: 600;
}
.bottom-card {
  height: 67.5vh;
  .bottom-box {
    position: relative;
    height: 100%;
    .button-style {
      position: absolute;
      bottom: 24px;
      right: 20px;
    }
  }
}
.from-style {
  width: 44.5%;
  margin-top: 20px;
  .bottom-text {
    font-size: 12px;
    font-weight: normal;
    color: rgba(0, 0, 0, 0.4);
    line-height: 22px;
    // margin-left: 134px
    margin-left: 130px;
  }
  .time-style {
    display: flex;
    width: 360px;
    .el-select {
      margin-right: 30px;
    }
    .el-form-item {
      padding: 0 !important;
      width: 150px;
      margin-right: 30px !important;
    }
  }
}
.el-select {
  width: 100%;
}
.el-radio {
  display: block;
  margin-bottom: 15px;
}
.el-radio:nth-child(1) {
  margin-top: 5px;
}
.el-radio:nth-child(3) {
  margin-bottom: 0;
}
</style>
