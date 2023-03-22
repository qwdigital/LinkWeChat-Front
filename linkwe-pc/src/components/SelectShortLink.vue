<template>
  <div>
    <el-dialog :title="title" :visible.sync="Pvisible" width="800px" append-to-body :close-on-click-modal="false">
      <template v-if="list.length">
        <el-row type="flex" justify="space-between" style="max-height: 500px;">
          <el-col style="margin-top: 0px;">
            <div>
              <el-form ref="queryForm" :model="query" :inline="true" label-width="">
                <el-form-item label="短链名称" prop="shortLinkName">
                  <el-input clearable v-model="query.shortLinkName" placeholder="请输入"></el-input>
                </el-form-item>
                <el-form-item label="类型" prop="type">
                  <el-select clearable v-model="query.type" placeholder="请选择">
                    <el-option
                      v-for="(item, index) in touchTypeDict"
                      :key="index"
                      :label="item.allName"
                      :value="+index"
                    ></el-option>
                  </el-select>
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
                <el-table-column label="短链名称" align="center" prop="shortLinkName" show-overflow-tooltip />
                <el-table-column label="类型" align="center" prop="type">
                  <template slot-scope="{ row }">{{ touchTypeDict[row.type + ''].allName }}</template>
                </el-table-column>
                <el-table-column label="短链地址" align="center" prop="shortLink" show-overflow-tooltip>
                  <template slot-scope="{ row }">
                    <span>{{ row.shortLink }}</span>
                    <i
                      class="el-icon-copy-document copy-btn cp ml20"
                      title="复制"
                      :data-clipboard-text="row.shortLink"
                    ></i>
                  </template>
                </el-table-column>
                <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
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
              <el-button
                size="mini"
                type="primary"
                @click="$router.push('/drainageCode/publicCustomer/IntelligentShortLink/index')"
              >
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
  import { getList } from '@/api/intelligentShortLink'
  import { touchTypeDict } from '@/views/intelligentShortLink/components/mixin'

  export default {
    components: {},
    props: {
      //显隐
      visible: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: '选择短链'
      },
      selected: {
        type: Array,
        default: () => []
      }
    },
    data() {
      return {
        touchTypeDict,
        loading: true, // 遮罩层
        query: {
          pageNum: 1,
          pageSize: 10
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
        getList(this.query)
          .then(({ rows, total }) => {
            this.list = rows
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
  .code-image {
    width: 200px;
    height: 200px;
  }

  .code-image--small {
    width: 50px;
    height: 50px;
  }

  .expire-icon {
    color: red;
  }

  .left {
    margin-right: 16px;
    .title {
      color: var(--color);
      display: flex;
      justify-content: space-between;
      align-items: center;
      .title-name {
        color: rgba(0, 0, 0, 0.9);
        font-size: 16px;
        font-weight: 600;
        // color: #333333;
        display: flex;
        align-items: center;
      }
      .title-btn {
        cursor: pointer;
        display: flex;
        align-items: center;
        font-size: 14px;
        font-weight: normal;
        color: var(--color);
        &:hover {
          opacity: 0.8;
        }
      }
    }

    .item-list {
      max-height: 700px;
      padding-top: 15px;
      display: flex;
      flex-direction: column;
      height: 100%;
      overflow-x: hidden;
      overflow-y: auto;
      .item {
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
        color: rgba(0, 0, 0, 0.6);
        height: 40px;
        line-height: 40px;
        width: 100%;
        padding-left: 20px;
        .name {
          overflow: hidden;
          white-space: nowrap;
          text-overflow: ellipsis;
        }
        .dropdown {
          // display: none;
          .dot {
            cursor: pointer;
            width: 15px;
            height: 15px;
            line-height: 15px;
            font-size: 14px;
            font-family: JMT-Font, JMT;
            font-weight: normal;
            color: rgba(0, 0, 0, 0.6);
            margin-right: 10px;
            margin-left: 5px;
            font-weight: 500;
            .content-icon {
              color: rgba(0, 0, 0, 0.6);
              font-size: 12px;
              transform: rotate(90deg);
            }
          }
        }
        &:hover {
          color: rgba(0, 0, 0, 0.9);
          background: #f5f8fe;
          opacity: 0.8;
          border-radius: 2px;
          .dropdown {
            // display: block;
          }
        }
      }

      .active {
        // border-left: 2px solid var(--color);
        color: rgba(0, 0, 0, 0.9);
        background: #f5f8fe;
        border-radius: 2px;
      }
    }
  }
</style>
