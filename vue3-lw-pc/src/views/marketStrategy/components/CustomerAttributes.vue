<template>
  <div>
    <el-form
      :inline="true"
      :rules="rules"
      ref="customerAttributes"
      :model="current"
      label-width="0"
      label-position="left"
    >
      <el-form-item prop="code">
        <el-select :disabled="detail" @change="setValueList" v-model="current.code" placeholder="请选择属性类型">
          <el-option v-for="(item, key) in baseData" :key="key" :label="item.value" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item prop="relation">
        <el-select :disabled="detail" @change="setValueState" v-model="current.relation" placeholder="请选择关系">
          <template v-for="(item, index) in relationData">
            <el-option v-if="filterFn(item.code)" :key="index" :label="item.value" :value="item.code"></el-option>
          </template>
        </el-select>
      </el-form-item>
      <template v-if="current.code === 1 || !current.code">
        <el-form-item v-if="current.relation !== 8 && current.relation !== 9" prop="value">
          <el-input :disabled="detail" v-model="current.value" placeholder="请输入属性值"></el-input>
        </el-form-item>
      </template>
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
          <el-input
            :disabled="detail"
            @input.native="ageNubmer($event)"
            v-model="current.value"
            placeholder="例：20-30"
          ></el-input>
        </el-form-item>
        <el-form-item v-else prop="value">
          <el-input
            :disabled="detail"
            v-model="current.value"
            @input.native="nubmer($event)"
            placeholder="请输入年龄"
          ></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 4 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input
            :disabled="detail"
            v-model="current.value"
            @input.native="phoneNubmer($event)"
            placeholder="请输入手机号码"
          ></el-input>
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
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-form-item>
        <el-form-item v-else prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="2"
            value-format="yyyy-MM-dd"
            v-model="current.startTime"
            type="date"
            @change="setDateChange"
            placeholder="选择日期"
          ></el-date-picker>
        </el-form-item>
      </template>
      <template v-if="current.code === 6 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input :disabled="detail" v-model="current.value" placeholder="请输入邮箱"></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 7 && current.relation !== 8 && current.relation !== 9">
        <select-city :detail="detail" :defaultValue="current.value" @update="setUpdateData"></select-city>
      </template>
      <template v-if="current.code === 8 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input :disabled="detail" v-model="current.value" placeholder="请输入QQ"></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 9 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input :disabled="detail" v-model="current.value" placeholder="请输入职业"></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 10 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input :disabled="detail" v-model="current.value" placeholder="请输入公司"></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 11 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-select :disabled="detail" v-model="current.value" placeholder="请选择客户类型">
            <el-option label="微信客户" value="1"></el-option>
            <el-option label="企业客户" value="2"></el-option>
          </el-select>
        </el-form-item>
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
      <template v-if="current.code === 13 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input
            :disabled="detail"
            readonly
            :value="current.name"
            placeholder="请选择部门"
            @focus="dialogVisibleSelectDept = true"
          ></el-input>
        </el-form-item>
      </template>
      <template v-if="current.code === 14 && current.relation !== 8 && current.relation !== 9">
        <el-form-item prop="value">
          <el-input
            :disabled="detail"
            readonly
            :value="current.name"
            placeholder="请选择员工"
            @focus="dialogVisibleSelectUser = true"
          ></el-input>
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
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-form-item>
        <el-form-item v-else prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="4"
            v-model="current.startTime"
            type="date"
            value-format="yyyy-MM-dd"
            @change="setDateChange"
            placeholder="选择日期"
          ></el-date-picker>
        </el-form-item>
      </template>
      <template v-if="current.code === 16 && current.relation !== 8 && current.relation !== 9">
        <el-form-item v-if="current.relation === 7" prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="5"
            v-model="dateValue"
            @change="setDate"
            value-format="yyyy-MM-dd"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-form-item>
        <el-form-item v-else prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="6"
            value-format="yyyy-MM-dd"
            v-model="current.startTime"
            type="date"
            @change="setDateChange"
            placeholder="选择日期"
          ></el-date-picker>
        </el-form-item>
      </template>
      <template v-if="current.code === 17 && current.relation !== 8 && current.relation !== 9">
        <el-form-item v-if="current.relation === 7" prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="7"
            v-model="dateValue"
            @change="setDate"
            value-format="yyyy-MM-dd"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          ></el-date-picker>
        </el-form-item>
        <el-form-item v-else prop="startTime">
          <el-date-picker
            :disabled="detail"
            key="8"
            value-format="yyyy-MM-dd"
            v-model="current.startTime"
            type="date"
            @change="setDateChange"
            placeholder="选择日期"
          ></el-date-picker>
        </el-form-item>
      </template>
    </el-form>
    <select-dept
      :defaultValues="selectedDeptList"
      :visible.sync="dialogVisibleSelectDept"
      title="选择部门"
      :isOnlyLeaf="false"
      @success="selectedDept"
    ></select-dept>
    <select-user
      :defaultValues="selectedUserList"
      :visible.sync="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      @success="selectedUser"
    ></select-user>
  </div>
