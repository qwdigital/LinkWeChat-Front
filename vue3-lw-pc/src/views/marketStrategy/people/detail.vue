<template>
  <div>
    <div class="head_content">
      <div class="g-card" style="flex: 1">
        <div class="card-top">
          <span style="margin-right: 6px">{{ detail.name }}</span>
          <div
            class="status_button"
            :class="{
              color1: detail.status === 1,
              color2: detail.status === 2,
              color3: detail.status === 3,
              color4: detail.status === 4,
            }">
            {{
              detail.status === 1
                ? '待计算'
                : detail.status === 2
                ? '计算中'
                : detail.status === 3
                ? '计算完成'
                : detail.status === 4
                ? '计算失败'
                : ''
            }}
          </div>
        </div>
        <div class="card-bottom">
          <div>
            <span class="title">人群分组：</span>
            <span class="content">{{ groupName }}</span>
            <span class="title" style="margin-left: 16px">更新方式：</span>
            <span class="content">{{ detail.type === 1 ? '手动更新' : '自动更新' }}</span>
          </div>
        </div>
      </div>
      <div class="g-card" style="margin-left: 20px; width: 180px; margin-top: 0; text-align: center">
        <div class="content_number">
          {{ detail.crowdNum ? detail.crowdNum : '-' }}
        </div>
        <div class="content_sub">
          人群规模
          <el-popover placement="top" trigger="hover">
            <div slot="reference" style="margin-left: 8px; cursor: pointer">
              <img src="../../../assets/marketstrategy/help.svg" alt="" />
            </div>
            <div>为上一次人群计算成功的数量，非实时数据，可手动更新</div>
          </el-popover>
        </div>
      </div>
    </div>

    <div class="card-tab">
      <div class="item" :class="activeIndex === 0 ? 'active' : ''" @click="activeIndex = 0">人群筛选</div>
      <div class="item" :class="activeIndex === 1 ? 'active' : ''" @click="activeIndex = 1">人群分析</div>
      <div class="item" :class="activeIndex === 2 ? 'active' : ''" @click="activeIndex = 2">人群明细</div>
    </div>
    <div style="margin-top: 10px">
      <template v-if="activeIndex === 0">
        <people-filter :swipe="detail.swipe"></people-filter>
      </template>
      <template v-if="activeIndex === 1">
        <people-analyse></people-analyse>
      </template>
      <template v-if="activeIndex === 2">
        <people-customer-detail></people-customer-detail>
      </template>
    </div>
  </div>
</template>

<script>
import { detail } from '@/api/marketStrategy/people'
import { getCodeCategoryList } from '@/api/drainageCode/staff'
import PeopleFilter from '../components/PeopleFilter'
import PeopleAnalyse from '../components/PeopleAnalyse'
import PeopleCustomerDetail from '../components/PeopleCustomerDetail'
export default {
  components: {},
  name: 'people-detail',
  data() {
    return {
      activeIndex: 0,
      detail: {
        crowdNum: null,
        groupId: '',
        name: '',
        status: null,
        swipe: [],
        type: null,
      },
      groupList: [],
      groupName: '',
    }
  },
  components: {
    PeopleFilter,
    PeopleAnalyse,
    PeopleCustomerDetail,
  },
  methods: {
    getDetailFn(id) {
      detail(id).then((res) => {
        if (res.code === 200) {
          this.detail = res.data
          this.getCodeCategoryListFn(this.detail.groupId)
        }
      })
    },
    getCodeCategoryListFn(id) {
      getCodeCategoryList({ mediaType: 7 }).then((res) => {
        if (res.code == 200) {
          this.groupList = res.data
          this.groupList.forEach((dd) => {
            if (dd.id === id) {
              this.groupName = dd.name
            }
          })
        }
      })
    },
  },
  mounted() {},
  created() {
    let id = this.$route.query.id
    this.getDetailFn(id)
  },
}
</script>

<style lang="scss" scoped>
.status_button {
  height: 24px;
  line-height: 24px;
  font-size: 12px;
  color: #ffffff;
  padding: 0 8px;
  border-radius: 3px;
}
.color1 {
  background: #0079de;
}
.color2 {
  background: #fa7216;
}
.color3 {
  background: #00d695;
}
.color4 {
  background: #e34d59;
}

.head_content {
  width: 100%;
  display: flex;
  justify-content: space-between;
}
.active {
  font-weight: 600;
  color: #0079de !important;
  background-color: #fff !important;
  box-shadow: 0px 6px 30px 5px rgba(59, 59, 59, 0.05);
}

.card-top {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  span {
    font-size: 16px;
    font-weight: 600;
    color: rgba(0, 0, 0, 0.9);
    line-height: 28px;
  }
}

.card-bottom {
  display: flex;
  justify-content: space-between;
  span {
    font-size: 14px;
    color: #000;
    line-height: 22px;
  }
  .title {
    opacity: 0.9;
  }
  .content {
    opacity: 0.6;
  }
}

.card-tab {
  margin-top: 10px;
  display: flex;
  div {
    width: 88px;
    height: 30px;
    background: #fafafa;
    border-radius: 32px 32px 32px 32px;
    font-size: 14px;
    color: rgba(0, 0, 0, 0.4);
    line-height: 30px;
    text-align: center;
    margin-top: 15px;
    margin-right: 12px;
    margin-bottom: 6px;
  }
  .item:hover {
    cursor: pointer;
    opacity: 0.8;
  }
}

.card-content {
  height: 59vh;
}
.content_number {
  font-size: 28px;
  font-weight: bold;
  color: #0079de;
  margin-bottom: 15px;
}
.content_sub {
  display: flex;
  justify-content: center;
  font-size: 14px;
  color: #000;
  opacity: 0.6;
}
</style>
