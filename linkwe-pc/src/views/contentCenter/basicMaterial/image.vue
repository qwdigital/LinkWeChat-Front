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
      <el-checkbox-group v-model="ids" class="imgStyle">
        <div class="imgItem" v-for="(item, index) in list" :key="index">
          <div class="img" :style="{ 'background-image': 'url(' + item.materialUrl + ')' }">
            <div class="imgstyle">
              <el-checkbox :label="item.id" @change="changeBox"></el-checkbox>
              <div class="iconClass">
                <i
                  class="el-icon-view"
                  @click="$refs.page.detail(item)"
                  v-hasPermi="['wechat:material:detail']"
                ></i>
                <i class="el-icon-edit-outline" @click="$refs.page.edit(item)"></i>
                <i class="el-icon-delete" @click="$refs.page.remove(item.id)"></i>
              </div>
            </div>
          </div>
          <el-tooltip
            :content="item.materialName"
            placement="top"
            :disabled="item.materialName ? item.materialName.length < 9 : true"
          >
            <div class="title">{{ coverContent(item.materialName, 8) }}</div>
          </el-tooltip>
          <div class="content">
            <el-tooltip
              :content="item.updateBy"
              placement="top"
              :disabled="item.updateBy ? item.updateBy.length < 5 : true"
            >
              <span>{{ coverContent(item.updateBy, 4) }}</span></el-tooltip
            >
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
.imgStyle {
  display: flex;
  // justify-content: space-between;
  flex-wrap: wrap;
  .imgItem {
    width: 18%;
    height: 230px;
    margin-bottom: 20px;
    margin-right: 2%;
    border: 1px solid #eaeaea;
    .img {
      width: 100%;
      height: 180px;
      background-repeat: no-repeat;
      background-size: cover;
      background-position: center;
      cursor: pointer;
      .imgstyle {
        display: flex;
        justify-content: space-between;
        padding: 10px 6px 0 6px;
        overflow: hidden;
        .iconClass {
          display: none;
        }
      }
    }
    .img:hover {
      .imgstyle {
        display: flex;
        justify-content: space-between;
        padding: 10px 6px 0 6px;
        overflow: hidden;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        .iconClass {
          width: 30%;
          display: flex;
          justify-content: space-between;
          i {
            font-size: 14px;
            color: #fff;
          }
        }
      }
    }
    .title,
    .content {
      margin-left: 10px;
    }
    .title {
      margin-top: 10px;
      width: 80%;
      overflow: hidden;
      // color: #d7d7d7;
      white-space: nowrap;
      text-overflow: ellipsis;
      font-size: 14px;
      margin-top: 10px;
    }
    .content {
      width: 95%;
      overflow: hidden;
      color: #d7d7d7;
      font-size: 12px;
      margin-top: 4px;
      span:nth-child(1) {
        margin-right: 6px;
      }
    }
  }
}
.emptyStyle {
  width: 100%;
  height: 60px;
  text-align: center;
  line-height: 60px;
  color: #909399;
  font-size: 13px;
}
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
