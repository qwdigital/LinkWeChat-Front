<script>
import { getList, getDetailList, remove } from './api'

export default {
  props: {},
  components: { Preview: defineAsyncComponent(() => import('./Preview')) },
  data() {
    return {
      getList,
      getDetailList,
      remove,
      dialogVisible: false,
      detail: {},
      preview: {
        dialogVisible: false,
        data: {},
      },
    }
  },
  watch: {},
  created() {
    this.$store.setBusininessDesc(`<div>聚合多个群活码，生成落地页，客户在页面内根据关键词进入相应群聊</div>`)
  },
  mounted() {},
  methods: {},
}
</script>

<template>
  <div>
    <RequestChartTable ref="rct" :params="query" :request="getList">
      <template #query="{ query }">
        <el-form-item label="链接标题" prop="title">
          <el-input clearable v-model="query.title" placeholder="请输入"></el-input>
        </el-form-item>
      </template>

      <template #operation="{ selectedIds }">
        <div class="fxbw">
          <el-button type="primary" @click="$refs.rct.goRoute()">新建链接</el-button>
          <el-button @click="$refs.rct.remove(remove)" type="danger">批量删除</el-button>
        </div>
      </template>

      <template #table>
        <el-table-column label="链接标题" align="center" prop="title" show-overflow-tooltip />
        <el-table-column label="链接描述" align="center" prop="descrition" show-overflow-tooltip />
        <el-table-column label="关键词" align="center" width="120">
          <template #default="{ row }">
            <div class="g-color cp" @click=";(detail = row), (dialogVisible = true)">
              {{ row.keyWordGroupNumber || 0 }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="访问客户数/进群客户数" align="center" prop="cusNumber" width="">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  访问客户数/进群客户数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>访问客户数：访问当前链接的客户总数（去重）；</div>
              <div>进群客户数：访问客户中成功进群的总数（去重）；</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <div class="g-color cp" @click="$refs.rct.goRoute('detail', { id: row.id, index: 1 })">
              {{ row.totalViewNumber }}/{{ row.totalJoinGroupNmber }}
            </div>
          </template>
        </el-table-column>

        <el-table-column label="最近更新" align="center" prop="updateTime">
          <template #default="{ row }">
            {{ row.updateBy }}
            <br />
            {{ row.updateTime }}
          </template>
        </el-table-column>

        <el-table-column label="操作" align="center" fixed="right">
          <template #default="{ row }">
            <el-button text @click="$refs.rct.goRoute('detail', row.id)">详情|统计</el-button>
            <el-button text @click="$refs.rct.goRoute('aev', row.id)">编辑</el-button>
            <el-button text @click=";(preview.data = row), (preview.dialogVisible = true)">预览</el-button>
            <el-button text @click="$refs.rct.remove(remove, row.id)">删除</el-button>
          </template>
        </el-table-column>
      </template>
    </RequestChartTable>

    <!-- 关键词列表弹窗 -->
    <el-dialog title="关键词" v-model="dialogVisible" destroy-on-close>
      <RequestChartTable
        ref="RequestChartTableDialog"
        style="padding: 0 0 20px"
        :params="{ keywordGroupId: detail.id }"
        :request="getDetailList">
        <template #="{ data }">
          <el-table :data="data">
            <el-table-column label="关键词" align="center" prop="keyword"></el-table-column>
            <el-table-column align="center" prop="codeName" label="群活码">
              <template #default="{ row }">
                <div>{{ row.codeName || '—' }}</div>
                <el-image :src="row.groupCodeUrl" style="width: 100px"></el-image>
              </template>
            </el-table-column>
            <!-- <el-table-column label="活码客群数" align="center">
              <template #default="{ row }">
                <div
                  class="g-color cp"
                  @click="
                    $router.push({
                      name: lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
                      query: { externalUserid: row.externalUserid, userId: row.addUserId },
                    })
                  ">
                  客户详情
                </div>
              </template>
            </el-table-column> -->
          </el-table>
        </template>
      </RequestChartTable>
    </el-dialog>

    <!-- 预览弹窗 -->
    <el-dialog title="预览" v-model="preview.dialogVisible" width="auto">
      <Preview :data="preview.data" />
      <div class="ac mt20">
        <el-button
          type="primary"
          plain
          @click="downloadBlob(preview.data.keywordGroupQrUrl, preview.data.title + '.png', 'image')">
          下载二维码
        </el-button>
        <el-button type="primary" @click="$copyText(preview.data.keywordGroupUrl)">复制链接</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss"></style>
