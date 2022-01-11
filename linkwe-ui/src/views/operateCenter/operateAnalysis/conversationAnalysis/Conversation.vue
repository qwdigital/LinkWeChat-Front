<script>
import TabContent from '../components/TabContent'
export default {
  name: '',
  components: { TabContent },
  data() {
    return {
      cardData: [
        {
          title: '开启会话存档员工',
          value: 1222453
        },
        {
          title: '未开启会话存档员工',
          value: 1222453
        },
        {
          title: '今日流失客户',
          value: 1222453
        },
        {
          title: '未同意会话存档客户',
          value: 1222453
        }
      ],
      active: 0
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = Number(total)
          this.loading = false
          this.ids = []
        })
        .catch(() => {
          this.loading = false
        })
    }
  }
}
</script>

<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div>
      <div>数据占比</div>
    </div>

    <div>
      <div>会话存档同意明细</div>
      <el-table :data="data" style="width: 100%">
        <el-table-column align="center" prop="prop" label="存档员工"> </el-table-column>
        <el-table-column align="center" prop="prop" label="客户"> </el-table-column>
        <el-table-column align="center" prop="prop" label="同意时间"> </el-table-column>
      </el-table>
      <el-pagination layout="prev, pager, next" :total="50"> </el-pagination>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
