<template>
  <div>
    <el-form ref="form" :model="form" label-width="100px">
      <SelectGroupVue
        :isDetail="isDetail"
        ref="selectCustomer"
        :dataObj="form.group"
        @update="getUpdateCustomer"></SelectGroupVue>
      <IdentityAttachmentVue
        :isDetail="isDetail"
        ref="selectAttachment"
        @phoneData="getPhoneData"
        @success="getAttentment"
        @changeInfo="changeInfo"
        :baseData="attachmentsData"></IdentityAttachmentVue>
      <SelectSendTypeVue
        :isDetail="isDetail"
        ref="selectSendType"
        :data="form.group"
        @update="getSendType"></SelectSendTypeVue>
      <SelectEndDateVue
        :isDetail="isDetail"
        ref="selectEndDate"
        :data="form.group"
        @update="getEndDate"></SelectEndDateVue>
    </el-form>
  </div>
</template>

<script>
import { dateFormat, setAttachments } from '@/utils/index'
import IdentityAttachmentVue from './IdentityAttachment.vue'
import SelectGroupVue from './SelectGroup.vue'
import SelectEndDateVue from './SelectEndDate.vue'
import SelectSendTypeVue from './SelectSendType.vue'
export default {
  name: 'step3-type-2',
  components: {
    SelectGroupVue,
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
      previewData: [],
      form: {
        type: 0,
        group: {
          content: '',
          type: 0,
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
      if (!this.form.group) {
        this.form.group = {
          type: 0,
          content: '',
          userIds: '',
          sendType: 0,
          taskSendTime: '',
          taskEndTime: '',
        }
      }
      if (!this.form.attachments) {
        this.form.attachments = []
      }
      if (this.form.attachments) {
        let arr = []
        this.form.attachments.forEach((dd) => {
          if (dd.msgType !== 'text') {
            arr.push(dd)
          }
        })
        this.attachmentsData.templateInfo = this.form.group.content
        let data = setAttachments(arr)
        this.attachmentsData.attachments = data
        this.$emit('preview', {
          previewData: JSON.parse(JSON.stringify(this.attachmentsData.attachments)),
        })
        this.$emit('previewText', { templateInfo: this.attachmentsData.templateInfo })
      }
    },
    changeInfo(data) {
      this.form.group.content = data
      this.$emit('update', this.form)
      this.$emit('previewText', { templateInfo: data })
    },
    getPhoneData(data) {
      this.previewData = data
      this.$emit('preview', {
        templateInfo: this.attachmentsData.templateInfo,
        previewData: JSON.parse(JSON.stringify(data)),
      })
    },
    getAttentment(data) {
      this.form.attachments = data
      this.$emit('update', this.form)
    },
    getSendType(data) {
      this.form.group.sendType = data.sendType
      this.form.group.taskSendTime = dateFormat(data.taskSendTime)
      this.$emit('update', this.form)
    },
    getEndDate(data) {
      this.form.group.taskEndTime = dateFormat(data.taskEndTime)
      this.$emit('update', this.form)
    },
    getUpdateCustomer(data) {
      this.form.group = data
      this.$emit('update', this.form)
    },
  },
}
</script>

<style scoped></style>
