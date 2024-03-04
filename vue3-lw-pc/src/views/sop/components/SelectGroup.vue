<template>
  <div>
    <el-radio-group v-model="newCustomerAll" @change="clearChange">
      <el-radio :label="1">{{ currentType === 4 ? '全部新客群' : '全部客群' }}</el-radio>
      <el-radio v-if="!hidePart" :label="2">{{ currentType === 4 ? '部分新客群' : '部分客群' }}</el-radio>
    </el-radio-group>
    <div class="select_content" v-if="newCustomerAll === 2">
      <div v-if="currentType != 4">
        <el-checkbox
          v-model="form.weSopExecuteGroupTimeCondit.change"
          @change="selectGroupTimeChange"
          label="客群创建时间"></el-checkbox>
        <div class="select_unit" v-if="form.weSopExecuteGroupTimeCondit.change">
          <el-date-picker
            @change="getChangeDate"
            v-model="dateRange"
            type="daterange"
            align="right"
            unlink-panels
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            v-bind="pickerOptions"></el-date-picker>
        </div>
      </div>
      <div>
        <el-checkbox
          v-model="form.weSopExecuteGroupTagIdsCondit.change"
          @change="clearTagFn"
          label="客群标签"></el-checkbox>
        <div class="select_unit" v-if="form.weSopExecuteGroupTagIdsCondit.change">
          <div v-if="selectedTagList.length > 0">
            <el-tag v-for="(item, index) in selectedTagList" :key="index">{{ item.name }}</el-tag>
          </div>
          <el-button icon="el-icon-plus" type="primary" plain @click="dialogVisibleSelectTag = true">
            {{ selectedTagList.length ? '修改' : '选择' }}标签
          </el-button>
        </div>
      </div>
      <div v-if="currentType !== 4">
        <el-checkbox
          v-model="form.weSopExecuteGroupMemberLimitCondit.change"
          @change="clearNumberFn"
          label="客群人数"></el-checkbox>
        <div class="select_unit" v-if="form.weSopExecuteGroupMemberLimitCondit.change">
          <div style="display: flex">
            <el-input
              @input="nubmer($event)"
              style="width: 150px"
              v-model="form.weSopExecuteGroupMemberLimitCondit.groupMemberDown"></el-input>
            <span style="padding: 0 20px">--</span>
            <el-input
              @input="nubmer($event)"
              style="width: 150px"
              v-model="form.weSopExecuteGroupMemberLimitCondit.groupMemberUp"></el-input>
          </div>
        </div>
      </div>
    </div>
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      type="2"
      :selected="selectedTagList"
      @success="getSelectTag"></SelectTag>
  </div>
