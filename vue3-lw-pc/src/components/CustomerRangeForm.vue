<!-- 选择部分条件范围客户表单 -->
<script>
import { getList } from '@/api/salesCenter/businessConver.js'
import { getCustomerList } from '@/api/groupMessage'
const defaultData = { isContain: '1' }
export default {
  components: {},
  props: {
    data: {
      type: Object,
      // default: () => JSON.parse(JSON.stringify(defaultData)), 处理不了null值情况下的默认值
    },
    // 是否为详情展示（不显示选择按钮）
    isDetail: {
      type: Boolean,
      default: false,
    },
    // 是否转换数据
    isTrans: {
      type: Boolean,
      default: false,
    },
    // 是否开启查询空结果提示
    isEmptyTips: {
      type: Boolean,
      default: true,
    },

    // 排除的表单条件项，eg: ['dateRange']
    exclude: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      form: this.data || JSON.parse(JSON.stringify(defaultData)),
      stageList: [],
      dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
    }
  },
  computed: {},
  watch: {
    form: {
      deep: true,
      handler(data) {
        data = JSON.parse(JSON.stringify(data))
        if (this.isTrans) {
          data = {
            genders: data.genders?.join(','),
            customerTypes: data.customerTypes?.join(','),
            tagIds: data.tags?.map((e) => e.tagId)?.join(','),
            tagNames: data.tags?.map((e) => e.name)?.join(','),
            userIds: data.users?.map((e) => e.userId)?.join(','),
            userNames: data.users?.map((e) => e.name)?.join(','),
            beginTime: data.dateRange?.[0],
            endTime: data.dateRange?.[1],
            trackState: data.trackState,
            isContain: data.tags?.length ? data.isContain : undefined,
          }
        }
        this.change(data)
      },
    },
  },
  created() {
    if (this.isTrans && this.data) {
      let data = JSON.parse(JSON.stringify(this.data))
      let userNames = data.userNames?.split(',')
      let tagNames = data.tagNames?.split(',')
      this.form = Object.assign(data, {
        isContain: data.isContain ? data.isContain + '' : undefined,
        genders: data.genders?.split(','),
        customerTypes: data.customerTypes?.split(','),
        users: data.userIds?.split(',')?.map((e, i) => ({ userId: e, name: userNames?.[i] })),
        tags: data.tagIds?.split(',')?.map((e, i) => ({ tagId: e, name: tagNames?.[i] })),
        dateRange: [data.beginTime, data.endTime],
      })
    }
    this.change(this.data || JSON.parse(JSON.stringify(defaultData))) // 赋默认值
    getList().then((res) => {
      this.stageList = res.data
    })
  },
  mounted() {},
  methods: {
    change(val) {
      this.$emit('update:data', val)

      this.$attrs.onGetCustomers && this.getCustomerList(val)
    },
    // 供父组件手动调用
    getCustomerList(params = this.data) {
      return getCustomerList(params, 1).then(({ data }) => {
        if (data?.length) {
          this.$attrs.onGetCustomers && this.$emit('getCustomers', data)
        } else if (this.isEmptyTips) {
          this.msgError('未找到符合条件的客户!')
          return Promise.reject()
        }
        return data
      })
    },
  },
}
</script>

<template>
  <el-form :model="form" ref="form" v-if="form">
    <el-form-item label="添加人员" prop="users" v-if="!exclude.includes('users')">
      <div v-if="!isDetail">
        <el-button type="primary" @click="dialogVisibleSelectUser = true">选择人员</el-button>
        <SelectUser
          v-model:visible="dialogVisibleSelectUser"
          title="选择人员"
          :defaultValues="form.users"
          @success="(data) => ((form.users = data), $refs.form.validateField('users'))"></SelectUser>
      </div>
      <TagEllipsis :list="form.users" limit="10" :emptyText="isDetail"></TagEllipsis>
    </el-form-item>

    <el-form-item label="客户类型" prop="customerTypes" v-if="!exclude.includes('customerTypes')">
      <el-checkbox-group v-model="form.customerTypes">
        <el-checkbox v-for="(item, key) in { 1: '微信用户', 2: '企业用户' }" :key="key" :label="key">
          {{ item }}
        </el-checkbox>
      </el-checkbox-group>
    </el-form-item>

    <el-form-item label="客户性别" prop="genders" v-if="!exclude.includes('genders')">
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

    <el-form-item label="添加时间" v-if="!exclude.includes('dateRange')">
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

    <el-form-item label="客户标签" prop="tags" v-if="!exclude.includes('tags')">
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

    <el-form-item label="商机阶段" prop="trackState" v-if="!exclude.includes('trackState')">
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
