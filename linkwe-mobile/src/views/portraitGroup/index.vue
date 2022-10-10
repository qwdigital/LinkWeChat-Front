<template>
  <div class="portrait" :style="{ 'margin-bottom': isQueryChatId ? '50px' : '0px' }">
    <div class="details">
      <div class="detail mb20">
        <div class="left">
          <div class="img"><img :src="form.avatar" alt="" /></div>
          <div class="right">
            <div class="key">
              {{ form.groupName }}
              <!-- {{ (form.name || '') + (form.remarkCorpName ? '-' + form.remarkCorpName : '') }} -->
            </div>
            <div class="data">群主：{{ form.groupLeaderName }}</div>
          </div>
        </div>
      </div>
    </div>
    <div class="card">
      <div class="title">群公告</div>
      <div>
        {{ form.notice || '无' }}
      </div>
    </div>

    <!-- 群成员 -->
    <div class="realationship card">
      <div class="detail">
        <div class="title">群成员</div>
        <div class="data" @click="goRoute('/groupMembers')">详情<van-icon name="arrow" /></div>
      </div>
      <div class="detail">
        <div class="boxnumber">
          <div class="number">{{ form.memberNum }}</div>
          <p class="key">群总人数</p>
        </div>
        <div class="boxnumber">
          <div class="number">{{ form.customerNum }}</div>
          <p class="key">客户总数</p>
        </div>
        <div class="boxnumber">
          <div class="number">{{ form.toDayMemberNum }}</div>
          <p class="key">今日进群</p>
        </div>
        <div class="boxnumber">
          <div class="number">{{ form.toDayExitMemberNum }}</div>
          <p class="key">今日退群</p>
        </div>
      </div>
    </div>

    <!-- 客群标签 -->
    <div class="userlabel card">
      <div class="detail">
        <div class="title">客群标签</div>
        <div class="data" is-link @click="labelEdit()">编辑<van-icon name="arrow" /></div>
      </div>
      <div v-if="form.tags && form.tags.length" class="labelstyle mt15">
        <div class="label" v-for="(unit, unique) in form.tags" :key="unique">
          {{ unit.name }}
        </div>
      </div>
      <van-empty v-else image-size="50" description="暂无数据" />
    </div>
    <!-- 客群轨迹 -->
    <div class="addwaiting card">
      <div class="detail">
        <div class="title">客群轨迹</div>
        <div class="data" is-link @click="sync">同步</div>
      </div>
      <!-- 步骤条 -->
      <StepList ref="stepList" :load="findTrajectory"></StepList>
    </div>

    <div class="cancat-btn">
      <van-button v-if="isQueryChatId" type="info" size="normal" block round @click="concat">
        进入群聊
      </van-button>
    </div>

    <!-- 点击客户标签里的编辑触发弹出框开始 -->
    <van-action-sheet v-model="show">
      <van-nav-bar title="客户标签"> </van-nav-bar>
      <div class="content">
        <div v-for="(item, index) in alllabel" :key="index">
          <div class="mb15 mt5 tag-group-name">{{ item.groupName }}</div>
          <div class="labelstyle">
            <div
              v-for="(unit, unique) in item.weTags"
              :key="unique"
              class="label"
              :class="addTag.some((e) => e.tagId == unit.tagId) && 'active'"
              @click="clickLabel(unit)"
            >
              {{ unit.name }}
            </div>
          </div>
        </div>

        <van-empty v-if="!alllabel || !alllabel.length" image-size="50" description="暂无数据" />
      </div>
      <div class="save-btn">
        <van-button type="info" size="normal" block round @click="saveCustomerTag">
          保存
        </van-button>
      </div>
    </van-action-sheet>

    <!-- 点击客户标签里的编辑触发弹出框结束 -->
  </div>
</template>

