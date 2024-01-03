<script>
import Sortable from 'sortablejs'
export default defineComponent({
  name: '',
  props: {
    data: {
      type: Array,
      default: () => [],
    },
    // 是否禁用拖动
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  components: {},
  data() {
    return {
      tableData: [],
    }
  },
  computed: {},
  watch: {
    data: {
      immediate: true,
      deep: true,
      handler(val) {
        val ??= []

        this.tableData = JSON.parse(JSON.stringify(val))
        this.tableData.forEach((item, index) => (item._sortId ??= index + Date.now()))
        // console.log(this.tableData)
      },
    },
  },
  created() {},
  mounted() {
    this.dragSort()
  },
  methods: {
    //表格拖动排序
    dragSort() {
      if (!this.tableData || this.disabled) return

      const el = this.$refs.table.$el.querySelector('.el-table__body-wrapper  table > tbody')

      this.sortable = Sortable.create(el, {
        ghostClass: 'sortable-ghost',
        setData: function (dataTransfer) {
          dataTransfer.setData('Text', '')
        },
        onEnd: (e) => {
          //e.oldIndex为拖动一行原来的位置，e.newIndex为拖动后新的位置
          let clone = JSON.parse(JSON.stringify(this.tableData))

          const targetRow = clone.splice(e.oldIndex, 1)[0]
          clone.splice(e.newIndex, 0, targetRow)

          // console.log(clone, '排序后的数据')
          this.$emit('update:data', clone)
        },
      })
    },
  },
})
</script>

<template>
  <div>
    <el-table :data="tableData" ref="table" row-key="_sortId">
      <el-table-column label="" width="50" align="center" v-if="!disabled">
        <svg-icon icon="dragIcon" style="cursor: move" />
      </el-table-column>
      <slot></slot>
    </el-table>
  </div>
</template>

<style lang="scss" scoped></style>
