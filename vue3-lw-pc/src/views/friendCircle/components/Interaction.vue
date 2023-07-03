<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <!-- <el-tabs v-model="activeName" @tab-click="handleClick" v-if="this.type === 1">
        <el-tab-pane label="互动记录" name="first"><Record /></el-tab-pane>
        <el-tab-pane label="查看明细" name="second"><ViewDetail /></el-tab-pane>
      </el-tabs> -->
      <Record />
    </div>
  </div>
</template>

<script>
import { statisticInteract } from '@/api/circle'
import Record from './Record.vue'
import ViewDetail from './ViewDetail'
export default {
  components: {
    Record,
    ViewDetail,
  },
  data() {
    return {
      activeName: 'first',
      cardData: [
        {
          title: '点赞客户数 ',
          tips: '该朋友圈任务点赞的客户数',
          value: 0,
          noArrow: true,
        },
        {
          title: '评论客户数',
          tips: '该朋友圈任务评论的客户数',
          value: 0,
        },
        // {
        //   title: '附件浏览人数',
        //   tips: '该朋友圈任务附带的视频/图文/文章/文件/海报的UV量',
        //   value: 0,
        // },
        // {
        //   title: '附件浏览次数',
        //   tips: '该朋友圈任务附带的视频/图文/文章/文件/海报的PV量',
        //   value: 0,
        // },
      ],
      id: undefined,
      type: undefined, // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
    }
  },
  mounted() {
    this.type = +this.$route.query.type
    this.id = this.$route.query.id

    // if (this.type !== 1) {
    //   this.cardData = this.cardData.slice(0, 2)
    // }
    this.getTabTotalFn()
  },
  methods: {
    getTabTotalFn() {
      statisticInteract(this.id).then((res) => {
        this.cardData[0].value = res.data.like
        this.cardData[1].value = res.data.comment
        // if (this.type === 1) {
        //   this.cardData[2].value = res.data.people
        //   this.cardData[3].value = res.data.count
        // }
      })
    },
  },
}
</script>

<style lang="scss" scoped></style>