<script>
import { getDetail, findTrajectory, markTag, sync, getTagList } from '@/api/group'
import StepList from '@/components/StepList.vue'
// import { param2Obj } from '@/utils'
export default {
  components: {
    StepList,
  },
  data() {
    return {
      // 客户标签弹出框
      show: false,
      form: {
        groupName: '',
        groupLeaderName: '',
        notice: '',
        memberNum: 0,
        customerNum: 0,
        toDayMemberNum: 0,
        toDayExitMemberNum: 0,
        groupName: 0,
        groupName: '',
      },
      alllabel: [], // 标签组
      addTag: [], // 添加的参数
      loading: false,
      finished: false,
      loadingStep: false,
      isQueryChatId: false,
    }
  },
  computed: {
    userId() {
      return process.env.NODE_ENV !== 'development' ? this.$store.state.userId : 'XuXueJun'
    },
  },
  created() {
    let query = this.$route.query
    this.chatId =
      process.env.NODE_ENV !== 'development'
        ? query && query.id
        : 'wrbhUTLgAABAQBtMn5Gc0LMxv-h-Xw-A'
    this.isQueryChatId = !!this.chatId
    if (process.env.NODE_ENV === 'production') {
      this.$toast.loading({
        message: 'loading...',
        duration: 0,
        forbidClick: true,
      })

      if (this.isQueryChatId) {
        this.start()
        this.$toast.clear()
      } else {
        this.init()
      }
    } else {
      this.start()
    }
  },

  methods: {
    start() {
      this.getDetail()
      this.refreshTrajectory()
    },
    init() {
      wx.invoke('getContext', {}, (res) => {
        if (res.err_msg == 'getContext:ok') {
          let entry = res.entry //返回进入H5页面的入口类型，目前有normal、contact_profile、single_chat_tools、group_chat_tools
          if (!['group_chat_tools', 'contact_profile'].includes(entry)) {
            // this.$toast.clear()
            this.$toast('入口错误：' + entry)
            return
          }
          wx.invoke('getCurExternalChat', {}, (res) => {
            if (res.err_msg == 'getCurExternalChat:ok') {
              this.chatId = res.chatId //返回当前外部群的群聊ID
              this.start()
            } else {
              //错误处理
              this.$dialog({ message: '进入失败：' + JSON.stringify(res) })
            }
            this.$toast.clear()
          })
        } else {
          //错误处理
          this.$toast.clear()
          this.$dialog({ message: '进入失败：' + JSON.stringify(res) })
        }
      })
    },
    getDetail() {
      getDetail(this.chatId)
        .then(({ data }) => {
          if (data.tagIds && data.tags) {
            data.tagIds = data.tagIds.split(',')
            data.tagNames = data.tags.split(',')
            data.tags = data.tagIds.map((unit, index) => ({
              id: unit,
              name: data.tagNames[index],
            }))
          }

          this.form = data
        })
        .catch((err) => {
          console.log(err)
        })
    },
    getAllTags() {
      this.$toast.loading({
        message: 'loading...',
        duration: 0,
        forbidClick: true,
      })
      let params = {
        groupTagType: 2,
      }
      return getTagList(params)
        .then(({ rows }) => {
          this.alllabel = this.listTagOneArray = rows

          this.listTagOneArray = []
          rows.forEach((element) => {
            element.weTags.forEach((d) => {
              this.listTagOneArray.push(d)
            })
          })
          this.$toast.clear()
        })
        .catch((err) => {
          console.log(err)
        })
    },
    // 获取轨迹信息
    findTrajectory(params) {
      if (!this.chatId) {
        return new Promise(() => {})
      }
      let query = {
        chatId: this.chatId,
        // weUserId: this.userId,
      }
      Object.assign(query, params)
      return findTrajectory(query)
    },
    refreshTrajectory() {
      this.$nextTick(() => {
        this.$refs.stepList.getList(1)
      })
    },
    goRoute(path) {
      this.$router.push({
        path,
        query: {
          id: this.chatId,
          //   type
        },
      })
    },
    // 点击编辑按钮
    async labelEdit() {
      await this.getAllTags()
      this.addTag = []

      let tags = this.form.tags
      let hasErrorTag = [] // 异常活已经删除的标签
      // let repeat = [] // 重复的标签
      tags &&
        tags.forEach((unit) => {
          // 判断是否有重复标签
          // let isRepeat = this.listTagOneArray.some((d) => {
          //   return d.tagId === unit.tagId
          // })
          // // 去重
          // if (isRepeat) {
          //   repeat.push(unit.name)
          //   return
          // }
          let filter = this.listTagOneArray.find((d) => {
            return d.tagId === unit.id
          })
          // 如果没有匹配到，则说明该便签处于异常状态，可能已被删除或破坏
          if (!filter) {
            hasErrorTag.push(unit.name)
            return
          }

          this.addTag.push(filter)
        })
      this.show = true
      // 获取用户当前的lable,将当前用户的lable与所有lable进行对比，相同的弹框内蓝色展示
      // 弹框内的标签组选中时蓝色展示
      // 弹框内的子标签与选中时蓝色展示，点击时
    },
    // 点击选择标签
    clickLabel(item) {
      let index = this.addTag.findIndex((e) => {
        return item.tagId == e.tagId
      })
      // 数组里不存在该对象,则添加
      if (index == -1) {
        this.addTag.push({
          groupId: item.groupId,
          name: item.name,
          tagId: item.tagId,
        })
      } else {
        // 数组里存在该对象,则删除
        this.addTag.splice(index, 1)
      }
    },
    // 更新标签
    saveCustomerTag() {
      markTag({
        chatId: this.chatId,
        tagIds: this.addTag.map((e) => e.tagId),
      })
        .then((res) => {
          if (res.code == 200) {
            this.show = false
            //   重新获取客户标签
            this.getDetail()
            this.$toast.success('保存成功')
          }
        })
        .catch((err) => {
          console.log(err)
        })
    },
    sync() {
      this.$toast.loading({
        message: 'loading...',
        duration: 0,
        forbidClick: true,
      })
      sync(this.userId)
        .then((res) => {
          this.$toast.success('同步成功')
          this.refreshTrajectory()
        })
        .finally(() => {
          this.$toast.clear()
        })
    },
    concat() {
      wx.invoke(
        'openExistedChatWithMsg',
        {
          chatId: this.chatId,
          // msg: {
          //   msgtype: 'link',
          //   link: {
          //     title: 'title1',
          //     desc: 'desc1',
          //     url: 'link1',
          //     imgUrl: 'imgurl1',
          //   },
          // },
        },
        (res) => {
          if (res.err_msg == 'openExistedChatWithMsg:ok') {
          } else {
            this.$dialog({ message: '进入失败：' + JSON.stringify(res) })
          }
        }
      )
    },
  },
}
</script>

