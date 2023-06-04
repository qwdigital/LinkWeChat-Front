<template>
  <div>
    <el-form
      :inline="true"
      :rules="rules"
      ref="customerAttributes"
      :model="current"
      label-width="0"
      label-position="left">
      <el-form-item prop="code">
        <el-select :disabled="detail" @change="setValueList" v-model="current.code" placeholder="请选择属性类型">
          <template v-for="(item, key) in baseData" :key="key">
            <el-option
              v-if="filterAttributeFn(item.code)"
              :label="item.value"
              :value="item.code"
              :disabled="setDisable(item.code)"></el-option>
          </template>
        </el-select>
      </el-form-item>
      <el-form-item prop="relation">
        <el-select :disabled="detail" @change="setValueState" v-model="current.relation" placeholder="请选择关系">
          <template v-for="(item, index) in relationData" :key="index">
            <el-option v-if="filterFn(item.code)" :label="item.value" :value="item.code"></el-option>
          </template>
        </el-select>
      </el-form-item>
      <template v-if="current.code === 2 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-select :disabled="detail" v-model="current.value" placeholder="请选择性别">
            <el-option label="男" value="1"></el-option>
            <el-option label="女" value="2"></el-option>
          </el-select>
        </el-form-item>
      </template>
      <template v-if="current.code === 3 && current.relation !== 8 && current.relation !== 9">
        <el-form-item v-if="current.relation === 7" prop="value">
          <el-input :disabled="detail" v-model="current.value" placeholder="例：20-30"></el-input>
        </el-form-item>
        <el-form-item v-else prop="value">
          <el-input
            :disabled="detail"
            v-model="current.value"
            @input="nubmer($event)"
            placeholder="请输入年龄"></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 5 && current.relation !== 8 && current.relation !== 9">
        <el-form-item v-if="current.relation === 7" prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="1"
            v-model="dateValue"
            @change="setDate"
            value-format="yyyy-MM-dd"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"></el-date-picker>
        </el-form-item>
        <el-form-item v-else prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="2"
            value-format="yyyy-MM-dd"
            v-model="current.startTime"
            type="date"
            placeholder="选择日期"></el-date-picker>
        </el-form-item>
      </template>
      <template v-if="current.code === 7 && current.relation !== 8 && current.relation !== 9">
        <select-city :detail="detail" :defaultValue="current.value" @update="setUpdateData"></select-city>
      </template>
      <template v-if="current.code === 12 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-select :disabled="detail" v-model="current.value" placeholder="请选择跟进状态">
            <el-option label="待跟进" value="1"></el-option>
            <el-option label="跟进中" value="2"></el-option>
            <el-option label="已成交" value="3"></el-option>
            <el-option label="无意向" value="4"></el-option>
            <el-option label="已流失" value="5"></el-option>
          </el-select>
        </el-form-item>
      </template>
      <template v-if="current.code === 15 && current.relation !== 8 && current.relation !== 9">
        <el-form-item v-if="current.relation === 7" prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="3"
            v-model="dateValue"
            @change="setDate"
            value-format="yyyy-MM-dd"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"></el-date-picker>
        </el-form-item>
        <el-form-item v-else prop="startTime">
          <el-date-picker
            :disabled="detail"
            value-format="yyyy-MM-dd"
            key="4"
            v-model="current.startTime"
            type="date"
            placeholder="选择日期"></el-date-picker>
        </el-form-item>
      </template>
      <template v-if="current.code === 100">
        <el-form-item>
          <el-select v-model="current.value" placeholder="请选择标签">
            <template v-for="(item, key) in tagList" :key="key">
              <el-option :label="item.value" :value="item.code"></el-option>
            </template>
          </el-select>
        </el-form-item>
      </template>
      <template v-if="current.code === 0">
        <el-form-item>
          <el-select v-model="current.value" placeholder="请选择渠道类型">
            <template v-for="(item, key) in valueList" :key="key">
              <el-option :label="item.value" :value="item.code" v-if="item.code !== 1002"></el-option>
            </template>
          </el-select>
        </el-form-item>
      </template>
      <template v-if="current.code === 102">
        <el-form-item>
          <el-select v-model="current.value" placeholder="请选择所属群聊">
            <template v-for="(item, key) in groupChatEnum" :key="key">
              <el-option :label="item.value" :value="item.code"></el-option>
            </template>
          </el-select>
        </el-form-item>
      </template>
      <el-form-item v-if="showDelete">
        <el-button text @click="deleteFn">删除</el-button>
      </el-form-item>
    </el-form>
    <select-dept
      :defaultValues="selectedDeptList"
      v-model:visible="dialogVisibleSelectDept"
      title="选择部门"
      :isOnlyLeaf="false"
      @success="selectedDept"></select-dept>
    <select-user
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      @success="selectedUser"></select-user>
  </div>
