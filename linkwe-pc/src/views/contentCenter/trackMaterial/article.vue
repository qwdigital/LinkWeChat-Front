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
  <MaPage ref="page" type="12" @listChange="listChange" :selected="ids" v-slot="{ list }">
    <el-table :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="文章" align="center" prop="materialName" width="260">
        <template slot-scope="{ row }">
          <PicTitContent :row="row" />
        </template>
      </el-table-column>
      <el-table-column
        label="发送总次数"
        align="center"
        prop="sendNum"
        :show-overflow-tooltip="true"
      >
        <template slot="header">
          <el-popover placement="top" trigger="hover">
            <div slot="reference">
              发送总次数
              <i class="el-icon-question"></i>
            </div>
            <div>当前素材在侧边栏被员工发送的总次数</div>
          </el-popover>
        </template>
        <template #default="{ row }">
          {{ row.sendNum }}
        </template>
      </el-table-column>
      <el-table-column
        label="查看总次数"
        align="center"
        prop="viewNum"
        :show-overflow-tooltip="true"
      >
        <template slot="header">
          <el-popover placement="top" trigger="hover">
            <div slot="reference">
              查看总次数
              <i class="el-icon-question"></i>
            </div>
            <div>当前轨迹素材被客户打开的次数，不去重</div>
          </el-popover>
        </template>
        <template #default="{ row }">
          {{ row.viewNum }}
        </template>
      </el-table-column>
      <el-table-column
        label="查看总人数"
        align="center"
        prop="viewByNum"
        :show-overflow-tooltip="true"
      >
        <template slot="header">
          <el-popover placement="top" trigger="hover">
            <div slot="reference">
              查看总人数
              <i class="el-icon-question"></i>
            </div>
            <div>当前轨迹素材被客户打开且授权的人数，去重</div>
          </el-popover>
        </template>
        <template #default="{ row }">
          {{ row.viewByNum }}
        </template>
      </el-table-column>
      <el-table-column label="最近更新" width="160px" align="center">
        <template slot-scope="scope">
          <div>{{ scope.row.updateBy }}</div>
          <span>{{ parseTime(scope.row.updateTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column
        label="操作"
        align="center"
        width="160px"
        class-name="small-padding fixed-width"
      >
        <template slot-scope="scope">
          <el-button
            type="text"
            @click="$refs.page.detail(scope.row)"
            v-hasPermi="['wechat:material:detail']"
            >详情|统计</el-button
          >
          <el-button type="text" @click="$refs.page.edit(scope.row, 12)">编辑</el-button>
          <el-button type="text" @click="$refs.page.remove(scope.row.id)">删除</el-button>
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
  border-bottom: 1px solid #e6ebf5;
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
  color: #fff;
  opacity: 0;
  font-size: 20px;
  background-color: rgba(0, 0, 0, 0.5);
  transition: opacity 0.3s;
  .el-icon-edit {
    margin-right: 20px;
  }
}
.el-image {
  width: 80px;
  height: 80px;
}
</style>
