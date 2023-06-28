<script>
import MaPage from '@/views/contentCenter/components/MaPage'

export default {
  name: 'Mimage',
  components: { MaPage },
  data() {
    return {
      srcList: [],
      ids: [], // 选中数组
    }
  },
  watch: {},
  created() {},
  methods: {
    changeBox() {
      // console.log(this.ids)
    },
    listChange(data) {
      // this.srcList = data.map((item) => item.materialUrl)
      this.ids = []
    },
    // 超过num个。。。展示
    coverContent(str, num) {
      if (str && str.length > num) {
        str = str.substr(0, num) + '...'
      }
      return str
    },
  },
}
</script>

<template>
  <MaPage ref="page" type="0" :selected="ids" v-slot="{ list }" @listChange="listChange">
    <!-- <el-table :data="list" @selection-change="handleSelectionChange"> -->
    <div v-if="list && list.length">
      <el-checkbox-group v-model="ids" class="list-wrap">
        <div class="list-li" v-for="(item, index) in list" :key="index">
          <div class="img" :style="{ 'background-image': 'url(' + item.materialUrl + ')' }">
            <div class="action-wrap">
              <el-checkbox :label="item.id" @change="changeBox"></el-checkbox>
              <div class="action">
                <el-icon-view
                  class="el-icon-view icon-action"
                  @click="$refs.page.detail(item)"
                  v-hasPermi="['wechat:material:detail']" />
                <el-icon-edit class="el-icon-edit icon-action" @click="$refs.page.edit(item)"></el-icon-edit>
                <el-icon-delete class="el-icon-delete icon-action" @click="$refs.page.remove(item.id)"></el-icon-delete>
              </div>
            </div>
          </div>
          <el-tooltip
            :content="item.materialName"
            placement="top"
            :disabled="item.materialName ? item.materialName.length < 9 : true">
            <div class="title">{{ item.materialName }}</div>
          </el-tooltip>
          <div class="content">
            <el-tooltip
              :content="item.updateBy"
              placement="top"
              :disabled="item.updateBy ? item.updateBy.length < 5 : true">
              <span class="name">{{ coverContent(item.updateBy, 4) }}</span>
            </el-tooltip>
            <span>{{ item.updateTime }}</span>
          </div>
        </div>
      </el-checkbox-group>
    </div>
    <div class="emptyStyle" v-else>
      <span>暂无数据</span>
    </div>
  </MaPage>
</template>

<style lang="scss" scoped>
.el-checkbox {
  width: 20px;
  overflow: hidden;
}
.list-wrap {
  display: grid;
  grid: auto/repeat(5, auto);
  gap: 20px 2%;
  .list-li {
    height: 230px;
    line-height: 1.15;
    border: 1px solid var(--border-black-9);
    border-radius: var(--border-radius);
    overflow: hidden;
    .img {
      width: 100%;
      height: 180px;
      background-repeat: no-repeat;
      background-size: cover;
      background-position: center;
      transition: all 0;
      .action-wrap {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 6px;
        // height: 100%;
        overflow: hidden;
        cursor: pointer;
        .action {
          opacity: 0;
          display: flex;
          width: 30%;
          justify-content: space-between;
          .icon-action {
            font-size: 14px;
            color: var(--font-white, #fff);
          }
        }
      }
    }
    .img:hover {
      .action-wrap {
        background-color: var(--bg-black-5);

        .action {
          opacity: 1;
        }
      }
    }
    .title,
    .content {
      padding: 5px 10px;
    }
    .title {
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      font-size: 14px;
      border-top: 1px solid var(--border-black-9);
    }
    .content {
      width: 95%;
      overflow: hidden;
      color: var(--font-black-7);
      font-size: 13px;
      .name {
        margin-right: 6px;
        color: var(--font-black-6);
      }
    }
  }
}
.emptyStyle {
  width: 100%;
  height: 60px;
  text-align: center;
  line-height: 60px;
  color: var(--font-black-6);
  font-size: 13px;
}
// .img-wrap {
//   position: relative;
//   height: 0;
//   padding: 70% 0 0 0;
//   border-bottom: 1px solid var(--border-black-9);
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
//   color: var(--font-white, #fff);
//   opacity: 0;
//   font-size: 20px;
//   background-color: var(--bg-black-5);
//   transition: opacity 0.3s;
//   .el-icon-EditPen {
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
