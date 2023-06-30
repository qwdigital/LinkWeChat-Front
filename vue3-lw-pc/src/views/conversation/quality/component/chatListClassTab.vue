<template>
  <div class="chatListClassTab" v-loading="loading">
    <!-- <el-date-picker
      v-model="dateRange"
      type="daterange"
      format="YYYY-MM-DD"
      value-format="YYYY-MM-DD"
      range-separator="至"
      start-placeholder="开始日期"
      end-placeholder="结束日期"
      align="right"
      @change="getList(1)"></el-date-picker> -->
    <div class="list">
      <template v-if="list.length">
        <chatList :queryChat="queryChat" v-if="'all,image,video,link,'.includes(type)" :data="list"></chatList>

        <el-table
          v-else-if="type == 'file'"
          :data="list"
          stripe
          style="width: 100%"
          :header-cell-style="{ background: '#fff' }">
          <!-- <el-table-column prop="msgtype" label="类型"> </el-table-column> -->
          <el-table-column label="名称">
            <template #default="{ row }">
              {{ JSON.parse(row.contact).filename }}
            </template>
          </el-table-column>
          <el-table-column label="大小">
            <template #default="{ row }">
              {{ filterSize(JSON.parse(row.contact).filesize) }}
            </template>
          </el-table-column>
          <el-table-column label="来源">
            <template #default="{ row }">
              {{ row.name }}
            </template>
          </el-table-column>
          <el-table-column prop="action" label="操作">
            <template #default="{ row }">
              <el-button text @click="downloadFile(row)">下载</el-button>
            </template>
          </el-table-column>
        </el-table>

        <el-table
          v-else-if="'voice,meeting_voice_call'.includes(type)"
          :data="list"
          stripe
          :header-cell-style="{ background: '#fff' }">
          <el-table-column prop="date" label="发起人">
            <template #default="{ row }">
              {{ row.name }}
            </template>
          </el-table-column>
          <el-table-column prop="name" label="通话时间">
            <template #default="{ row }">
              {{ row.msgTime }}
            </template>
          </el-table-column>
          <el-table-column prop="address" label="时长" min-width="50">
            <template #default="{ row }">
              <span v-if="row.msgType == 'voice'">{{ JSON.parse(row.contact).play_length }}s</span>
              <span v-else>
                {{ setDate(JSON.parse(row.contact).endtime, row.msgTime) }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="msgType" label="类型">
            <template #default="{ row }">
              {{ row.msgType === 'voice' ? '语音消息' : '语音通话' }}
            </template>
          </el-table-column>
          <el-table-column prop="address" min-width="80" label="操作">
            <template #default="{ row }">
              <!-- <el-button
                text

                @click="voiceLook(JSON.parse(row.contact))"
                >查看</el-button
              > -->
              <!-- <AudioPlayer
                :audio-list="[JSON.parse(row.contact).attachment]"
                ref="AudioPlayer"
              /> -->
              <voice :amrUrl="JSON.parse(row.contact)['attachment']"></voice>
              <!-- <audio controls>
                <source :src="JSON.parse(row.contact).attachment" type="audio/mpeg" />
              </audio> -->
            </template>
          </el-table-column>
        </el-table>
      </template>

      <el-empty v-else :image-size="100"></el-empty>
    </div>

    <el-pagination
      v-if="total"
      layout="prev, pager, next"
      v-model:current-page="currentPage"
      @current-change="getList"
      :total="total" />
  </div>
</template>

<script>
import chatList from './chatList.vue'
import { statisticRecordList } from '../api.js'

import Voice from '@/components/Voice'
import { download } from '@/api/common.js'
import { diffDate } from '@/utils/index'
import { parseTime } from '@/utils/common'
export default {
  name: '',
  components: { chatList, Voice },
  props: {
    // 消息收发者
    queryChat: {
      type: Object,
      default: () => ({}),
    },
    // 消息类型
    type: {
      type: String | Number,
      default: 0,
    },
  },
  data() {
    return {
      loading: false,
      currentPage: 1,
      dateRange: [],
      list: [],
      total: 0,
    }
  },
  computed: {},
  watch: {
    queryChat() {
      this.getList(1)
    },
  },
  created() {
    this.getList(1)
  },
  mounted() {},
  methods: {
    setDate(start, end) {
      return diffDate(end, parseTime(start))
    },
    getList(page) {
      // if (!this.queryChat.fromId) {
      //   return //没有选择人
      // }
      this.loading = true
      let query = {
        msgType: this.type == 'all' ? '' : this.type,
      }
      // if (this.dateRange) {
      //   query.beginTime = this.dateRange[0]
      //   query.endTime = this.dateRange[1]
      // } else {
      //   query.beginTime = ''
      //   query.endTime = ''
      // }
      page && (query.pageNum = this.currentPage = page)
      Object.assign(query, this.queryChat)
      statisticRecordList(query)
        .then((res) => {
          // this.total = ~~res.total
          this.list = res.data
          this.loading = false
        })
        .catch((err) => {
          this.loading = false
        })
    },
    filterSize(size) {
      if (!size) return ''
      if (size < pow1024(1)) return size + ' B'
      if (size < pow1024(2)) return (size / pow1024(1)).toFixed(2) + ' KB'
      if (size < pow1024(3)) return (size / pow1024(2)).toFixed(2) + ' MB'
      if (size < pow1024(4)) return (size / pow1024(3)).toFixed(2) + ' GB'
      return (size / pow1024(4)).toFixed(2) + ' TB'
      function pow1024(num) {
        return Math.pow(1024, num)
      }
    },
    downloadFile(row) {
      this.$confirm('是否确认下载该文件?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then((response) => {
          this.downloadNet(JSON.parse(row.contact).attachment, JSON.parse(row.contact).filename)
        })
        .catch(function () {})
    },
  },
}
</script>

<style lang="scss" scoped>
.list {
  height: calc(100vh - 420px);
  margin-top: 10px;
  background: var(--bg-white);
  overflow-y: scroll;
  border-bottom: 1px solid var(--border-black-10);
  color: var(--font-black-6);
  text-align: center;

  ::-webkit-scrollbar {
    display: none;
  }
}
.chatListClassTab {
  padding: 10px 10px 0;
  background: var(--bg-white);
  text-align: left;
}
</style>
