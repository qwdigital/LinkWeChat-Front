<template>
  <div>
    <div class="item-magin aic">
      <div>
        <el-tag v-for="item in selectCustomerGroupList" :key="item.userId">{{ item.name }}</el-tag>
      </div>
      <el-button v-if="!isDetail" icon="el-icon-plus" type="primary" class="mr10" plain @click="onSelectCustomerGroup">
        选择群主
      </el-button>
    </div>
    <SelectUser
      v-model:visible="dialogVisibleSelectCustomerGroup"
      title="选择群主"
      :defaultValues="selectCustomerGroupList"
      @success="submitSelectCustomerGroup"></SelectUser>
  </div>
</template>

<script>
export default {
  name: 'select-group',
  data() {
    return {
      form: {
        weUserIds: '', //群主id，多个使用逗号隔开
        weUserName: '',
      },
      selectCustomerGroupList: [],
      dialogVisibleSelectCustomerGroup: false,
      currentType: 0,
    }
  },
  props: {
    dataObj: {
      type: Object,
      default: null,
    },
    isDetail: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    dataObj: {
      handler(val, old) {
        if (val) {
          this.setData(val)
        }
      },
      deep: true,
      immediate: true,
    },
  },
  methods: {
    setData(data) {
      if (!data) {
        this.currentType = 0
        this.form = {
          weUserIds: '',
          weUserName: '',
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
            name: this.form.weUserName.split(',')[index],
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
      if (!this.form.weUserIds) {
        this.msgError('请选择群主！')
        return false
      } else {
        return true
      }
    },
    changeFn() {
      this.$emit('update', this.form)
    },
  },
}
</script>

<style scoped></style>
