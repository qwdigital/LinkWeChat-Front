<template>
  <div>
    <el-form ref="form" :model="form" label-width="100px">
      <el-form-item label="发送范围" required :error="errorInfo">
        <SelectMemberVue
          ref="selectMember"
          :isDetail="isDetail"
          title="发送范围"
          :initData="form.appMsg"
          @update="getMember"
        ></SelectMemberVue>
      </el-form-item>
      <SelectSendTypeVue
        :isDetail="isDetail"
        ref="selectSendType"
        :data="form.appMsg"
        @update="getSendType"
      ></SelectSendTypeVue>
      <SelectEndDateVue
        :isDetail="isDetail"
        ref="selectEndDate"
        :data="form.appMsg"
        @update="getEndDate"
      ></SelectEndDateVue>
    </el-form>
  </div>
</template>

<script>
  import { dateFormat } from '@/utils/index'
  import SelectEndDateVue from './SelectEndDate.vue'
  import SelectSendTypeVue from './SelectSendType.vue'
  import SelectMemberVue from '../../common/SelectMember.vue'
  export default {
    name: 'step3-type-4',
    components: {
      SelectSendTypeVue,
      SelectEndDateVue,
      SelectMemberVue
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
      }
    },
    data() {
      return {
        errorInfo: '',
        previewData: [],
        form: {
          type: 0,
          appMsg: {
            executeUserCondit: {
              change: false,
              weUserIds: []
            },
            executeDeptCondit: {
              change: false,
              deptIds: [],
              posts: []
            },
            sendType: 0,
            taskSendTime: '',
            taskEndTime: ''
          }
        }
      }
    },
    methods: {
      checkFn() {
        return this.$refs.selectMember.validateFn()
      },
      setData() {
        if (!this.form.appMsg) {
          this.form.appMsg = {
            executeUserCondit: {
              change: false,
              weUserIds: []
            },
            executeDeptCondit: {
              change: false,
              deptIds: [],
              posts: []
            },
            sendType: 0,
            taskSendTime: '',
            taskEndTime: ''
          }
        } else {
          if (!this.form.appMsg.executeUserCondit) {
            this.form.appMsg.executeUserCondit = {
              change: false,
              weUserIds: []
            }
          }
          if (!this.form.appMsg.executeDeptCondit) {
            this.form.appMsg.executeDeptCondit = {
              change: false,
              deptIds: [],
              posts: []
            }
          }
        }
      },
      getSendType(data) {
        this.form.appMsg.sendType = data.sendType
        this.form.appMsg.taskSendTime = dateFormat(data.taskSendTime)
        this.$emit('update', this.form)
      },
      getEndDate(data) {
        this.form.appMsg.taskEndTime = dateFormat(data.taskEndTime)
        this.$emit('update', this.form)
      },
      getMember(data) {
        this.form.appMsg.executeUserCondit = data.executeUserCondit
        this.form.appMsg.executeDeptCondit = data.executeDeptCondit
        this.$emit('update', this.form)
      }
    }
  }
</script>

<style scoped></style>
