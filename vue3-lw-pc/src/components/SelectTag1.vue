<script>
import { getList } from '@/api/customer/tag'

export default {
  components: {},
  props: {
    // "标签分组类型(1:客户标签;2:群标签)"
    type: {
      type: String,
      default: '1',
    },
    selected: {
      type: Array,
      default: () => [],
    },
    isSingle: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      loading: true,
      list: [],
      listOneArray: [],
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
    checkedTagMap() {
      return new Set(this.selectedList.map((i) => i.tagId || (typeof i == 'string' && i)))
    },
  },
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      getList({ groupTagType: this.type })
        .then(({ rows }) => {
          this.list = rows
          this.listOneArray = []
          this.list.forEach((element) => {
            element.weTags.forEach((d) => {
              this.listOneArray.push({ tagId: d.tagId, name: d.name })
            })
          })
        })
        .finally(() => {
          this.loading = false
        })
    },
    submit() {
      // 统一数据格式
      let selected = this.listOneArray.filter((i) => this.selectedList.some((e) => e.tagId === i.tagId))
      this.$emit('update:selected', selected)
    },
    onSelectTag(tag) {
      if (this.isSingle) {
        this.selectedList = [tag]
      } else {
        const existIdx = this.selectedList.findIndex((i) => i.tagId === tag.tagId)
        if (existIdx > -1) {
          this.selectedList.splice(existIdx, 1)
        } else {
          this.selectedList.push(tag)
        }
      }
      this.submit()
    },
    isSelected(data) {
      return this.checkedTagMap.has(data.tagId) || this.checkedTagMap.has(data.name)
    },
  },
}
</script>

<template>
  <section class="label-group" v-loading="loading">
    <div v-for="item in list" :key="item.groupId" class="label-group-item">
      <div class="label-group-item-title">{{ item.groupName }}</div>
      <div v-if="item.weTags" class="label-group-item-body">
        <el-tag
          v-for="tag in item.weTags"
          :key="tag.tagId"
          :type="isSelected(tag) ? '' : 'info'"
          @click="onSelectTag(tag)">
          {{ tag.name }}
        </el-tag>
      </div>
    </div>
  </section>
</template>
<style lang="scss" scoped>
.label-group {
  // max-height: 400px;
  // overflow-x: hidden;
  // overflow-y: scroll;
  &-item {
    margin: 10px;
    border-bottom: 1px solid var(--border-black-10);

    &-title {
      font-weight: 700;
      line-height: 24px;
    }
    &-body {
      padding: 10px 0;
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      .el-tag {
        margin: 0;
      }
    }

    .el-tag {
      cursor: pointer;
    }
  }
}
</style>
