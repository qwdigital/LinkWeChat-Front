<template>
  <div>
    <template v-if="list.length">
      <el-table :data="list">
        <el-table-column label="短链名称" align="center" prop="shortLinkName" show-overflow-tooltip />
        <el-table-column label="类型" align="center" prop="type">
          <template slot-scope="{ row }">{{ touchTypeDict[row.type + ''].allName }}</template>
        </el-table-column>
        <el-table-column label="短链地址" align="center" prop="shortLink" width="350" show-overflow-tooltip>
          <template slot-scope="{ row }">
            <span>{{ row.shortLink }}</span>
            <i class="el-icon-copy-document copy-btn cp ml20" title="复制" :data-clipboard-text="row.shortLink"></i>
          </template>
        </el-table-column>
        <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
      </el-table>
    </template>
  </div>
</template>
<script>
  import { touchTypeDict } from '@/views/intelligentShortLink/components/mixin'
  export default {
    components: {},
    props: {
      data: {
        type: Array,
        default: () => []
      }
    },
    data() {
      return {
        touchTypeDict,
        list: [] // 列表
      }
    },
    watch: {
      data: {
        handler(newVal) {
          this.list = newVal
        },
        deep: true,
        immediate: true
      }
    },
    computed: {},
    created() {},
    mounted() {
      this.clipboard = new this.ClipboardJS('.copy-btn')
    },
    methods: {}
  }
</script>

<style lang="scss" scoped></style>
