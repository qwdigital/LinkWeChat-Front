<template>
  <div>
    <van-tabs v-model="active">
      <van-tab :title="'待添加（' + total + '）'">
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="getData">
          <van-cell>
            <template v-for="(unit, key) in list">
              <div class="content" :key="key">
                <div>{{ unit.phone }}</div>
                <div>
                  {{ unit.customerName }}
                </div>
                <div>
                  <van-button plain round type="info" @click="copyFn($event, unit.phone)">复制</van-button>
                </div>
              </div>
            </template>
          </van-cell>
        </van-list>
      </van-tab>
      <van-tab :title="'待通过（' + total2 + '）'">
        <van-list v-model="loading2" :finished="finished2" finished-text="没有更多了" @load="getData2">
          <van-cell>
            <template v-for="(unit, key) in list2">
              <div class="content" :key="key">
                <div>{{ unit.phone }}</div>
                <div>
                  {{ unit.customerName }}
                </div>
              </div>
            </template>
          </van-cell>
        </van-list>
      </van-tab>
      <van-tab :title="'已添加（' + total1 + '）'">
        <van-list v-model="loading1" :finished="finished1" finished-text="没有更多了" @load="getData1">
          <van-cell>
            <template v-for="(unit, key) in list1">
              <div class="content" :key="key">
                <div>{{ unit.phone }}</div>
                <div>
                  {{ unit.customerName }}
                </div>
              </div>
            </template>
          </van-cell>
        </van-list>
      </van-tab>
    </van-tabs>
  </div>
</template>
<script src="https://open.work.weixin.qq.com/wwopen/js/jwxwork-1.0.0.js"></script>
<script>
  import ClipboardJS from 'clipboard'
  import { getTypeList, setState } from '@/api/seas.js'

  export default {
    name: 'highSeas-index',
    data() {
      return {
        active: 0,
        query: {
          pageSize: 20,
          pageNum: 1,
          addState: 0, // 0:待添加;1:已添加;3:待通过
          userId: ''
        },
        list: [],
        total: 0,
        total1: 0,
        total2: 0,
        list1: [],
        list2: [],
        loading: false,
        finished: false,
        loading1: false,
        finished1: false,
        loading2: false,
        finished2: false,
        query1: {
          pageSize: 20,
          pageNum: 1,
          addState: 1, // 0:待添加;1:已添加;3:待通过
          userId: ''
        },
        query2: {
          pageSize: 20,
          pageNum: 1,
          addState: 3, // 0:待添加;1:已添加;3:待通过
          userId: ''
        }
      }
    },
    watch: {},
    methods: {
      init() {
        this.query.userId = this.userId
        this.query1.userId = this.userId
        this.query2.userId = this.userId
        getTypeList(this.query).then((res) => {
          this.total = res.total
        })
        getTypeList(this.query1).then((res) => {
          this.total1 = res.total
        })
        getTypeList(this.query2).then((res) => {
          this.total2 = res.total
        })
      },

      getData() {
        this.query.userId = this.userId
        getTypeList(this.query).then((res) => {
          this.total = res.total
          this.list.push(...res.rows)
          this.loading = false
          this.query.pageNum++
          if (this.list.length >= Number(this.total)) {
            this.finished = true
          }
        })
      },
      getData1() {
        this.query1.userId = this.userId
        getTypeList(this.query1).then((res) => {
          this.total1 = res.total
          this.list1.push(...res.rows)
          this.loading1 = false
          this.query1.pageNum++
          if (this.list1.length >= Number(this.total1)) {
            this.finished1 = true
          }
        })
      },
      getData2() {
        this.query2.userId = this.userId
        getTypeList(this.query2).then((res) => {
          this.total2 = res.total
          this.list2.push(...res.rows)
          this.loading2 = false
          this.query2.pageNum++
          if (this.list2.length >= Number(this.total2)) {
            this.finished2 = true
          }
        })
      },
      setGoto(text) {
        setState({ phone: text }).then((res) => {
          this.list = []
          this.list1 = []
          this.list2 = []
          this.query.pageNum = 1
          this.query1.pageNum = 1
          this.query2.pageNum = 1
          this.getData()
          this.getData1()
          this.getData2()
          wx.invoke('navigateToAddCustomer', {}, function (res) {})
        })
      },
      copyFn(e, text) {
        const clipboard = new ClipboardJS(e.target, { text: () => text })
        clipboard.on('success', (e) => {
          this.setGoto(text)
          this.$toast({ type: 'success', message: '复制成功' })
          // 释放内存
          clipboard.off('error')
          clipboard.off('success')
          clipboard.destroy()
        })
        clipboard.on('error', (e) => {
          // 不支持复制
          this.$toast({ type: 'fail', message: '该浏览器不支持自动复制', icon: 'none' })
          // 释放内存
          clipboard.off('error')
          clipboard.off('success')
          clipboard.destroy()
        })
        clipboard.onClick(e)
      }
    },
    mounted() {
      this.init()
    },
    computed: {
      userId() {
        return this.$store.state.userId // 员工Id
      }
    },
    created() {}
  }
</script>
<style lang="less" scoped>
  .page {
    height: 100vh;
    background: #f6f6f6;
  }
  .content {
    font-size: 15px;
    font-weight: 500;
    display: flex;
    justify-content: space-between;
    align-items: center;
    line-height: 60px;
  }

  /deep/ .van-button--info {
    border: none;
  }
</style>
