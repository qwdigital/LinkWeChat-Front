<script>
import { getMemberList } from '@/api/group'
import { dateFormat, param2Obj } from '@/utils'
export default {
  name: '',
  components: {},
  data() {
    return {
      refreshing: false,
      loading: false,
      finished: false,
      finishedText: '暂无数据',
      error: false,
      query: {
        pageNum: 1,
        pageSize: 10,
        chatId: 'sdfsdf',
      },
      list: [],
      joinScene: {
        '1': '直接邀请入群',
        '2': '通过邀请链接入群',
        '3': '通过扫描群二维码入群',
      },
      type: {
        '1': '成员',
        '2': '客户',
        '3': '群主',
      },
      dateFormat,
    }
  },
  computed: {},
  watch: {},
  created() {
    let query = this.$route.query
    this.query.chatId =
      process.env.NODE_ENV !== 'development'
        ? query && query.id
        : 'wrbhUTLgAABAQBtMn5Gc0LMxv-h-Xw-A'
    this.getList()
  },
  mounted() {},
  methods: {
    getList(page) {
      this.loading = true
      this.finished = false
      page && (this.query.pageNum = page)
      if (page == 1) {
        this.list = []
      }
      if (this.refreshing) {
        this.list = []
        this.refreshing = false
      }

      getMemberList(this.query)
        .then(({ rows, total }) => {
          this.list.push(...rows)

          this.loading = false
          this.refreshing = false
          // 数据全部加载完成
          if (this.list.length >= +total) {
            if (this.list.length == 0) {
              this.query.pageNum = 1
              this.finishedText = '暂无数据'
            } else {
              this.finishedText = '没有更多了'
            }
            this.finished = true
          } else {
            this.query.pageNum++
          }
        })
        .catch((error) => {
          this.loading = false
          this.finished = true
          this.error = true
          alert(error)
        })
    },
  },
}
</script>

<template>
  <div class="page">
    <van-pull-refresh v-model="refreshing" success-text="刷新成功" @refresh="getList(1)">
      <van-list
        v-model="loading"
        :finished="finished"
        :finished-text="finishedText"
        :error.sync="error"
        error-text="请求失败，点击重新加载"
        @load="getList()"
      >
        <template v-if="list.length">
          <div class="content card flex" v-for="(item, index) in list" :key="index">
            <van-image class="img" :src="item.avatar" />
            <div style="flex: auto;">
              <div class="fxbw aic">
                <div>
                  <span class="name">{{ item.name }}</span>
                  <span
                    :style="{
                      color: item.customerType === 1 ? '#00D695' : '#0079DE',
                    }"
                  >
                    {{ { 1: '@微信', 2: '@企业' }[item.customerType] }}
                  </span>
                </div>

                <div class="label active">{{ type[item.type] }}</div>
              </div>

              <div class="">入群时间：{{ dateFormat(item.joinTime) }}</div>
              <div class="fxbw">
                <div class="">入群方式：{{ joinScene[item.joinScene] }}</div>
                <div class="c9">邀请人：{{ item.invitorUserName }}</div>
              </div>
            </div>
          </div>
        </template>
      </van-list>
    </van-pull-refresh>
  </div>
</template>

<style lang="less" scoped>
.page {
  padding: 0 12px;
  border-top: 9px solid transparent;
  background: #fafafa;
  background-origin: border-box;
}
.card {
  background: #ffffff;
  box-shadow: 0px 2px 6px -3px rgba(0, 0, 0, 0.04);
  border-radius: 8px;
  margin-bottom: 8px;
  padding: 14px;
  font-size: 12px;
  color: #666;
  line-height: 18px;
  .name {
    color: #222;
    font-size: 14px;
    font-weight: 500;
    margin-right: 5px;
  }
  .img {
    width: 52px;
    height: 52px;
    background-color: #f2f2f2;
    margin-right: 10px;
    border-radius: 2px;
    overflow: hidden;
    vertical-align: bottom;
    flex: none;
  }
  .c9 {
    color: #999;
    font-size: 12px;
  }
}
.label {
  display: inline-block;
  min-width: 44px;
  font-size: 12px;
  border-radius: 2px;
  color: #666;
  background: #fafafa;
  text-align: center;
  line-height: 20px;
}
.active {
  background: #ecf5ff;
  color: @color;
}
.van-cell {
  padding: 16px 16px 13px;
}
</style>
