<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top:10px;">
      <el-col>
        <div class="g-card g-pad20">
          <el-form ref="form" :model="form" label-position="right" label-width="100px">
            <el-form-item label="接待方式:" required prop="receptionType">
              <div class="radio-content">
                <div>
                  <el-radio v-model="form.receptionType" @change="setInit(1)" :label="1">人工客服</el-radio>
                  <div class="sub-des">
                    新咨询自动发送欢迎语后转接人工客服
                  </div>
                </div>
                <div style="margin-left:20px;">
                  <el-radio v-model="form.receptionType" @change="setInit(2)" :label="2">智能助手</el-radio>
                  <div class="sub-des">
                    新咨询先由智能助手接待并自动发送菜单导航
                  </div>
                </div>
              </div>
              <!-- <el-radio-group v-model="form.receptionType">
                <el-radio :label="1">人工客服</el-radio>
                <el-radio :label="2">智能助手</el-radio>
              </el-radio-group> -->
            </el-form-item>
            <div v-if="form.receptionType === 1">
              <el-form-item label="分时段:">
                <el-switch v-model="form.splitTime" :active-value=2 :inactive-value=1></el-switch>
                <div class="sub-des">
                  开启后，根据咨询时间发送当前时段欢迎语
                </div>
              </el-form-item>
              <el-form-item v-if="form.splitTime == 1" required label="欢迎语:" style="width: 50%; margin-bottom: 0;">
                <el-input type="textarea" v-model="form.wecome[0].content" maxlength="200" show-word-limit placeholder="请输入" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
              </el-form-item>
              <el-form-item required v-if="form.splitTime == 2" label="欢迎语:">
                <template v-for="(item, index) in form.wecome">
                  <el-card class="box-card roster-card" :key="index">
                    <el-form-item label="工作周期">
                      <el-checkbox-group v-model="item.workCycle" @change="checkStartEnd($event, index)">
                        <el-checkbox :label="1">周一</el-checkbox>
                        <el-checkbox :label="2">周二</el-checkbox>
                        <el-checkbox :label="3">周三</el-checkbox>
                        <el-checkbox :label="4">周四</el-checkbox>
                        <el-checkbox :label="5">周五</el-checkbox>
                        <el-checkbox :label="6">周六</el-checkbox>
                        <el-checkbox :label="7">周日</el-checkbox>
                      </el-checkbox-group>
                    </el-form-item>
                    <el-form-item label="时间段">
                      <el-time-select v-model="item.beginTime" :picker-options="{
                        start: '00:00',
                        end: '23:59',
                        step:'00:30'
                      }" style="width: 160px;" :end="item.endTime" @change="checkStartEnd($event, index)" placeholder="任意时间点">
                      </el-time-select>
                      ——
                      <el-time-select :picker-options="{
                        start: '00:00',
                        end: '23:59',
                        step:'00:30'
                      }" style="width: 160px;" :start="item.beginTime" @change="checkStartEnd($event, index)" v-model="item.endTime" placeholder="任意时间点">
                      </el-time-select>
                    </el-form-item>
                    <el-form-item label="欢迎语" style="width: 50%; margin-bottom: 0;">
                      <el-input type="textarea" v-model="item.content" maxlength="200" show-word-limit placeholder="请输入欢迎语" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
                    </el-form-item>
                  </el-card>
                  <div class="delete_btn">
                  <el-button  v-if="index !== 0" type="text" icon="el-icon-delete" @click="onRemoveRoster(index)">删除</el-button>
                  </div>
                </template>
                <div class="mt20">
                  <el-button size="mini" type="primary" plain @click="onAddRoster">+添加工作周期</el-button>
                </div>
              </el-form-item>
            </div>
            <div v-if="form.receptionType === 2">
              <el-form-item required label="引导语:" style="width: 50%; margin-bottom: 0;">
                <el-input type="textarea" v-model="form.wecome[0].content" maxlength="200" show-word-limit placeholder="请输入" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
              </el-form-item>
               <el-form-item label="导航菜单:">
                <template v-for="(item, index) in form.wecome[0].menuList">
                  <el-card class="box-card roster-card" :key="index">
                    <el-form ref="subform" label-position="right" label-width="100px">
                      <el-form-item required label="菜单名称:">
                        <el-input v-model="item.name" maxlength="60" show-word-limit></el-input>
                      </el-form-item>
                      <el-form-item required label="菜单类型:">
                        <el-radio-group v-model="item.type">
                          <el-radio label="1">文本回复</el-radio>
                          <el-radio label="view">跳转链接</el-radio>
                          <el-radio label="miniprogram">跳转小程序</el-radio>
                          <el-radio label="2">转接人工</el-radio>
                        </el-radio-group>
                      </el-form-item>
                      <el-form-item required label="内容:">
                        <el-input type="textarea" v-model="item.content" maxlength="200" show-word-limit placeholder="请输入欢迎语" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
                      </el-form-item>
                      <el-form-item  required label="跳转链接:">
                        <el-input type="text" v-model="item.url"  placeholder="请输入跳转链接"/>
                      </el-form-item>
                      <el-form-item required label="小程序ID:" >
                        <el-input type="text" v-model="item.url"  placeholder="请输入小程序ID:"/>
                      </el-form-item>
                      <el-form-item required label="小程序页面:">
                        <el-input type="text" v-model="item.url"  placeholder="请输入小程序页面路径"/>
                      </el-form-item>
                    </el-form>
                  </el-card>
                  <div class="delete_btn">
                    <el-button  v-if="index !== 0" type="text" icon="el-icon-delete" @click="onRemoveMenu(index)">删除</el-button>
                  </div>
                </template>
                <div class="mt20" v-if="form.wecome[0].menuList.length < 9">
                  <el-button size="mini" type="primary" plain @click="onAddMenu">+添加菜单</el-button>
                  <div class="sub-des">
                    客户点击菜单，客服自动回复
                  </div>
                </div>
              </el-form-item>
            </div>
          <el-form-item>
            <el-button plain @click="nextStep(1)">上一步</el-button>
            <el-button type="primary" @click="nextStep(3)">下一步</el-button>
          </el-form-item>
          </el-form>
        </div>
      </el-col>
      <el-col style="width: 350px">
        <div class="g-card g-pad20" style="height: 100%">
          预览
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: 'customer-service-part2',
    data () {
      return {
        form: {
          receptionType: 1,
          splitTime: 1,
          wecome: [{
            startTime: '',
            endTime: '',
            workCycle: [],
            type: 1,
            content: '您好，很高兴为您服务，请问有什么可以帮您？'
          }]
        },
      }
    },
    props: {
      isEdit:{
        type:Boolean,
        default: false
      },
      editData: {
        type: Object,
        default: () => {
          return {}
        }
      }
    },
    methods: {
      nextStep (type) {
        this.$emit('update', type, this.form)
      },
      checkStartEnd () {
      },
      setInit (type) {
        if (type === 1) {
          this.form = {
            receptionType: 1,
            splitTime: 1,
            wecome: [{
              startTime: '',
              endTime: '',
              workCycle: [],
              type: 1,
              content: '您好，很高兴为您服务，请问有什么可以帮您？',
              menuList: []
            }]
          }
        } else {
            this.form = {
            receptionType: 2,
            splitTime: 1,
            wecome: [{
              startTime: '',
              endTime: '',
              workCycle: [],
              type: 1,
              content: '您好，很高兴为您服务，请问有什么可以帮您？',
              menuList: []
            }]
          }
        }
      },
      onAddRoster () {
        this.form.wecome.push({
          startTime: '',
          endTime: '',
          workCycle: [],
          type: 1,
          content: ''
        })
      },
      onRemoveRoster (index) {
        this.form.wecome.splice(index, 1)
      },
      onAddMenu () {
        this.form.wecome[0].menuList.push({
          name: '',
          type: '',
          content: '',
          url: '',
          appId: ''
        })
      },
      onRemoveMenu (index) {
        this.form.wecome[0].menuList.splice(index, 1)
      }
    },
    mounted () {

    },
    created () {

    }
  }
</script>
<style lang="scss" scoped>
  .sub-des {
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #999999;
  }
  .radio-content {
    display: flex;
    align-items: center;
  }
  
  .roster-btn-delete {
    margin-top: 10px;
    margin-bottom: 10px;
  }
  .roster-card:not(:first-child) {
    margin-top: 20px;
  }
  .delete_btn {
    display: flex;
    justify-content: flex-end;
  }
</style>