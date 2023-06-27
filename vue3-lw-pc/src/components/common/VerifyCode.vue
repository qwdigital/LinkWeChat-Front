<template>
  <div>
    <div :class="className" @click="requestSMS">
      <span></span>
      {{ count }}{{ message }}
    </div>
    <el-dialog :append-to-body="true" title="图形验证码" v-model="dialogVisible" width="300px">
      <el-form ref="form" inline :model="form" :rules="rules">
        <el-form-item prop="code">
          <el-input v-model="form.code" auto-complete="off" placeholder="验证码" style="width: 63%">
            <template #prefix><svg-icon icon="validCode" class="el-input__icon input-icon" /></template>
          </el-input>
          <div class="login-code">
            <img :src="codeUrl" @click="getCode" class="login-code-img" />
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <!-- <el-button @click="dialogVisible = false">取 消</el-button> -->
          <el-button type="primary" @click="confirmFn">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { getImageCode, getCodeInPhone } from '@/api/login'
export default {
  name: 'verify-code',
  props: {
    // 用户电话
    telNumber: {
      required: true,
    },
  },
  data() {
    return {
      form: {
        code: '',
      },
      codeUrl: '',
      dialogVisible: false,
      className: 'clickable',
      message: '发送验证码',
      count: '',
      send: true,
      timer: null,
      reg: /^((1[0-9][0-9]))\d{8}$/,
      rules: {
        code: [{ required: true, trigger: 'blur', message: '请输入验证码' }],
      },
    }
  },
  methods: {
    confirmFn() {
      this.$refs.form.validate((vali) => {
        if (vali) {
          getCodeInPhone({
            account: this.telNumber,
            imgCode: this.form.code,
            uuid: this.form.uuid,
          }).then((res) => {
            if (res.code === 200) {
              this.msgSuccess('短信发送成功')
              this.send = false
              this.className = 'unclickable'
              this.message = 's后重发'
              const TOTAL_TIME = 60
              if (!this.timer) {
                this.count = TOTAL_TIME
                this.timer = setInterval(() => {
                  if (this.count > 0 && this.count <= TOTAL_TIME) {
                    this.count--
                  } else {
                    clearInterval(this.timer)
                    this.timer = null
                    this.count = ''
                    this.message = '重新发送'
                    this.className = 'clickable'
                    this.send = true
                  }
                }, 1000)
              }
            } else {
              this.getCode()
            }
            this.dialogVisible = false
          })
        }
      })
    },
    getCode() {
      getImageCode().then((res) => {
        if (res.code === 200) {
          this.codeUrl = 'data:image/gif;base64,' + res.img
          this.form.uuid = res.uuid
        }
      })
    },
    requestSMS() {
      if (this.send) {
        if (this.$props.telNumber === '' || this.$props.telNumber === undefined) {
          this.msgError('请输手机号码')
        } else if (!this.reg.test(this.$props.telNumber)) {
          // 核对手机号格式
          this.msgError('请输正确的手机号码')
        } else {
          this.getCode()
          this.dialogVisible = true
        }
      }
    },
  },
}
</script>

<style scoped lang="scss">
.clickable {
  font-size: 12px;
  color: #5474c2;
  letter-spacing: 0;
  text-align: center;
  cursor: pointer;
}

.unclickable {
  font-size: 12px;
  color: var(--font-black-7);
  letter-spacing: 0;
  text-align: center;
}

span {
  color: var(--font-black-7);
  margin-right: 5px;
}

.login-code {
  width: 33%;
  height: 38px;
  float: right;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}
.login-code-img {
  height: 38px;
}
</style>
