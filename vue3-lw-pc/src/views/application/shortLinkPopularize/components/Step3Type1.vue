<template>
  <div>
    <el-form ref="form" :model="form" label-width="100px">
      <SelectCustomerVue
        ref="selectCustomer"
        :isDetail="isDetail"
        :dataObj="form.client"
        @update="getUpdateCustomer"></SelectCustomerVue>
      <IdentityAttachmentVue
        ref="selectAttachment"
        :isDetail="isDetail"
        @phoneData="getPhoneData"
        @success="getAttentment"
        @changeInfo="changeInfo"
        :baseData="attachmentsData"></IdentityAttachmentVue>
      <SelectSendTypeVue
        ref="selectSendType"
        :isDetail="isDetail"
        :data="form.client"
        @update="getSendType"></SelectSendTypeVue>
      <SelectEndDateVue
        :isDetail="isDetail"
        ref="selectEndDate"
        :data="form.client"
        @update="getEndDate"></SelectEndDateVue>
    </el-form>
  </div>
</template>

<script>
import { dateFormat, setAttachments } from '@/utils/index'
import IdentityAttachmentVue from './IdentityAttachment.vue'
import SelectCustomerVue from './SelectCustomer.vue'
import SelectEndDateVue from './SelectEndDate.vue'
import SelectSendTypeVue from './SelectSendType.vue'
export default {
  name: 'step3-type-1',
  components: {
    SelectCustomerVue,
    IdentityAttachmentVue,
    SelectSendTypeVue,
    SelectEndDateVue,
  },
  props: {
    data: {
      type: Object,
      default: {},
    },
    isDetail: {
      type: Boolean,
      default: false,
    },
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
      immediate: true,
    },
  },
  data() {
    return {
      attachmentsData: {
        templateInfo: '',
        attachments: [],
      },
      form: {
        type: 0,
        client: {
          type: 0,
          content: '',
          sex: null,
          trackState: null,
          addBeginTime: '',
          addEndTime: '',
          labelIds: '',
          userIds: '',
          sendType: 0,
          taskSendTime: '',
          taskEndTime: '',
        },
        attachmentsList: [],
        senderList: [],
      },
    }
  },
  methods: {
    setData() {
      if (this.form.attachments) {
        let arr = []
        this.form.attachments.forEach((dd) => {
          if (dd.msgType !== 'text') {
            arr.push(dd)
          }
        })
        this.attachmentsData.templateInfo = this.form.client.content
        let data = setAttachments(arr)
        this.attachmentsData.attachments = data
        this.$emit('preview', {
          previewData: JSON.parse(JSON.stringify(this.attachmentsData.attachments)),
        })
        this.$emit('previewText', { templateInfo: this.attachmentsData.templateInfo })
      }
      if (!this.form.client) {
        this.form.client = {
          type: 0,
          sex: '',
          content: '',
          trackState: '',
          addBeginTime: '',
          addEndTime: '',
          labelIds: '',
          userIds: '',
          sendType: 0,
          taskSendTime: '',
          taskEndTime: '',
        }
      }
      if (!this.form.attachments) {
        this.form.attachments = []
      }
      // this.$forceUpdate()
    },
    changeInfo(data) {
      this.form.client.content = data
      // this.$forceUpdate()
      this.$emit('update', this.form)
      this.$emit('previewText', { templateInfo: data })
    },
    getPhoneData(data) {
      this.$emit('preview', { previewData: data })
    },
    getAttentment(data) {
      this.form.attachments = data
      this.$emit('update', this.form)
    },
    getSendType(data) {
      this.form.client.sendType = data.sendType
      this.form.client.taskSendTime = dateFormat(data.taskSendTime)
      this.$emit('update', this.form)
    },
    getEndDate(data) {
      this.form.client.taskEndTime = dateFormat(data.taskEndTime)
      this.$emit('update', this.form)
    },
    getUpdateCustomer(data) {
      this.form.client = data
      this.$emit('update', this.form)
    },
  },
}
</script>

<style scoped></style>