<style lang="less" scoped>
.portrait {
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
  .title {
    font-size: 16px;
    color: #222;
    font-weight: 500;
    line-height: 30px;
  }
}
//  详细资料
.detail {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #666;
  .key {
    color: #222;
    font-weight: 500;
  }
  .data {
    font-size: 13px;
    color: #999;
  }
  // .van-icon-cross {
  //   color: #999;
  // }
}
.left {
  display: flex;
  align-items: center;
  .img {
    width: 50px;
    height: 50px;
    background-color: #f2f2f2;
    margin-right: 16px;
    border-radius: 2px;
    overflow: hidden;
  }
  .right {
    line-height: 25px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }
}
.content {
  max-height: 60vh;
  position: relative;
  margin: 15px 0 0;
  padding: 0 16px;
  overflow: auto;
  .tag-group-name {
    font-size: 14px;
    color: #666;
  }
}
// 客户标签
.labelstyle {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  .label {
    display: inline-block;
    min-width: 72px;
    font-size: 13px;
    padding: 4px 5px 3px;
    border-radius: 8px;
    color: #666;
    background: #fafafa;
    text-align: center;
    margin: 0 0 11px 9px;
    line-height: 26px;
  }
  .active {
    background: #ecf5ff;
    color: @color;
  }
}
.save-btn {
  width: 90%;
  margin: 20px auto;
  .van-button {
    height: 40px;
    line-height: 40px;
  }
}

//  社交关系
.boxnumber {
  width: 100%;
  text-align: center;
  margin: 10px 0;
  .key {
    font-size: 12px;
    color: #b5b8c0;
  }
  .number {
    text-align: center;
    margin-bottom: 10px;
    font-size: 18px;
    font-weight: 700;
    color: #222;
  }
}
.cancat-btn {
  background: #fff;
  position: fixed;
  bottom: 0;
  left: 0;
  padding: 15px 5%;
  width: 100%;
  .van-button {
    height: 40px;
    line-height: 40px;
  }
}
</style>
