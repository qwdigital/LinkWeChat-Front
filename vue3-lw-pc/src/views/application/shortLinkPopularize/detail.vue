<template>
  <div>
    <el-tabs v-model="activeName">
      <el-tab-pane label="任务信息" name="first">
        <el-row :gutter="20" type="flex" style="margin-top: 20px">
          <el-col>
            <div class="g-card">
              <div style="display: flex; justify-content: space-between">
                <div class="info_title">基本信息</div>
                <el-button
                  v-if="form.taskStatus == 0"
                  type="primary"
                  @click="$router.push({ path: './add', query: { id: id } })">
                  编辑
                </el-button>
              </div>
              <el-form ref="baseForm" :model="form" label-position="right" label-width="100px">
                <el-form-item label="任务名称:" prop="taskName">
                  <el-input
                    maxlength="15"
                    placeholder="请输入名称"
                    v-model="form.taskName"
                    show-word-limit
                    disabled
                    clearable></el-input>
                </el-form-item>
                <el-form-item label="任务状态:">
                  <el-tag :type="form.taskStatus == 0 ? 'info' : form.taskStatus == 2 ? 'danger' : ''">
                    {{ setStatus(form) }}
                  </el-tag>
                </el-form-item>
                <el-form-item label="推广短链:">
                  <div style="margin-top: 10px">
                    <ShowShortLinkVue :data="shortLinkObj"></ShowShortLinkVue>
                  </div>
                </el-form-item>
                <el-form-item label="推广样式:" prop="style">
                  <el-radio-group v-model="form.style">
                    <el-radio v-if="form.style == 0" :label="0">短链二维码</el-radio>
                    <el-radio v-if="form.style == 1" :label="1">短链海报</el-radio>
                  </el-radio-group>
                </el-form-item>
                <el-form-item v-if="form.style == 1" label="推广海报:" prop="materialId">
                  <div style="margin-top: 10px" v-if="posterUrl">
                    <ul class="el-upload-list el-upload-list--picture-card">
                      <li class="el-upload-list__item is-success">
                        <img style="width: 100%; height: 100%" :src="posterUrl" />
                      </li>
                    </ul>
                  </div>
                </el-form-item>
              </el-form>
            </div>
          </el-col>
          <el-col style="flex-basis: 370px">
            <div class="g-card" style="height: 100%">
              <div class="info_title">消息预览</div>
              <Preview :value="posterUrl"></Preview>
            </div>
          </el-col>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="推广信息" name="second">
        <Step3 :posterObj="posterObj" :data="form" :isDetail="true">
          <div slot>
            <el-form label-width="100px">
              <el-form-item label="推广方式" required>
                <div class="unit">
                  <div class="unit-item" v-if="form.type == 0" :class="{ active_item: form.type == 0 }">
                    <div>
                      <img class="icon-style" src="@/assets/image/customer_active.png" alt="" />
                    </div>
                    <div>
                      <div class="item-title">群发客户</div>
                      <div class="item-text">员工将推广内容一键群发给客户</div>
                    </div>
                  </div>
                  <div class="unit-item" v-if="form.type == 1" :class="{ active_item: form.type == 1 }">
                    <div>
                      <img class="icon-style" src="@/assets/image/group_active.png" alt="" />
                    </div>
                    <div>
                      <div class="item-title">群发客户群</div>
                      <div class="item-text">员工将推广内容一键群发给客户群</div>
                    </div>
                  </div>
                  <div class="unit-item" v-if="form.type == 2" :class="{ active_item: form.type == 2 }">
                    <div>
                      <img class="icon-style" src="@/assets/image/friends_active.png" alt="" />
                    </div>
                    <div>
                      <div class="item-title">群发朋友圈</div>
                      <div class="item-text">员工将推广内容一键群发到朋友圈</div>
                    </div>
                  </div>
                  <div class="unit-item" v-if="form.type == 3" :class="{ active_item: form.type == 3 }">
                    <div>
                      <img class="icon-style" src="@/assets/image/app_active.png" alt="" />
                    </div>
                    <div>
                      <div class="item-title">应用消息</div>
                      <div class="item-text">员工收到应用消息，选择客户发送</div>
                    </div>
                  </div>
                </div>
              </el-form-item>
            </el-form>
          </div>
        </Step3>
      </el-tab-pane>
      <el-tab-pane label="推广统计" name="third">
        <Statistics></Statistics>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import Statistics from './statistics'
import Preview from './components/PreviewInPhone.vue'
import ShowShortLinkVue from './components/ShowShortLink.vue'
import Step3 from './components/Step3.vue'

import { getDetail } from './api'

export default {
  name: 'short-link-popularize-detail',
  components: {
    Statistics,
    ShowShortLinkVue,
    Preview,
    Step3,
  },
  data() {
    return {
      activeName: 'first',
      form: {
        taskName: '',
        shortLinkId: '',
        style: 0,
        materialId: '',
        type: null,
        attachments: [],
      },
      choseDialog: false,
      showShortLink: false,
      shortLinkObj: [],
      posterUrl: '',
      posterObj: {},
      statusType: [
        { name: '待推广', key: 0 },
        { name: '推广中', key: 1 },
        { name: '已结束', key: 2 },
      ],
    }
  },
  methods: {
    setStatus(data) {
      let str = ''
      this.statusType.forEach((dd) => {
        if (dd.key == data.taskStatus) {
          str = dd.name
        }
      })
      return str
    },
    getDetailFn() {
      getDetail(this.id).then((res) => {
        this.form = res.data
        if (this.form.shortLinkId) {
          this.shortLinkObj = [this.form.shortLink]
        }
        if (this.form.style == 1) {
          this.posterObj = this.form.weMaterial
          this.posterUrl = this.posterObj.materialUrl
        }
      })
    },
  },
  created() {
    this.id = this.$route.query.id
    if (this.id) {
      this.getDetailFn()
    }
  },
}
</script>

<style lang="scss" scoped>
.unit {
  // margin: 0 auto;
  display: flex;
  flex-wrap: wrap;
  // width: 580px;
  justify-content: space-between;
  .unit-item {
    width: 280px;
    // height: 80px;
    border-width: 1px;
    border-style: solid;
    border-color: rgba(242, 242, 242, 1);
    border-radius: 5px;
    display: flex;
    padding: 17px;
    margin-bottom: 20px;
    // cursor: pointer;
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
.info_title {
  font-size: 16px;
  font-weight: 600;
  color: var(--font-black);
  margin-bottom: 10px;
}
</style>
