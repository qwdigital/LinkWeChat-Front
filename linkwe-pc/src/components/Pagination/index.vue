<template>
  <div class="pagination-container" ref="pagination">
    <el-pagination
      :background="background"
      :current-page.sync="currentPage"
      :page-size.sync="pageSize"
      :layout="layout"
      :page-sizes="pageSizes"
      v-bind="$attrs"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange" />
  </div>
</template>

<script>
import { scrollTo } from '@/utils/scroll-to'

export default {
  name: 'Pagination',
  props: {
    page: {
      type: Number,
      default: 1,
    },
    limit: {
      type: Number,
      default: 20,
    },
    pageSizes: {
      type: Array,
      default() {
        return [10, 20, 30, 50]
      },
    },
    layout: {
      type: String,
      default: 'total, sizes, prev, pager, next, jumper',
    },
    background: {
      type: Boolean,
      default: true,
    },
    autoScroll: {
      type: Boolean,
      default: true,
    },
  },
  computed: {
    currentPage: {
      get() {
        return this.page
      },
      set(val) {
        this.$emit('update:page', val)
      },
    },
    pageSize: {
      get() {
        return this.limit
      },
      set(val) {
        this.$emit('update:limit', val)
      },
    },
  },
  methods: {
    handleSizeChange(val) {
      this.$emit('pagination', { page: this.currentPage, limit: val })
      if (this.autoScroll) {
        this.scrollTo()
      }
    },
    handleCurrentChange(val) {
      this.$emit('pagination', { page: val, limit: this.pageSize })
      if (this.autoScroll) {
        this.scrollTo()
      }
    },
    scrollTo() {
      setTimeout(() => {
        this.$refs.pagination.parentNode.scrollTop = 0
        document.querySelector('.page.container').scrollTop = 0
      }, 200)
    },
  },
}
</script>

<style scoped>
.pagination-container {
  position: sticky;
  bottom: -20px;
  margin-bottom: -20px;
  z-index: 9;
  background: #fff;
  border-top: 1px solid #f8f8f8;
  padding: 15px 5px 20px;
  text-align: right;
}
.pagination-container.hidden {
  display: none;
}
</style>
