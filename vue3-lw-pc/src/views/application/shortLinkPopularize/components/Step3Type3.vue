<template>
  <div>
    <el-form ref="form" :model="form" label-width="100px">
      <SelectCustomerVue
        :isDetail="isDetail"
        ref="selectCustomer"
        :dataObj="form.moments"
        title="发送范围"
        @update="getUpdateCustomer"
      ></SelectCustomerVue>
      <el-form-item label="动态文本" required style="margin-right: 200px !important;" :error="templateInfoError">
        <TextareaExtend
          :disabled="isDetail"
          v-model="templateInfo"
          :toolbar="isDetail ? [] : ['emoji']"
          maxlength="2000"
          show-word-limit
          placeholder="请输入"
          :autosize="{ minRows: 5, maxRows: 20 }"
          clearable
          :autofocus="false"
        />
      </el-form-item>
      <SelectSendTypeVue
        :isDetail="isDetail"
        ref="selectSendType"
        :data="form.moments"
        @update="getSendType"
      ></SelectSendTypeVue>
      <SelectEndDateVue
        :isDetail="isDetail"
        ref="selectEndDate"
        :data="form.moments"
        @update="getEndDate"
      ></SelectEndDateVue>
    </el-form>
  </div>
</template>

<script>
  import { dateFormat } from '@/utils/index'
  import SelectCustomerVue from './SelectCustomer.vue'
  import SelectEndDateVue from './SelectEndDate.vue'
  import SelectSendTypeVue from './SelectSendType.vue'
  export default {
    name: 'step3-type-3',
    components: {
      SelectCustomerVue,
      SelectSendTypeVue,
      SelectEndDateVue
    },
    props: {
      data: {
        type: Object,
        default: () => {}
      },
      isDetail: {
        type: Boolean,
        default: false
      }
    },
    watch: {
      data: {
        handler(val, old) {
          if (val) {
            this.form = val
            this.setData()
          }
        },
        deep: true,
        immediate: true
      },
      templateInfo(val) {
        this.templateInfoError = ''
        this.changeInfo(val)
      }
    },
    data() {
      return {
        templateInfoError: '',
        templateInfo: '',
        previewData: [],
        form: {
          type: 0,
          moments: {
            type: 0,
            sex: null,
            content: '',
            trackState: null,
            addBeginTime: '',
            addEndTime: '',
            labelIds: '',
            userIds: '',
            sendType: 0,
            taskSendTime: '',
            taskEndTime: ''
          }
        }
      }
    },
    methods: {
      checkFn() {
        if (!this.templateInfo) {
          this.templateInfoError = '请输入动态文本'
          return false
        } else {
          return true
        }
      },
      setData() {
        if (!this.form.moments) {
          this.form.moments = {
            type: 0,
            sex: null,
            content: '',
            trackState: null,
            addBeginTime: '',
            addEndTime: '',
            labelIds: '',
            userIds: '',
            sendType: 0,
            taskSendTime: '',
            taskEndTime: ''
          }
        }
        this.templateInfo = this.form.moments.content
        this.$emit('previewText', { templateInfo: this.templateInfo })
      },
      changeInfo(data) {
        this.form.moments.content = data
        this.$emit('update', this.form)
        this.$emit('previewText', { templateInfo: this.templateInfo })
      },
      getSendType(data) {
        this.form.moments.sendType = data.sendType
        this.form.moments.taskSendTime = dateFormat(data.taskSendTime)
        this.$emit('update', this.form)
      },
      getEndDate(data) {
        this.form.moments.taskEndTime = dateFormat(data.taskEndTime)
        this.$emit('update', this.form)
      },
      getUpdateCustomer(data) {
        this.form.moments = data
        this.$emit('update', this.form)
      }
    }
  }
</script>

<style scoped></style>
