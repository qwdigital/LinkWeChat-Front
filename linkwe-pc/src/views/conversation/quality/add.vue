<template>
  <div>
    <div class="g-card">
      <el-form ref="codeForm" :rules="rules" :model="form" label-position="right" label-width="100px">
        <el-form-item label="质检规则名称" prop="">
          <el-input maxlength="20" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item label="活码员工" prop="weEmpleCodeUseScops" v-if="codeForm.qrRuleType == 1">
          <div v-if="codeForm.weEmpleCodeUseScops.length > 0">
            <el-tag size="medium" v-for="(item, index) in codeForm.weEmpleCodeUseScops" :key="index">
              {{ item.businessName }}
            </el-tag>
          </div>
          <el-button type="primary" plain size="mini" @click="onSelectUser">
            {{ codeForm.weEmpleCodeUseScops.length ? '修改' : '选择' }}员工
          </el-button>
          <div class="sub-des">单人活码只能选择一个员工，多人活码支持选择多个员工</div>
        </el-form-item>
        <el-form-item v-if="codeForm.qrRuleType == 2" label="质检时间范围" prop="empleCodeRosterDto">
          <div class="sub-des">
            <span>可根据不同成员的上班时间灵活调整配置</span>
          </div>
          <template v-for="(item, index) in codeForm.empleCodeRosterDto">
            <el-card class="box-card roster-card" :key="item.id">
              <div style="display: flex; justify-content: flex-end;">
                <el-button v-if="index !== 0" type="text" icon="el-icon-delete" @click="onRemoveRoster(index)">
                  删除
                </el-button>
              </div>
              <el-form-item label="排班员工">
                <el-tag size="medium" v-for="(tag, key) in item.weEmpleCodeUseScops" :key="key">
                  {{ tag.businessName }}
                </el-tag>
                <el-button style="margin-left: 10px;" size="mini" type="primary" plain @click="onSelectUser(index)">
                  {{ item.weEmpleCodeUseScops.length ? '修改' : '选择' }}员工
                </el-button>
              </el-form-item>
              <el-form-item label="工作周期">
                <el-checkbox-group v-model="item.weekday" @change="checkStartEnd($event, index)">
                  <el-checkbox :label="1" :disabled="index === 0">周一</el-checkbox>
                  <el-checkbox :label="2" :disabled="index === 0">周二</el-checkbox>
                  <el-checkbox :label="3" :disabled="index === 0">周三</el-checkbox>
                  <el-checkbox :label="4" :disabled="index === 0">周四</el-checkbox>
                  <el-checkbox :label="5" :disabled="index === 0">周五</el-checkbox>
                  <el-checkbox :label="6" :disabled="index === 0">周六</el-checkbox>
                  <el-checkbox :label="7" :disabled="index === 0">周日</el-checkbox>
                </el-checkbox-group>
              </el-form-item>
              <el-form-item label="在线时间">
                <el-time-select
                  v-model="item.startDate"
                  :disabled="index === 0"
                  :picker-options="{
                    start: '00:00',
                    end: '23:59',
                    step: '00:30'
                  }"
                  :end="item.endDate"
                  @change="checkStartEnd($event, index)"
                  placeholder="任意时间点"
                ></el-time-select>
                <el-time-select
                  :picker-options="{
                    start: '00:00',
                    end: '23:59',
                    step: '00:30'
                  }"
                  :start="item.startDate"
                  @change="checkStartEnd($event, index)"
                  v-model="item.endDate"
                  :disabled="index === 0"
                  placeholder="任意时间点"
                ></el-time-select>
              </el-form-item>
            </el-card>
          </template>
          <div class="mt20">
            <el-button size="mini" type="primary" plain @click="onAddRoster">添加工作周期</el-button>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button @click="currentActive = 1">上一步</el-button>
          <el-button type="primary" @click="nextStep(3)">下一步</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'quality-add',
    data() {
      return {
        form: {},
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