</template>
<script>
import { pickerOptions } from '@/utils/index'
import { getList } from '@/api/customer/tag'
export default {
  name: 'select-group',
  data() {
    return {
      dialogVisibleSelectTag: false,
      selectedTagList: [],
      pickerOptions: pickerOptions,
      dateRange: [],
      newCustomerAll: 1, // 新客sop 生效客户
      form: {
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
      hidePart: true,
    }
  },
  props: {
    sendType: {
      type: Number,
      default: 1,
    },
    currentType: {
      type: Number,
      default: 4,
    },
    initData: {
      type: Object,
      default: {
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
  },
  watch: {
    sendType: {
      immediate: true,
      handler(val, old) {
        if (val == 1) {
          this.hidePart = true
          this.newCustomerAll = 1
          this.clearChange()
        } else {
          this.hidePart = false
          // this.newCustomerAll = 2
        }
      },
    },
  },
  components: {},
  methods: {
    nubmer(e) {
      let _value = e.target.value
      const reg = isNaN(_value)

      if (reg) {
        e.target.value = _value.replace(/^[^1-9]/g, '')
      }
      if (_value === '0') {
        e.target.value = _value.replace(/^[^1-9]/g, '')
      }
      console.log(e.target.value)
    },
    clearNumberFn(data) {
      if (!data) {
        this.form.weSopExecuteGroupMemberLimitCondit.groupMemberUp = ''
        this.form.weSopExecuteGroupMemberLimitCondit.groupMemberDown = ''
      }
    },
    getChangeDate(data) {
      if (data.length) {
        this.form.weSopExecuteGroupTimeCondit.beginTime = data[0]
        this.form.weSopExecuteGroupTimeCondit.endTime = data[1]
      } else {
        this.form.weSopExecuteGroupTimeCondit.beginTime = ''
        this.form.weSopExecuteGroupTimeCondit.endTime = ''
      }
    },
    selectGroupTimeChange(data) {
      if (!data) {
        this.form.weSopExecuteGroupTimeCondit.beginTime = ''
        this.form.weSopExecuteGroupTimeCondit.endTime = ''
        this.dateRange = []
      }
    },
    clearTagFn(data) {
      if (!data) {
        this.form.weSopExecuteGroupTagIdsCondit.tagIds = []
      }
    },
    getSelectTag(list) {
      this.selectedTagList = list
      let arr = []
      let arr1 = []
      list.forEach((dd) => {
        arr.push(dd.name)
        arr1.push(dd.tagId)
      })
      this.form.weSopExecuteGroupTagIdsCondit.tagIds = arr1
    },
    editTag() {
      if (this.form.weSopExecuteGroupTagIdsCondit.tagIds.length) {
        this.selectedTagList = []
        getList({ groupTagType: 2 }).then(({ rows }) => {
          this.listOneArray = []
          rows.forEach((element) => {
            element.weTags.forEach((d) => {
              this.listOneArray.push({ tagId: d.tagId, name: d.name })
            })
          })
          this.form.weSopExecuteGroupTagIdsCondit.tagIds.forEach((dd) => {
            let index = this.listOneArray.findIndex((item) => item.tagId == dd)
            if (index !== -1) {
              this.selectedTagList.push(this.listOneArray[index])
            }
          })
        })
      }
    },
    validateFn() {
      if (this.newCustomerAll === 2) {
        if (this.currentType === 4) {
          if (!this.form.weSopExecuteGroupTimeCondit.change && !this.form.weSopExecuteGroupTagIdsCondit.change) {
            this.msgError('请至少勾选一项客群属性！')
            return false
          }
        } else {
          if (
            !this.form.weSopExecuteGroupTimeCondit.change &&
            !this.form.weSopExecuteGroupTagIdsCondit.change &&
            !this.form.weSopExecuteGroupMemberLimitCondit.change
          ) {
            this.msgError('请至少勾选一项客群属性！')
            return false
          }
        }
        if (this.form.weSopExecuteGroupTimeCondit.change) {
          if (!this.form.weSopExecuteGroupTimeCondit.beginTime || !this.form.weSopExecuteGroupTimeCondit.endTime) {
            this.msgError('请选择客群创建时间！')
            return false
          }
        }
        if (this.form.weSopExecuteGroupTagIdsCondit.change) {
          if (!this.form.weSopExecuteGroupTagIdsCondit.tagIds.length) {
            this.msgError('请选择客群标签！')
            return false
          }
        }
        if (this.currentType !== 4) {
          if (this.form.weSopExecuteGroupMemberLimitCondit.change) {
            if (
              !this.form.weSopExecuteGroupMemberLimitCondit.groupMemberDown ||
              !this.form.weSopExecuteGroupMemberLimitCondit.groupMemberUp
            ) {
              this.msgError('请输入客群人数区间！')
              return false
            }
            if (
              Number(this.form.weSopExecuteGroupMemberLimitCondit.groupMemberDown) >
              Number(this.form.weSopExecuteGroupMemberLimitCondit.groupMemberUp)
            ) {
              this.msgError('请输入正确客群人数区间！')
              return false
            }
          }
        }
      }
      return true
    },
    clearChange() {
      this.form = {
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
      }
      this.selectedTagList = []
      this.dateRange = []
    },
    submitFn() {
      if (this.newCustomerAll === 1) {
        this.form = null
      }
      this.$emit('update', this.form)
    },
  },
  created() {
    if (this.initData) {
      this.newCustomerAll = 2
      if (this.initData.weSopExecuteGroupTimeCondit && this.initData.weSopExecuteGroupTimeCondit.change) {
        this.form.weSopExecuteGroupTimeCondit = this.initData.weSopExecuteGroupTimeCondit
        this.dateRange = [
          this.initData.weSopExecuteGroupTimeCondit.beginTime,
          this.initData.weSopExecuteGroupTimeCondit.endTime,
        ]
      }
      if (this.initData.weSopExecuteGroupTagIdsCondit && this.initData.weSopExecuteGroupTagIdsCondit.change) {
        this.form.weSopExecuteGroupTagIdsCondit = this.initData.weSopExecuteGroupTagIdsCondit
        this.editTag()
      }
      if (this.initData.weSopExecuteGroupMemberLimitCondit && this.initData.weSopExecuteGroupMemberLimitCondit.change) {
        this.form.weSopExecuteGroupMemberLimitCondit = this.initData.weSopExecuteGroupMemberLimitCondit
      }
      // this.$forceUpdate()
    }
  },
}
</script>
<style lang="scss" scoped>
.select_content {
  background-color: var(--color-light-10);
  padding: 20px;
  border-radius: 5px;
  .select_unit {
    padding: 10px 25px;
  }
}
</style>
