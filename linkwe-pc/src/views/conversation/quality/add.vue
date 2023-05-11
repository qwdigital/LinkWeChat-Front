<template>
  <div>
    <div class="g-card">
      <el-form ref="codeForm" :rules="rules" :model="form" label-position="right" label-width="140px">
        <el-form-item label="质检规则名称:" prop="name">
          <el-input v-model="form.name" maxlength="20" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item label="超时时间标准:" prop="timeOut">
          <el-input v-model="form.timeOut" style="width: 120px;" placeholder="请输入"></el-input>分钟
        </el-form-item>
        <el-form-item label="质检时间范围:" prop="qiRuleScope">
          <div class="sub-des">
            <span>可根据不同成员的上班时间灵活调整配置</span>
          </div>
          <template v-for="(item, index) in form.qiRuleScope">
            <el-card class="box-card roster-card" :key="item.id">
              <div style="display: flex; justify-content: flex-end;">
                <el-button v-if="index !== 0" type="text" icon="el-icon-delete" @click="onRemoveRoster(index)">
                  删除
                </el-button>
              </div>
              <el-form-item label-width="100px" label="排班员工:">
                <el-tag size="medium" v-for="(tag, key) in item.weQiRuleUserList" :key="key">
                  {{ tag.userName }}
                </el-tag>
                <el-button
                  icon="el-icon-plus"
                  style="margin-left: 10px;"
                  size="mini"
                  type="primary"
                  @click="onSelectUser(index)"
                >
                  {{ item.weQiRuleUserList.length ? '修改' : '选择' }}员工
                </el-button>
              </el-form-item>
              <el-form-item label-width="100px" label="工作周期:">
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
              <el-form-item label-width="100px" label="在线时间:">
                <el-time-select
                  style="width: 130px;"
                  v-model="item.startTime"
                  :picker-options="{
                    start: '00:00',
                    end: '23:59',
                    step: '00:30'
                  }"
                  :end="item.endTime"
                  @change="checkStartEnd($event, index)"
                  placeholder="任意时间点"
                ></el-time-select>
                --
                <el-time-select
                  style="width: 130px;"
                  :picker-options="{
                    start: '00:00',
                    end: '23:59',
                    step: '00:30'
                  }"
                  :start="item.startTime"
                  @change="checkStartEnd($event, index)"
                  v-model="item.endTime"
                  placeholder="任意时间点"
                ></el-time-select>
              </el-form-item>
            </el-card>
          </template>
          <div class="mt20">
            <el-button size="mini" type="primary" icon="el-icon-plus" @click="onAddRoster">添加工作周期</el-button>
          </div>
        </el-form-item>
        <el-form-item label="质检会话类型" prop="chatType">
          <el-radio-group v-model="form.chatType">
            <el-radio :label="1">全部</el-radio>
            <el-radio :label="2">客户会话</el-radio>
            <el-radio :label="2">客群会话</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="质检督导:" prop="manageUserInfo">
          <div v-if="form.manageUserInfo.length > 0">
            <el-tag size="medium" v-for="(item, index) in form.manageUserInfo" :key="index">
              {{ item.userName }}
            </el-tag>
          </div>
          <el-button icon="el-icon-plus" type="primary" size="mini" @click="onSelectUser">
            {{ form.manageUserInfo.length ? '修改' : '选择' }}成员
          </el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-footer-sticky">
      <el-button>取消</el-button>
      <el-button type="primary">确定</el-button>
    </div>
    <SelectWeUser
      :visible.sync="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectWeUser>
  </div>
</template>

<script>
  export default {
    name: 'quality-add',
    data() {
      return {
        form: {
          name: '',
          chatType: 1,
          timeOut: '',
          manageUserInfo: [],
          qiRuleScope: [
            {
              beginTime: '',
              endTime: '',
              weQiRuleUserList: [],
              workCycle: ''
            }
          ]
        },
        rules: []
      }
    },
    methods: {}
  }
</script>

<style lang="scss" scoped>
  .sub-des {
    font-size: 12px;
    font-weight: 400;
    color: #999999;
  }
</style>
