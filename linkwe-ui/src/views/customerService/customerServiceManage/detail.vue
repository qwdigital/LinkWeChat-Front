<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top:10px;">
      <el-col>
        <div class="header">
          <div class="show_img">
            <img :src="detail.avatar" style="width: 60px; height: 60px"></img>
          </div>
          <div class="show_name">
            <div>{{detail.name}}</div>
            <div class="company">
              @{{companyName}}
            </div>
          </div>
          <el-button type="primary" style="position:absolute;right: 0; top: 0;" plain size="mini" @click="gotoEdit">编辑</el-button>
        </div>
        <div class="g-card g-pad20">
          <div class="title">欢迎语</div>
          <el-form ref="form" label-position="right" label-width="100px">
            <el-form-item label="接待方式:" prop="receptionType">
              {{detail.receptionType === 1 ? '人工客服': '智能助手'}}
            </el-form-item>
            <div v-if="detail.receptionType === 1">
              <el-form-item label="分时段:">
                <el-switch v-model="detail.splitTime" disabled :active-value=2 :inactive-value=1></el-switch>
              </el-form-item>
              <el-form-item v-if="detail.splitTime == 1" label="欢迎语:" style="width: 50%; margin-bottom: 0;">
                <el-input type="textarea" disabled v-model="detail.welcome[0].content" maxlength="200" :autosize="{ minRows: 3, maxRows: 20 }" />
              </el-form-item>
              <el-form-item v-if="detail.splitTime == 2" label="欢迎语:">
                <template v-for="(item, index) in detail.welcome">
                  <el-card class="box-card roster-card" :key="index">
                    <el-form-item label="工作周期">
                      <el-checkbox-group v-model="item.workCycle">
                        <el-checkbox disabled label="1">周一</el-checkbox>
                        <el-checkbox disabled label="2">周二</el-checkbox>
                        <el-checkbox disabled label="3">周三</el-checkbox>
                        <el-checkbox disabled label="4">周四</el-checkbox>
                        <el-checkbox disabled label="5">周五</el-checkbox>
                        <el-checkbox disabled label="6">周六</el-checkbox>
                        <el-checkbox disabled label="7">周日</el-checkbox>
                      </el-checkbox-group>
                    </el-form-item>
                    <el-form-item label="时间段">
                      {{item.beginTime}} —— {{item.endTime}}
                      </el-time-select>
                    </el-form-item>
                    <el-form-item label="欢迎语" style="width: 50%; margin-bottom: 0;">
                      <el-input type="textarea" v-model="item.content" disabled maxlength="200" placeholder="请输入欢迎语" :autosize="{ minRows: 3, maxRows: 20 }" />
                    </el-form-item>
                  </el-card>
                </template>
              </el-form-item>
            </div>
            <div v-if="detail.receptionType === 2">
              <el-form-item label="引导语:" style="width: 50%; margin-bottom: 0;">
                <el-input type="textarea" disabled v-model="detail.welcome[0].content" maxlength="200" placeholder="请输入" :autosize="{ minRows: 3, maxRows: 20 }" />
              </el-form-item>
              <el-form-item label="导航菜单:">
                <template v-for="(item, index) in detail.welcome[0].menuList">
                  <el-card class="box-card roster-card" :key="index">
                    <el-form ref="subform" label-position="right" label-width="100px">
                      <el-form-item label="菜单名称:">
                        {{item.name}}
                      </el-form-item>
                      <el-form-item label="菜单类型:">
                        {{item.type === 'click' ? '文本回复':item.type === 'view' ? '跳转链接':item.type === 'miniprogram' ? '跳转小程序':'转接人工'}}
                      </el-form-item>
                      <el-form-item v-if="item.type === 'click'" label="内容:">
                        <el-input type="textarea" disabled v-model="item.content" maxlength="200" placeholder="请输入欢迎语" :autosize="{ minRows: 5, maxRows: 20 }" />
                      </el-form-item>
                      <el-form-item v-if="item.type === 'view'" label="跳转链接:">
                        <el-input type="text" disabled v-model="item.url" placeholder="请输入跳转链接" />
                      </el-form-item>
                      <el-form-item v-if="item.type === 'miniprogram'" label="小程序ID:">
                        <el-input type="text" disabled v-model="item.appId" placeholder="请输入小程序ID:" />
                      </el-form-item>
                      <el-form-item v-if="item.type === 'miniprogram'" label="小程序页面:">
                        <el-input type="text" disabled v-model="item.url" placeholder="请输入小程序页面路径" />
                      </el-form-item>
                    </el-form>
                  </el-card>
                </template>
              </el-form-item>
            </div>
          </el-form>
        </div>
        <div class="g-card g-pad20">
          <div class="title">
            接待规则
          </div>
          <el-form label-position="right" label-width="120px">
            <el-form-item label="接待员工:">
              <div>
                <el-tag size="medium" v-for="(item, index) in detail.userIdList" :key="index">{{ item.userName }}</el-tag>
              </div>
            </el-form-item>
            <el-form-item label="分配方式:">
              {{detail.allocationWay === 1 ? '轮流分配':'空闲分配'}}
            </el-form-item>
            <el-form-item label="优先分配:">
              <el-switch v-model="detail.isPriority" disabled :active-value=2 :inactive-value=1></el-switch>
            </el-form-item>
            <el-form-item label="接待上限:">
              一个接待员工最多同时接待{{detail.receiveLimit}}人
            </el-form-item>
            <el-form-item label="排队提醒:">
              <el-switch v-model="detail.queueNotice" disabled :active-value=1 :inactive-value=2></el-switch>
              <el-input v-if="detail.queueNotice === 1" type="textarea" disabled v-model="detail.queueNoticeContent" maxlength="200" :autosize="{ minRows: 3, maxRows: 20 }"/>
            </el-form-item>
            <el-form-item label="超时未回复提醒:">
              <el-switch v-model="detail.timeOutNotice" disabled :active-value=1 :inactive-value=2></el-switch>
              <div v-if="detail.timeOutNotice === 1">
                超过
                <el-input disabled style=" width:60px;" v-model="detail.timeOut"></el-input>
                <el-select disabled style="width:80px;" v-model="detail.timeOutType">
                  <el-option label="分钟" :value="1"></el-option>
                  <el-option label="小时" :value="2"></el-option>
                </el-select> 客户未回复时，自动发送提示语
                <el-input disabled style="margin-top: 10px;" type="textarea" v-model="detail.timeOutContent" maxlength="200" :autosize="{ minRows: 3, maxRows: 20 }" />
              </div>
            </el-form-item>
            <el-form-item label="自动结束提醒:">
              <el-switch disabled v-model="detail.endNotice" :active-value=1 :inactive-value=2></el-switch>
              <div v-if="detail.endNotice === 1">
                超过
                <el-input disabled style=" width:60px;" v-model="detail.endNoticeTime"></el-input>
                <el-select disabled style="width:80px;" v-model="detail.endTimeType">
                  <el-option label="分钟" :value="1"></el-option>
                  <el-option label="小时" :value="2"></el-option>
                </el-select> 客户未回复时，自动发送结束语
                <el-input disabled style="margin-top: 10px;" type="textarea" v-model="detail.endContent" maxlength="200" :autosize="{ minRows: 3, maxRows: 20 }" />
              </div>
            </el-form-item>
          </el-form> 
        </div>
      </el-col>
      <el-col style="width: 350px">
        <div class="g-card g-pad20" style="height: 100%">
          <show-in-phone v-if="show" :name="detail.name" def="detail" :avatar="detail.avatar" :data="detail"></show-in-phone>
        </div>
      </el-col>
    </el-row>
    </div>
