<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left">
      <el-form-item label="链接名称" prop="linkName">
        <el-input v-model="query.linkName" placeholder="请输入链接名称"></el-input>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <div style="display: flex; align-items: end;">
          <template v-if="customerLinkMargin">
            <el-button type="primary" @click="$router.push('./add')">新建链接</el-button>
          </template>
          <template v-else>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  <el-button type="primary" disabled>新建链接</el-button>
                </div>
              </template>
              <div>最多创建3000个链接。</div>
            </el-popover>
          </template>
          <span style="margin-left: 10px; font-size: 12px;"
            >剩余可用量
            <span style="font-size: 20px;"
              >{{ customerLinkMargin }}
              <span class="refresh" :class="{ rotate360: showAnimate }" @click="refreshFn">
                <el-icon-Refresh class="el-icon-refresh"></el-icon-Refresh> </span
            ></span>
          </span>
        </div>
        <el-button type="primary" plain :disabled="selected.length === 0" @click="handleRemove('mult')"
          >批量删除</el-button
        >
      </div>
      <el-table :data="list" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="linkName" label="链接名称" align="center"></el-table-column>
        <el-table-column prop="linkUrl" label="获客链接" align="center" minWidth="130">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  获客链接
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>企微官方的获客长链接，可直接使用</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <div>
              {{ row.linkUrl }}
              <el-button text @click="copyFn(row.linkUrl)">复制</el-button>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="linkShortUrl" label="获客短链" align="center" minWidth="130">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  获客短链
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>系统生成的获客短链，满足短链场景</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <div>
              {{ row.linkShortUrl }}
              <el-button text @click="copyFn(row.linkShortUrl)">复制</el-button>
            </div>
          </template>
        </el-table-column>
        <!-- <el-table-column prop="createBy" label="创建人" align="center"></el-table-column> -->
        <el-table-column prop="updateTime" label="最近更新" align="center" width="160"></el-table-column>
        <el-table-column label="操作" align="center" width="200" fixed="right">
          <template #default="{ row }">
            <el-button
              text
              @click="
                $router.push({
                  path: 'detail',
                  query: { linkId: row.linkId, id: row.id }
                })
              "
            >
              详情统计
            </el-button>
            <el-button
              text
              @click="
                $router.push({
                  path: 'add',
                  query: {
                    id: row.id
                  }
                })
              "
            >
              编辑
            </el-button>
            <el-button text @click="handleRemove('single', row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getListFn"
      />
    </div>
  </div>
</template>

<script>
  import { getDetail } from '@/api/enterpriseId'
  import { getList, remove, refresh } from './api.js'
  export default {
    components: {},
    data() {
      return {
        query: {
          pageNum: 1,
          pageSize: 10,
          linkName: ''
        },
        selected: [],
        loading: false,
        list: [],
        total: 0, // 总数据量
        customerLinkMargin: 0,
        showAnimate: false
      }
    },
    watch: {},
    mounted() {},
    created() {
      this.getListFn()
      this.$store.setBusininessDesc(
        `
        <div>唯一可以从全域添加好友的官方链路</div>
      `
      )
      this.getData()
    },
    destroyed() {},
    methods: {
      getData() {
        getDetail().then((res) => {
          this.customerLinkMargin = Number(res.data.customerLinkMargin)
        })
      },
      refreshFn() {
        this.showAnimate = true
        refresh().then((res) => {
          if (res.code == 200) {
            this.getData()
            // this.$message({ message: '操作成功', type: 'success' })
            this.msgSuccess('操作成功')
          }
          this.showAnimate = false
        })
      },
      copyFn(text) {
        const input = document.createElement('input')
        input.style.cssText = 'opacity: 0;'
        input.type = 'text'
        input.value = text // 修改文本框的内容
        document.body.appendChild(input)
        input.select() // 选中文本
        document.execCommand('copy') // 执行浏览器复制命令
        this.$message({ message: '复制成功', type: 'success' })
      },
      getListFn() {
        const params = Object.assign({}, this.query)
        this.loading = true
        getList(params)
          .then((res) => {
            if (res.code === 200) {
              this.list = res.rows
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
        this.query.pageNum = 1
        this.getListFn()
      },
      // 搜索栏清空
      resetQuery() {
        this.$refs['queryForm'].resetFields()
        this.$nextTick(() => {
          this.handleSearch()
        })
      },
      // 删除
      handleRemove(type, id) {
        if (type === 'mult' && !this.selected.length) {
          this.msgInfo('请选择要删除项！')
          return
        }
        const ids = id || this.selected.join(',')
        this.$confirm('是否确认删除当前获客链接？删除后链接立即停用，该操作不可撤销，请谨慎操作。', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            remove(ids).then((res) => {
              if (res.code === 200) {
                this.getListFn()
              } else {
              }
            })
          })
          .catch(() => {})
      },
      // 处理多选
      handleSelectionChange(val) {
        this.selected = val.map((item) => item.id)
      }
    }
  }
</script>

<style scoped lang="scss">
  .refresh {
    color: var(--color);
    font-size: 16px;
    cursor: pointer;
    :hover {
      opacity: 0.7;
    }
    display: inline-block;
  }

  .rotate360 {
    animation: rotate360 1s ease-out 0s;
  }
  @keyframes rotate360 {
    100% {
      transform: rotate(360deg);
    }
  }
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
