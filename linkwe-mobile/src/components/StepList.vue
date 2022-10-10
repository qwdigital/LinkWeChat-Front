<template>
  <div>
    <van-pull-refresh v-model="refreshing" success-text="刷新成功" @refresh="getList(1)">
      <van-list
        v-model="loading"
        :finished="finished"
        :finished-text="finishedText"
        :error.sync="error"
        error-text="请求失败，点击重新加载"
        @load="getList()"
      >
        <van-cell v-for="(item, index) in list" :key="index">
          <!-- 时间 -->
          <p class="f12" style="position:relative; ">
            {{ dateFormat(item[0].createTime, 'yyyy-MM-dd w') }}
            <!-- {{item1.trajectoryType}} -->
          </p>
          <!-- <van-cell> -->
          <van-steps
            direction="vertical"
            :inactive-color="color"
            :active-color="color"
            :active="item.length"
          >
            <van-step class="msg" v-for="(item1, index) in item" :key="index">
              <span class="f12 po"> {{ dateFormat(item1.createTime, 'hh:mm') }}</span>
              <span class="fs14">{{ item1.title }}</span>
              <!-- <span class="finish-box">
              <span
                class="finish"
                v-if="item1.trajectoryType == 4 && item1.status != 3"
                @click="finDynamic(item1.id)"
              >
                完成
              </span>
              <span class="deldynamic" @click="delDynamic(item1.id)">删除</span>
            </span> -->

              <p class="fs14 con ">{{ item1.content }}</p>
            </van-step>
            <!-- <van-step>
          <span class="f12 po"> 12:40</span>
          <span class="fs14">社交动态</span>
          <span class="deldynamic">删除</span>
          <p class="fs14 con ">编辑编辑</p>
        </van-step> -->
          </van-steps>
        </van-cell>
      </van-list>
    </van-pull-refresh>
  </div>
</template>

<script>
import { color } from '@/styles/varibles.less'
// import { removeTrajectory, handleWait } from '@/api/portrait'
import { dateFormat } from '@/utils'
export default {
  props: {
    load: Function,
  },
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      content: '',
      type: 0,
      //   轨迹外层按时间
      list: [],
      loading: false,
      finished: false,
      refreshing: false,
      dateFormat,
      color,
    }
  },
  watch: {},
  methods: {
    getList(page) {
      this.loading = true
      this.finished = false
      page && (this.query.pageNum = page)
      if (this.query.pageNum == 1) {
        this.list = []
      }
      if (this.refreshing) {
        this.list = []
        this.refreshing = false
      }

      this.load(this.query)
        .then(({ rows, total }) => {
          rows = rows || []
          let dayList = []
          rows.forEach((ele) => {
            let date = dateFormat(ele.createTime, 'yyyyMMdd')
            dayList.includes(date) || dayList.push(date)
          })
          dayList.sort((a, b) => b - a)
          for (let i = 0; i < dayList.length; i++) {
            let timeList = []
            for (let j = 0; j < rows.length; j++) {
              // console.log(rows[j].createTime);
              if (dayList[i] == dateFormat(rows[j].createTime, 'yyyyMMdd')) {
                timeList.push(rows[j])
              }
            }
            this.list.push(timeList)
          }

          this.loading = false
          this.refreshing = false

          // 判断加载状态
          if (!total || total == 0) {
            this.finishedText = '暂无数据'
            this.finished = true
          } else if (rows.length < this.query.pageSize) {
            this.finishedText = '没有更多了'
            this.finished = true
          } else {
            this.query.pageNum++
          }

          // 数据全部加载完成
          // if (this.list.length >= +total) {
          //   if (this.list.length == 0) {
          //     this.query.pageNum = 1
          //     this.finishedText = '暂无数据'
          //   } else {
          //     this.finishedText = '没有更多了'
          //   }
          //   this.finished = true
          // } else {
          //   this.query.pageNum++
          // }
        })
        .catch((error) => {
          this.loading = false
          this.finished = true
          this.error = true
          alert(error)
        })
    },

    // 删除轨迹
    // delDynamic(id) {
    //   this.$dialog
    //     .confirm({
    //       title: '警告',
    //       message: '确定要删除吗？'
    //     })
    //     .then(() => {
    //       return removeTrajectory(id)
    //     })
    //     .then((data) => {
    //       this.$toast.success('删除成功')
    //       // 重新获取全部数据
    //       this.$emit('reload')
    //     })
    //     .catch(() => {
    //       // on cancel
    //     })
    // },
    // 点击完成
    // finDynamic(id) {
    //   handleWait(id)
    //     .then((data) => {
    //       this.$emit('reload')
    //     })
    //     .catch((err) => {
    //       console.log(err)
    //     })
    // }
  },
}
</script>

<style lang="less" scoped>
.f12 {
  color: #9c9c9c;
  font-size: 12px;
  font-weight: 600;
}
/deep/.msg {
  &::after {
    border: none;
  }
  .po {
    position: relative;
  }
}
.fs14 {
  color: #333;
  font-size: 14px;
  position: relative;
  margin-left: 20px;
}
.con {
  margin-left: 51px;
  margin-top: 20px;
  color: #666;
}
/deep/.van-step__circle {
  width: 8px;
  height: 8px;
  margin-left: 110px;
}
/deep/.van-step__line {
  margin-left: 54px;
  width: 2px;
  transform: scaleX(0.5);
}
.van-step--vertical:not(:last-child)::after {
  border-width: 1px;
}
</style>
