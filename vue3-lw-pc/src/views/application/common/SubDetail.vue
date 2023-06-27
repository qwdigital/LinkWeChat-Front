<template>
  <div>
    <el-dialog :title="title" v-model="Pvisible" append-to-body :close-on-click-modal="false">
      <el-row justify="space-between" style="max-height: 500px">
        <el-col style="margin-top: 0px">
          <div>
            <el-table :data="list" v-loading="loading">
              <el-table-column label="新客" align="center" prop="inviterUserName" show-overflow-tooltip />
              <el-table-column
                :label="fissionType == 'customer' ? '添加员工' : '添加客群'"
                align="center"
                prop="targetName"
                show-overflow-tooltip />
              <el-table-column label="最近更新时间" align="center" prop="createTime" width="180"></el-table-column>
            </el-table>
            <pagination
              v-show="total > 0"
              :total="total"
              v-model:page="query.pageNum"
              v-model:limit="query.pageSize"
              @pagination="getList" />
          </div>
        </el-col>
      </el-row>
      <template #footer>
        <div style="padding: 10px 0">
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
    fissionType: {
      type: String,
      default: 'customer',
    },
    //显隐
    visible: {
      type: Boolean,
      default: false,
    },
    title: {
      type: String,
      default: '新客明细',
    },
    fissionInviterRecordId: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      loading: true, // 遮罩层
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      list: [], // 列表
      total: 0, // 总条数
    }
  },
  watch: {
    fissionInviterRecordId: {
      handler(val) {
        if (val) {
          this.getList(1)
        }
      },
      immediate: true,
    },
  },
  computed: {
    Pvisible: {
      get() {
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
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
    },
  },
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
      color: var(--font-black);
      font-size: 16px;
      font-weight: 600;
      // color: var(--font-black);
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
      color: var(--font-black-5);
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
          color: var(--font-black-5);
          margin-right: 10px;
          margin-left: 5px;
          font-weight: 500;
          .content-icon {
            color: var(--font-black-5);
            font-size: 12px;
            transform: rotate(90deg);
          }
        }
      }
      &:hover {
        color: var(--font-black);
        background: var(--bg-black-11);
        opacity: 0.8;
        border-radius: 2px;
        .dropdown {
          // display: block;
        }
      }
    }

    .active {
      // border-left: 2px solid var(--color);
      color: var(--font-black);
      background: var(--bg-black-11);
      border-radius: 2px;
    }
  }
}
</style>
