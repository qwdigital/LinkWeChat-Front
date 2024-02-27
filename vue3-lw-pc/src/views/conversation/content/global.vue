<template>
  <div>
    <el-form :inline="true" :model="query" class="top-search" style="top: 40px">
      <el-form-item label="员工名称">
        <el-input v-model="query.userName" clearable placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="客户名称">
        <el-input v-model="query.customerName" clearable placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="查找内容">
        <el-input v-model="query.contact" clearable placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="时间范围">
        <el-date-picker
          clearable
          v-model="dateRange"
          type="daterange"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"
          v-bind="pickerOptions"></el-date-picker>
      </el-form-item>
      <el-form-item label="消息状态">
        <el-select v-model="query.action" class="noborder">
          <el-option
            v-for="item in displayOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetFn">重置</el-button>
      </el-form-item>
      <el-form-item style="float: right">
        <el-button type="primary" @click="exportList()">导出列表</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <el-table v-loading="loading" :data="fileData">
        <el-table-column prop="date" label="发送者" width="180">
          <template #default="scope">
            <p v-if="scope.row">{{ scope.row.name }}</p>
          </template>
        </el-table-column>
        <el-table-column prop="name" label=" 内容">
          <template #default="{ row }">
            <ChatContent :message="row" class="ml0" style="background: var(--bg-black-10)"></ChatContent>
          </template>
        </el-table-column>
        <el-table-column label="消息状态" width="200">
          <template #default="scope">
            <div class="pers">
              <span v-if="scope.row.action == ''"></span>
              <span v-else-if="scope.row.action == 'send'">
                <span class="green"></span>
                已发送
              </span>
              <span v-else-if="scope.row.action == 'recall'">
                <span class="red"></span>
                已撤回
              </span>
              <span v-else-if="scope.row.action == 'switch'">
                <span class="gay"></span>
                企业日志
              </span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="address" label="发送时间" width="200">
          <template #default="scope">
            {{ scope.row.msgTime }}
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()" />
    </div>
  </div>
</template>
<script>
import { getChatList, exportList } from '@/api/conversation/content.js'
import ChatContent from '@/components/ChatContent'
import { dateFormat } from '@/utils/index'

export default {
  components: { ChatContent },
  data() {
    return {
      query: {
        action: '',
        userName: '',
        customerName: '',
        contact: '',
        beginTime: '',
        endTime: '',
        pageNum: 1,
        pageSize: 10,
        orderByColumn: 't.msg_time',
        isAsc: 'desc', // asc 升序 desc 降序
        fullSearch: 1,
      },
      dateRange: [],
      total: 0,
      fileData: [],
      floorRange: '全部',
      displayOptions: [
        {
          value: '',
          label: '全部',
        },
        {
          value: 'send',
          label: '已发送',
        },
        {
          value: 'recall',
          label: '已撤回',
        },
        {
          value: 'switch',
          label: '切回企业日志',
        },
      ],
      loading: false,
    }
  },
  created() {
    this.getList()
  },
  methods: {
    resetFn() {
      this.dateRange = []
      this.query = {
        action: '',
        userName: '',
        customerName: '',
        contact: '',
        beginTime: '',
        endTime: '',
        pageNum: 1,
        pageSize: 10,
        orderByColumn: 't.msg_time',
        isAsc: 'desc',
      }
      this.getList(1)
    },
    getList(page) {
      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0]
        this.query.endTime = this.dateRange[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
      page && (this.query.pageNum = page)
      this.loading = true
      getChatList(this.query)
        .then((res) => {
          this.fileData = res.rows
          this.total = ~~res.total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    parseMesContent(data, type) {
      let contact = JSON.parse(data)
      let typeDict = {
        text: 'content',
        image: 'attachment',
        text: 'content',
      }
      return contact[type]
    },
    exportList() {
      this.$confirm('是否确认导出所有数据项?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return exportList(this.query)
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' })

          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '内容存档')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_内容存档.xlsx' //指定下载文件名
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
        })
        .catch(function () {})
    },
  },
}
</script>
<style lang="scss" scoped>
.demo-form-inline {
  background: var(--bg-black-10);
  padding: 18px 10px 0 10px;
}

.content {
  margin-top: 15px;
  padding: 10px;
}

.pers {
  position: relative;

  .green {
    background: greenyellow;
    position: absolute;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    top: 10px;
    left: -8px;
  }

  .red {
    background: red;
    position: absolute;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    top: 10px;
    left: -8px;
  }

  .gay {
    background: gray;
    position: absolute;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    top: 10px;
    left: -8px;
  }
}

.noborder {
  ::v-deep .el-input--mini .el-input__inner {
    width: 2px;
    border: none;
  }
}

.emcode ::v-deep em {
  color: #ff0000;
}
</style>
