<template>
  <div>
    <div class="g-card">
      <el-steps :active="active" align-center>
        <el-step title="活码设置"></el-step>
        <el-step title="拉新设置"></el-step>
        <el-step title="生成活码"></el-step>
      </el-steps>
    </div>
    <div class="g-card">
      <div>
        <div v-if="active === 0">
          <BaseInfo ref="baseInfo" :query="query" @nextBaseInfo="nextBaseInfo"></BaseInfo>
        </div>
        <div v-if="active === 1">
          <PullNews ref="pullNews" :query="pullNewsObj" @createLiveCode="createLiveCode"></PullNews>
        </div>
        <div v-if="active === 2">
          <GroupCode
            ref="groupCode"
            :query="baseInfo"
            :groupCode="groupCodeQuery"
            @getGroupCode="getGroupCode"></GroupCode>
        </div>
      </div>
      <div class="ar" style="margin-top: 30px">
        <template v-if="active === 0">
          <el-button @click="$router.back()">取消</el-button>
          <el-button type="primary" v-loading="loading" :disabled="loading" @click="infoNext">下一步</el-button>
        </template>
        <template v-else-if="active === 1">
          <el-button @click="prev('one')">上一步</el-button>
          <el-button type="primary" v-loading="loading" :disabled="loading" @click="handleGroupCode">
            生成活码
          </el-button>
        </template>
        <template v-else>
          <el-button @click="prev('two')">上一步</el-button>
          <el-button type="primary" @click="finished">确定</el-button>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import BaseInfo from './baseInfo'
import PullNews from './pullNews'
import GroupCode from './groupCode'
import { add, update, getDetail } from '@/api/drainageCode/pullNews'
export default {
  components: {
    BaseInfo,
    PullNews,
    GroupCode,
  },
  data() {
    return {
      loading: false,
      // 当前群活码ID
      groupCodeId: null,
      // 当前激活的步骤
      active: 0,
      baseInfo: {},
      functionType: 0, // 拉新方式 0红包拉新 1卡券拉新
      query: {},
      pullNewsObj: {},
      groupCodeQuery: {},
    }
  },
  created() {
    if (this.$route.query.groupCodeId) {
      this.groupCodeId = this.$route.query.groupCodeId
      this.getDetail(this.$route.query.groupCodeId)
    }
  },
  methods: {
    // 活码设置里点击下一步
    nextBaseInfo(form) {
      this.query = Object.assign(this.query, form)
    },
    // 生成活码
    createLiveCode(val) {
      console.log(87, val)

      this.query = Object.assign(this.query, val)
      console.log(88, this.query)
    },
    getGroupCode(val) {
      console.log(90, val)
      // this.groupCodeQuery = Object.assign(this.groupCodeQuery, val)
    },
    // 下一步
    // next(groupCodeId, info) {
    //   this.loading = false
    //   if (groupCodeId || info) {
    //     if (groupCodeId) this.groupCodeId = groupCodeId
    //     this.baseInfo = info
    //     this.active += 1
    //     if (this.active > 3) this.active = 1
    //   }
    // },
    // 上一步
    prev(type) {
      this.active -= 1
      if (this.active < 0) this.active = 0
      if (type === 'one') {
        this.$refs.pullNews.transInfo()
        console.log(this.query)
      } else {
        this.$refs.groupCode.transInfo()
        console.log(this.groupCodeQuery)
      }
      if (this.query.qrName) {
        // 新增
        this.query.name = this.query.qrName
      }
      console.log(100, this.query)
    },
    // 完成
    finished() {
      // this.next()
      this.$router.back()
    },
    infoNext() {
      this.$refs.baseInfo.handleValidateFn().then(() => {
        this.pullNewsObj = this.query
        this.active += 1
      })
    },
    // 新增或更新群活码
    handleGroupCode() {
      if (!this.$refs.pullNews.handleValidateFn()) return
      this.loading = true
      this.submit()
    },
    // 提交
    submit() {
      delete this.query.tags
      if (this.groupCodeId) {
        this.query.id = this.groupCodeId
      }
      if (this.groupCodeQuery.attachments) {
        this.query = Object.assign(this.query, this.groupCodeQuery)
      } else {
        this.groupCodeQuery = Object.assign(this.groupCodeQuery, this.query)
      }
      console.log(this.query)
      console.log(143, this.groupCodeQuery)
      ;(this.groupCodeId ? update : add)(this.query)
        .then((res) => {
          if (res.code === 200) {
            if (!this.groupCodeId) {
              // 新建
              res.data.qrName = this.query.qrName
              this.baseInfo = res.data
            } else {
              // 编辑
              let form = { imageUrl: '', linkPath: '', qrName: '' }
              form.imageUrl = this.query.imageUrl
              form.linkPath = this.query.linkPath
              form.qrName = this.query.qrName
              form.qrId = this.groupCodeId
              this.baseInfo = form
            }
            this.active = 2
            this.loading = false
          }
        })
        .catch(() => {
          this.loading = false
        })
    },
    getDetail(id) {
      getDetail(id).then((res) => {
        console.log(147, res)
        let obj = { qrTags: [], tags: [] }
        res.data.qrTags.forEach((el) => {
          obj.qrTags.push(el.tagId)
          obj.tags.push(el.tagName)
        })
        let list = [
          { scopeType: 1, userIds: [] },
          { scopeType: 2, partys: [] },
          { scopeType: 3, positions: [] },
        ]
        if (res.data.qrUserInfos) {
          res.data.qrUserInfos.forEach((item) => {
            switch (item.scopeType) {
              case 1:
                item.userId ? list[0].userIds.push(item.userId) : ''
                break
              case 2:
                item.party ? list[1].partys.push(item.party) : ''
                break
              case 3:
                item.position ? list[2].positions.push(item.position) : ''
                break
            }
          })
        }

        this.query = Object.assign(res.data, obj)
        this.query['qrUserInfos'] = list
        console.log(180, this.query)
      })
    },
    // 管理实际群活码
    // handleRealCode() {
    //   this.next()
    // },
  },
}
</script>

<style scoped lang="scss">
.page-content {
  padding-top: 50px;
  padding-bottom: 20px;
}
</style>
