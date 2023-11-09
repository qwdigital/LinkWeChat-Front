<script>
import { getList } from '@/api/customer/tag'

export default {
  name: 'delete-tag',
  components: {},
  props: {
    title: {
      type: String,
      default: '选择标签',
    },
    visible: {
      type: Boolean,
      default: false,
    },
    destroyOnClose: Boolean,
    // "标签分组类型(1:客户标签;2:群标签)"
    type: {
      type: String,
      default: '1',
    },
    selected: {
      type: Array,
      default: () => [],
    },
    initList: {
      type: Array,
      default: () => {},
    },
  },
  data() {
    return {
      loading: false,
      list: [],
      listOneArray: [],
      selectedList: [],
      init: [],
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
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
    checkedTagMap() {
      return new Set(this.selectedList.map((i) => i.tagId || (typeof i == 'string' && i)))
    },
  },
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    setData() {
      this.list = []
      if (this.initList.length) {
        this.init.forEach((dd, index) => {
          let once = false
          dd.weTags.forEach((ff) => {
            if (this.initList.includes(ff.tagId)) {
              ff.show = true
              once || this.list.push(dd)
              once = true
            }
          })
        })
      } else {
        this.list = []
      }
    },
    getList() {
      this.loading = true
      getList({ groupTagType: this.type }).then(({ rows }) => {
        // this.list = rows
        this.init = rows
        this.listOneArray = []
        this.init.forEach((element) => {
          element.weTags.forEach((d) => {
            this.listOneArray.push({ tagId: d.tagId, name: d.name })
          })
        })
        this.setData()
        this.loading = false
      })
    },
    submit() {
      // 统一数据格式
      let arr = []
      this.selected.forEach((dd) => {
        if (!this.selectedList.includes(dd)) {
          arr.push(dd)
        }
      })
      if (arr.length) {
        let selected = this.listOneArray.filter((i) => arr.some((e) => e === i.tagId))
        this.$emit('success', selected)
        this.Pvisible = false
      } else {
        this.msgError('未操作任何标签！')
      }
    },
    onSelectTag(tag) {
      const existIdx = this.selectedList.findIndex((i) => i === tag.tagId)
      if (existIdx > -1) {
        this.selectedList.splice(existIdx, 1)
      } else {
        this.selectedList.push(tag.tagId)
      }
    },
    isSelected(data) {
      return this.checkedTagMap.has(data.tagId) || this.checkedTagMap.has(data.name)
    },
  },
}
</script>

<template>
  <el-dialog :title="title" v-model="Pvisible" :destroy-on-close="destroyOnClose">
    <div v-loading="loading">
      <section class="label-group">
        <template v-for="(item, index) in list" :key="index">
          <div class="label-group-item" v-if="item">
            <div class="label-group-item-title">{{ item.groupName }}</div>
            <div v-if="item.weTags" class="label-group-item-body">
              <template v-for="tag in item.weTags" :key="tag.tagId">
                <el-tag v-if="tag.show" :type="isSelected(tag) ? '' : 'info'" @click="onSelectTag(tag)">
                  {{ tag.name }}
                </el-tag>
              </template>
            </div>
          </div>
        </template>
      </section>
    </div>
    <template #footer>
      <div>
        <el-button @click="Pvisible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </div>
    </template>
  </el-dialog>
</template>
<style lang="scss" scoped>
.label-group {
  max-height: 400px;
  overflow-x: hidden;
  overflow-y: scroll;
  &-item {
    margin: 10px;
    border-bottom: 1px solid var(--border-black-10);

    &-title {
      font-weight: 700;
      line-height: 24px;
    }
    &-body {
      padding: 10px 0;
    }

    .el-tag {
      cursor: pointer;
    }
  }
}
</style>
