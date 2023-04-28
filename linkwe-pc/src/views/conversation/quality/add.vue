<template>
  <div>
    <div class="g-card">
      <el-form ref="codeForm" :rules="rules" :model="form" label-position="right" label-width="140px">
        <el-form-item label="质检规则名称:" prop="">
          <el-input maxlength="20" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item label="超时时间标准:">
          <el-input style="width: 120px;" placeholder="请输入"></el-input>分钟
        </el-form-item>
        <el-form-item label="质检时间范围:" prop="empleCodeRosterDto">
          <div class="sub-des">
            <span>可根据不同成员的上班时间灵活调整配置</span>
          </div>
          <template v-for="(item, index) in form.empleCodeRosterDto">
            <el-card class="box-card roster-card" :key="item.id">
              <div style="display: flex; justify-content: flex-end;">
                <el-button v-if="index !== 0" type="text" icon="el-icon-delete" @click="onRemoveRoster(index)">
                  删除
                </el-button>
              </div>
              <el-form-item label-width="100px" label="排班员工:">
                <el-tag size="medium" v-for="(tag, key) in item.weEmpleCodeUseScops" :key="key">
                  {{ tag.businessName }}
                </el-tag>
                <el-button
                  icon="el-icon-plus"
                  style="margin-left: 10px;"
                  size="mini"
                  type="primary"
                  @click="onSelectUser(index)"
                >
                  {{ item.weEmpleCodeUseScops.length ? '修改' : '选择' }}员工
                </el-button>
              </el-form-item>
              <el-form-item label-width="100px" label="工作周期:">
                <el-checkbox-group v-model="item.weekday" @change="checkStartEnd($event, index)">
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
                  v-model="item.startDate"
                  :picker-options="{
                    start: '00:00',
                    end: '23:59',
                    step: '00:30'
                  }"
                  :end="item.endDate"
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
                  :start="item.startDate"
                  @change="checkStartEnd($event, index)"
                  v-model="item.endDate"
                  placeholder="任意时间点"
                ></el-time-select>
              </el-form-item>
            </el-card>
          </template>
          <div class="mt20">
            <el-button size="mini" type="primary" icon="el-icon-plus" @click="onAddRoster">添加工作周期</el-button>
          </div>
        </el-form-item>
        <el-form-item label="质检督导:" prop="weEmpleCodeUseScops">
          <div v-if="form.weEmpleCodeUseScops.length > 0">
            <el-tag size="medium" v-for="(item, index) in form.weEmpleCodeUseScops" :key="index">
              {{ item.businessName }}
            </el-tag>
          </div>
          <el-button icon="el-icon-plus" type="primary" size="mini" @click="onSelectUser">
            {{ form.weEmpleCodeUseScops.length ? '修改' : '选择' }}成员
          </el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-footer-sticky">
      <el-button>取消</el-button>
      <el-button type="primary">确定</el-button>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'quality-add',
    data() {
      return {
        form: {
          weEmpleCodeUseScops: [],
          empleCodeRosterDto: [{ weEmpleCodeUseScops: [] }]
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