</template>
<script>
  import SelectDept from '@/components/SelectDept'
  import SelectCity from '@/components/common/SelectCity'
  import { dateFormat } from '@/utils/index'
  export default {
    name: 'customer-attributes',
    components: {
      SelectDept,
      SelectCity
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
          value: '',
          relation: '',
          startTime: '',
          endTime: '',
          name: ''
        },
        valueList: [],
        list: [],
        setRelation: {
          1: [1, 2, 8, 9],
          2: [1, 2, 8, 9],
          3: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          4: [1, 2, 8, 9, 10, 11],
          5: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          6: [1, 2, 8, 9, 10, 11],
          7: [1, 2, 8, 9, 10, 11],
          8: [1, 2, 8, 9],
          9: [1, 2, 8, 9, 10, 11],
          10: [1, 2, 8, 9, 10, 11],
          11: [1, 2, 8, 9],
          12: [1, 2, 8, 9],
          13: [1, 2, 8, 9],
          14: [1, 2, 8, 9],
          15: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          16: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          17: [1, 2, 3, 4, 5, 6, 7, 8, 9]
        },
        rules: {
          code: [{ required: true, message: '请选择属性类型', trigger: 'blur' }],
          relation: [{ required: true, message: '请选择关系', trigger: 'blur' }],
          value: [{ required: true, message: '数据不能为空', trigger: 'blur' }],
          startTime: [{ required: true, message: '请选择时间', trigger: 'blur' }]
        }
      }
    },
    props: {
      detail: {
        type: Boolean,
        default: false
      },
      baseData: {
        type: Array,
        default: () => []
      },
      relationData: {
        type: Array,
        default: () => []
      },
      currentData: {
        type: Object,
        default: () => {}
      }
    },
    methods: {
      handleValidateFn() {
        let status = null
        this.$refs['customerAttributes'].validate((valid) => {
          if (valid) {
            status = true
          } else {
            status = false
          }
        })
        return status
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
      setDateChange() {
        this.current.value = dateFormat(this.current.value, 'yyyy-MM-dd')
      },
      ageNubmer(e) {
        let _value = e.target.value
        let isTu = e.target.value.indexOf('-')
        console.log(isTu)
        let arr = _value.split('-')
        if (arr[0]) {
          const reg = isNaN(arr[0])
          if (reg) {
            arr[0] = arr[0].replace(/[^1-9]/g, '')
          }
          if (arr[0] === '0') {
            arr[0] = arr[0].replace(/^[^1-9]/g, '')
          }
        }
        if (arr[1]) {
          const reg = isNaN(arr[1])
          if (reg) {
            arr[1] = arr[1].replace(/[^1-9]/g, '')
          }
          if (arr[1] === '0') {
            arr[1] = arr[0].replace(/^[^1-9]/g, '')
          }
        }
        if (arr[0] && arr[1]) {
          e.target.value = arr[0] + '-' + arr[1]
        } else if (isTu !== -1) {
          e.target.value = arr[0] + '-'
        } else {
          e.target.value = arr[0]
        }
      },
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
      filterFn(code) {
        if (this.current.code) {
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
          this.dateValue = []
          this.current.value = ''
          this.current.name = ''
          this.current.relation = ''
          this.current.startTime = ''
          this.current.endTime = ''
          this.selectedDeptList = []
          this.selectedUserList = []
        }
      }
    },
    mounted() {
      this.current = this.currentData
      if (this.current.startTime || this.current.endTime) {
        this.dateValue = [this.current.startTime, this.current.endTime]
      }
      if (this.current.code) {
        this.current.code = Number(this.current.code)
        this.current.relation = Number(this.current.relation)
        this.setValueList(this.current.code, 'first')
        if (this.current.code === 13) {
          if (this.current.name && this.current.value) {
            this.selectedDeptList = []
            let names = this.current.name.split(',')
            let values = this.current.value.split(',')
            names.forEach((res, index) => {
              let obj = {
                deptId: values[index],
                deptName: res
              }
              this.selectedDeptList.push(obj)
            })
          }
        }
        if (this.current.code === 14) {
          if (this.current.name && this.current.value) {
            this.selectedUserList = []
            let names = this.current.name.split(',')
            let values = this.current.value.split(',')
            names.forEach((res, index) => {
              let obj = {
                userId: values[index],
                name: res
              }
              this.selectedUserList.push(obj)
            })
          }
        }
      }
    }
  }
</script>
<style lang="scss" scoped></style>
