<!-- 选择部分条件范围客户表单 -->
<script>
import { getList } from '@/api/salesCenter/businessConver.js'
export default {
  components: {},
  props: {
    data: {
      type: Object,
      default: () => ({ isContain: '1', customerTypes: ['1'] }),
    },
    // 是否为详情展示（不显示选择按钮）
    isDetail: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return { form: this.data, stageList: [], dialogVisibleSelectUser: false, dialogVisibleSelectTag: false }
  },
  computed: {},
  watch: {
    form: {
      deep: true,
      handler(val) {
        this.$emit('update:data', val)
      },
    },
  },
  created() {
    this.$emit('update:data', this.data)
    getList().then((res) => {
      this.stageList = res.data
    })
  },
  mounted() {},
  methods: {},
}
</script>

<template>
  <el-form :model="form" ref="form" v-if="form">
    <el-form-item label="添加人员" prop="users">
      <div v-if="!isDetail">
        <el-button type="primary" @click="dialogVisibleSelectUser = true">选择人员</el-button>
        <SelectUser
          v-model:visible="dialogVisibleSelectUser"
          title="选择人员"
          :defaultValues="form.users"
          @success="(data) => ((form.users = data), $refs.form.validateField('users'))"></SelectUser>
      </div>
      <TagEllipsis :list="form.users" limit="10"></TagEllipsis>
    </el-form-item>

    <el-form-item label="客户类型" prop="customerTypes">
      <el-checkbox-group v-model="form.customerTypes">
        <el-checkbox v-for="(item, key) in { 1: '微信用户', 2: '企业用户' }" :key="key" :label="key">
          {{ item }}
        </el-checkbox>
      </el-checkbox-group>
    </el-form-item>

    <el-form-item label="客户性别" prop="genders">
      <el-checkbox-group v-model="form.genders">
        <el-checkbox
          v-for="(sendGender, index) in [
            { label: '男', value: '1' },
            { label: '女', value: '2' },
            { label: '未知', value: '0' },
          ]"
          :key="index"
          :label="sendGender.value">
          {{ sendGender.label }}
        </el-checkbox>
      </el-checkbox-group>
    </el-form-item>

    <el-form-item label="添加时间">
      <el-date-picker
        v-model="form.dateRange"
        value-format="YYYY-MM-DD"
        type="daterange"
        v-bind="pickerOptions"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        align="right"></el-date-picker>
    </el-form-item>

    <el-form-item label="客户标签" prop="tags">
      <div v-if="!isDetail">
        <el-button type="primary" @click="dialogVisibleSelectTag = true">选择标签</el-button>
        <SelectTag
          v-model:visible="dialogVisibleSelectTag"
          :selected="form.tags"
          @success="(data) => ((form.tags = data), $refs.form.validateField('tags'))"></SelectTag>
      </div>

      <TagEllipsis class="block mt5" :list="form.tags" limit="10"></TagEllipsis>

      <el-radio-group v-model="form.isContain" @change="">
        <el-radio
          v-for="(item, key) in { 1: '包含全部选中标签', 2: '包含其中一个标签', 3: '不包含选中标签' }"
          :key="key"
          :label="key">
          {{ item }}
        </el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item label="商机阶段" prop="trackState">
      <el-select v-model="form.trackState" placeholder="请选择">
        <el-option
          v-for="(item, index) in stageList"
          :key="index"
          :label="item.stageKey"
          :value="item.stageVal"></el-option>
      </el-select>
    </el-form-item>
  </el-form>
</template>

<style lang="scss" scoped></style>
