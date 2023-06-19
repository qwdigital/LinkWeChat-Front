<template>
  <div>
    <el-row :gutter="20" type="flex" style="margin-top: 20px">
      <el-col>
        <div class="g-card">
          <slot></slot>
          <template v-if="baseData.type == 0">
            <Step3Type1
              :isDetail="isDetail"
              :data="baseData"
              @update="getData"
              @preview="getPreviewInfo"
              @previewText="getPreviewInfoText"></Step3Type1>
          </template>
          <template v-else-if="baseData.type == 1">
            <Step3Type2
              :isDetail="isDetail"
              :data="baseData"
              @update="getData"
              @preview="getPreviewInfo"
              @previewText="getPreviewInfoText"></Step3Type2>
          </template>
          <template v-else-if="baseData.type == 2">
            <Step3Type3
              :isDetail="isDetail"
              ref="type3"
              :data="baseData"
              @update="getData"
              @previewText="getPreviewInfoText"></Step3Type3>
          </template>
          <template v-else-if="baseData.type == 3">
            <Step3Type4 :isDetail="isDetail" ref="type4" :data="baseData" @update="getData"></Step3Type4>
          </template>
        </div>
        <div class="g-card" style="text-align: right" v-if="!isDetail">
          <el-button plain @click="goPrdSteps(1)">上一步</el-button>
          <el-button type="primary" @click="submitFn" v-loading="submitLoading">确认推广</el-button>
        </div>
      </el-col>
      <el-col style="flex-basis: 370px" v-if="baseData.type == 0 || baseData.type == 1">
        <div class="g-card" style="height: 100%">
          <div class="info_title">消息预览</div>
          <PreviewInPhone :list="preview.previewData" :templateInfo="preview.templateInfo"></PreviewInPhone>
        </div>
      </el-col>
      <el-col style="flex-basis: 370px" v-if="baseData.type == 2">
        <div class="g-card" style="height: 100%">
          <div class="info_title">朋友圈预览</div>
          <FriendsCircPreviewVue :value="preview.templateInfo" :poster="posterObj.materialUrl"></FriendsCircPreviewVue>
        </div>
      </el-col>
      <el-col style="flex-basis: 750px" v-if="baseData.type == 3">
        <div class="g-card" style="height: 100%">
          <div class="info_title">消息预览</div>
          <AppPreviewVue :title="baseData.taskName" :value="posterObj.materialUrl"></AppPreviewVue>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { addPromotion, editPromotion } from '../api'
