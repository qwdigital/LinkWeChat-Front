<template>
  <div>
    <div class="g-card">
      <el-steps :active="currentActive" align-center finish-status="success">
        <el-step title="基本信息"></el-step>
        <el-step title="推广方式"></el-step>
        <el-step title="推广设置"></el-step>
      </el-steps>
    </div>
    <template v-if="currentActive == 0">
      <el-row :gutter="20" type="flex" style="margin-top: 20px">
        <el-col>
          <div class="g-card">
            <el-form ref="baseForm" :rules="rules" :model="form" label-position="right" label-width="100px">
              <el-form-item label="任务名称:" prop="taskName">
                <el-input
                  maxlength="15"
                  placeholder="请输入名称"
                  v-model="form.taskName"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item label="推广短链:" prop="shortLinkId">
                <el-button type="primary" icon="el-icon-plus" @click="showShortLink = true">
                  {{ form.shortLinkId ? '编辑' : '选择' }}短链
                </el-button>
                <el-button
                  type="primary"
                  @click="$router.push('/drainageCode/publicCustomer/IntelligentShortLink/index')">
                  去新建
                </el-button>

                <div style="margin-top: 10px">
                  <ShowShortLinkVue :data="shortLinkObj"></ShowShortLinkVue>
                </div>
              </el-form-item>
              <el-form-item label="推广样式:" prop="style">
                <el-radio-group v-model="form.style" @change="setChange">
                  <el-radio :label="0">短链二维码</el-radio>
                  <el-radio :label="1">短链海报</el-radio>
                </el-radio-group>
                <div v-if="form.style == 0" class="sub-des">以二维码图片形式触达客户</div>
                <div v-if="form.style == 1" class="sub-des">在海报中附加二维码触达客户</div>
              </el-form-item>
              <el-form-item v-if="form.style == 1" label="推广海报:" prop="materialId">
                <el-button type="primary" icon="el-icon-plus" @click="choseDialog = true">
                  {{ form.materialId ? '编辑' : '选择' }}海报
                </el-button>
                <div style="margin-top: 10px" v-if="posterUrl">
                  <ul class="el-upload-list el-upload-list--picture-card">
                    <li class="el-upload-list__item is-success">
                      <img style="width: 100%; height: 100%" :src="posterUrl" />
                      <span class="el-upload-list__item-actions">
                        <span class="el-upload-list__item-delete">
                          <el-icon-delete class="el-icon-delete" @click="handleRemove"></el-icon-delete>
                        </span>
                      </span>
                    </li>
                  </ul>
                </div>
              </el-form-item>
            </el-form>
          </div>
          <div class="g-card" style="text-align: right">
            <el-button plain @click="$router.go(-1)">取消</el-button>
            <el-button type="primary" @click="gotoNext">下一步</el-button>
          </div>
        </el-col>
        <el-col style="flex-basis: 370px">
          <div class="g-card" style="height: 100%">
            <div class="info_title">消息预览</div>
            <Preview :value="posterUrl"></Preview>
          </div>
        </el-col>
      </el-row>
    </template>
    <template v-if="currentActive == 1">
      <div class="g-card">
        <!-- <el-form>
          <el-form-item label="推广方式:" required>
            <el-radio-group v-model="form.type">
              <el-radio :label="0">群发客户</el-radio>
              <el-radio :label="1">群发客户群</el-radio>
              <el-radio :label="2">群发朋友圈</el-radio>
              <el-radio :label="3">应用消息</el-radio>
              推广方式：0群发客户，1群发客户群，2群发朋友圈，3应用消息
            </el-radio-group>
          </el-form-item>
        </el-form> -->
        <div class="unit">
          <div class="title">推广方式</div>
        </div>
        <div class="unit">
          <div class="unit-item" :class="{ active_item: form.type == 0 }" @click="setTypeFn(0)">
            <div>
              <img v-if="form.type == 0" class="icon-style" src="@/assets/image/customer_active.png" alt="" />
              <img v-else class="icon-style" src="@/assets/image/customer.png" alt="" />
            </div>
            <div>
              <div class="item-title">群发客户</div>
              <div class="item-text">员工将推广内容一键群发给客户</div>
            </div>
          </div>
          <div class="unit-item" :class="{ active_item: form.type == 1 }" @click="setTypeFn(1)">
            <div>
              <img v-if="form.type == 1" class="icon-style" src="@/assets/image/group_active.png" alt="" />
              <img v-else class="icon-style" src="@/assets/image/group.png" alt="" />
            </div>
            <div>
              <div class="item-title">群发客户群</div>
              <div class="item-text">员工将推广内容一键群发给客户群</div>
            </div>
          </div>
          <div class="unit-item" :class="{ active_item: form.type == 2 }" @click="setTypeFn(2)">
            <div>
              <img v-if="form.type == 2" class="icon-style" src="@/assets/image/friends_active.png" alt="" />
              <img v-else class="icon-style" src="@/assets/image/friends.png" alt="" />
            </div>
            <div>
              <div class="item-title">群发朋友圈</div>
              <div class="item-text">员工将推广内容一键群发到朋友圈</div>
            </div>
          </div>
          <div class="unit-item" :class="{ active_item: form.type == 3 }" @click="setTypeFn(3)">
            <div>
              <img v-if="form.type == 3" class="icon-style" src="@/assets/image/app_active.png" alt="" />
              <img v-else class="icon-style" src="@/assets/image/app.png" alt="" />
            </div>
            <div>
              <div class="item-title">应用消息</div>
              <div class="item-text">员工收到应用消息，选择客户发送</div>
            </div>
          </div>
        </div>
      </div>
      <div class="g-card" style="text-align: right">
        <el-button plain @click="currentActive = 0">上一步</el-button>
        <el-button plain @click="saveFn" v-loading="loading">保存，暂不推广</el-button>
        <el-button type="primary" @click="currentActive = 2">下一步</el-button>
      </div>
    </template>
    <template v-if="currentActive == 2">
      <Step3 :posterObj="posterObj" :data="form" @update="getUpdateData" @steps="updateSteps"></Step3>
    </template>

    <!-- 选择海报 -->
    <SelectPosterSingle v-model:visible="choseDialog" @success="getItemArry"></SelectPosterSingle>

    <!-- 选择短链 -->
    <SelectShortLink v-model:visible="showShortLink" @success="getShortLink"></SelectShortLink>
  </div>
