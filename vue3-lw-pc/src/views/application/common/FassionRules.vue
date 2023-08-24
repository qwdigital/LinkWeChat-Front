<template>
  <div>
    <div class="g-card" style="margin-top: 20px;">
      <el-row>
        <el-col :span="15">
          <el-form :model="form" :rules="ruleForm" ref="ruleForm" label-width="140px" labelPosition="right">
            <el-form-item label="兑奖条件" prop="exchangeTip">
              客户成功邀请
              <el-input :disabled="isDetail" style="width: 100px;" v-model="form.exchangeTip"></el-input>
              人
              <span v-if="form.fassionType == 2">入群</span>
              ，可参与兑奖
            </el-form-item>
            <el-form-item label="兑奖方式" required prop="exchangeType">
              <el-radio-group v-model="form.exchangeType" @change="changeType" :disabled="isDetail">
                <el-radio :label="3">自助兑奖</el-radio>
                <el-radio :label="1">跳转链接兑奖</el-radio>
                <el-radio :label="2">添加客服兑奖</el-radio>
              </el-radio-group>
            </el-form-item>
            <template v-if="form.exchangeType == 3">
              <div class="select_content">
                <el-form-item label-width="80px" label="兑奖规则" prop="exchangeContent.redemptionRule">
                  <el-input
                    :disabled="isDetail"
                    type="textarea"
                    style="border: none; width: 364px;"
                    v-model="form.exchangeContent.redemptionRule"
                    rows="5"
                    placeholder="请输入兑奖规则"
                    maxlength="2000"
                    show-word-limit
                  ></el-input>
                </el-form-item>
              </div>
            </template>
            <template v-if="form.exchangeType == 1">
              <div class="select_content">
                <el-form-item label-width="80px" label="兑奖链接" prop="exchangeContent.redemptionLink">
                  <el-input
                    :disabled="isDetail"
                    v-model="form.exchangeContent.redemptionLink"
                    placeholder="请输入兑奖链接"
                  ></el-input>
                  <div class="sub-des">仅做链接的跳转，不做具体兑奖的逻辑处理</div>
                </el-form-item>
                <el-form-item label-width="80px" label="兑奖规则" prop="exchangeContent.redemptionRule">
                  <el-input
                    :disabled="isDetail"
                    type="textarea"
                    style="border: none; width: 364px;"
                    v-model="form.exchangeContent.redemptionRule"
                    rows="5"
                    placeholder="请输入兑奖规则"
                    maxlength="2000"
                    show-word-limit
                  ></el-input>
                </el-form-item>
              </div>
            </template>
            <template v-if="form.exchangeType == 2">
              <div class="select_content">
                <el-form-item label-width="80px" label="选择客服" prop="exchangeContent.weUserId">
                  <div v-if="selectedUserList.length > 0">
                    <el-tag v-for="(item, index) in selectedUserList" :key="index">
                      {{ item.name }}
                    </el-tag>
                  </div>
                  <el-button
                    v-if="!isDetail"
                    icon="el-icon-plus"
                    type="primary"
                    plain
                    @click="dialogVisibleSelectUser = true"
                  >
                    {{ form.exchangeContent.weUserId ? '编辑' : '选择' }}客服
                  </el-button>
                </el-form-item>
              </div>
            </template>
          </el-form>
        </el-col>
      </el-row>
    </div>
    <div class="g-footer-sticky" v-if="!isDetail">
      <el-button plain @click="gotoPre">上一步</el-button>
      <el-button type="primary" v-loading="loading" @click="submit">
        确认{{ $route.query.id ? '保存' : '创建' }}
      </el-button>
    </div>
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择成员"
      :isOnlyLeaf="true"
      :isSigleSelect="true"
      :defaultValues="selectedUserList"
      @success="selectedUser"
    ></SelectUser>
  </div>
</template>

<script>
  import { addFassion, editFassion } from '../taskGroup/api'

  import { validURL } from '@/utils/validate'
  const validateUrl = (rule, value, callback) => {
    if (value !== '' && !validURL(value)) {
      callback(new Error('链接格式不正确'))
    } else {
      callback()
    }
  }
  export default {
    name: 'task-steps-rules',
    data() {
      return {
        loading: false,
        dialogVisibleSelectUser: false,
        selectedUserList: [],
        form: {
          fassionType: 1,
          exchangeTip: null,
          exchangeType: 3,
          exchangeContent: {
            redemptionLink: '',
            redemptionRule: '',
            weUserId: '',
            userName: ''
          }
        },
        ruleForm: {
          exchangeTip: [
            { required: true, message: '请输入数字', trigger: 'blur' },
            { pattern: /^[1-9]\d*$/, message: '请输入正确数字', trigger: 'blur' }
          ],
          'exchangeContent.redemptionLink': [
            { required: true, message: '请输入兑奖链接', trigger: 'blur' },
            { validator: validateUrl, trigger: 'blur' }
          ],
          'exchangeContent.redemptionRule': [{ required: true, message: '请输入兑奖规则', trigger: 'blur' }],
          'exchangeContent.weUserId': [{ required: true, message: '请选择客服', trigger: 'blur' }]
        }
      }
    },
    props: {
      isDetail: {
        type: Boolean,
        default: false
      },
      baseData: {
        type: Object,
        defalult: {}
      }
    },
    watch: {
      baseData: {
        handler(val) {
          this.form = val
          this.setData()
        },
        immediate: true
      }
    },
    methods: {
      gotoPre() {
        this.$emit('updata', this.form)
        this.$emit('next', 1)
      },
      changeType(data) {
        this.$refs['ruleForm'].clearValidate()
        if (data == 1) {
          this.selectedUserList = []
          this.form.exchangeContent.weUserId = ''
        } else {
          this.form.exchangeContent.redemptionLink = ''
          this.form.exchangeContent.redemptionRule = ''
        }
      },
      selectedUser(data) {
        this.selectedUserList = data
        let ids = []
        let names = []
        data.forEach((dd) => {
          ids.push(dd.userId)
          names.push(dd.name)
        })
        this.form.exchangeContent.weUserId = ids.join(',')
        this.form.exchangeContent.userName = names.join(',')
      },
      setData() {
        if (this.form.exchangeType == 2 && this.form.exchangeContent?.weUserId) {
          this.selectedUserList = []
          let arr1 = this.form.exchangeContent.weUserId.split(',')
          let arr2 = this.form.exchangeContent.userName.split(',')
          arr1.forEach((dd, index) => {
            let obj = {
              userId: dd,
              name: arr2[index]
            }
            this.selectedUserList.push(obj)
          })
        }
      },
      submit() {
        this.$refs.ruleForm.validate((validate) => {
          if (validate) {
            this.loading = true
            ;(this.$route.query.id ? editFassion(this.form) : addFassion(this.form))
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
          }
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  textarea {
    white-space: pre-wrap; //保留所有空格
  }
  .select_content {
    // background-color: var(--color-light-10);
    padding: 20px;
    border-radius: 5px;
    margin-left: 120px;
  }
  .sub-des {
    font-size: 12px;
    font-weight: 400;
    color: var(--font-black-6);
  }
</style>
