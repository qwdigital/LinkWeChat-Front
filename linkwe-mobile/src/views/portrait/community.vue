<template>
  <div>
    <div class="header">
      <span class="title"> 社群关系 </span>
      <van-icon name="cross" color="#9c9c9c" size="16" @click="$router.back()" />
    </div>
    <!-- 标签页 -->
    <div class="labelPge">
      <van-tabs
        v-model="active"
        sticky
        color="#2C8CF0"
        line-height="1.4px"
        title-active-color="#2C8CF0"
      >
        <van-tab :title="'添加的员工(' + staff.length + ')'">
          <van-list>
            <van-cell-group v-if="staff.length">
              <van-cell v-for="(item, index) in staff" :key="index">
                <!-- <div class="li">
                  <div class="img">
                    <img :src="item.headImageUrl" alt="" />
                  </div>
                </div> -->
                <div class="li">
                  <div class="name">
                    <span>{{ item.userName }}</span>
                  </div>
                  <div class="c9">
                    <span>添加时间：</span>
                    <span>{{ getTime(item.createTime) }}</span>
                  </div>
                </div>
              </van-cell>
            </van-cell-group>
            <van-empty v-else image-size="50" description="暂无数据" />
          </van-list>
        </van-tab>
        <van-tab :title="'添加的群聊(' + groupChat.length + ')'">
          <div class="ar">
            <div :class="commonActive && 'active'" class="common mar10" @click="conGroup">
              只看与我共同的群聊
            </div>
          </div>
          <van-list>
            <van-cell-group v-if="groupChat.length">
              <van-cell v-for="(item, index) in groupChat" :key="index">
                <div class="li">
                  <div class="fxbw aic name">
                    <div class="">
                      {{ item.groupName + '(' + item.groupMemberNum + ')' }}
                    </div>
                    <div class="common active" v-if="!item.commonGroup">
                      共同群聊
                    </div>
                  </div>
                  <div class="fxbw">
                    <div>
                      <span class="c9">群主：</span>
                      <span class="c9">{{ item.ownerName }}</span>
                    </div>
                    <div class="c9">
                      <span>入群时间：</span><span>{{ getTime(item.joinTime) }}</span>
                    </div>
                  </div>
                </div>
              </van-cell>
            </van-cell-group>
            <van-empty v-else image-size="50" description="暂无数据" />
          </van-list>
        </van-tab>
      </van-tabs>
    </div>
  </div>
</template>

<script>
import { findAddaddEmployes, findAddGroupNum } from '@/api/portrait'
import { dateFormat } from '@/utils'
export default {
  data() {
    return {
      active: 0,
      //   添加员工
      list: [],
      // loading: false,
      // finished: false,
      staff: [], // 添加的员工
      allGroup: [], // 添加的群聊
      groupChat: [], // 添加的群聊
      commonGroup: [], // 共同的群聊
      commonActive: false,
      //   externalUserid: "wmiGuBCgAAIH-T9ekaE-Q52N2lKWeInw",
      externalUserid: '',
    }
  },
  computed: {
    userId() {
      return this.$store.state.userId // 员工Id
    },
  },
  created() {
    this.externalUserid = this.$route.query.customerId
    this.findAddaddEmployes()
    this.findAddGroupNum()
  },
  methods: {
    conGroup() {
      this.commonActive = !this.commonActive
      this.groupChat = this.commonActive ? this.commonGroup : this.allGroup
    },
    findAddaddEmployes() {
      this.$toast.loading()
      findAddaddEmployes(this.externalUserid)
        .then(({ data }) => {
          this.staff = data
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {
          this.$toast.clear()
        })
    },
    findAddGroupNum() {
      findAddGroupNum({
        externalUserid: this.externalUserid,
        userId: this.userId,
      })
        .then(({ data }) => {
          this.groupChat = this.allGroup = data
          this.commonGroup = data.filter((ele) => {
            return ele.groupMemberNum == 1
          })
        })
        .catch((err) => {
          console.log(err)
        })
    },
    getTime(data) {
      return dateFormat(data, 'yyyy-MM-dd hh:mm')
    },
  },
}
</script>

<style lang="less" scoped>
.labelPge {
  width: 100%;
  height: 100%;
  // background-color: #f2f2f2;
}
.header {
  padding: 20px 20px 10px;
  vertical-align: center;
  text-align: left;
  background: #fff;
  border-bottom: 1px solid #fafafa;
}
.van-icon-cross {
  float: right;
}
.title {
  text-align: center;
  font-size: 14px;
}
/* 添加的员工 */
.details {
  margin: 10px;
}
.detail {
  display: flex;
  justify-content: space-between;
}
.van-cell {
  padding: 16px 16px 13px;
}
.li {
  .name {
    color: #222;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 8px;
  }
  .img {
    width: 50px;
    height: 50px;
    background-color: #f2f2f2;
    margin-right: 10px;
    border-radius: 25px;
    vertical-align: bottom;
  }
  .c9 {
    color: #9c9c9c;
    font-size: 12px;
  }
}
// 添加的群聊
.common {
  display: inline-block;
  min-width: 57px;
  font-size: 10px;
  padding: 4px 10px 3px;
  border-radius: 8px;
  background: #eee;
  text-align: center;
  line-height: 22px;
}
.active {
  color: @color;
  background: #ecf5ff;
}
</style>
