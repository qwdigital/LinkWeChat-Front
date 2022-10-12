<script>
import * as api from '@/api/commodityCenter/commodityManage'

export default {
  components: {},
  props: {},
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        name: '',
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
        picture: [{ required: true, message: '必填项', trigger: 'change' }],
        groupName: [{ required: true, message: '必填项', trigger: 'blur' }],
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
      this.form = JSON.parse(
        JSON.stringify(Object.assign({ groupTagType: this.type, weTags: [] }, data || {}))
      )
      this.dialogVisible = true
    },
    syncTag() {
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)',
      })
      api
        .sync()
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
        type: 'warning',
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
    <el-form ref="queryForm" :inline="true" :model="query" label-width="100px" class="top-search">
      <el-form-item label="商品名称" prop="name">
        <el-input v-model="query.name" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label=" ">
        <!-- v-hasPermi="['customerManage:customer:query']" -->
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button type="success" @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="mid-action">
      <!-- v-hasPermi="['customerManage:tag:add']" -->
      <el-button type="primary" class="mr10" @click="edit()">新建商品</el-button>
      <!-- v-hasPermi="['customerManage:tag:remove']" -->
      <el-button :disabled="!ids.length" type="danger" @click="remove()">批量删除</el-button>
    </div>

    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />

      <el-table-column label="商品" align="center" prop="groupName">
        <div slot-scope="{ row }" class="toe">
          <el-image style="width: 50px; height: 50px" :src="row.picture"></el-image>
          <span>{{ row.describe }}}</span>
        </div>
      </el-table-column>
      <el-table-column label="单价(元)" align="center" prop="price" />
      <el-table-column label="订单总数" align="center" prop="groupName" />
      <el-table-column label="订单总额(元)" align="center" prop="groupName" />
      <el-table-column label="创建人" align="center" prop="createBy" />
      <el-table-column label="最近操作时间" align="center" prop="operTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.operTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="{ row, index }">
          <!-- v-hasPermi="['customerManage:tag:edit']" -->
          <el-button type="text" @click="goRoute(row, index)">详情</el-button>
          <el-button type="text" @click="edit(row, index)">编辑</el-button>
          <el-button @click="remove(row.groupId)" type="text">删除</el-button>
          <!-- v-hasPermi="['customerManage:tag:remove']" -->
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()"
    />

    <!-- 弹窗 -->
    <el-dialog
      :title="form.id ? '修改' : '新建'"
      :visible.sync="dialogVisible"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form ref="form" :model="form" :rules="rules" label-width="80px">
            <el-form-item label="商品封面" prop="picture">
              <upload :fileUrl.sync="form.picture" type="0">
                <div slot="tip">支持jpg/jpeg/png格式，图片大小不超过20M</div>
              </upload>
            </el-form-item>
            <el-form-item label="商品单价(元)" prop="price">
              <el-input-number
                v-model="form.price"
                :precision="2"
                :step="0.1"
                :min="0"
                :max="50000"
              ></el-input-number>
              <div class="tip">精确到小数点后两位，不超过5万元</div>
            </el-form-item>
            <el-form-item label="商品描述" prop="describe">
              <el-input
                v-model="form.describe"
                type="textarea"
                :maxlength="300"
                show-word-limit
                :autosize="{ minRows: 2, maxRows: 50 }"
                placeholder="请输入"
              ></el-input>
            </el-form-item>

            <el-form-item label="商品详情">
              <upload :fileUrl.sync="form.attachments" type="0">
                <div slot="tip">
                  最多添加八张详情，支持JPG,PNG格式，图片大小不超过2M，建议上传宽高1:1的图片
                </div>
              </upload>
            </el-form-item>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" v-loading="submitLoading" @click="submit">确 定</el-button>
              <el-button @click="dialogVisible = false">取 消</el-button>
            </div>
          </el-form>
        </el-col>
        <el-col :span="12">
          <PhoneTemplate>
            <el-image style="width: 100%; height: 50px" :src="form.picture"></el-image>
            <div class="price">￥{{ form.picture }}</div>
            <div class="content">{{ form.describe }}</div>
            <el-image
              v-for="(item, index) of form.attachments"
              style="width: 100%; height: 50px"
              :src="item.picURL"
              :key="index"
            ></el-image>
          </PhoneTemplate>
        </el-col>
      </el-row>
    </el-dialog>
  </div>
</template>
<style lang="scss" scoped></style>
