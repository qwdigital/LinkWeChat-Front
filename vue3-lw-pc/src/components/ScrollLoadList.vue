<!-- 下拉刷新、下拉加载列表 组件 -->
<script>
export default {
  name: '',
  props: {
    // 加载请求接口
    request: {
      type: Function,
    },
    // 查询参数
    params: {
      type: Object,
      default: () => ({}),
    },
    // 是否显示搜索框
    isQuery: {
      type: Boolean,
      default: true,
    },
    // 是否禁用滚动加载
    disabled: {
      type: Boolean,
      default: false,
    },
    // 自定义的查询参数处理方法，可用于添加和修改查询参数
    dealQueryFun: {
      type: Function,
      default: null,
    },
    // 自定义的返回数据处理方法，可用于添加和修改查询参数
    dealDataFun: {
      type: Function,
      default: null,
    },
    finishedText: {
      type: String,
      default: '没有更多了',
    },
  },
  data() {
    return {
      loading: false,
      query: {
        pageNum: 1,
        pageSize: 10,
        keywords: '',
      },
      // refreshing: false,
      finished: false,
      error: false,
      list: [
        // {
        //   state: '跟进',
        //   content: 'asdfasdf请求失败，点击重新加载d',
        //   customerName: 'aaa森岛帆高色',
        //   sendTime: '1010-12-12 32:32:23',
        // },
        // {
        //   title: 'ssdsdssfsdfs',
        //   content: 'ssdsdssfsdfs',
        //   notificationTime: 'ssdsdssfsdfs',
        // },
        // {
        //   title: 'ssdsdssfsdfs',
        //   content: 'ssdsdssfsdfs',
        //   notificationTime: 'ssdsdssfsdfs',
        // },
      ],
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
  },
  mounted() {},
  methods: {
    getList(page) {
      if (this.disabled || this.error) {
        return
      }
      this.loading = true
      this.finished = false
      page && (this.query.pageNum = page)

      Object.assign(this.query, this.params)

      this.dealQueryFun && this.dealQueryFun(this.query)

      this.request(this.query)
        .then(({ rows, data, total = 0 }) => {
          rows ??= data || []
          if (this.query.pageNum == 1) {
            this.list = []
          }
          this.dealDataFun && this.dealDataFun(rows)

          this.list.push(...rows)
          this.loading = false
          // this.refreshing = false
          // 数据全部加载完成
          if (this.list.length >= +total) {
            if (this.list.length == 0) {
              this.query.pageNum = 1
            }
            this.finished = true
          } else {
            this.query.pageNum++
          }
        })
        .catch(() => {
          this.error = true
          this.loading = false
          // this.finished = true
        })
    },
  },
}
</script>

<template>
  <div class="ScrollLoadList">
    <div class="g-margin-b" v-if="isQuery">
      <el-input v-model="query.keywords" placeholder="请输入关键词" @keyup.enter.exact="getList(1)">
        <template #append>
          <el-button icon="el-icon-search" @click="getList(1)" />
        </template>
      </el-input>
    </div>

    <div
      ref="scroll"
      v-infinite-scroll="getList.bind()"
      style="overflow: auto; height: 100%"
      :infinite-scroll-disabled="loading || finished">
      <template v-for="(item, i) in list" :key="i">
        <slot name="item" v-bind="{ item }"></slot>
      </template>

      <div>
        <slot name="list" v-bind="{ list }"></slot>
      </div>

      <div class="ac mt10 mb10" style="color: var(--font-black-6)" v-if="loading || finished">
        <p v-if="loading">正在加载...</p>
        <slot name="empty" v-else-if="!list?.length">
          <Empty />
        </slot>
        <p v-else-if="finishedText">{{ finishedText }}</p>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.ScrollLoadList {
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
</style>
