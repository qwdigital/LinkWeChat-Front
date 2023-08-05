<script>
import { del } from '@/views/clue/clueTemplate/api'

export default {
  name: 'TagEllipsis',
  components: {},
  props: {
    list: {
      type: Array,
      default: () => [],
    },
    limit: {
      type: [String, Number],
      default: 2,
    },
    defaultProps: {
      type: String,
      default: 'name',
    },
    // 空数据时显示的文本内容
    emptyText: {
      type: String,
      default: '',
    },
  },
  data() {
    return {}
  },
  computed: {
    _list() {
      return this.list?.filter((e) => (typeof e === 'string' ? e : e[this.defaultProps]))
    },
  },
  watch: {},
  created() {
    // 可传入 el-tag 的props
    this.elTagProps = Object.assign({}, this.$attrs)
    delete this.elTagProps.style
  },
  mounted() {},
  methods: {},
}
</script>

<template>
  <div class="tag-ellipsis" v-if="_list?.length || emptyText">
    <div v-if="!_list?.length">{{ emptyText }}</div>

    <template v-else-if="_list.length <= +limit">
      <el-tag v-bind="elTagProps" v-for="(item, unique) in _list" :key="unique">
        {{ item[defaultProps] || item }}
      </el-tag>
    </template>

    <el-popover v-else placement="bottom" trigger="hover">
      <!-- 插入到body，这里用css scoped calss无效，需使用style-->
      <div class="tag-all" style="display: flex; flex-wrap: wrap; gap: 10px">
        <el-tag v-bind="elTagProps" v-for="(item, unique) in _list" :key="unique" style="margin: 0">
          {{ item[defaultProps] || item }}
        </el-tag>
      </div>
      <template #reference>
        <div>
          <el-tag v-bind="elTagProps" v-for="(item, unique) in _list.slice(0, +limit)" :key="unique">
            {{ item[defaultProps] || item }}
          </el-tag>
          <el-tag v-bind="elTagProps" key="a" v-if="_list.length > +limit">...</el-tag>
        </div>
      </template>
    </el-popover>
  </div>
</template>

<style lang="scss" scoped>
.tag-ellipsis {
  display: inline-block;
  line-height: 34px;
  .el-tag {
    vertical-align: middle;
  }
  // .tag-all {
  //   display: flex;
  //   flex-wrap: wrap;
  //   gap: 10px;
  //   .el-tag {
  //     margin: 0;
  //   }
  // }
}
</style>
