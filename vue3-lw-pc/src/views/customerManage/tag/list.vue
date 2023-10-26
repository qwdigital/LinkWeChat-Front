<script>
import * as api from '@/api/customer/tag'
import AddTag from '@/components/AddTag'

export default {
  name: 'GroupTag',
  components: { AddTag },
  props: {
    // "标签分组类型(1:客户标签;2:群标签)"
    type: {
      type: String,
      default: '1',
    },
  },
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        groupName: '',
        groupTagType: this.type,
      },
      // 遮罩层
      loading: false,
      dialogVisible: false,
      // 表单参数
      form: {
        groupName: '',
        weTags: [],
      },
      // 添加标签输入框
      newInput: '',
      // 添加标签显隐
      newInputVisible: false,
      // 表单验证规则
      rules: Object.freeze({
        groupName: [{ required: true, message: '必填项', trigger: 'blur' }],
      }),
      // 选中数组
      ids: [],
      // 非多个禁用
      multiple: true,
      // 总条数
      total: 0,
      // 表格数据
      list: [],
      lastSyncTime: 0,
    }
  },
  computed: {},
  created() {
    // this.query.groupTagType = this.type
    this.getList()
  },
  methods: {
    resetQuery() {
      this.query.groupName = ''
      this.getList(1)
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      api
        .getList(this.query)
        .then(({ rows, total, lastSyncTime }) => {
          this.list = rows
          this.total = +total
          this.lastSyncTime = lastSyncTime
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    edit(data, type) {
      this.form = JSON.parse(JSON.stringify(Object.assign({ groupTagType: this.type, weTags: [] }, data || {})))
      this.dialogVisible = true
      console.log(this.dialogVisible)
    },
    syncTag() {
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)',
      })
      api
        .syncTag()
        .then(() => {
          loading.close()
          this.msgSuccess('后台开始同步数据，请稍后关注进度')
          this.getList()
        })
        .catch(() => {
          loading.close()
        })
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.groupId)
      this.multiple = !selection.length
    },
    /** 删除按钮操作 */
    remove(id) {
      const operIds = id || this.ids + ''
      this.$confirm('是否确认删除吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      })
        .then(function () {
          return api.remove(operIds)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
  },
}
</script>
<template>
  <div class="">
    <el-form :model="query" :inline="true" label-width="0" label-position="left" class="top-search">
      <el-form-item label="">
        <el-input v-model="query.groupName" placeholder="请输入标签组名称" clearable @keyup.enter="getList(1)" />
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <div>
          <!-- v-hasPermi="['customerManage:tag:add']" -->
          <el-button type="primary" class="mr10" @click="edit()">新建标签组</el-button>
          <ButtonSync v-if="type == 1" :lastSyncTime="lastSyncTime" @click="syncTag">同步企微标签</ButtonSync>
        </div>
        <div>
          <!-- v-hasPermi="['customerManage:tag:remove']" -->
          <el-button :disabled="!ids.length" type="danger" @click="remove()">批量删除</el-button>
        </div>
      </div>
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="标签组" align="center" prop="groupName" />
        <el-table-column label="标签" align="center" prop="weTags">
          <template #default="{ row }">
            <div v-if="row.weTags">
              <TagEllipsis :list="row.weTags"></TagEllipsis>
            </div>
            <!-- <div v-if="row.weTags">
              <el-popover placement="bottom" trigger="hover" :disabled="row.weTags.length < 3">
                <el-tag v-for="(unit, unique) in row.weTags" :key="unique">
                  {{ unit.name }}
                </el-tag>
                <template #reference>
                  <el-tag v-for="(unit, unique) in row.weTags.slice(0, 2)" :key="unique">
                    {{ unit.name }}
                  </el-tag>
                  <el-tag key="a" v-if="row.weTags.length > 2">...</el-tag>
                </template>
              </el-popover>
            </div>
            <span v-else>无标签</span> -->
          </template>
        </el-table-column>
        <!-- <el-table-column label="创建人" align="center" prop="createBy" /> -->
        <!-- <el-table-column label="创建时间" align="center" prop="operTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.operTime) }}</span>
        </template>
      </el-table-column>-->
        <el-table-column label="操作" align="center">
          <template #default="scope">
            <!-- v-hasPermi="['customerManage:tag:edit']" -->
            <el-button text @click="edit(scope.row, scope.index)">编辑</el-button>
            <el-button text @click="remove(scope.row.groupId)">删除</el-button>
            <!-- v-hasPermi="['customerManage:tag:remove']" -->
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()" />
    </div>

    <!-- 弹窗 -->
    <AddTag v-model:visible="dialogVisible" :form="form" :key="dialogVisible" @success="getList(!form.groupId && 1)" />
  </div>
</template>
<style lang="scss" scoped></style>
