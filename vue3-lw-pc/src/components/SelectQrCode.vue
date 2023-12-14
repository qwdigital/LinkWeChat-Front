<script>
import { getList } from '@/api/drainageCode/group'

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
      default: '选择群活码',
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
        activityName: '',
        tagIds: '',
        // createBy: '',
        // beginTime: '',
        // endTime: ''
      },
      list: [], // 列表
      total: 0, // 总条数
      radio: '',
      tagNames: '',
      showSelectTag: false,
      tagList: [],
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
    this.getList()
  },
  mounted() {},
  methods: {
    getSelectTag(list) {
      this.taglist = list
      let arr = []
      let arr1 = []
      list.forEach((dd) => {
        arr.push(dd.name)
        arr1.push(dd.tagId)
      })
      this.tagNames = arr.join(',')
      this.query.tagIds = arr1.join(',')
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
    },
  },
}
</script>

<template>
  <div>
    <el-dialog :title="title" v-model="Pvisible" width="750px" append-to-body :close-on-click-modal="false">
      <div>
        <el-form ref="form" :model="query" label-width="">
          <el-form-item label="">
            <el-input
              v-model="query.activityName"
              class="mr10"
              style="width: 150px"
              placeholder="请输入名称"
              @keyup.enter="getList(1)"></el-input>
            <el-input
              class="mr10"
              style="width: 150px"
              :model-value="tagNames"
              readonly
              @click="showSelectTag = true"
              placeholder="请选择客群标签" />
            <el-button icon="el-icon-search" circle @click="getList(1)"></el-button>
          </el-form-item>
        </el-form>
        <el-table :data="list" v-loading="loading">
          <el-table-column width="30">
            <template #default="scope">
              <el-radio v-model="radio" :label="scope.row">'</el-radio>
            </template>
          </el-table-column>

          <el-table-column prop="activityName" label="活码名称" align="center"></el-table-column>
          <el-table-column prop="codeUrl" label="二维码" align="center" width="130">
            <template #default="{ row }">
              <el-popover placement="bottom" trigger="hover">
                <template #reference><el-image :src="row.codeUrl" class="code-image--small"></el-image></template>
                <el-image :src="row.codeUrl" class="code-image"></el-image>
              </el-popover>
            </template>
          </el-table-column>
          <el-table-column label="客群标签">
            <template #default="{ row }">
              <tag-ellipsis v-if="row.tags" limit="1" :list="row.tags.split(',')"></tag-ellipsis>
            </template>
          </el-table-column>
          <el-table-column label="活码客群数" align="center" prop="chatGroupNum"></el-table-column>
          <el-table-column prop="chatGroupMemberTotalNum" label="群总人数" align="center"></el-table-column>
        </el-table>
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          layout="total,prev, pager, next, jumper"
          @pagination="getList()" />
      </div>
      <template #footer>
        <div>
          <el-button @click="Pvisible = false">取 消</el-button>
          <el-button type="primary" @click="submit">确 定</el-button>
        </div>
      </template>
      <div style="z-index: 9999999"></div>
    </el-dialog>
    <SelectTag v-model:visible="showSelectTag" type="2" :selected="tagList" @success="getSelectTag"></SelectTag>
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
