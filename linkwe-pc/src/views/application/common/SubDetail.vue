<template>
  <div>
    <el-dialog :title="title" :visible.sync="Pvisible" append-to-body :close-on-click-modal="false">
      <template>
        <el-row type="flex" justify="space-between" style="max-height: 500px;">
          <el-col style="margin-top: 0px;">
            <div>
              <el-table :data="list" v-loading="loading">
                <el-table-column label="新客" align="center" prop="inviterUserName" show-overflow-tooltip />
                <el-table-column label="添加员工" align="center" prop="targetName" show-overflow-tooltip />
                <el-table-column label="最近更新时间" align="center" prop="createTime" width="180"></el-table-column>
              </el-table>
              <pagination
                v-show="total > 0"
                :total="total"
                :page.sync="query.pageNum"
                :limit.sync="query.pageSize"
                @pagination="getList"
              />
            </div>
          </el-col>
        </el-row>
        <div slot="footer" style="padding: 10px 0;">
          <el-button @click="Pvisible = false">取 消</el-button>
          <el-button type="primary" @click="Pvisible = false">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>
<script>
  import { getFissionSubTable } from '../taskGroup/api'

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
        default: '新客明细'
      },
      fissionInviterRecordId: {
        type: String,
        default: ''
      }
    },
    data() {
      return {
        loading: true, // 遮罩层
        query: {
          pageNum: 1,
          pageSize: 10
        },
        list: [], // 列表
        total: 0 // 总条数
      }
    },
    watch: {
      fissionInviterRecordId: {
        handler(val) {
          if (val) {
            this.getList(1)
          }
        },
        immediate: true
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
    created() {},
    mounted() {},
    methods: {
      // 获取列表
      getList(page) {
        page && (this.query.pageNum = page)
        this.loading = true
        this.query.fissionInviterRecordId = this.fissionInviterRecordId
        getFissionSubTable(this.query)
          .then(({ rows, total }) => {
            this.list = rows
            this.total = +total
            this.loading = false
          })
          .catch(() => {
            this.loading = false
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
