<script>
const defaultData = { autoCreateRoom: 0 }
export default defineComponent({
  name: '',
  components: {
    SelectGroup: defineAsyncComponent(() => import('@/components/SelectGroup.vue')),
  },
  props: {
    form: {
      type: Object,
      default: () => ({}),
      // default: () => JSON.parse(JSON.stringify(defaultData)), 处理不了null值情况下的默认值
    },
    // 是否为详情展示（不显示选择按钮）
    isDetail: {
      type: Boolean,
      default: false,
    },
    rules: {
      type: Object,
      default: () => ({}),
    },
    appendToBody: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      _form: {},
      visible: false,
    }
  },
  computed: {
    _rules() {
      return Object.assign(
        {
          groups: [{ required: true, message: '必填项', trigger: 'change' }],
          autoCreateRoom: [{ required: true, message: '必填项', trigger: 'change' }],
          roomBaseName: [{ required: true, message: '必填项', trigger: 'blur' }],
          roomBaseId: [{ required: true, message: '必填项', trigger: 'blur' }],
        },
        this.rules,
      )
    },
    // _form: {
    //   get() {
    //     return JSON.parse(JSON.stringify(this.form))
    //   },
    //   set(val) {
    //     debugger
    //     // val = JSON.parse(JSON.stringify(val))
    //     // this.change(val)
    //   },
    // },
  },
  watch: {
    form: {
      deep: true,
      immediate: true,
      handler(data) {
        // debugger
        this._form = data || JSON.parse(JSON.stringify(defaultData))
      },
    },
    _form: {
      deep: true,
      // immediate: true,
      handler(data) {
        // debugger
        // data = JSON.parse(JSON.stringify(data))
        this.change(data)
      },
    },
  },
  created() {
    // debugger
    // this.change(this.form || JSON.parse(JSON.stringify(defaultData))) // 赋默认值
  },
  mounted() {},
  methods: {
    change(val) {
      this.$emit('update:form', val)
    },
    // 对外暴露
    validate(callback) {
      return this.$refs.form.validate(callback)
    },
  },
})
</script>

<template>
  <el-form ref="form" label-width="100px" label-position="right" :rules="_rules" :model="_form">
    <slot v-bind="{ form: _form }"></slot>
    <el-form-item label="添加客群:" prop="groups">
      <template v-if="!isDetail">
        <el-button type="primary" @click="visible = true">选择客群</el-button>
        <div class="g-tip">最多选择五个客群</div>
        <SelectGroup
          v-model:visible="visible"
          :defaults="_form.groups"
          :append-to-body="appendToBody"
          @submit="(data) => ((_form.groups = data), $refs.form.validateField('groups'))"></SelectGroup>
      </template>
      <TagEllipsis :list="_form.groups" limit="5" defaultProps="groupName" :emptyText="isDetail && '无'"></TagEllipsis>
    </el-form-item>

    <el-form-item label="群满自动建群:">
      <el-switch v-model="_form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
      <div class="g-tip">默认以第一个群的群主作为新建群的群主</div>
    </el-form-item>
    <template v-if="_form.autoCreateRoom">
      <el-form-item label="群名前缀:" prop="roomBaseName">
        <el-input show-word-limit maxlength="20" v-model="_form.roomBaseName" placeholder="请输入群名前缀"></el-input>
      </el-form-item>
      <el-form-item label="群起始序号:" prop="roomBaseId">
        <el-input-number v-model="_form.roomBaseId" controls-position="right" :min="1"></el-input-number>
      </el-form-item>
    </template>
  </el-form>
</template>

<style lang="scss" scoped></style>
