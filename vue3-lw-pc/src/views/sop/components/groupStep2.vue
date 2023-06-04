<template>
  <div style="margin-top: 10px">
    <div class="g-card">
      <div class="g-card-title">基础设置</div>
      <el-form ref="baseForm" :rules="baseRules" :model="baseForm" label-position="right" label-width="100px">
        <el-form-item label="SOP名称" prop="sopName">
          <el-input v-model="baseForm.sopName" style="width: 400px" maxlength="20" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item label="发送方式" required prop="sendType">
          <el-radio-group v-model="baseForm.sendType">
            <el-radio :label="1">
              企微群发
              <el-popover placement="top" trigger="hover">
                <template #reference><el-icon-QuestionFilled class="el-icon-QuestionFilled ml5" /></template>
                <div>
                  企微群发采用企业微信官方的一键转发功能，每个客户/客群每天只可通过此种方式接收一条消息。设置SOP内容时每天仅可设置一条。
                </div>
              </el-popover>
            </el-radio>
            <el-radio :label="2">
              手动发送
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled ml5" />
                </template>
                <div>手动发送由员工自主推送，每个客户/客群每天不限制消息接收次数。设置SOP内容时可一天内设置多条。</div>
              </el-popover>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-divider></el-divider>
        <div class="g-card-title" style="margin-top: 20px">执行成员</div>
        <el-form-item label="选择类型" required>
          <el-radio-group v-model="type" @change="clearChange">
            <el-radio :label="1">全部成员</el-radio>
            <el-radio :label="2">部分成员</el-radio>
          </el-radio-group>
        </el-form-item>
        <template v-if="type === 2">
          <el-form-item label="">
            <SelectMember ref="selectMember" :initData="baseForm.executeWeUser" @update="getExecuteData"></SelectMember>
          </el-form-item>
        </template>
        <el-divider></el-divider>
        <div class="g-card-title" style="margin-top: 20px">生效客群</div>
        <el-form-item label="选择类型" required>
          <SelectGroup
            ref="selectGroup"
            :sendType="baseForm.sendType"
            :currentType="baseForm.businessType"
            :initData="baseForm.executeCustomerOrGroup"
            @update="getChangeData"></SelectGroup>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-card" style="text-align: right">
      <el-button v-if="!baseForm.id" plain @click="next(1)">上一步</el-button>
      <el-button type="primary" @click="next(3)">下一步</el-button>
    </div>
  </div>
</template>
<script>
import SelectMember from './SelectMember.vue'
import SelectGroup from './SelectGroup.vue'
export default {
  name: 'group-step-2',
  components: {
    SelectMember,
    SelectGroup,
  },
  props: {
    initData: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      baseRules: {
        sopName: [{ required: true, message: '请输入SOP名称', trigger: 'blur' }],
      },
      type: 1, // 前端维护 执行成员方式 executeWeUser 为空默认全部成员
      baseForm: {
        sopName: '',
        sendType: 1,
        executeWeUser: null,
        executeCustomerOrGroup: {
          weSopExecuteGroupTimeCondit: {
            change: false,
            beginTime: '',
            endTime: '',
          },
          weSopExecuteGroupTagIdsCondit: {
            change: false,
            tagIds: [],
          },
          weSopExecuteGroupMemberLimitCondit: {
            change: false,
            groupMemberUp: '',
            groupMemberDown: '',
          },
        },
      },
    }
  },
  methods: {
    next(type) {
      if (type === 3) {
        this.$refs['baseForm'].validate((dd) => {
          if (dd) {
            let selectmember = true
            let selectgroup = true
            if (this.type === 2) {
              selectmember = this.$refs.selectMember.validateFn()
            }
            selectgroup = this.$refs.selectGroup.validateFn()
            if (selectgroup) {
              this.$refs.selectGroup.submitFn()
            }
            if (selectmember && selectgroup) {
              this.$emit('stepFn', type)
            }
          }
        })
      } else {
        this.$emit('stepFn', type)
      }
    },
    getExecuteData(data) {
      this.baseForm.executeWeUser = data
    },
    clearChange(type) {
      if (type === 1) {
        this.baseForm.executeWeUser = null
      } else {
        this.baseForm.executeWeUser = {
          executeUserCondit: {
            change: false,
            weUserIds: [],
          },
          executeDeptCondit: {
            change: false,
            deptIds: [],
            posts: [],
          },
        }
      }
    },
    getChangeData(data) {
      this.baseForm.executeCustomerOrGroup = data
      // this.$emit('stepFn', 3, this.baseForm)
    },
    setEditData() {
      if (this.baseForm.executeWeUser) {
        this.type = 2
      } else {
        this.type = 1
      }
    },
  },
  created() {
    this.baseForm = this.initData
    if (this.baseForm.executeWeUser) {
      this.type = 2
    } else {
      this.type = 1
    }
  },
}
</script>
<style lang="scss" scoped></style>
