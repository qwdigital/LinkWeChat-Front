<template>
  <div>
    <div class="g-card" :style="isDetail ? '' : 'margin-top: 20px;'">
      <el-row>
        <el-col>
          <el-form :model="form" :rules="ruleForm" ref="ruleForm" label-width="140px" labelPosition="right">
            <el-form-item label="任务名称" prop="fassionName">
              <el-input
                :disabled="isDetail"
                v-model="form.fassionName"
                placeholder="请输入名称"
                maxlength="15"
                show-word-limit
                clearable
              >
              </el-input>
            </el-form-item>
            <slot></slot>
            <el-form-item label="任务时间" prop="fassionStartTime">
              <el-date-picker
                :disabled="isDetail"
                @change="setChange"
                v-model.trim="dateRange"
                :picker-options="pickerOptions"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                align="right"
                value-format="yyyy-MM-dd HH:mm:SS"
              ></el-date-picker>
            </el-form-item>
            <template v-if="form.fassionType == 1">
              <SelectFassionCustomerVue
                :isDetail="isDetail"
                :dataObj="form.executeUserOrGroup"
                @update="getData"
              ></SelectFassionCustomerVue>
            </template>
            <template v-if="form.fassionType == 2">
              <SelectFassionGroup
                :isDetail="isDetail"
                ref="fassionGroup"
                :dataObj="form.executeUserOrGroup"
                @update="getData"
              ></SelectFassionGroup>
            </template>
          </el-form>
        </el-col>
      </el-row>
    </div>
    <div class="g-footer-sticky" style="text-align: center;" v-if="!isDetail">
      <el-button plain @click="$router.go(-1)">取消</el-button>
      <el-button type="primary" @click="gotoNext">下一步</el-button>
    </div>
  </div>
</template>
<script>
  import { dateFormat } from '@/utils/index'
  import SelectFassionCustomerVue from './SelectFassionCustomer.vue'
  import SelectFassionGroup from './SelectFassionGroup.vue'
  export default {
    name: 'task-steps-base',
    components: {
      SelectFassionCustomerVue,
      SelectFassionGroup
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
        ruleForm: {
          fassionName: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
          fassionStartTime: [{ required: true, message: '请选择任务时间', trigger: 'blur' }]
        },
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
          if (newValue && newValue[0]) {
            let date = new Date()
            let min = date.getMinutes()
            date.setMinutes(min + 1)
            let nowDate = dateFormat(date, 'hh:mm:ss')
            let st = ''
            if (dateFormat(date, 'yyyy-MM-dd') === dateFormat(newValue[0], 'yyyy-MM-dd')) {
              let hh1 = dateFormat(newValue[0], 'hh:mm:ss')
              if (hh1 < nowDate) {
                this.dateRange[0] = dateFormat(new Date(), 'yyyy-MM-dd hh:mm:ss')
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
          this.form = val
          this.setData()
        },
        immediate: true
      }
    },
    methods: {
      gotoNext() {
        this.$refs.ruleForm.validate((validate) => {
          if (validate) {
            if (this.form.fassionType == 2) {
              if (this.$refs.fassionGroup.checkData()) {
                this.$emit('next', 1)
              }
            } else {
              this.$emit('next', 1)
            }
          }
        })
      },
      setData() {
        if (this.form.fassionStartTime && this.form.fassionEndTime) {
          this.dateRange = [this.form.fassionStartTime, this.form.fassionEndTime]
        }
      },
      setChange(data) {
        if (data && data[0]) {
          this.form.fassionStartTime = data[0]
        } else {
          this.form.fassionStartTime = ''
        }
        if (data && data[1]) {
          this.form.fassionEndTime = data[1]
        } else {
          this.form.fassionEndTime = ''
        }
        this.$emit('update', this.form)
      },
      getData(data) {
        this.form.executeUserOrGroup = data
        this.$emit('update', this.form)
      }
    }
  }
</script>

<style lang="scss" scoped></style>
