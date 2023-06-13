<template>
  <div>
    <el-form :inline="true" :model="current" :rules="rules" ref="strategicCrowd" label-width="0" label-position="left">
      <el-form-item prop="code">
        <el-select :disabled="detail" v-model="current.code" placeholder="请选择已有人群">
          <el-option v-for="(item, key) in baseData" :key="key" :label="item.value" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
  export default {
    name: 'strategic-crowd',
    data () {
      return {
        current: {
          code: '',
        },
         rules: {
          code: [
            {required: true, message:'请选择已有人群', trigger:'blur'}
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
    methods: {
      handleValidateFn () {
        let status = null
        this.$refs['strategicCrowd'].validate((valid) => {
          if (valid) {
            status = true
          } else {
            status = false
          }
        });
        return status
      },
    },
    mounted () {
      this.current = this.currentData
    },
  }
</script>
<style lang="scss" scoped>
</style>
