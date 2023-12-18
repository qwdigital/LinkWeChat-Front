<script>
const defaultData = { autoCreateRoom: 0 }
export default defineComponent({
  name: '',
  components: {
    SelectGroup: defineAsyncComponent(() => import('@/components/SelectGroup.vue')),
  },
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
  },
  data() {
    return {
      form: {},
      rules: {
        groups: [{ required: true, message: '必填项', trigger: 'change' }],
        autoCreateRoom: [{ required: true, message: '必填项', trigger: 'change' }],
        roomBaseName: [{ required: true, message: '必填项', trigger: 'blur' }],
        roomBaseId: [{ required: true, message: '必填项', trigger: 'blur' }],
      },
      visible: false,
    }
  },
  computed: {},
  watch: {
    form: {
      deep: true,
      immediate: true,
      handler(data) {
        data = JSON.parse(JSON.stringify(data))
        this.change(data)
      },
    },
  },
  created() {
    this.change(this.data || JSON.parse(JSON.stringify(defaultData))) // 赋默认值
  },
  mounted() {},
  methods: {
    change(val) {
      this.$emit('update:data', val)
    },
    // 对外暴露
    validate(callback) {
      return this.$refs.form.validate(callback)
    },
  },
})
</script>

<template>
  <el-form ref="form" label-width="120px" label-position="right" :rules="rules" :model="form">
    <slot></slot>
    <el-form-item label="添加客群:" prop="groups">
      <template v-if="!isDetail">
        <el-button type="primary" @click="visible = true">选择客群</el-button>
        <div class="g-tip">最多选择五个客群</div>
        <SelectGroup
          v-model:visible="visible"
          :defaults="form.groups"
          @submit="(data) => ((form.groups = data), $refs.form.validateField('groups'))"></SelectGroup>
      </template>
      <TagEllipsis :list="form.groups" limit="5" defaultProps="groupName" :emptyText="isDetail && '无'"></TagEllipsis>
    </el-form-item>

    <el-form-item label="群满自动建群:">
      <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
      <div class="g-tip">默认以第一个群的群主作为新建群的群主</div>
    </el-form-item>
    <template v-if="form.autoCreateRoom">
      <el-form-item label="群名前缀:" prop="roomBaseName">
        <el-input show-word-limit maxlength="20" v-model="form.roomBaseName" placeholder="请输入群名前缀"></el-input>
      </el-form-item>
      <el-form-item label="群起始序号:" prop="roomBaseId">
        <el-input-number v-model="form.roomBaseId" controls-position="right" :min="1"></el-input-number>
      </el-form-item>
    </template>
  </el-form>
</template>

<style lang="scss" scoped></style>
