<script>
  import SelectTag1 from '@/components/SelectTag1'
  export default {
    name: 'SelectTag',
    components: { SelectTag1 },
    props: {
      isSingle: {
        type: Boolean,
        default: false
      },
      // 添加标签显隐
      visible: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: '选择标签'
      },
      // "标签分组类型(1:客户标签;2:群标签)"
      type: {
        type: String,
        default: '1'
      },
      destroyOnClose: Boolean,
      // 已选中的标签，一般用于回显
      selected: {
        type: Array,
        default: () => []
      },
      // 已选中的标签，一般用于回显，(下一主版本弃用)
      defaultValues: {
        type: Array,
        default: () => []
      }
    },
    data() {
      return {
        selectedList: []
      }
    },
    watch: {
      selected: {
        handler(val = []) {
          this.selectedList = [...val]
        },
        immediate: true
      },
      // 下一主版本弃用
      defaultValues: {
        handler(val = []) {
          this.selectedList = [...val]
        },
        immediate: true
      }
    },
    computed: {
      Pvisible: {
        get() {
          return this.visible
        },
        set(val) {
          this.$emit('update:visible', val)
        }
      }
    },
    created() {},
    mounted() {},
    methods: {
      submit() {
        this.$emit('success', this.selectedList)
        this.Pvisible = false
      }
    }
  }
</script>

<template>
  <el-dialog :title="title" :visible.sync="Pvisible" :destroy-on-close="destroyOnClose">
    <div>
      <SelectTag1 :type="type" :isSingle="isSingle" :selected.sync="selectedList"></SelectTag1>
      <slot></slot>
    </div>
    <div slot="footer">
      <el-button @click="Pvisible = false">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </div>
  </el-dialog>
</template>
<style lang="scss" scoped></style>
