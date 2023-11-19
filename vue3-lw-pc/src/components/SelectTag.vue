<script>
import SelectTag1 from '@/components/SelectTag1'
export default {
  name: 'SelectTag',
  components: { SelectTag1 },
  props: {
    isSingle: {
      type: Boolean,
      default: false,
    },
    // 添加标签显隐
    visible: {
      type: Boolean,
      default: false,
    },
    title: {
      type: String,
      // default: '',
    },
    // "标签分组类型(1:客户标签;2:群标签)"
    type: {
      type: String,
      default: '1',
    },
    destroyOnClose: Boolean,
    // 已选中的标签，一般用于回显
    selected: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      selectedList: [],
    }
  },
  watch: {
    selected: {
      handler(val = []) {
        this.selectedList = [...val]
      },
      immediate: true,
      deep: true,
    },
  },
  computed: {
    Pvisible: {
      get() {
        this.selectedList = [...this.selected]
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
  },
  created() {},
  mounted() {},
  methods: {
    submit() {
      this.$emit('success', this.selectedList)
      this.Pvisible = false
    },
  },
}
</script>

<template>
  <el-dialog
    :title="title || `选择${type == 1 ? '客户' : '客群'}标签`"
    v-model="Pvisible"
    :destroy-on-close="destroyOnClose">
    <div>
      <SelectTag1 :type="type" :isSingle="isSingle" v-model:selected="selectedList"></SelectTag1>
      <slot></slot>
    </div>
    <template #footer>
      <div>
        <el-button @click="Pvisible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </div>
    </template>
  </el-dialog>
</template>
<style lang="scss" scoped></style>
