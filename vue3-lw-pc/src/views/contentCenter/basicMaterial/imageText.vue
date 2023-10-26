<script>
import MaPage from '@/views/contentCenter/components/MaPage'
import PicTitContent from '@/views/contentCenter/components/PicTitContent'
export default {
  name: 'MImageText',
  components: { MaPage, PicTitContent },
  data() {
    return {
      srcList: [],
      ids: [], // 选中数组
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
  },
}
</script>

<template>
  <MaPage ref="page" type="9" @listChange="listChange" :selected="ids" v-slot="{ list }">
    <el-table :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="图文" align="center" prop="materialName" width="260">
        <template #default="{ row }">
          <PicTitContent :row="row" />
        </template>
      </el-table-column>
      <el-table-column label="发送总次数" align="center" prop="sendNum" :show-overflow-tooltip="true">
        <template #header>
          <el-popover placement="top" trigger="hover">
            <template #reference>
              <div>
                发送总次数
                <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
              </div>
            </template>
            <div>当前素材在侧边栏被员工发送的总次数</div>
          </el-popover>
        </template>
        <template #default="{ row }">
          {{ row.sendNum }}
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
          <el-button text @click="$refs.page.detail(scope.row)" v-hasPermi="['wechat:material:detail']">
            详情|统计
          </el-button>
          <el-button text @click="$refs.page.edit(scope.row)">编辑</el-button>
          <el-button text @click="$refs.page.remove(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </MaPage>
</template>

<style lang="scss" scoped>
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
