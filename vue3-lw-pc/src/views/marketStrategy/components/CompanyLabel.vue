<template>
  <div>
    <el-form :inline="true" :rules="rules" ref="companyLabel" :model="current"  label-width="0" label-position="left">
      <el-form-item prop="code">
        <el-select :disabled="detail" @change="setValueList" v-model="current.code" placeholder="请选择标签组">
          <el-option v-for="(item, key) in baseData" :key="key" :label="item.value" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item prop="value">
        <el-select :disabled="detail" v-model="current.value" placeholder="请选择标签">
          <el-option v-for="(item, index) in valueList" :key="index" :label="item.value" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
  import { getList } from '@/api/customer/tag'
  export default {
    name: 'company-label',
    data () {
      return {
        current: {
          code: null,
          value: ''
        },
        valueList: [],
        rules: {
          code: [
            {required: true, message:'请选择标签组', trigger:'blur'}
          ],
          value: [
            {required: true, message:'请选择标签', trigger:'blur'}
          ]
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
      currentData: {
        type: Object,
        default: () => { }
      }
    },
    watch: {
      baseData (val) {
        if (val) {
          this.setValueList(this.current.code, 'first')
        }
      }
    },
    methods: {
       handleValidateFn () {
        let status = null
        this.$refs['companyLabel'].validate((valid) => {
          if (valid) {
            status = true
          } else {
            status = false
          }
        });
        return status
      },
      setValueList (data, state) {
        if (!state) {
          this.current.value = ''
        }
        this.valueList = []
        this.baseData.forEach(dd => {
          if (dd.code === data) {
            this.valueList = dd.child
          }
        })
      }
    },
    mounted () {
      this.current = this.currentData
      if (this.current.code) {
        this.setValueList(this.current.code, 'first')
      }
    },
  }
</script>
<style lang="scss" scoped>
</style>