</template>
<script>
import SelectPosterSingle from './components/SelectPosterSingle.vue'
import Preview from './components/PreviewInPhone.vue'
import SelectShortLink from '@/components/SelectShortLink'
import Step3 from './components/Step3.vue'
import ShowShortLinkVue from './components/ShowShortLink.vue'

import { getDetail, savePromotion } from './api'
export default {
  name: 'short-link-popularize-add',
  components: {
    Preview,
    SelectPosterSingle,
    SelectShortLink,
    ShowShortLinkVue,
    Step3,
  },
  data() {
    return {
      loading: false,
      form: {
        taskName: '',
        shortLinkId: '',
        style: 0,
        materialId: '',
        type: 0,
        client: {
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
      currentActive: 0,
      choseDialog: false,
      showShortLink: false,
      shortLinkObj: [],
      posterUrl: '',
      posterObj: {},
      rules: {
        taskName: [
          {
            required: true,
            message: '请输入任务名称',
            trigger: 'blur',
          },
        ],
        shortLinkId: [
          {
            required: true,
            message: '请选择短链',
            trigger: 'blur',
          },
        ],
        style: [
          {
            required: true,
            message: '请选择推广样式',
            trigger: 'blur',
          },
        ],
        materialId: [
          {
            required: true,
            message: '请选择海报',
            trigger: 'blur',
          },
        ],
      },
    }
  },
  methods: {
    setTypeFn(type) {
      this.form.type = type
    },
    setChange(type) {
      if (type == 0) {
        this.posterUrl = ''
        this.posterObj = {}
        this.form.materialId = ''
      }
    },
    saveFn() {
      savePromotion(this.form)
        .then((res) => {
          if (res.code == 200) {
            this.msgSuccess('操作成功!')
            this.$router.back()
          }
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    gotoNext() {
      this.$refs.baseForm.validate((validate) => {
        if (validate) {
          this.currentActive = 1
        }
      })
    },
    handleRemove() {
      this.posterUrl = ''
      this.posterObj = {}
      this.form.materialId = ''
    },
    getItemArry(data) {
      this.posterUrl = data.materialUrl
      this.posterObj = data
      this.form.materialId = data.id
    },
    getShortLink(data) {
      this.form.shortLinkId = data.id
      this.shortLinkObj = [data]
    },
    getUpdateData(data) {
      this.form = data
    },
    updateSteps(step) {
      this.currentActive = step
    },
    getDetailFn() {
      getDetail(this.id).then((res) => {
        this.form = res.data
        this.setEdit()
      })
    },
    setEdit() {
      if (this.form.shortLinkId) {
        this.shortLinkObj = [this.form.shortLink]
      }
      if (this.form.style == 1) {
        this.posterObj = this.form.weMaterial
        this.posterUrl = this.posterObj.materialUrl
      }
    },
  },
  created() {
    this.id = this.$route.query.id
    if (this.$route.query.promotion) {
      this.currentActive = 1
    }
    if (this.id) {
      this.getDetailFn()
    }
  },
}
</script>

<style lang="scss" scoped>
.info_title {
  font-size: 16px;
  font-weight: 600;
  color: var(--font-black);
  margin-bottom: 10px;
}
.sub-des {
  font-size: 12px;
  font-weight: 400;
  color: var(--font-black-6);
}
.title {
  font-size: 16px;
  font-family: PingFang SC-Bold, PingFang SC;
  font-weight: 600;
  color: var(--font-black);
  margin: 24px 0;
}
.unit {
  margin: 0 auto;
  display: flex;
  flex-wrap: wrap;
  width: 580px;
  justify-content: space-between;
  .unit-item {
    width: 280px;
    height: 80px;
    border-width: 1px;
    border-style: solid;
    border-color: rgba(242, 242, 242, 1);
    border-radius: 5px;
    display: flex;
    padding: 17px;
    margin-bottom: 20px;
    cursor: pointer;
    .icon-style {
      margin-right: 10px;
      margin-top: 7px;
      font-size: 22px;
      width: 24px;
      // height: 20px;
    }
    .item-title {
      margin-top: 4px;
      font-size: 16px;
      font-family: Source Han Sans CN-Regular, Source Han Sans CN;
      font-weight: 400;
      color: var(--font-black);
    }
    .item-text {
      margin-top: 6px;
      font-size: 12px;
      color: var(--font-black-7);
      line-height: 24px;
    }
    &:hover {
      border: 1px solid rgba(7, 193, 96, 1);
      background-color: rgba(7, 193, 96, 0.09019607843137255);
    }
  }
  .active_item {
    border: 1px solid rgba(7, 193, 96, 1);
    background-color: rgba(7, 193, 96, 0.09019607843137255);
  }
}
</style>