</template>
<script>
  import ShowInPhone from '../components/WelcomeInPhonePre.vue'
  import { getDetail } from '@/api/drainageCode/customerService.js'
  import * as api from '@/api/enterpriseId'
  import Cookies from 'js-cookie'
  export default {
    name: 'customer-service-manage-detail',
    data () {
      return {
        id: '',
        detail: {
          welcome: []
        },
        show: false,
        showiconStyle: {
          'justify-content': 'center'
        }
      }
    },
    components: {
      ShowInPhone
    },
    methods: {
      gotoEdit () {
        this.$router.push({
          path: '/drainageCode/customerService/add',
          query: {
            id: this.detail.id
          }
        })
      },
      getDetailFn () {
        getDetail(this.id).then(res => {
          this.detail = res.data
          this.detail.welcome.forEach(dd => {
            if (dd.workCycle) {
              dd.workCycle = dd.workCycle.split(',')
            }
            console.log(dd.workCycle)
          })
          this.show = true
        })
      },
      getDetail () {
        this.loading = true
        api.getDetail()
          .then(({ data }) => {
            this.companyName = data.companyName
            Cookies.set('companyName', data.companyName)
          })
          .catch(() => {
            this.loading = false
          })
      },
    },
    created () {
      this.id = this.$route.query.id
      if (this.id) {
        this.getDetailFn()
      }
      if (!Cookies.get('companyName')) {
        this.getDetail()
      } else {
        this.companyName = Cookies.get('companyName')
      }
    }
  }
</script>
<style lang="scss" scoped>
  .header {
    position: relative;
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    .show_img {
      margin-right: 10px;
      height: 60px;
      width: 60px;
    }
    .show_name {
      height: 60px;
      line-height: normal;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: space-between;
      font-size: 12px;
      .company {
        color: #ffcf0e;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  }
  .title {
    font-size: 14px;
    font-weight: 500;
    color: #000;
  }
</style>
