<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <el-form :model="form" ref="form" :rules="rule" label-width="120px" label-position="right">
          <div class="g-card">
            <el-form-item label="门店范围：" prop="raidus">
              距离门店半径
              <el-input v-model="form.raidus" style="width: 50px"></el-input>
              公里范围内，客户可扫码添加门店群
            </el-form-item>
            <el-form-item label="加群引导语：" prop="welcomeMsg">
              <el-input
                v-model="form.welcomeMsg"
                type="textarea"
                maxlength="200"
                show-word-limit
                placeholder="请输入加群引导语"
                :autosize="{ minRows: 5, maxRows: 20 }"
                clearable />
            </el-form-item>
            <el-form-item label="超出范围提示：" prop="outOfRangeTip">
              <el-input
                v-model="form.outOfRangeTip"
                type="textarea"
                maxlength="30"
                show-word-limit
                placeholder="请输入超出范围提示"
                :autosize="{ minRows: 2, maxRows: 20 }"
                clearable />
            </el-form-item>
            <el-form-item label="活码员工客服：">
              <el-switch @change="setChange" v-model="form.codeState" :active-value="0" :inactive-value="1"></el-switch>
              <div class="sub-des">开启后，当客户超过范围时显示该员工客服的二维码</div>
              <template v-if="form.codeState === 0">
                <div v-if="selectedUserList.length > 0">
                  <el-tag v-for="(item, index) in selectedUserList" :key="index">{{ item.name }}</el-tag>
                </div>
                <el-button type="primary" dialogVisibleSelectTag plain @click="onSelectUser">
                  {{ selectedUserList.length ? '编辑' : '选择' }}员工
                </el-button>
              </template>
            </el-form-item>
          </div>
          <el-form-item style="float: right">
            <el-button plain @click="cancelFn">取消</el-button>
            <el-button type="primary" v-loading="submitLoading" :disabled="submitLoading" @click="submitFn">
              确定
            </el-button>
          </el-form-item>
        </el-form>
      </el-col>
      <el-col style="min-width: 750px">
        <div class="g-card" style="height: 100%; display: flex">
          <preview-store-client key="1" :showStore="true" name="专属门店群" :value="form"></preview-store-client>
          <preview-store-client key="2" :showTip="true" name="专属门店群" :value="form"></preview-store-client>
        </div>
      </el-col>
    </el-row>
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      :isSigleSelect="true"
      :defaultValues="selectedUserList"
      @success="selectedUser"></SelectUser>
  </div>
</template>

<script>
import PreviewStoreClient from '../components/PreviewInStore.vue'
import { addOrUpdateCodeInStore, getCode } from '@/api/drainageCode/store'
function validateRadius(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }
  if (Number.isNaN(Number(value)) || Number(value) < 1 || Number(value) > 10 || value.toString().indexOf('.') > -1) {
    callback('请输入 1-100 的正整数')
  } else {
    callback()
  }
}
export default {
  name: 'store_code_add',
  data() {
    return {
      submitLoading: false,
      dialogVisibleSelectUser: false,
      selectedUserList: [],
      form: {
        addOrUpdate: true,
        raidus: 3,
        outOfRangeTip: '您所在区域暂未开设门店，可联系客服或手动搜索',
        welcomeMsg: '直接加入专属门店群，享受更多福利！',
        codeState: 1,
        storeCodeType: 2,
        customerServiceName: '',
        customerServiceId: '',
      },
      rule: {
        raidus: [
          { required: true, message: '请输入门店范围', trigger: 'blur' },
          { validator: validateRadius, trigger: 'change' },
        ],
        outOfRangeTip: [{ required: true, message: '请输入超出范围提示', trigger: 'blur' }],
        welcomeMsg: [{ required: true, message: '请输入加群引导语', trigger: 'blur' }],
      },
    }
  },
  components: {
    PreviewStoreClient,
  },
  created() {
    this.init()
  },
  methods: {
    setChange(data) {
      if (data === 1) {
        this.selectUserList = []
        this.form.customerServiceName = ''
        this.form.customerServiceId = ''
      }
    },
    onSelectUser() {
      this.dialogVisibleSelectUser = true
    },
    selectedUser(data) {
      this.selectedUserList = data
      if (data && data.length) {
        this.form.customerServiceName = data[0].name
        this.form.customerServiceId = data[0].userId
      } else {
        this.form.customerServiceName = ''
        this.form.customerServiceId = ''
      }
    },
    cancelFn() {
      this.$router.back()
    },
    submitFn() {
      this.$refs['form'].validate((val) => {
        if (val) {
          if (this.form.codeState === 0) {
            if (!this.form.customerServiceId) {
              this.msgError('开启了活码员工客服， 请选择员工')
              return
            }
          }
          this.submitLoading = true
          this.form.addOrUpdate = this.form.id ? false : true
          addOrUpdateCodeInStore(this.form).then(({ data }) => {
            this.msgSuccess('操作成功')
            this.$router.back()
            this.submitLoading = false
          })
        }
      })
    },
    init() {
      getCode(2).then(({ data }) => {
        if (data?.id) {
          this.form = data
          if (this.form.customerServiceId) {
            let obj = {
              name: this.form.customerServiceName,
              userId: this.form.customerServiceId,
            }
            this.selectedUserList = [obj]
          }
        }
      })
    },
  },
}
</script>
<style lang="scss" scoped>
.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
