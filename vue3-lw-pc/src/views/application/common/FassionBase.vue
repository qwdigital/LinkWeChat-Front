<template>
  <div>
    <div class="g-card" :style="isDetail ? '' : 'margin-top: 20px;'">
      <el-form :model="form" :rules="ruleForm" ref="ruleForm" label-width="140px" labelPosition="right">
        <el-form-item label="任务名称" prop="fassionName">
          <el-input
            :disabled="isDetail"
            v-model="form.fassionName"
            placeholder="请输入名称"
            maxlength="15"
            show-word-limit
            clearable></el-input>
        </el-form-item>
        <slot></slot>
        <el-form-item label="任务时间" prop="fassionStartTime">
          <el-date-picker
            :disabled="isDetail"
            @change="setChange"
            v-model="dateRange"
            v-bind="pickerOptions"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            align="right"
            value-format="YYYY-MM-DD HH:mm:ss"></el-date-picker>
        </el-form-item>
        <template v-if="form.fassionType == 1">
          <el-form-item label="选择老客" required>
            <el-radio-group v-model="form.scopeType" :disabled="isDetail">
              <el-radio :label="0">全部客户</el-radio>
              <el-radio :label="1">部分客户</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="form.scopeType == 1">
            <CustomerRangeForm
              ref="customerRangeForm"
              isTrans
              v-model:data="form.weCustomersQuery"
              :disabled="isDetail"
              :isDetail="isDetail" />
          </el-form-item>
        </template>
        <template v-if="form.fassionType == 2">
          <el-form-item label="选择客群" required>
            <el-radio-group v-model="form.scopeType" :disabled="isDetail">
              <el-radio :label="0">全部</el-radio>
              <el-radio :label="1">选择群主</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="form.scopeType == 1">
            <SelectFassionGroup
              :isDetail="isDetail"
              ref="fassionGroup"
              :dataObj="form.executeUserOrGroup"
              @update="getData"></SelectFassionGroup>
          </el-form-item>
        </template>
      </el-form>
    </div>
    <div class="g-footer-sticky" style="text-align: center" v-if="!isDetail">
      <el-button plain @click="$router.go(-1)">取消</el-button>
      <el-button type="primary" @click="gotoNext">下一步</el-button>
    </div>
  </div>
</template>
<script>
import { dateFormat } from '@/utils/index'
import SelectFassionGroup from './SelectFassionGroup.vue'
export default {
  name: 'task-steps-base',
  components: {
    SelectFassionGroup,
  },
  data() {
    return {
      form: {
        fassionType: 1,
        scopeType: 1,
        fassionName: '',
        fassionStartTime: '',
        fassionEndTime: '',
        executeUserOrGroup: null,
      },
      dateRange: [],
      ruleForm: {
        fassionName: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
        fassionStartTime: [{ required: true, message: '请选择任务时间', trigger: 'blur' }],
      },
      pickerOptions: {
        disabledDate(time) {
          let data = Date.now() - 8.64e7
          return time.getTime() < data
        },
      },
    }
  },
  props: {
    isDetail: {
      type: Boolean,
      default: false,
    },
    baseData: {
      type: Object,
      defalult: {},
    },
  },
  watch: {
    dateRange: {
      deep: true,
      handler(newValue, oldValue) {
        if (newValue && newValue[0]) {
          let date = new Date()
          let min = date.getMinutes()
          date.setMinutes(min + 1)
          let nowDate = dateFormat(date, 'HH:mm:ss')
          let st = ''
          if (dateFormat(date, 'YYYY-MM-DD') === dateFormat(newValue[0], 'YYYY-MM-DD')) {
            let hh1 = dateFormat(newValue[0], 'HH:mm:ss')
            if (hh1 < nowDate) {
              this.dateRange[0] = dateFormat(new Date(), 'YYYY-MM-DD HH:mm:ss')
            }
            st = nowDate
          } else {
            st = '00:00'
          }
        }
      },
    },
    baseData: {
      handler(val) {
        this.form = val
        this.setData()
      },
      immediate: true,
    },
  },
  methods: {
    gotoNext() {
      this.$refs.ruleForm.validate((validate) => {
        if (validate) {
          if (this.form.scopeType == 1) {
            if (this.form.fassionType == 1) {
              this.$store.loading = true
              this.$refs.customerRangeForm
                .getCustomerList()
                .then((data) => {
                  if (data?.length) {
                    this.form.senderList = data
                    this.$emit('next', 1)
                  }
                })
                .finally(() => {
                  this.$store.loading = false
                })
            } else if (this.form.fassionType == 2) {
              if (this.$refs.fassionGroup.checkData()) {
                this.$emit('next', 1)
              }
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
    },
  },
}
</script>

<style lang="scss" scoped></style>
