<template>
  <div>
    <el-form-item label="选择客群" required prop="type">
      <el-radio-group v-model="form.type" @change="clearData" :disabled="isDetail">
        <el-radio :label="0">全部</el-radio>
        <el-radio :label="1">选择群主</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item v-if="form.type == 1">
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
            {{ form.userIds ? '编辑' : '选择' }}群主
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
          type: 0
        },
        selectCustomerGroupList: [],
        dialogVisibleSelectCustomerGroup: false
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
            this.form = val
            this.setData()
          }
        },
        deep: true,
        immediate: true
      }
    },
    methods: {
      setData() {
        if (this.form.userIds) {
          this.selectCustomerGroupList = []
          let arr = this.form.userIds.split(',')
          let obj = {}
          arr.forEach((dd) => {
            obj = {
              userId: dd,
              name: this.form.users[dd]
            }
            this.selectCustomerGroupList.push(obj)
          })
        }
      },
      clearData(type) {
        if (type == 0) {
          this.selectCustomerGroupList = []
          this.form.userIds = ''
          this.changeFn()
        }
      },
      onSelectCustomerGroup() {
        this.dialogVisibleSelectCustomerGroup = true
      },
      submitSelectCustomerGroup(users) {
        this.selectCustomerGroupList = users
        this.form.userIds = users
          .map((dd) => {
            return dd.userId
          })
          .join(',')
        let obj = {}
        users.forEach((ff) => {
          obj[ff.userId] = ff.name
        })
        this.form.users = obj
        this.changeFn()
      },
      changeFn() {
        this.$emit('update', this.form)
      }
    }
  }
</script>

<style scoped></style>
