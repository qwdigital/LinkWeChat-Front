<template>
  <div>
    <el-form :inline="true" :rules="rules" ref="channelLabel" :model="current" label-width="0" label-position="left">
      <el-form-item prop="code">
        <el-select :disabled="detail" @change="setValueList" v-model="current.code" placeholder="请选择渠道类型">
          <el-option v-for="(item, key) in baseData" :key="key" :label="item.value" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item prop="value">
        <el-select :disabled="detail" v-model="current.value" placeholder="请选择渠道来源">
          <template v-if="current.code !== 1">
            <el-option
              v-for="(item, index) in valueList"
              :key="index"
              :label="item.value"
              :value="item.code"
            ></el-option>
          </template>
          <template v-else>
            <template v-for="(item, index) in valueList">
              <el-option :key="index" :label="item.value" :value="item.code" v-if="item.code !== 1002"></el-option>
            </template>
          </template>
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
  import { getList } from '@/api/drainageCode/staff'
  import { getChannelDetail } from '@/api/marketStrategy/people'
  export default {
    name: 'channel-label',
    data() {
      return {
        current: {
          code: null,
          value: ''
        },
        valueList: [],
        rules: {
          code: [{ required: true, message: '请选择渠道类型', trigger: 'blur' }],
          value: [{ required: true, message: '请选择渠道来源', trigger: 'blur' }]
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
      channel: {
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
        this.$refs['channelLabel'].validate((valid) => {
          if (valid) {
            status = true
          } else {
            status = false
          }
        })
        return status
      },
      setValueList(data, state) {
        if (!state) {
          this.current.value = ''
        }
        getChannelDetail({ code: data }).then((res) => {
          if (res.code === 200) {
            this.valueList = res.rows
          } else {
            this.valueList = []
          }
        })
      }
    },
    mounted() {
      this.current = this.currentData
      if (this.current.code) {
        this.current.code = Number(this.current.code)
      }
      if (this.current.code === 1) {
        this.current.value = Number(this.current.value)
      }
      if (this.current.code) {
        this.setValueList(this.current.code, 'first')
      }
    }
  }
</script>
<style lang="scss" scoped></style>
