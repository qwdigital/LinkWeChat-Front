<template>
  <el-dialog
    :modelValue="modelValue"
    @update:modelValue="(val) => $emit('update:modelValue', val)"
    :title="(editId ? '编辑' : '新建') + '字段'"
    width="30%">
    <el-form
      v-loading="loading"
      :model="ruleForm"
      :rules="rules"
      ref="ruleForm"
      label-width="120px"
      class="demo-ruleForm">
      <el-form-item label="字段名称：" prop="name">
        <el-input
          v-model="ruleForm.name"
          placeholder="请输入字段名称"
          maxlength="10"
          show-word-limit
          :disabled="ruleForm.fixed || editId"></el-input>
      </el-form-item>
      <el-form-item label="字段类型：" prop="type">
        <el-select v-model="ruleForm.type" :disabled="ruleForm.fixed || editId">
          <el-option :label="item.value" :value="item.key" v-for="(item, index) in typeList" :key="index"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="是否是金额：" prop="money" v-if="ruleForm.type == 6">
        <el-radio-group v-model="ruleForm.money">
          <el-radio :label="1">是</el-radio>
          <el-radio :label="0">否</el-radio>
        </el-radio-group>
        <div class="tips">金额需精确到小数点后两位</div>
      </el-form-item>
      <el-form-item label="是否精确到时间：" prop="toTime" v-if="ruleForm.type == 3">
        <el-radio-group v-model="ruleForm.toTime">
          <el-radio :label="1">是</el-radio>
          <el-radio :label="0">否</el-radio>
        </el-radio-group>
        <div class="tips">金额需精确到小数点后两位</div>
      </el-form-item>
      <el-form-item label="是否多选：" prop="multipleChoice" v-if="[2, 4, 5].includes(ruleForm.type)">
        <el-radio-group v-model="ruleForm.multipleChoice">
          <el-radio :label="1">是</el-radio>
          <el-radio :label="0">否</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="是否支持多个：" prop="more" v-if="ruleForm.type == 7">
        <el-radio-group v-model="ruleForm.more">
          <el-radio :label="1">是</el-radio>
          <el-radio :label="0">否</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="是否必填：" prop="required">
        <el-radio-group v-model="ruleForm.required" :disabled="editId">
          <el-radio :label="1">是</el-radio>
          <el-radio :label="0">否</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="字段说明：" prop="expound" v-if="[0, 1, 3, 6].includes(ruleForm.type)">
        <el-input v-model="ruleForm.expound" placeholder="请输入字段说明" maxlength="20" show-word-limit></el-input>
      </el-form-item>
      <el-form-item label="字段值：" prop="value" v-if="ruleForm.type == 2">
        <el-input
          v-model="ruleForm.value"
          placeholder="请输入选项，多个选项用英文逗号隔开"
          type="textarea"
          :rows="4"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer fr">
      <el-button @click="$emit('update:modelValue', false)">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </span>
  </el-dialog>
</template>

<script>
import { add, update, getDetail, getTypeList } from '@/api/salesCenter/orderInfo'
import { nextTick } from 'vue'
export default {
  props: {
    modelValue: {
      type: Boolean,
      default: false,
    },
    catalogueId: {
      type: String,
      default: '',
    },
    editId: {
      type: String,
      default: '',
    },
  },
  watch: {
    // modelValue: {
    //   handler(data) {
    //     if (!data) {
    //       this.$refs['ruleForm'].resetFields()
    //     }
    //   },
    // },
    editId: {
      handler(val) {
        nextTick(() => {
          this.$refs['ruleForm'].resetFields()
        })
        if (val) {
          this.getDetail(val)
        } else {
          this.ruleForm = {
            type: 0,
            money: 1,
            required: 1,
            multipleChoice: 0,
            more: 0,
            toTime: 0,
          }
        }
      },
    },
  },
  data() {
    return {
      loading: false,
      ruleForm: {},
      rules: {
        name: [{ required: true, message: '请输入字段名称', trigger: 'blur' }],
        type: [{ required: true, message: '请选择字段类型', trigger: 'change' }],
        money: [{ required: true, message: '请选择', trigger: 'change' }],
        required: [{ required: true, message: '请选择', trigger: 'change' }],
        multipleChoice: [{ required: true, message: '请选择', trigger: 'change' }],
        more: [{ required: true, message: '请选择', trigger: 'change' }],
        toTime: [{ required: true, message: '请选择', trigger: 'change' }],
        expound: [{ required: true, message: '请输入字段说明', trigger: 'blur' }],
        value: [{ required: true, message: '请输入字段值', trigger: 'blur' }],
      },
      typeList: [],
    }
  },
  mounted() {
    this.getTypeList()
  },
  methods: {
    getDetail(id) {
      if (!id) return

      this.loading = true
      getDetail(id)
        .then((res) => {
          this.ruleForm = res.data
        })
        .finally(() => {
          this.loading = false
        })
    },
    submit() {
      this.$refs['ruleForm'].validate((valid) => {
        if (valid) {
          this.ruleForm.catalogueId = this.catalogueId
          if (this.editId) {
            this.ruleForm.id = this.editId
            delete this.ruleForm.typeStr
          }
          this.loading = true
          ;(this.editId ? update : add)(this.ruleForm)
            .then((res) => {
              this.msgSuccess(res.msg)
              this.dialogVisible = false
              this.$emit('success')
              this.$emit('update:modelValue', false)
            })
            .finally(() => {
              this.loading = false
            })
        }
      })
    },
    getTypeList() {
      getTypeList().then((res) => {
        this.typeList = []
        let listKey = Object.keys(res.data)
        listKey.forEach((item) => {
          let obj = { key: +item, value: '' }
          this.typeList.push(obj)
        })
        let listValue = Object.values(res.data)
        listValue.forEach((item2, i) => {
          this.typeList[i].value = item2
        })
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.tips {
  color: #aaa;
  font-size: 12px;
  line-height: 30px;
}
</style>
