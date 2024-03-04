<script>
import list from './list'

export default {
  components: { list },
  props: {
    // 添加标签显隐
    visible: {
      type: Boolean,
      default: false,
    },
    // title: {
    //   type: String,
    //   default: '',
    // },
    type: {
      type: [String, Number],
      default: '4',
    },
    // 显示哪些素材类型标签
    showArr: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      text: {},
      image: {},
      file: {},
    }
  },
  watch: {},
  computed: {
    title() {
      const titleMap = {
        4: '文本',
        0: '图片',
        9: '图文',
        11: '小程序',
        2: '视频',
        3: '文件',
      }
      return titleMap[this.type] || '素材'
    },
    Pvisible: {
      get() {
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
    Ptype: {
      get() {
        return this.type
      },
      set(val) {
        this.$emit('update:type', val)
      },
    },
  },
  created() {},
  mounted() {},
  methods: {
    submit() {
      this.Pvisible = false
      this.$emit('success', this.selectedData)
    },
    onChange(data) {
      this.selectedData = data
    },
  },
}
</script>

<template>
  <el-dialog :title="`选择${title}`" v-model="Pvisible" width="680px" append-to-body destroy-on-close>
    <div>
      <list v-if="showArr.length <= 1" :type="showArr[0] || type" @change="onChange"></list>
      <el-tabs v-else-if="showArr.length > 1" v-model="Ptype">
        <!-- <el-tab-pane name="0" v-if="showArr.includes(0)">
          <template #label> <el-icon-date class="el-icon-date"/> 文本 </template>
          <list type="4" @change="onChange"> </list>
        </el-tab-pane>
        <el-tab-pane name="1" v-if="showArr.includes(1)">
          <template #label> <el-icon-date class="el-icon-date"/> 图片 </template>
          <list type="0" @change="onChange"> </list>
        </el-tab-pane> -->
      </el-tabs>
    </div>
    <template #footer>
      <el-button @click="Pvisible = false">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </template>
  </el-dialog>
</template>

<style lang="scss" scoped>
.user-list {
  .el-row {
    line-height: 26px;
  }
}
.mr30 {
  margin-right: 30px;
}

::v-deep.el-dialog__body {
  padding: 5px 20px;
  height: 76vh;
  overflow: auto;
}
</style>
