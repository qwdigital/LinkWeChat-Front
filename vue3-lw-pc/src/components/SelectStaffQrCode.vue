<script>
import { getList } from '@/api/drainageCode/staff'
import { getCodeCategoryList } from '@/api/drainageCode/staff'

export default {
  components: {},
  props: {
    // 添加标签显隐
    visible: {
      type: Boolean,
      default: false,
    },
    title: {
      type: String,
      default: '选择员工活码',
    },
    selected: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      groupList: [],
      groupIndex: 0,
      loading: true, // 遮罩层
      query: {
        pageNum: 1,
        pageSize: 10,
        groupId: '',
        // createBy: '',
        // beginTime: '',
        // endTime: ''
        orderByColumn: 'wqc.update_time',
        isAsc: 'desc',
      },
      list: [], // 列表
      userArray: [], //
      total: 0, // 总条数
      radio: '',
      qrUserName: '',
      dialogVisible: false,
    }
  },
  watch: {
    selected: {
      deep: true,
      handler(val) {
        this.setSelected()
      },
    },
    list: {
      deep: true,
      handler(val) {
        this.setSelected()
      },
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
  created() {
    this.getCodeCategoryListFn()
  },
  mounted() {},
  methods: {
    switchGroup(index, data) {
      this.groupIndex = index
      this.query.groupId = data.id
      this.search()
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    getCodeCategoryListFn() {
      getCodeCategoryList({ mediaType: '6' }).then((res) => {
        if (res.code == 200) {
          this.groupList = res.data
          this.query.groupId = this.groupList[0].id
          this.groupIndex = 0
          this.query.pageNum = 1
          this.getList()
        }
      })
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
    getSelectUser(data) {
      this.userArray = data
      this.qrUserName = data.map((e) => e.name) + ''
      this.query.qrUserIds = data.map((e) => e.userId) + ''
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
    },
  },
}
</script>

<template>
  <div>
    <el-dialog :title="title" v-model="Pvisible" width="900px" append-to-body :close-on-click-modal="false">
      <el-row type="flex" justify="space-between">
        <el-col :span="5" class="left pad20" style="border-radius: 4px; background: var(--bg-white)">
          <div class="title">
            <div class="title-name">活码分组</div>
          </div>
          <div class="item-list">
            <div
              class="item"
              :class="{ active: groupIndex == key }"
              v-for="(group, key) in groupList"
              :key="group.id"
              @click="switchGroup(key, group)">
              <!-- <div class="name">{{ group.name + ' (' + group.number + ')' }}</div> -->
              <div class="name">{{ group.name }}</div>
            </div>
          </div>
        </el-col>

        <el-col :span="19" style="margin-top: 0px">
          <div>
            <el-form ref="form" :model="query" label-width="">
              <el-form-item label="">
                <el-input
                  v-model="query.qrName"
                  class="mr10"
                  clearable
                  style="width: 150px"
                  placeholder="请输入活码名称"
                  @keyup.enter="getList(1)"></el-input>

                <el-input
                  :model-value="userArray.map((e) => e.name) + ''"
                  clearable
                  @clear="userArray = []"
                  @click="dialogVisible = true"
                  class="mr10"
                  style="width: 150px"
                  placeholder="请选择员工" />

                <el-button icon="el-icon-search" circle @click="getList(1)"></el-button>
                <!-- <el-pagination
                  class="fr"
                  @current-change="getList"
                  :current-page="query.pageNum"
                  :page-size="query.pageSize"
                  layout="prev, pager, next"
                  :total="total"
                ></el-pagination> -->
              </el-form-item>
            </el-form>
            <el-table :data="list" v-loading="loading">
              <el-table-column width="30">
                <template #default="{ row }">
                  <el-radio v-model="radio" :label="row"></el-radio>
                </template>
              </el-table-column>

              <el-table-column prop="name" label="活码名称" align="center"></el-table-column>
              <el-table-column prop="qrCode" label="二维码" align="center" width="130">
                <template #default="{ row }">
                  <el-popover placement="bottom" trigger="hover">
                    <template #reference><el-image :src="row.qrCode" class="code-image--small"></el-image></template>
                    <el-image :src="row.qrCode" class="code-image"></el-image>
                  </el-popover>
                </template>
              </el-table-column>
              <el-table-column label="标签" align="center">
                <template #default="{ row }">
                  <tag-ellipsis limit="1" :list="row.qrTags"></tag-ellipsis>
                </template>
              </el-table-column>
              <el-table-column label="使用员工" align="center" min-width="140" prop="qrUserInfos" show-overflow-tooltip>
                <template #default="{ row }">
                  <div v-for="(unit, key) in row.qrUserInfos" :key="key" style="display: inline">
                    <template v-for="(item, index) in unit.weQrUserList" :key="index">
                      <span>{{ item.userName + ' ' }}</span>
                    </template>
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
            </el-table>
            <pagination
              v-show="total > 0"
              :total="total"
              v-model:page="query.pageNum"
              v-model:limit="query.pageSize"
              layout="total,prev, pager, next, jumper"
              @pagination="getList()" />
          </div>
        </el-col>
      </el-row>

      <template #footer>
        <div>
          <el-button @click="Pvisible = false">取 消</el-button>
          <el-button type="primary" @click="submit">确 定</el-button>
        </div>
      </template>
      <div style="z-index: 9999999"></div>
    </el-dialog>

    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
  </div>
</template>

<style lang="scss" scoped>
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
