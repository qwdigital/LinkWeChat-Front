<template>
  <div>
    <div class="g-card" style="margin-top: 20px;">
      <el-row>
        <el-col :offset="8" :span="8">
          <el-form :model="form" :rules="ruleForm" ref="ruleForm" label-width="120px" labelPosition="right">
            <el-form-item label="任务名称" prop="taskName">
              <el-input v-model="form.fassionName" placeholder="请输入名称" maxlength="15" show-word-limit clearable>
              </el-input>
            </el-form-item>
            <el-form-item label="任务时间" required>
              <el-date-picker
                v-model.trim="dateRange"
                :picker-options="pickerOptions"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                align="right"
                value-format="yyyy-MM-dd HH:mm"
              ></el-date-picker>
            </el-form-item>
            <SelectFassionCustomerVue :dataObj="form.executeUserOrGroup" @update="getData"></SelectFassionCustomerVue>
          </el-form>
        </el-col>
      </el-row>
    </div>
    <div class="g-card" style="text-align: center;" v-if="!isDetail">
      <el-button plain>取消</el-button>
      <el-button type="primary">下一步</el-button>
    </div>
  </div>
</template>
<script>
  import { dateFormat } from '@/utils/index'
  import SelectFassionCustomerVue from './SelectFassionCustomer.vue'
  export default {
    name: 'task-steps-base',
    components: {
      SelectFassionCustomerVue
    },
    data() {
      return {
        form: {
          fassionType: 1,
          fassionName: '',
          fassionStartTime: '',
          fassionEndTime: '',
          executeUserOrGroup: null
        },
        dateRange: [],
        ruleForm: {},
        pickerOptions: {
          disabledDate(time) {
            let data = Date.now() - 8.64e7
            return time.getTime() < data
          }
        }
      }
    },
    props: {
      isDetail: {
        type: Boolean,
        default: false
      },
      baseData: {
        type: Object,
        defalult: {}
      }
    },
    watch: {
      dateRange: {
        handler(newValue, oldValue) {
          if (newValue[0]) {
            let date = new Date()
            let min = date.getMinutes()
            date.setMinutes(min + 1)
            let nowDate = dateFormat(date, 'hh:mm')
            let st = ''
            if (dateFormat(date, 'yyyy-MM-dd') === dateFormat(newValue[0], 'yyyy-MM-dd')) {
              let hh1 = dateFormat(newValue[0], 'hh:mm')
              if (hh1 < nowDate) {
                this.dateRange[0] = dateFormat(new Date(), 'yyyy-MM-dd hh:mm')
              }
              st = nowDate
            } else {
              st = '00:00'
            }
          }
        }
      },
      baseData: {
        handler(val) {
          this.setData(val)
        },
        immediate: true
      }
    },
    methods: {
      setData(val) {},
      getData(data) {
        this.form.executeUserOrGroup = data
      }
    }
  }
</script>

<style lang="scss" scoped></style>