</template>
<script>
import SelectDept from '@/components/SelectDept'
import SelectCity from '@/components/common/SelectCity'
import { dateFormat } from '@/utils/index'
import { getChannelDetail } from '@/api/sop/index'
export default {
  name: 'sop-customer-attributes',
  components: {
    SelectDept,
    SelectCity,
  },
  data() {
    return {
      dialogVisibleSelectDept: false,
      selectedDeptList: [],
      dialogVisibleSelectUser: false,
      selectedUserList: [],
      dateValue: [],
      current: {
        code: null,
        swipType: '',
        value: '',
        relation: '',
        startTime: '',
        endTime: '',
        name: '',
      },
      valueList: [],
      tagList: [],
      list: [],
      setAttribute: [2, 3, 5, 7, 12, 15, 100, 0, 102],
      setRelation: {
        2: [1, 2],
        3: [1, 2, 3, 5, 7, 8, 9],
        5: [1, 2, 3, 5, 7, 8, 9],
        7: [1, 2, 8, 9],
        12: [1, 2],
        15: [1, 2, 3, 5, 7, 8, 9],
        100: [1, 2],
        0: [1, 2],
        102: [1, 2],
      },
      rules: {
        code: [{ required: true, message: '请选择属性类型', trigger: 'blur' }],
        relation: [{ required: true, message: '请选择关系', trigger: 'blur' }],
        value: [{ required: true, message: '数据不能为空', trigger: 'blur' }],
        startTime: [{ required: true, message: '请选择时间', trigger: 'blur' }],
      },
    }
  },
  props: {
    showDelete: {
      type: Boolean,
      default: true,
    },
    detail: {
      type: Boolean,
      default: false,
    },
    baseData: {
      type: Array,
      default: () => [],
    },
    relationData: {
      type: Array,
      default: () => [],
    },
    currentData: {
      type: Object,
      default: () => {},
    },
    weCorpTagEnum: {
      type: Array,
      default: () => [],
    },
    groupChatEnum: {
      type: Array,
      default: () => [],
    },
    enableList: {
      type: Array,
      default: () => [2, 3, 5, 7, 12, 15, 100, 0, 102],
    },
    disabled: {
      type: Array,
      default: () => [],
    },
  },
  watch: {
    current: {
      deep: true,
      handler(newData, old) {
        this.$emit('update:currentData', newData)
        this.$emit('updatedata')
        // this.$forceUpdate()
      },
    },
    currentData: {
      deep: true,
      handler(newData, old) {
        this.current = newData
        if (this.current.code === 0) {
          this.current.value = Number(this.current.value)
        }
        // this.$forceUpdate()
      },
    },
    enableList: {
      immediate: true,
      handler(val) {
        this.setAttribute = val
      },
    },
    weCorpTagEnum: {
      handler(val) {
        this.tagList = []
        val.forEach((dd) => {
          if (dd.child && dd.child.length) {
            this.tagList = [...this.tagList, ...dd.child]
          }
        })
      },
    },
  },
  methods: {
    deleteFn() {
      this.$emit('remove')
    },
    async handleValidateFn() {
      return await this.$refs['customerAttributes'].validate()
    },
    setUpdateData(data) {
      this.current.value = data
    },
    selectedUser(data) {
      this.selectedUserList = data
      let ids = data.map((item) => item.userId)
      let names = data.map((item) => item.name)
      this.current.value = ids.join(',')
      this.current.name = names.join(',')
    },
    selectedDept(data) {
      this.selectedDeptList = data
      let ids = data.map((item) => item.deptId)
      let names = data.map((item) => item.deptName)
      this.current.value = ids.join(',')
      this.current.name = names.join(',')
    },
    setDate(data) {
      if (!data) {
        this.dateValue = []
        this.current.startTime = ''
        this.current.endTime = ''
      } else {
        if (data[0]) {
          this.current.startTime = data[0]
        }
        if (data[1]) {
          this.current.endTime = data[1]
        }
      }
    },
    // setDateChange() {
    //   this.current.value = dateFormat(this.current.value, 'yyyy-MM-dd')
    // },
    nubmer(e) {
      let _value = e.target.value
      const reg = isNaN(_value)
      if (reg) {
        e.target.value = _value.replace(/[^1-9]/g, '')
      }
      if (_value === '0') {
        e.target.value = _value.replace(/^[^1-9]/g, '')
      }
    },
    phoneNubmer(e) {
      let _value = e.target.value
      const reg = isNaN(_value)
      if (reg) {
        e.target.value = _value.replace(/[^1-9]/g, '')
      }
      if (_value === '0') {
        e.target.value = _value.replace(/^[^1-9]/g, '')
      }
      if (_value.length > 11) {
        e.target.value = _value.slice(0, 11)
      }
    },
    setDisable(code) {
      return this.disabled.includes(code)
    },
    filterAttributeFn(code) {
      return this.setAttribute.includes(code)
    },
    filterFn(code) {
      if (this.setRelation[this.current.code]) {
        return this.setRelation[this.current.code].includes(code)
      }
    },
    setValueState() {
      this.current.value = ''
      this.current.name = ''
      this.current.startTime = ''
      this.current.endTime = ''
      this.dateValue = []
      this.selectedDeptList = []
      this.selectedUserList = []
    },
    setValueList(data, state) {
      if (!state) {
        if (data === 100) {
          this.current.swipType = 2
        } else if (data === 0) {
          this.current.swipType = 1
        } else if (data === 102) {
          this.current.swipType = 6
        } else {
          this.current.swipType = 3
        }
        this.dateValue = []
        this.current.value = ''
        this.current.name = ''
        this.current.relation = ''
        this.current.startTime = ''
        this.current.endTime = ''
        this.selectedDeptList = []
        this.selectedUserList = []
      }
      this.$emit('change')
    },
  },
  mounted() {
    this.current = this.currentData
    if (this.current.startTime || this.current.endTime) {
      this.dateValue = [this.current.startTime, this.current.endTime]
    }
    if (this.current.code) {
      this.current.code = Number(this.current.code)
      if (this.current.relation) {
        this.current.relation = Number(this.current.relation)
      }
      this.setValueList(this.current.code, 'first')
      if (this.current.code === 13) {
        if (this.current.name && this.current.value) {
          this.selectedDeptList = []
          let names = this.current.name.split(',')
          let values = this.current.value.split(',')
          names.forEach((res, index) => {
            let obj = {
              deptId: values[index],
              deptName: res,
            }
            this.selectedDeptList.push(obj)
          })
        }
      }
    }
  },
  created() {
    this.weCorpTagEnum.forEach((dd) => {
      if (dd.child && dd.child.length) {
        this.tagList = [...this.tagList, ...dd.child]
      }
    })
    getChannelDetail({ code: 1 }).then((res) => {
      if (res.code === 200) {
        this.valueList = res.rows
      } else {
        this.valueList = []
      }
    })
  },
}
</script>
<style lang="scss" scoped></style>