import { getCustomerList } from '@/api/groupMessage'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import Step3Type1 from './Step3Type1.vue'
import Step3Type2 from './Step3Type2.vue'
import Step3Type3 from './Step3Type3.vue'
import Step3Type4 from './Step3Type4.vue'
import FriendsCircPreviewVue from './FriendsCircPreview.vue'
import AppPreviewVue from './AppPreview.vue'
export default {
  components: {
    PreviewInPhone,
    FriendsCircPreviewVue,
    AppPreviewVue,
    Step3Type1,
    Step3Type2,
    Step3Type3,
    Step3Type4,
  },
  name: 'step-third',
  data() {
    return {
      baseData: {
        type: 0,
        client: {
          content: '',
          type: 0,
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
        attachments: [],
        senderList: [],
      },
      submitLoading: false,
      preview: {
        previewData: [],
        templateInfo: '',
      },
    }
  },
  props: {
    isDetail: {
      type: Boolean,
      default: false,
    },
    data: {
      type: Object,
      default: {},
    },
    posterObj: {
      type: Object,
      default: {},
    },
  },
  watch: {
    posterObj() {
      // this.$forceUpdate()
    },
    data: {
      handler(val, old) {
        if (val) {
          this.baseData = val
        }
      },
      deep: true,
      immediate: true,
    },
  },
  methods: {
    getPreviewInfoText(data) {
      this.preview.templateInfo = data.templateInfo
      // this.$forceUpdate()
    },
    getPreviewInfo(data) {
      this.preview.previewData = JSON.parse(JSON.stringify(data.previewData))
      if (this.baseData.style == 1) {
        this.preview.previewData.unshift({
          mediaType: '5',
          materialUrl: this.posterObj.materialUrl,
          materialName: this.posterObj.materialName,
          digest: this.posterObj.digest,
        })
      } else {
        this.preview.previewData.unshift({
          mediaType: '0',
          materialUrl:
            'https://link-wechat-1251309172.cos.ap-nanjing.myqcloud.com/2023-03-20/t1679281068694-X76U09uVyhcKs5EW.png',
        })
      }
    },
    submitFn() {
      if (this.baseData.type == 0) {
        this.submitType1()
      } else if (this.baseData.type == 1) {
        this.submitType2()
      } else if (this.baseData.type == 2) {
        this.submitType3()
      } else {
        this.submitType4()
      }
    },
    compareDate(d1, d2) {
      return new Date(d1.replace(/\-/g, '\/')) > new Date(d2.replace(/\-/g, '\/'))
    },
    submitType4() {
      if (!this.$refs.type4.checkFn()) return
      if (this.baseData.appMsg.sendType == 1) {
        if (!this.baseData.appMsg.taskSendTime) {
          this.msgError('请填写定时发送时间！')
          return
        }
        if (this.baseData.appMsg.taskEndTime) {
          if (this.compareDate(this.baseData.appMsg.taskSendTime, this.baseData.appMsg.taskEndTime)) {
            this.msgError('结束时间不得小于发送时间！')
            return
          }
        }
      }
      this.pushData(this.baseData)
    },
    async submitType3() {
      if (!this.$refs.type3.checkFn()) return
      if (this.baseData.moments.sendType == 1) {
        if (!this.baseData.moments.taskSendTime) {
          this.msgError('请填写定时发送时间！')
          return
        }
        if (this.baseData.moments.taskEndTime) {
          if (this.compareDate(this.baseData.moments.taskSendTime, this.baseData.moments.taskEndTime)) {
            this.msgError('结束时间不得小于发送时间！')
            return
          }
        }
      }
      this.submitLoading = true
      if (this.baseData.moments.type == 1) {
        let data = {
          userIds: this.baseData.moments.userIds,
          tagIds: this.baseData.moments.labelIds,
          beginTime: this.baseData.moments.addBeginTime,
          endTime: this.baseData.moments.addEndTime,
          gender: this.baseData.moments.sex,
          trackState: this.baseData.moments.trackState,
        }
        await getCustomerList(data).then((res) => {
          if (res.code === 200) {
            if (res.data && res.data.length) {
              this.baseData.senderList = this.newArryById(res.data)
            }
          }
        })
      }
      this.pushData(this.baseData)
    },
    submitType2() {
      if (this.baseData.group.type == 1) {
        if (!this.baseData.group.userIds) {
          this.msgError('请选择群主！')
          return
        }
        this.baseData.senderList = this.baseData.group.userIds.split(',').map((i) => {
          return { userId: i }
        })
      }
      if (this.baseData.group.sendType == 1) {
        if (!this.baseData.group.taskSendTime) {
          this.msgError('请填写定时发送时间！')
          return
        }
        if (this.baseData.group.taskEndTime) {
          if (this.compareDate(this.baseData.group.taskSendTime, this.baseData.group.taskEndTime)) {
            this.msgError('结束时间不得小于发送时间！')
            return
          }
        }
      }
      if (this.baseData.group.content) {
        this.baseData.attachments.unshift({
          content: this.baseData.group.content,
          msgType: 'text',
        })
      }
      this.pushData(this.baseData)
    },
    async submitType1() {
      if (this.baseData.type == 0 && this.baseData.client.sendType == 1) {
        if (!this.baseData.client.taskSendTime) {
          this.msgError('请填写定时发送时间！')
          return
        }
        if (this.baseData.client.taskEndTime) {
          if (this.compareDate(this.baseData.client.taskSendTime, this.baseData.client.taskEndTime)) {
            this.msgError('结束时间不得小于发送时间！')
            return
          }
        }
      }
      if (this.baseData.client.content) {
        this.baseData.attachments.unshift({
          content: this.baseData.client.content,
          msgType: 'text',
        })
      }
      this.submitLoading = true
      if (this.baseData.client.type == 1) {
        let data = {
          userIds: this.baseData.client.userIds,
          tagIds: this.baseData.client.labelIds,
          beginTime: this.baseData.client.addBeginTime,
          endTime: this.baseData.client.addEndTime,
          gender: this.baseData.client.sex,
          trackState: this.baseData.client.trackState,
        }
        await getCustomerList(data).then((res) => {
          if (res.code === 200) {
            if (res.data && res.data.length) {
              this.baseData.senderList = this.newArryById(res.data)
            }
          }
        })
      }
      this.pushData(this.baseData)
    },
    pushData(data) {
      this.submitLoading = true
      ;(data.id ? editPromotion(data) : addPromotion(data))
        .then((res) => {
          if (res.code == 200) {
            this.msgSuccess('操作成功!')
            this.$router.back()
          }
          this.submitLoading = false
        })
        .catch(() => {
          this.submitLoading = false
          if (this.baseData.type == 0 || this.baseData.type == 1) {
            let arr = []
            this.baseData.attachments.forEach((dd) => {
              if (dd.msgType != 'text') {
                arr.push(dd)
              }
            })
            this.baseData.attachments = arr
          }
        })
    },
    newArryById(arr) {
      let map = {}
      let dest = []
      for (let i = 0; i < arr.length; i++) {
        let ai = arr[i]
        if (!map[ai.firstUserId]) {
          dest.push({
            userId: ai.firstUserId,
            customerList: [ai.externalUserid],
          })
          map[ai.firstUserId] = ai
        } else {
          for (let j = 0; j < dest.length; j++) {
            let dj = dest[j]
            if (dj.userId == ai.firstUserId) {
              dj.customerList.push(ai.externalUserid)
              break
            }
          }
        }
      }
      return dest
    },
    goPrdSteps(step) {
      this.$emit('steps', step)
    },
    getData(data) {
      this.baseData = data
      this.$emit('update', this.baseData)
    },
  },
}
</script>

<style scoped>
.info_title {
  font-size: 16px;
  font-weight: 600;
  color: var(--font-black);
  margin-bottom: 10px;
}
</style>
