<template>
  <div class="dynamics">
    <div class="dynamics-content" v-infinite-scroll="load">
      <div class="dynamics-item" v-for="(item, index) in dynamicsOutList" :key="index">
        <div class="dynamics-left">
          <div class="top">
            <span :class="item.operatorType === 1 ? 'customer' : 'staff'">
              {{ item.operatorType === 1 ? '客户' : '员工' }}
            </span>
            <span>{{ item.operatorName }}</span>
          </div>
          <div class="bottom">
            <span
              :class="
                item.action === '删除员工' || item.action === '解散群聊' || item.action === '退出群聊'
                  ? 'unnomal'
                  : 'nomal'
              ">
              {{ item.action }}&nbsp;&nbsp;
            </span>
            <span>{{ item.operatoredObjectName }}</span>
          </div>
        </div>
        <div class="dynamics-right">
          <span>{{ item.trajectoryType === 1 ? '客户动态' : item.trajectoryType === 5 ? '客群动态' : '' }}</span>
          <span>{{ item.createTime }}</span>
        </div>
      </div>
      <div v-if="finished" class="ac">暂无更多数据</div>
    </div>
  </div>
</template>

<script>
import { getCompanyDynamicsData } from '@/api/index'
export default {
  data() {
    return {
      loading: false,
      finished: false,
      dynamicsFrom: {
        trajectoryType: '',
        pageSize: 10,
        pageNum: 1,
      },
      dynamicsOutList: [],
      total: 0,
      isLoad: false,
    }
  },
  methods: {
    // tabClick(i) {
    //   this.activeIndex = i;
    //   this.isLoad = true;
    //   if (i === 0) {
    //     this.dynamicsFrom.trajectoryType = "";
    //   } else {
    //     this.dynamicsFrom.trajectoryType = i;
    //   }
    //   this.getDynamicsData(1);
    // },
    load() {
      if (this.total > this.dynamicsOutList.length) {
        this.dynamicsFrom.pageNum++
        this.getDynamicsData()
      } else if (this.total < this.dynamicsOutList.length) {
        this.finished = true
      }
    },
    // 获取企业轨迹
    getDynamicsData(page) {
      page && (this.dynamicsFrom.pageNum = page)
      this.loading = true
      this.finished = false
      getCompanyDynamicsData(this.dynamicsFrom).then((res) => {
        if (res.code === 200) {
          if (this.dynamicsFrom.pageNum > 1) {
            this.dynamicsOutList = [...this.dynamicsOutList, ...res.rows]
          } else {
            this.dynamicsOutList = res.rows
          }
          this.total = Number(res.total)
          this.dynamicsOutList.forEach((item) => {
            item.operatoredObjectType =
              item.operatoredObjectType === 1 ? '客户' : item.operatoredObjectType === 2 ? '员工' : '客群'
          })
          if (this.total <= this.dynamicsOutList.length) {
            this.finished = true
          }
        }
        this.loading = false
        this.isLoad = false
      })
    },
  },
  mounted() {
    this.getDynamicsData()
  },
  created() {
    // this.dynamicsFrom.dataScope = this.$route.query.dataScope;
  },
}
</script>

<style lang="scss" scoped>
.dynamics {
  width: 100%;
  max-height: 60vh;
  margin: 0;
  background: var(--bg-black-11);
  .dynamics-content {
    width: 100%;
    background: var(--bg-white);
    box-shadow: 0px 2px 6px -3px rgba(0, 0, 0, 0.04);
    border-radius: 8px 8px 8px 8px;
    padding: 20px 16px;
    margin-top: 12px;
    .dynamics-item {
      border-bottom: 1px solid var(--border-black-10);
      display: flex;
      justify-content: space-between;
      padding-bottom: 9px;
      margin-bottom: 15px;
      .dynamics-left {
        .top {
          margin-bottom: 7px;
          span:nth-child(1) {
            display: inline-block;
            max-width: 80px;
            padding: 0 2px;
            // height: 18px;
            border-radius: 3px 3px 3px 3px;
            font-size: 10px;
            line-height: 18px;
            text-align: center;
            margin-right: 8px;
          }
          .customer {
            background: var(--color-light-10);
            color: var(--color);
          }
          .staff {
            background: var(--color-light-9);
            color: #00d695;
          }
          span:nth-child(2) {
            font-size: 14px;
            font-family: 'PingFang SC-粗体', 'PingFang SC';
            color: var(--font-black);
            line-height: 20px;
            font-weight: 600;
          }
        }
        .bottom {
          span {
            font-size: 12px;
            font-family: 'PingFang SC-中等', 'PingFang SC';
            font-weight: normal;
            color: var(--font-black-4);
            line-height: 17px;
          }
          .nomal {
            color: var(--color);
          }
          .unnomal {
            color: #e34d59;
          }
        }
      }
      .dynamics-right {
        display: flex;
        flex-direction: column;
        text-align: right;
        span {
          font-size: 12px;
          font-family: 'PingFang SC-中等', 'PingFang SC';
          font-weight: normal;
          line-height: 17px;
        }
        span:nth-child(1) {
          color: var(--font-black-4);
          margin-bottom: 9px;
        }
        span:nth-child(2) {
          color: var(--font-black-6);
        }
      }
    }
  }
}
</style>
