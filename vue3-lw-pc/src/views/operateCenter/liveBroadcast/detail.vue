<template>
  <div>
    <!-- 直播详情 -->
    <div>
      <div class="flex">
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <div class="boxCard">
          <div>
            <span>直播回放</span>
            <div v-if="detailData.openReplay === 0">
              <span class="noBack">主播未开启本场直播回放功能</span>
            </div>
          </div>
          <div v-if="detailData.openReplay === 1">
            <div class="backStyle">{{ dealBackType(detailData.replayStatus) }}</div>
            <el-button
              type="primary"
              :disabled="detailData.replayStatus !== 0"
              @click="lookBack(detailData.shareOrJoinUrl)">
              查看回放
            </el-button>
          </div>
        </div>
      </div>
      <div class="g-card">
        <el-descriptions title="基本信息">
          <el-descriptions-item
            :label="item.title"
            label-class-name="my-label"
            content-class-name="my-content"
            v-for="(item, index) in descripList"
            :key="index">
            {{ item.name }}
          </el-descriptions-item>
          >
        </el-descriptions>
      </div>
      <div class="g-card mt20">
        <el-tabs v-model="activeName" @tab-change="tabClick">
          <el-tab-pane label="客户列表" name="first">
            <div v-if="activeName === 'first'">
              <el-form label-position="left" inline label-width="80px">
                <el-form-item label-width="0">
                  <el-input placeholder="请输入客户名称" v-model="query.watchUserName" style="width: 180px"></el-input>
                </el-form-item>
                <el-form-item label-width="0">
                  <el-select v-model="query.isCompanyCustomer" placeholder="请选择是否为企业客户" style="width: 180px">
                    <el-option
                      v-for="item in companyCustomer"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value"></el-option>
                  </el-select>
                </el-form-item>
                <el-form-item label-width="0">
                  <el-select v-model="query.isComment" placeholder="请选择评论状态" style="width: 180px">
                    <el-option
                      v-for="item in comment"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value"></el-option>
                  </el-select>
                </el-form-item>
                <el-form-item label-width="0">
                  <el-select v-model="query.isMic" placeholder="发言状态" style="width: 180px">
                    <el-option
                      v-for="item in mic"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value"></el-option>
                  </el-select>
                </el-form-item>
                <el-form-item label-width="0">
                  <el-button type="primary" @click="getList(0)">查询</el-button>
                  <el-button @click="resetQuery">重置</el-button>
                </el-form-item>
                <div class="fr mt10">
                  <el-button type="primary" plain @click="exportFn(2)" v-loading="exportLoading">导出Excel</el-button>
                </div>
              </el-form>
              <el-table v-loading="loading" :data="list">
                <el-table-column label="客户名称" align="center">
                  <template #default="{ row }">
                    <div class="cp flex aic">
                      <el-image
                        style="width: 50px; height: 50px; flex: none"
                        :src="row.watchAvatar"
                        fit="fill"
                        v-if="row.watchAvatar"></el-image>
                      <svg-icon icon="service" class="code-user" v-else></svg-icon>
                      <div class="ml10">
                        <p>{{ row.watchUserName }}</p>
                        <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[row.gender]]" />
                        <span
                          :style="{
                            color: ['@微信', '@微信用户'].includes(row.remarks) ? '#4bde03' : '#f9a90b',
                          }">
                          {{ row.remarks }}
                        </span>
                      </div>
                    </div>
                  </template>
                </el-table-column>
                <el-table-column label="是否为企业客户" align="center">
                  <template #default="scope">
                    {{ dealType(scope.row.isCompanyCustomer) }}
                  </template>
                </el-table-column>
                <el-table-column label="观看时长" align="center" prop="watchTime"></el-table-column>
                <el-table-column label="是否评论" align="center">
                  <template #default="scope">
                    {{ dealType(scope.row.isComment) }}
                  </template>
                </el-table-column>
                <el-table-column label="是否连麦发言" align="center">
                  <template #default="scope">
                    {{ dealType(scope.row.isMic) }}
                  </template>
                </el-table-column>
              </el-table>
              <div class="bottom">
                <pagination
                  :total="total"
                  v-model:page="query.pageNum"
                  v-model:limit="query.pageSize"
                  @pagination="getList()" />
              </div>
            </div>
          </el-tab-pane>
          <!-- <el-tab-pane label="员工列表" name="second">
            <div v-if="activeName === 'second'">
              <div>
                <el-form label-position="left" inline label-width="80px">
                  <el-form-item label-width="0">
                    <el-input
                      placeholder="请输入员工名称"
                      v-model="query.watchUserName"
                      style="width: 260px"
                    ></el-input>
                  </el-form-item>
                  <el-form-item label-width="0">
                    <el-input
                      style="width: 180px"
                      :model-value="query.remarks"
                      readonly
                      @click="dialogVisible = true"
                      placeholder="请选择所在部门"
                    />
                  </el-form-item>
                  <el-form-item label-width="0">
                    <el-select
                      v-model="query.isComment"
                      placeholder="请选择评论状态"
                      style="width: 180px"
                    >
                      <el-option
                        v-for="item in comment"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      >
                      </el-option>
                    </el-select>
                  </el-form-item>
                  <el-form-item label-width="0">
                    <el-select v-model="query.isMic" placeholder="发言状态" style="width: 180px">
                      <el-option
                        v-for="item in mic"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      >
                      </el-option>
                    </el-select>
                  </el-form-item>
                  <el-form-item label-width="0">
                    <el-button type="primary" @click="getList(0)">查询</el-button>
                    <el-button @click="resetQuery">重置</el-button>
                  </el-form-item>
                  <div class="fr mt10">
                    <el-button
                      type="primary"
                      plain

                      @click="exportFn(1)"
                      v-loading="exportLoading"
                      >导出Excel</el-button
                    >
                  </div>
                </el-form>
                <el-table v-loading="loading" :data="list">
                  <el-table-column label="成员名称" align="center" show-overflow-tooltip>
                    <template #default="scope">
                      {{ scope.row.watchUserName }}
                    </template>
                  </el-table-column>
                  <el-table-column label="所在部门" align="center">
                    <template #default="scope">
                      {{ coverContent(scope.row.remarks) }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    label="观看时长"
                    align="center"
                    prop="watchTime"
                  ></el-table-column>
                  <el-table-column label="是否评论" align="center">
                    <template #default="scope">
                      {{ dealType(scope.row.isComment) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="是否连麦发言" align="center">
                    <template #default="scope">
                      {{ dealType(scope.row.isMic) }}
                    </template>
                  </el-table-column>
                </el-table>
                <div class="bottom">
                  <pagination
                    :total="total"
                     v-model:page="query.pageNum"
                     v-model:limit="query.pageSize"
                    @pagination="getList()"
                  />
                </div>
              </div>
            </div>
          </el-tab-pane> -->
        </el-tabs>
      </div>
    </div>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
      :isOnlyLeaf="false"></SelectUser>
  </div>
</template>

<script>
import { detailLive, watchUserList, exprotWeLiveWatchUser } from '@/api/operateCenter/liveBroadcast'

import { dateFormat } from '@/utils/index'
export default {
  data() {
    return {
      detailData: {}, //详情数据
      descripList: [],
      activeName: 'first',
      dialogVisible: false,
      query: {
        pageNum: 1,
        pageSize: 10,
        watchUserType: 2,
      },
      companyCustomer: [
        { value: 0, label: '否' },
        { value: 1, label: '是' },
      ],
      comment: [
        { value: 0, label: '否' },
        { value: 1, label: '是' },
      ],
      mic: [
        { value: 0, label: '否' },
        { value: 1, label: '是' },
      ],
      cardData: [
        {
          title: '观看直播总人数',
          tips: '观看本场直播的总人数数量',
          value: 0,
          noArrow: true,
        },
        {
          title: '当前在线观看人数 ',
          tips: '当前时间段观看直播的人数数量（实时更新）',
          value: 0,
        },
        {
          title: '连麦发言人数 ',
          tips: '参与本场直播连麦发言的观众总人数',
          value: 0,
        },
        {
          title: '直播评论人数',
          tips: '参与本场直播进行评论的观众总人数',
          value: 0,
        },
      ],
      userArray: [],
      exportLoading: false,
      total: 0,
      list: [],
      id: '',
    }
  },
  created() {
    this.id = this.$route.query.id
    this.getDeatil(this.id)
    this.getList()
  },
  components: {},
  methods: {
    tabClick() {
      this.query = {
        pageNum: 1,
        pageSize: 10,
      }
      this.getList()
    },
    exportFn(type) {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          return exprotWeLiveWatchUser({ watchUserType: type, liveId: this.id })
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型

          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '咨询记录')
          } else {
            let list = type === 1 ? '员工' : '客户'
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_' + list + '列表.xlsx' //指定下载文件名
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    dealType(type) {
      let data = type === 0 ? '否' : '是'
      return data
    },
    getSelectUser(data) {
      this.userArray = data
      if (Array.isArray(this.userArray)) {
        this.query.remarks = this.userArray
          .filter((e) => e.isParty)
          .map((e) => e.deptName)
          .join(',')
      }
    },
    /** 查询 */
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      this.query.watchUserType = this.activeName === 'first' ? 2 : 1
      this.query.liveId = this.$route.query.id
      watchUserList(this.query)
        .then((res) => {
          this.list = res.rows
          this.total = +res.total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 重置
    resetQuery() {
      let pageSize = this.query.pageSize
      this.query = { pageNum: 1, pageSize }
      this.getList()
    },
    // 查看回放
    lookBack(url) {
      var textArea = document.createElement('textarea')
      textArea.textContent = url
      textArea.style.position = 'fixed'
      document.body.appendChild(textArea)
      textArea.select()
      try {
        document.execCommand('copy') // 把要复制的内容拷贝到剪贴板
        this.$message.success('链接复制成功，请在微信中打开')
      } catch (ex) {
        this.$message.error('链接复制失败')
        return false
      } finally {
        document.body.removeChild(textArea) // 移除插入的文本域节点
      }
    },
    // 获取直播详情
    getDeatil(id) {
      detailLive(id)
        .then((res) => {
          this.cardData[0].value = res.data.viewerNum
          this.cardData[1].value = res.data.onlineCount
          this.cardData[2].value = res.data.micNum
          this.cardData[3].value = res.data.commentNum
          this.detailData = res.data
          let data = res.data

          let liveState = this.dealState(res.data.liveState)
          if (res.data.liveState === 1) {
            data.livingActualDurationDesc = '--'
          }
          data.liveDesc = data.liveDesc ? this.coverContent(data.liveDesc) : ''
          this.descripList = [
            { title: '直播标题', name: data.liveTitle },
            { title: '直播预约开始时间', name: data.liveStartDate + ' ' + data.liveStartTime },
            { title: '直播实际开始时间', name: data.actualStartTime },
            { title: '直播状态', name: liveState },
            { title: '直播预约持续时长', name: data.livingDurationDesc },
            { title: '直播实际持续时间', name: data.livingActualDurationDesc },
            { title: '直播简介', name: data.liveDesc },
            { title: '直播员工', name: data.liveUserName },
            { title: '员工所在部门', name: data.deptName },
          ]
        })
        .catch(() => {})
    },
    // 超过20个。。。展示
    coverContent(str) {
      if (str && str.length > 20) {
        str = str.substr(0, 20) + '...'
      }
      return str
    },
    dealState(state) {
      switch (state) {
        case 0:
          return '预约中'
          break
        case 1:
          return '直播中'
          break
        case 2:
          return '已结束'
          break
        case 3:
          return '已过期'
          break
        case 4:
          return '已取消'
          break
      }
    },
    dealBackType(type) {
      switch (type) {
        case 0:
          return '生成成功'
          break
        case 1:
          return '生成中'
          break
        case 2:
          return '回放已删除'
          break
        case 3:
          return '生成失败'
          break
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.code-user {
  width: 50px;
  height: 50px;
  color: var(--font-black-6);
}
.noBack {
  color: #ed4014;
  font-size: 18px;
  margin-top: 15px;
  display: block;
}
.boxCard {
  min-width: 300px;
  background: var(--bg-white);
  border-radius: 4px;
  margin: 0 10px 20px 0;
  padding: 22px 20px;
  display: flex;
  justify-content: space-between;
}
.backStyle {
  font-size: 18px;
  color: var(--color);
  margin-bottom: 15px;
}
.my-label {
  font-size: 14px;
  color: var(--font-black-7);
}
.my-content {
  font-size: 14px;
  color: var(--font-black);
}
.el-icon-s-custom {
  font-size: 16px;
  // margin-left: 4px;
  color: var(--font-black-6);
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
</style>
