<script>
import { getList } from '@/api/drainageCode/staff'

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
      loading: true, // 遮罩层
      query: {
        pageNum: 1,
        pageSize: 10,
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
    selected(val) {
      this.setSelected()
    },
    list(val) {
      this.setSelected()
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
    this.getList()
  },
  mounted() {},
  methods: {
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
    <el-dialog :title="title" :visible.sync="Pvisible" width="750px" append-to-body :close-on-click-modal="false">
      <div>
        <el-form ref="form" :model="query" label-width="">
          <el-form-item label="">
            <el-input
              v-model="query.qrName"
              class="mr10"
              clearable
              style="width: 150px"
              placeholder="请输入活码名称"
              @keydown.enter="getList(1)"></el-input>

            <el-input
              :value="userArray.map((e) => e.name) + ''"
              clearable
              @clear="userArray = []"
              @focus="dialogVisible = true"
              class="mr10"
              style="width: 150px"
              placeholder="请选择员工" />

            <el-button icon="el-icon-search" circle @click="getList(1)"></el-button>

            <el-pagination
              class="fr"
              @current-change="getList"
              :current-page="query.pageNum"
              :page-size="query.pageSize"
              layout="prev, pager, next"
              :total="total"></el-pagination>
          </el-form-item>
        </el-form>
        <el-table :data="list" v-loading="loading">
          <el-table-column width="30">
            <template slot-scope="{ row }">
              <el-radio v-model="radio" :label="row"></el-radio>
            </template>
          </el-table-column>

          <el-table-column prop="name" label="活码名称" align="center"></el-table-column>
          <el-table-column prop="qrCode" label="二维码" align="center" width="130">
            <template #default="{ row }">
              <el-popover placement="bottom" trigger="hover">
                <el-image slot="reference" :src="row.qrCode" class="code-image--small"></el-image>
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
            <template slot-scope="{ row }">
              <div v-for="(unit, key) in row.qrUserInfos" :key="key" style="display: inline">
                <template v-for="(item, index) in unit.weQrUserList">
                  <span :key="index">{{ item.userName + ' ' }}</span>
                </template>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
        </el-table>
      </div>
      <div slot="footer">
        <el-button @click="Pvisible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </div>
      <div style="z-index: 9999999"></div>
    </el-dialog>

    <SelectWeUser
      :visible.sync="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectWeUser>
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
</style>
