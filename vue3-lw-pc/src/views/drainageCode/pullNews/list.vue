<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="80px">
      <el-form-item label-width="0" prop="qrName">
        <el-input clearable v-model="query.qrName" placeholder="请输入活码名称"></el-input>
      </el-form-item>
      <el-form-item label-width="0" prop="type">
        <el-select v-model="query.type" placeholder="请选择拉新方式">
          <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button type="" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="fxbw">
        <el-button type="primary" @click="$router.push('/drainageCode/qrCode/pullNews/add')">新建活码</el-button>
        <div>
          <!-- <el-button
            type="primary"
            plain
            :disabled="multiGroupCode.length === 0"
            @click="handleBulkDownload"
          >
            批量下载
          </el-button> -->
          <el-button type="primary" plain :disabled="multiGroupCode.length === 0" @click="handleBulkRemove">
            批量删除
          </el-button>
        </div>
      </div>
      <el-table :data="groupCodes" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="name" label="活码名称" align="center"></el-table-column>
        <el-table-column prop="type" label="拉新方式" align="center">
          <template #default="{ row }">
            {{ row.type === 1 ? '红包拉新' : '卡券拉新' }}
          </template>
        </el-table-column>
        <el-table-column prop="imageUrl" label="二维码" align="center" width="130">
          <template #default="{ row }">
            <el-popover placement="bottom" trigger="hover">
              <template #reference><el-image :src="row.imageUrl" class="code-image--small"></el-image></template>
              <el-image :src="row.imageUrl" class="code-image"></el-image>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="scanNum" width="160px" label="新增客户总数" align="center">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  新增客户总数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>通过当前活码新增的客户总数</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="receiveNum" width="160px" label="新客领取总数" align="center">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  新客领取总数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>新增客户领取的红包/卡券总数</div>
            </el-popover>
          </template>
        </el-table-column>

        <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
        <el-table-column prop="updateTime" label="最近操作时间" align="center" width="200"></el-table-column>
        <el-table-column label="操作" align="center" width="180" fixed="right">
          <template #default="{ row }">
            <el-button
              text
              @click="
                $router.push({
                  path: 'detail',
                  query: { groupId: row.id },
                })
              ">
              详情|统计
            </el-button>
            <el-button text @click="handleDownload(row.imageUrl, row.name)">下载</el-button>
            <el-button text class="copy-btn" :data-clipboard-text="row.imageUrl">复制</el-button>
            <el-dropdown style="margin-left: 10px">
              <el-button text>
                <el-icon-MoreFilled class="el-icon-MoreFilled"></el-icon-MoreFilled>
              </el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item>
                    <el-button
                      text
                      @click="
                        $router.push({
                          path: 'add',
                          query: {
                            groupCodeId: row.id,
                          },
                        })
                      ">
                      编辑
                    </el-button>
                  </el-dropdown-item>
                  <el-dropdown-item>
                    <el-button text @click="handleRemove(row.id)">删除</el-button>
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getGroupCodes" />
    </div>
  </div>
</template>

<script>
import { getList, remove, downloadBatch, download } from '@/api/drainageCode/pullNews'

