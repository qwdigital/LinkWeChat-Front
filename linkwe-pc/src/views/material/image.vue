<script>
import MaPage from '@/views/material/components/MaPage'

export default {
  name: 'Mimage',
  components: { MaPage },
  data() {
    return {
      srcList: [],
      ids: [] // 选中数组
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
    }
  }
}
</script>

<template>
  <MaPage ref="page" type="0" :selected="ids" v-slot="{ list }">
    <el-table :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="图片" align="center" prop="materialUrl" width="150">
        <template slot-scope="{ row }">
          <el-image
            :src="row.materialUrl"
            :preview-src-list="list.map((item) => item.materialUrl)"
            fit="contain"
          ></el-image>
        </template>
      </el-table-column>
      <el-table-column label="图片地址" align="center" prop="materialUrl" />

      <el-table-column label="最近更新时间" align="center" prop="updateTime"> </el-table-column>
      <el-table-column
        label="操作"
        align="center"
        width="100"
        class-name="small-padding fixed-width"
      >
        <template slot-scope="scope">
          <el-button
            type="text"
            @click="$refs.page.edit(scope.row)"
            v-hasPermi="['wechat:material:edit']"
            >修改</el-button
          >
          <el-button
            type="text"
            @click="$refs.page.remove(scope.row.id)"
            v-hasPermi="['wechat:material:remove']"
            >删除</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <!-- <el-row :gutter="20">
      <el-col
        :span="6"
        style="margin-bottom: 24px;min-width: 220px;"
        v-for="(item, index) in list"
        :key="index"
      >
        <el-card shadow="hover" body-style="padding: 0px;">
          <div class="img-wrap">
            <el-image :src="item.materialUrl" :preview-src-list="srcList" fit="contain"></el-image>
            <div class="actions">
              <i
                v-hasPermi="['wechat:material:edit']"
                class="el-icon-edit cp"
                @click="$refs.page.edit(item)"
              ></i>
              <i
                v-hasPermi="['wechat:material:remove']"
                class="el-icon-delete cp"
                @click="$refs.page.remove(item.id)"
              ></i>
            </div>
          </div>
          <div style="margin: 14px;overflow: hidden;">
            <el-checkbox v-model="ids" :label="item.id">{{ item.materialName }}</el-checkbox>
          </div>
        </el-card>
      </el-col>
    </el-row> -->
  </MaPage>
</template>

<style lang="scss" scoped>
// .img-wrap {
//   position: relative;
//   height: 0;
//   padding: 70% 0 0 0;
//   border-bottom: 1px solid #e6ebf5;
//   &:hover .actions {
//     opacity: 1;
//   }
// }
// .actions {
//   position: absolute;
//   width: 100%;
//   height: 50px;
//   left: 0;
//   top: 0;
//   text-align: center;
//   color: #fff;
//   opacity: 0;
//   font-size: 20px;
//   background-color: rgba(0, 0, 0, 0.5);
//   transition: opacity 0.3s;
//   .el-icon-edit {
//     margin-right: 20px;
//   }
// }
// .el-image {
//   position: absolute;
//   width: 100%;
//   height: 100%;
//   top: 0;
// }
</style>
