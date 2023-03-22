<template>
  <div>
    <el-dialog :title="title" :visible.sync="Pvisible" width="800px" append-to-body :close-on-click-modal="false">
      <template v-if="list.length">
        <el-row type="flex" justify="space-between" style="max-height: 500px;">
          <el-col style="margin-top: 0px;">
            <div>
              <el-form ref="queryForm" :model="query" :inline="true" label-width="">
                <el-form-item label="海报标题" prop="shortLinkName">
                  <el-input clearable v-model="query.title" placeholder="请输入"></el-input>
                </el-form-item>
                <el-form-item label="">
                  <el-button type="primary" @click="getList(1)">查询</el-button>
                  <el-button @click="resetForm()">重置</el-button>
                </el-form-item>
              </el-form>
              <el-table :data="list" v-loading="loading">
                <el-table-column width="30">
                  <template slot-scope="{ row }">
                    <el-radio v-model="radio" :label="row"></el-radio>
                  </template>
                </el-table-column>
                <el-table-column label="素材">
                  <template slot-scope="{ row }">
                    <PicTitle :row="row"></PicTitle>
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
            </div>
          </el-col>
        </el-row>
        <div slot="footer" style="padding: 10px 0;">
          <el-button @click="Pvisible = false">取 消</el-button>
          <el-button type="primary" @click="submit">确 定</el-button>
        </div>
      </template>
      <template v-else>
        <div class="empty">
          <div>
            暂无短链，点击下方按钮立即创建
            <div style="margin-top: 30px;">
              <el-button size="mini" type="primary" @click="$router.push('/content/martial/trackMaterial/list')">
                去新建
              </el-button>
            </div>
          </div>
        </div>
      </template>
    </el-dialog>
  </div>
</template>
<script>
  import { getPosterList } from '../api'
  import PicTitle from '@/views/contentCenter/components/PicTitContent.vue'
  export default {
    components: {
      PicTitle
    },
    props: {
      //显隐
      visible: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: '选择海报'
      },
      selected: {
        type: Array,
        default: () => []
      }
    },
    data() {
      return {
        loading: true, // 遮罩层
        query: {
          pageNum: 1,
          pageSize: 10,
          title: ''
        },
        list: [], // 列表
        total: 0, // 总条数
        radio: '',
        dialogVisible: false
      }
    },
    watch: {
      selected(val) {
        this.setSelected()
      },
      list(val) {
        this.setSelected()
      }
    },
    computed: {
      Pvisible: {
        get() {
          return this.visible
        },
        set(val) {
          this.$emit('update:visible', val)
        }
      }
    },
    created() {
      this.getList()
    },
    mounted() {},
    methods: {
      resetForm() {
        this.$refs['queryForm'].resetFields()
        this.getList(1)
      },
      search() {
        this.query.pageNum = 1
        this.getList()
      },
      // 获取列表
      getList(page) {
        page && (this.query.pageNum = page)
        this.loading = true
        getPosterList(this.query)
          .then(({ rows, total }) => {
            this.list = rows
            this.list.forEach((dd) => {
              dd.coverUrl = dd.materialUrl
            })
            this.total = +total
            this.loading = false
          })
          .catch(() => {
            this.loading = false
          })
      },
      submit() {
        this.Pvisible = false
        this.$emit('success', this.radio)
      },
      setSelected() {
        if (!this.selected.length) return
        this.list.forEach((code) => {
          if (code.id == this.selected[0].id) {
            this.radio = code
          }
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .empty {
    height: 300px;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
  }
</style>
