<template>
  <div>
    <el-form-item label="选择客群" required>
      <el-radio-group v-model="currentType" @change="clearData" :disabled="isDetail">
        <el-radio :label="0">全部</el-radio>
        <el-radio :label="1">选择群主</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item v-if="currentType == 1">
      <div>
        <div class="item-magin aic">
          <!-- <div class="item-name" v-if="!isDetail">
            选择群主：
          </div> -->
          <el-button
            v-if="!isDetail"
            type="primary"
            size="mini"
            class="mr10"
            icon="el-icon-circle-plus-outline"
            plain
            @click="onSelectCustomerGroup"
          >
            {{ form.weUserIds ? '编辑' : '选择' }}群主
          </el-button>
          <el-tag v-for="item in selectCustomerGroupList" :key="item.userId">{{ item.name }}</el-tag>
        </div>
      </div>
    </el-form-item>
    <SelectWeUser
      :visible.sync="dialogVisibleSelectCustomerGroup"
      title="选择群主"
      destroyOnClose
      :defaultValues="selectCustomerGroupList"
      @success="submitSelectCustomerGroup"
    ></SelectWeUser>
  </div>
</template>

<script>
  export default {
    name: 'select-group',
    data() {
      return {
        form: {
          weUserIds: '', //群主id，多个使用逗号隔开
          weUserName: ''
        },
        selectCustomerGroupList: [],
        dialogVisibleSelectCustomerGroup: false,
        currentType: 0
      }
    },
    props: {
      dataObj: {
        type: Object,
        default: null
      },
      isDetail: {
        type: Boolean,
        default: false
      }
    },
    watch: {
      dataObj: {
        handler(val, old) {
          if (val) {
            this.setData(data)
          }
        },
        deep: true,
        immediate: true
      }
    },
    methods: {
      setData(data) {
        if (!data) {
          this.currentType = 0
          this.form = {
            weUserIds: '',
            weUserName: ''
          }
          return
        } else {
          this.form = data
          this.currentType = 1
        }
        if (this.form.weUserIds) {
          this.selectCustomerGroupList = []
          let arr = this.form.weUserIds.split(',')
          let obj = {}
          arr.forEach((dd, index) => {
            obj = {
              userId: dd,
              name: this.form.weUserName.split(',')[index]
            }
            this.selectCustomerGroupList.push(obj)
          })
        }
      },
      clearData(type) {
        this.selectCustomerGroupList = []
        this.form.weUserIds = ''
        this.form.weUserName = ''
        this.changeFn()
      },
      onSelectCustomerGroup() {
        this.dialogVisibleSelectCustomerGroup = true
      },
      submitSelectCustomerGroup(users) {
        this.selectCustomerGroupList = users
        this.form.weUserIds = users
          .map((dd) => {
            return dd.userId
          })
          .join(',')
        this.form.weUserName = users
          .map((dd) => {
            return dd.name
          })
          .join(',')
        this.changeFn()
      },
      checkData() {
        if (this.currentType == 1 && !this.form.weUserIds) {
          this.msgError('请选择群主！')
          return false
        } else {
          return true
        }
      },
      changeFn() {
        this.$emit('update', this.currentType == 1 ? this.form : null)
      }
    }
  }
</script>

<style scoped></style>
