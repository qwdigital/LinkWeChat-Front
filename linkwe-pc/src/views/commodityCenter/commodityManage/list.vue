<script>
  import * as api from '@/api/commodityCenter/commodityManage'

  const defaultForm = {
    picture: '',
    price: 1,
    describe: '',
    attachments: []
  }

  export default {
    components: {},
    props: {},
    data() {
      return {
        query: {
          pageNum: 1,
          pageSize: 10,
          name: ''
        },
        loading: false,
        submitLoading: false,
        dialogVisible: false,
        form: JSON.parse(JSON.stringify(defaultForm)),
        newInput: '',
        newInputVisible: false,
        rules: Object.freeze({
          picture: [{ required: true, message: '必填项', trigger: 'change' }],
          price: [{ required: true, message: '必填项', trigger: 'change' }],
          describe: [{ required: true, message: '必填项', trigger: 'blur' }]
        }),
        // 选中数组
        ids: [],
        multiple: true,
        total: 0,
        list: [],
        lastSyncTime: 0,
        fileList: []
      }
    },
    computed: {},
    created() {
      this.$store.dispatch(
        'app/setBusininessDesc',
        `
			     <div>快捷创建商品图册，员工一键发送给客户，客户直接购买。</div>
			   `
      )
      this.getList()
    },
    methods: {
      resetForm() {
        this.query.name = ''
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
      edit(data) {
        this.fileList = []
        if (data) {
          api.getDetail(data.id).then((res) => {
            this.form = res.data
            if (this.form.attachments) {
              let arr = this.form.attachments.split(',')
              arr.forEach((dd) => {
                this.fileList.push({ url: dd })
              })
            }
          })
        } else {
          this.form = JSON.parse(JSON.stringify(defaultForm))
        }
        this.dialogVisible = true
      },
      sync() {
        const loading = this.$loading({
          lock: true,
          text: 'Loading',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
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
      submit() {
        this.$refs['form'].validate((valid) => {
          let form = JSON.parse(JSON.stringify(this.form))
          form.price = form.price.toFixed(2)
          form.attachments = this.fileList.map((dd) => dd.url).join(',')
          this.submitLoading = true
          api[form.id ? 'update' : 'add'](form, form.id)
            .then(() => {
              this.msgSuccess('操作成功')
              this.dialogVisible = false
              this.getList()
            })
            .finally(() => {
              this.submitLoading = false
            })
        })
      },
      // 多选框选中数据
      handleSelectionChange(selection) {
        this.ids = selection.map((item) => item.id)
        this.multiple = !selection.length
      },
      /** 删除按钮操作 */
      remove(id) {
        const operIds = id || this.ids + ''
        this.$confirm('是否确认删除吗?', '警告', {
          type: 'warning'
        })
          .then(function () {
            return api.remove(operIds)
          })
          .then(() => {
            this.getList()
            this.msgSuccess('删除成功')
          })
      },
      goRoute(row) {
        this.$router.push({
          path: './detail',
          query: {
            id: row.id
          }
        })
      }
    }
  }
</script>
<template>
  <div class="g-card g-pad20">
    <el-form ref="queryForm" :inline="true" :model="query" label-width="110px" class="top-search">
      <el-form-item label="商品名称或描述" prop="name">
        <el-input clearable v-model="query.name" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label=" ">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button type="success" @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="mid-action">
      <el-button type="primary" class="mr10" @click="edit()">新建商品</el-button>
      <el-button :disabled="!ids.length" type="danger" @click="remove()">批量删除</el-button>
    </div>

    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="商品" align="center" prop="" width="200">
        <div slot-scope="{ row }">
          <div style="display: flex;">
            <el-image
              style="width: 50px; height: 50px; margin-right: 5px; flex-shrink: 0;"
              :src="row.picture"
            ></el-image>
            <span class="limit_span">{{ row.describe }}</span>
          </div>
        </div>
      </el-table-column>
      <el-table-column label="单价(元)" align="center" prop="price" />
      <el-table-column label="订单总数" align="center" prop="orderNum" />
      <el-table-column label="订单总额(元)" align="center" prop="orderTotalAmount" />
      <el-table-column label="创建人" align="center" prop="createBy" />
      <el-table-column label="最近操作时间" align="center" prop="updateTime" width="180"> </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="{ row, index }">
          <el-button type="text" @click="goRoute(row)">详情</el-button>
          <el-button type="text" @click="edit(row, index)">编辑</el-button>
          <el-button type="text" @click="remove(row.id)">删除</el-button>
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
      width="800px"
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form ref="form" :model="form" :rules="rules" label-width="100px">
            <el-form-item label="商品封面" prop="picture">
              <upload :fileUrl.sync="form.picture" type="0" :maxSize="10" :format="['jpg', 'png']">
                <div slot="tip" class="tip">支持jpg/png格式，图片大小不超过10M</div>
              </upload>
            </el-form-item>
            <el-form-item label="商品单价(元)" prop="price">
              <el-input-number v-model="form.price" :precision="2" :step="0.1" :min="0" :max="50000"></el-input-number>
              <div class="tip">精确到小数点后两位，不超过5万元</div>
            </el-form-item>
            <el-form-item label="商品标题或描述" prop="describe">
              <el-input
                v-model="form.describe"
                type="textarea"
                :maxlength="270"
                show-word-limit
                :autosize="{ minRows: 4, maxRows: 50 }"
                placeholder="请输入"
              ></el-input>
            </el-form-item>
            <el-form-item label="商品详情">
              <upload
                :fileList.sync="fileList"
                :multiple="true"
                :limit="8"
                type="0"
                :maxSize="10"
                :format="['jpg', 'png']"
              >
                <div slot="tip" class="tip">最多添加八张详情</div>
              </upload>
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="12">
          <PhoneTemplate>
            <div class="phone-content">
              <el-image
                v-if="form.picture"
                class="commodity-img commodity-thumb"
                style="width: 100%;"
                :src="form.picture"
              ></el-image>
              <div v-else class="commodity-img commodity-thumb"></div>
              <div class="price">￥{{ form.price }}</div>
              <div class="content">{{ form.describe }}</div>
              <el-image v-for="(item, index) in fileList" class="commodity-img" :src="item.url" :key="index"></el-image>
            </div>
          </PhoneTemplate>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer ar">
        <el-button type="primary" v-loading="submitLoading" @click="submit">确 定</el-button>
        <el-button @click="dialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<style lang="scss" scoped>
  .tip {
    color: #aaa;
    font-size: 12px;
    line-height: 20px;
  }
  .phone-content {
    padding: 10px;
  }
  .price {
    font-weight: 500;
    font-size: 20px;
    margin: 10px 0;
  }
  .content {
    margin: 10px 0;
  }
  .commodity-img {
    width: 100%;
  }
  .limit_span {
    // width: 250px;
    // overflow: hidden;
    // text-overflow: ellipsis;
    // // white-space: nowrap;
    // display: inline-block;

    white-space: pre-wrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
</style>
