<script>
import MaPage from '@/views/contentCenter/components/MaPage'
import PicTitContent from '@/views/contentCenter/components/PicTitContent'
import { tsThisType } from '@babel/types'
export default {
  name: 'MImageText',
  components: { MaPage, PicTitContent },
  data() {
    return {
      srcList: [],
      ids: [], // 选中数组
      dialogVisible: false,
      currentType: 0,
      poster: '',
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
    gotoSend(data) {
      console.log(data)
      this.dialogVisible = true
      this.poster = data
    },
    setTypeFn(type) {
      this.currentType = type
    },
    gotoRoute() {
      if (this.currentType == 0) {
        this.$router.push({
          path: '/customerMaintain/groupMessage/record/add',
          query: {
            posterId: this.poster.id,
            chatType: 1,
          },
        })
      } else if (this.currentType == 1) {
        this.$router.push({
          path: '/customerMaintain/groupMessage/record/add',
          query: {
            posterId: this.poster.id,
            chatType: 2,
          },
        })
      } else if (this.currentType == 2) {
        this.$router.push({
          path: '/customerMaintain/friendCircle/publish',
          query: {
            posterId: this.poster.id,
          },
        })
      } else {
        this.$router.push({
          path: '/enterpriseManage/internalCollaborate/appManage',
          query: {
            posterId: this.poster.materialUrl,
          },
        })
      }
    },
  },
}
</script>

<template>
  <div>
    <MaPage ref="page" type="5" @listChange="listChange" :selected="ids" v-slot="{ list }">
      <el-table :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="50" align="center" />
        <el-table-column label="海报" align="center" width="260" prop="materialName">
          <template #default="{ row }">
            <PicTitContent :row="row" />
            <!-- <PicTitContent
            :coverUrl="row.materialUrl"
            :materialName="row.materialName"
            :digest="row.digest"
          /> -->
            <!-- <div class="cp flex aic">
            <el-image
              style="width: 50px; height: 50px; flex: none"
              :src="row.materialUrl"
              fit="fill"
            ></el-image>
            <div class="ml10">
              <p style="text-align: left">{{ row.materialName }}</p>
              <span style="color: var(--font-black-7)">
                {{ coverContent(row.digest) }}
              </span>
            </div>
          </div> -->
          </template>
        </el-table-column>
        <el-table-column prop="tagNames" label="客户标签" align="center" width="">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  客户标签
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>客户查看素材时自动打标签</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <TagEllipsis :list="row.tagNames" emptyText="无标签"></TagEllipsis>
          </template>
        </el-table-column>
        <el-table-column label="海报类型" align="center" prop="materialName">
          <template #default="{ row }">
            {{ row.type === '1' ? '通用海报' : '裂变海报' }}
          </template>
        </el-table-column>

        <el-table-column label="发送总次数" align="center" prop="sendNum" :show-overflow-tooltip="true" width="120px">
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
        <el-table-column label="查看总次数" align="center" prop="viewNum" :show-overflow-tooltip="true" width="120px">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  查看总次数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>当前轨迹素材被客户打开的次数，不去重</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            {{ row.viewNum }}
          </template>
        </el-table-column>
        <el-table-column label="查看总人数" align="center" prop="viewByNum" :show-overflow-tooltip="true" width="120px">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  查看总人数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>当前轨迹素材被客户打开且授权的人数，去重</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            {{ row.viewByNum }}
          </template>
        </el-table-column>
        <el-table-column label="最近更新" align="center" width="160px">
          <template #default="scope">
            <div>{{ scope.row.updateBy }}</div>
            <span>{{ parseTime(scope.row.updateTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="160px" fixed="right">
          <template #default="scope">
            <el-button text @click="$refs.page.detail(scope.row)" v-hasPermi="['wechat:material:detail']">
              详情|统计
            </el-button>
            <el-button text @click="$refs.page.edit(scope.row)">编辑</el-button>
            <el-button text @click="$refs.page.remove(scope.row.id)">删除</el-button>
            <el-button text @click="gotoSend(scope.row)">推广</el-button>
          </template>
        </el-table-column>
      </el-table>
    </MaPage>
    <el-dialog title="推广方式" :close-on-click-modal="false" :show-close="false" v-model="dialogVisible" width="40%">
      <div class="unit">
        <div class="unit-item" :class="{ active_item: currentType == 0 }" @click="setTypeFn(0)">
          <div>
            <img v-if="currentType == 0" class="icon-style" src="@/assets/image/customer_active.png" alt="" />
            <img v-else class="icon-style" src="@/assets/image/customer.png" alt="" />
          </div>
          <div>
            <div class="item-title">群发客户</div>
            <div class="item-text">员工将推广内容一键群发给客户</div>
          </div>
        </div>
        <div class="unit-item" :class="{ active_item: currentType == 1 }" @click="setTypeFn(1)">
          <div>
            <img v-if="currentType == 1" class="icon-style" src="@/assets/image/group_active.png" alt="" />
            <img v-else class="icon-style" src="@/assets/image/group.png" alt="" />
          </div>
          <div>
            <div class="item-title">群发客户群</div>
            <div class="item-text">员工将推广内容一键群发给客户群</div>
          </div>
        </div>
        <div class="unit-item" :class="{ active_item: currentType == 2 }" @click="setTypeFn(2)">
          <div>
            <img v-if="currentType == 2" class="icon-style" src="@/assets/image/friends_active.png" alt="" />
            <img v-else class="icon-style" src="@/assets/image/friends.png" alt="" />
          </div>
          <div>
            <div class="item-title">群发朋友圈</div>
            <div class="item-text">员工将推广内容一键群发到朋友圈</div>
          </div>
        </div>
        <div class="unit-item" :class="{ active_item: currentType == 3 }" @click="setTypeFn(3)">
          <div>
            <img v-if="currentType == 3" class="icon-style" src="@/assets/image/app_active.png" alt="" />
            <img v-else class="icon-style" src="@/assets/image/app.png" alt="" />
          </div>
          <div>
            <div class="item-title">应用消息</div>
            <div class="item-text">员工收到应用消息，选择客户发送</div>
          </div>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="gotoRoute">去推广</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<style lang="scss" scoped>
.unit {
  margin: 0 auto;
  display: flex;
  flex-wrap: wrap;
  width: 580px;
  justify-content: space-between;
  .unit-item {
    width: 280px;
    height: 80px;
    border-width: 1px;
    border-style: solid;
    border-color: rgba(242, 242, 242, 1);
    border-radius: 5px;
    display: flex;
    padding: 17px;
    margin-bottom: 20px;
    cursor: pointer;
    .icon-style {
      margin-right: 10px;
      margin-top: 7px;
      font-size: 22px;
      width: 24px;
      // height: 20px;
    }
    .item-title {
      margin-top: 4px;
      font-size: 16px;
      font-family: Source Han Sans CN-Regular, Source Han Sans CN;
      font-weight: 400;
      color: var(--font-black);
    }
    .item-text {
      margin-top: 6px;
      font-size: 12px;
      color: var(--font-black-7);
      line-height: 24px;
    }
    &:hover {
      border: 1px solid rgba(7, 193, 96, 1);
      background-color: rgba(7, 193, 96, 0.09019607843137255);
    }
  }
  .active_item {
    border: 1px solid rgba(7, 193, 96, 1);
    background-color: rgba(7, 193, 96, 0.09019607843137255);
  }
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
