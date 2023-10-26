<template>
  <div>
    <div v-if="dataList.length">
      <el-button
        style="float: right; margin-bottom: 5px"
        type="primary"
        plain
        @click="removeMultFn()"
        :disabled="!deleteList.length">
        批量移除
      </el-button>
      <el-table :data="dataList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="员工名称" align="center" prop="businessName" show-overflow-tooltip />
        <el-table-column label="每日添加上限" align="center" width="150" prop="businessNumber" show-overflow-tooltip>
          <template #default="scope">
            <el-input-number
              v-model="scope.row.businessNumber"
              @change="setChange($event, scope.row.businessId)"
              :min="1"
              :max="100"></el-input-number>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="text" @click="removeFn(row.businessId)">移除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="pageNum" v-model:limit="pageSize" @pagination="pageChange()" />
    </div>
  </div>
</template>

<script>
export default {
  name: 'member-list',
  props: {
    list: {
      type: Array,
      default: () => [],
    },
  },
  watch: {
    list: {
      handler(data) {
        this.setData(data)
      },
      deep: true,
      immediate: true,
    },
  },
  data() {
    return {
      total: 0,
      pageSize: 10,
      pageNum: 1,
      dataList: [],
      initList: [],
      deleteList: [],
    }
  },
  methods: {
    setChange(data, id) {
      this.initList.forEach((dd) => {
        if (dd.businessId == id) {
          dd.businessNumber = data
        }
      })
      this.$emit('update', this.initList)
    },
    pageChange() {
      if (this.initList.length) {
        this.dataList = this.initList.slice((this.pageNum - 1) * this.pageSize, this.pageNum * this.pageSize)
      }
    },
    setData(data) {
      this.initList = data
      this.total = this.initList.length
      this.dataList = this.initList.slice((this.pageNum - 1) * this.pageSize, this.pageNum * this.pageSize)
    },
    removeFn(id) {
      let index = this.initList.findIndex((item) => item.businessId == id)
      if (index !== -1) {
        this.initList.splice(index, 1)
      }
      this.$emit('update', this.initList)
    },
    handleSelectionChange(data) {
      this.deleteList = data
    },
    removeMultFn() {
      this.deleteList.forEach((dd) => {
        let index = this.initList.findIndex((item) => item.businessId == dd.businessId)
        if (index !== -1) {
          this.initList.splice(index, 1)
        }
      })
      this.$emit('update', this.initList)
    },
  },
}
</script>

<style lang="scss" scoped></style>
