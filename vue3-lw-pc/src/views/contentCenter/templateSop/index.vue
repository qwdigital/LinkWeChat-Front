<script>
import TalkMaPage from '@/views/contentCenter/components/TalkMaPage'
import ScriptMaterial from '@/components/ContentCenter/ScriptMaterial'
export default {
  name: 'service-script',
  components: { TalkMaPage, ScriptMaterial },
  data() {
    return {
      srcList: [],
      ids: [], // 选中数组
      dialogVisible: false,
      obj: {},
    }
  },
  watch: {},
  created() {},
  methods: {
    listChange(data) {
      this.srcList = data.map((item) => item.materialUrl)
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    // 超过50个。。。展示
    coverContent(str) {
      if (str && str.length > 50) {
        str = str.substr(0, 50) + '...'
      }
      return str
    },
    // visibleChange(val) {
    //   this.dialogVisible = val
    // }
  },
}
</script>

<template>
  <!-- 群发模板 -->
  <TalkMaPage ref="page" type="16" @listChange="listChange" :selected="ids" v-slot="{ list }">
    <el-table :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="群发内容" align="center" prop="materialName" :show-overflow-tooltip="true">
        <template #default="{ row }">
          {{ row.talkTitle }}
        </template>
      </el-table-column>
      <el-table-column label="附件数量" align="center" prop="materialName">
        <template #default="{ row }">
          <div class="scriptNum">
            {{ row.materialNum }}
          </div>
        </template>
      </el-table-column>
      <el-table-column label="最近更新" align="center">
        <template #default="scope">
          <div>{{ scope.row.updateBy }}</div>
          <span>{{ parseTime(scope.row.updateTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="scope">
          <el-button text @click="dialogVisible = true" v-hasPermi="['wechat:material:detail']">预览</el-button>
          <el-button text @click="$refs.page.edit(scope.row.id, 17)">编辑</el-button>
          <el-button text @click="$refs.page.remove(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 点击预览按钮 -->
  </TalkMaPage>
</template>

<style lang="scss" scoped>
.scriptNum {
  font-size: 14px;
  color: var(--color);
  cursor: pointer;
}

.img-wrap {
  position: relative;
  height: 0;
  padding: 70% 0 0 0;
  border-bottom: 1px solid var(--border-black-9);
  &:hover .actions {
    opacity: 1;
  }
}
.actions {
  position: absolute;
  width: 100%;
  height: 50px;
  left: 0;
  top: 0;
  text-align: center;
  color: var(--font-white, #fff);
  opacity: 0;
  font-size: 20px;
  background-color: var(--bg-black-5);
  transition: opacity 0.3s;
  .el-icon-EditPen {
    margin-right: 20px;
  }
}
.el-image {
  width: 80px;
  height: 80px;
}
</style>
