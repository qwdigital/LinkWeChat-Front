<script>
import { getDeptUserAll } from '@/api/organization'

// 选择企业成员
export default {
  name: 'SelectStaffForm',
  components: {},
  props: {
    selected: {
      type: [Array, String],
      default: undefined,
    },
    // 是否多选
    multiple: {
      type: Boolean,
      default: false,
    },
    // 是否必选
    required: {
      type: Boolean,
      default: true,
    },
    labelPosition: {
      type: String,
      default: 'left',
    },
  },
  data() {
    return {
      getDeptUserAll,
      form: { selectedList: '' },
      rules: {
        selectedList: [{ required: this.required, message: '必填项', trigger: 'change' }],
      },
    }
  },
  watch: {
    // selected: {
    //   handler(val = []) {
    //     this.selectedList = [...val]
    //   },
    //   immediate: true,
    // },
    'form.selectedList'(val) {
      this.$emit('update:selected', val)
    },
  },
  computed: {},
  created() {
    this.form.selectedList = this.selected
    // this.form.selectedList = Array.isArray(this.selected) ? [...this.selected] : this.selected
  },
  mounted() {},
  methods: {
    validate() {
      return this.$refs['form'].validate().then(() => {
        this.$emit('update:selected', this.form.selectedList)
      })
    },
  },
}
</script>

<template>
  <el-form ref="form" :model="form" inline :rules="rules">
    <el-form-item prop="selectedList" :labelPosition="labelPosition" label="选择员工">
      <CoRemoteSelect
        v-model="form.selectedList"
        :multiple="multiple"
        queryKeywordsKey="userName"
        :defaultProps="{ id: 'weUserId', name: 'userName' }"
        :remote-method="getDeptUserAll"
      ></CoRemoteSelect>
    </el-form-item>
  </el-form>
</template>
<style lang="scss" scoped></style>