import ShowTag from '@/components/common/ShowTag.vue'
export default {
  components: { ShowTag },
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        qrName: '',
        type: '',
      },
      options: [
        {
          value: '1',
          label: '红包拉新',
        },
        {
          value: '2',
          label: '卡券拉新',
        },
      ],
      // tagNames: '',
      loading: false,
      searchDate: '', // 查询日期
      multiGroupCode: [], // 多选数据
      groupCodes: [], // 群活码数据
      total: 0, // 总数据量
      // realCodeDialog: false, // 实际群码总数dialog
      // openGroupCodeId: null, // 打开实际群码关联的群活码ID
      // openGroupCodeStatus: -1, // 打开实际群码的检索状态
      clipboard: null, // 拷贝对象
      showSelectTag: false,
      // tagList: [],
      tagIndex: 1,
      // tableList: [],
      loading: false,
      // detailDialog: false,
    }
  },
  watch: {
    searchDate: {
      deep: true,
      handler(dateRange) {
        if (!dateRange || dateRange.length !== 2) {
          this.query.beginTime = ''
          this.query.endTime = ''
        } else {
          ;[this.query.beginTime, this.query.endTime] = dateRange
        }
      },
    },
    // 如果实际群码弹出框关闭,刷新数据
    // realCodeDialog(val) {
    //   if (val === false) this.getGroupCodes()
    // },
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  created() {
    this.getGroupCodes()
    this.$store.setBusininessDesc(
      `
        <div>通过红包、卡券等方式吸引新客户扫码添加</div>
      `,
    )
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    // getDetail(id) {
    //   // this.detailDialog = true
    //   this.loading = true
    //   getTableTotal(id).then((res) => {
    //     this.tableList = res.data
    //     this.loading = false
    //   })
    // },
    // getSelectTag(list) {
    //   this.taglist = list
    //   let arr = []
    //   let arr1 = []
    //   list.forEach((dd) => {
    //     arr.push(dd.name)
    //     arr1.push(dd.tagId)
    //   })
    //   this.tagNames = arr.join(',')
    //   this.query.tagIds = arr1.join(',')
    // },
    // 获取活码数据
    getGroupCodes() {
      const params = Object.assign({}, this.query)
      this.loading = true
      getList(params)
        .then((res) => {
          if (res.code === 200) {
            this.groupCodes = res.rows
            this.total = parseInt(res.total)
          }
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 查询
    handleSearch() {
      this.getGroupCodes()
    },
    // 搜索栏清空
    resetQuery() {
      this.$refs['queryForm'].resetFields()
      // this.tagNames = ''
      // this.tagList = []
      this.$nextTick(() => {
        this.getGroupCodes()
      })
    },
    // 批量下载
    handleBulkDownload() {
      const ids = this.multiGroupCode.map((group) => group.id)
      this.$confirm('是否确认下载所有图片吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return downloadBatch(ids + '')
        })
        .then((res) => {
          if (res != null) {
            let blob = new Blob([res], { type: 'application/zip' })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '批量群活码.zip' // 重命名文件
            link.click()
            URL.revokeObjectURL(url) // 释放内存
          }
        })
        .catch(function () {})
    },
    // 批量删除
    handleBulkRemove() {
      this.$confirm('确认删除当前拉新活码?删除操作无法撤销，请谨慎操作。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          const ids = this.multiGroupCode.map((group) => group.id)
          remove(ids + '').then((res) => {
            if (res.code === 200) {
              this.getGroupCodes()
            } else {
            }
          })
        })
        .catch(() => {})
    },
    // 下载
    handleDownload(url, qrname) {
      let name = qrname + '.png'
      this.downloadByBlob(url, name)
    },
    downloadByBlob(url, name) {
      let image = new Image()
      image.setAttribute('crossOrigin', 'anonymous')
      image.src = url
      image.onload = () => {
        let canvas = document.createElement('canvas')
        canvas.width = image.width
        canvas.height = image.height
        let ctx = canvas.getContext('2d')
        ctx.drawImage(image, 0, 0, image.width, image.height)
        canvas.toBlob((blob) => {
          let url = URL.createObjectURL(blob)
          this.downloadFn(url, name)
          // 用完释放URL对象
          URL.revokeObjectURL(url)
        })
      }
    },
    downloadFn(href, name) {
      let eleLink = document.createElement('a')
      eleLink.download = name
      eleLink.href = href
      eleLink.click()
      eleLink.remove()
    },
    // 删除
    handleRemove(codeId) {
      this.$confirm('确认删除当前拉新活码?删除操作无法撤销，请谨慎操作。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          remove(codeId).then((res) => {
            if (res.code === 200) {
              this.getGroupCodes()
            } else {
            }
          })
        })
        .catch(() => {})
    },
    // 处理多选
    handleSelectionChange(val) {
      this.multiGroupCode = val
    },
    // 打开实际群码窗口
    // handleRealCodeDialogOpen(groupCodeId, status) {
    //   this.openGroupCodeId = groupCodeId
    //   this.openGroupCodeStatus = status
    //   this.realCodeDialog = true
    // },
  },
}
</script>

<style scoped lang="scss">
.overflow-ellipsis {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.table-desc {
  max-width: 150px;
}
.code-image {
  width: 200px;
  height: 200px;
}
.code-image--small {
  width: 50px;
  height: 50px;
}
.expire-icon {
  color: red;
}
</style>
