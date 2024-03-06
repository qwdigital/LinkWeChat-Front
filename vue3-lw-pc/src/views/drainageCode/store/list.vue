<template>
  <div>
    <div class="tab flex">
      <div class="g-card mr20 fxauto">
        <div class="g-card-title">
          门店导购码
          <span class="desc mr10">根据客户最近位置，引导添加最近门店的导购</span>
        </div>
        <div class="unit_content" v-loading="storeLoading">
          <div class="value" v-if="storeGuide.storeCodeConfigQr">
            <img style="height: 80px; width: 80px" :src="storeGuide.storeCodeConfigQr" />
            <div class="con">
              门店范围：距离门店{{ storeGuide.raidus }}公里内，客户可扫码添加门店导购
              <div class="operate">
                <div>
                  <el-button
                    type="primary"
                    @click="downloadBlob(storeGuide.storeCodeConfigQr, '门店导购码.jpg', 'image')">
                    下载活码
                  </el-button>
                  <el-button type="primary" plain @click="$copyText(storeGuide.storeCodeConfigUrl)">复制链接</el-button>
                </div>
                <el-button text @click="goRoute('guideDetail')">详情|统计>></el-button>
              </div>
            </div>
          </div>
          <div class="empty" v-else>
            <el-button type="primary" icon="el-icon-plus" @click="addNow('guideCode')">立即新建</el-button>
          </div>
        </div>
      </div>
      <div class="g-card mt0 fxauto">
        <div class="g-card-title">
          门店群活码
          <span class="desc mr10">根据客户最近位置，引导添加最近门店的客户群</span>
        </div>
        <div class="unit_content" v-loading="guideLoading">
          <div class="value" v-if="storeCode.storeCodeConfigQr">
            <img style="height: 80px; width: 80px" :src="storeCode.storeCodeConfigQr" />
            <div class="con">
              门店范围：距离门店{{ storeCode.raidus }}公里内，客户可扫码添加门店群
              <div class="operate">
                <div>
                  <el-button
                    type="primary"
                    @click="downloadBlob(storeCode.storeCodeConfigQr, '门店群活码.jpg', 'image')">
                    下载活码
                  </el-button>
                  <el-button type="primary" plain @click="$copyText(storeCode.storeCodeConfigUrl)">复制链接</el-button>
                </div>
                <el-button text @click="goRoute('storeDetail')">详情|统计>></el-button>
              </div>
            </div>
          </div>
          <div class="empty" v-else>
            <el-button type="primary" icon="el-icon-plus" @click="addNow('storeCode')">立即新建</el-button>
          </div>
        </div>
      </div>
    </div>

    <RequestChartTable class="g-margin-t" ref="rct" :params="query" :request="getList" @reset="reset">
      <template #query="{ query }">
        <el-form-item label="门店名称" prop="storeName">
          <el-input v-model="query.storeName" placeholder="请输入门店名称" clearable />
        </el-form-item>
        <el-form-item label="所属地区">
          <el-cascader
            v-model="areaIds"
            :props="props"
            :options="cityTree"
            ref="tree"
            @change="handleChange"></el-cascader>
        </el-form-item>
        <el-form-item label="状态" prop="storeState">
          <el-select v-model="query.storeState" :popper-append-to-body="false">
            <el-option label="全部状态" value=""></el-option>
            <el-option label="启用" value="0"></el-option>
            <el-option label="停用" value="1"></el-option>
          </el-select>
        </el-form-item>
      </template>

      <template #operation="{ selectedIds }">
        <div class="fxbw">
          <div>
            <el-button type="primary" @click="goRoute('add')">新建</el-button>
            <el-button type="primary" plain @click="importDialogVisible = true">批量导入</el-button>
          </div>
          <div>
            <el-button type="primary" plain @click="switchMultFn('启用', selectedIds)">批量启用</el-button>
            <el-button type="primary" plain @click="switchMultFn('停用', selectedIds)">批量停用</el-button>
            <el-button type="primary" plain @click="$refs.rct.remove(remove)">批量删除</el-button>
          </div>
        </div>
      </template>

      <template #table>
        <el-table-column label="门店名称" align="center" prop="storeName" show-overflow-tooltip />
        <el-table-column label="所属地区" align="center" prop="area" show-overflow-tooltip />
        <el-table-column label="详细地址" align="center" prop="address"></el-table-column>
        <el-table-column label="门店状态" align="center" prop="storeState" show-overflow-tooltip>
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  门店状态
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>
                门店状态开启时必须要求保证导购人员或群活码至少设置一项；启用后，范围内的客户扫码可正常添加门店导购或群活码；停用后，扫码无法就近添加
              </div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <el-switch
              @change="switchFn(row)"
              v-model="row.storeState"
              :active-value="0"
              :inactive-value="1"></el-switch>
          </template>
        </el-table-column>
        <el-table-column label="门店导购" align="center" prop="shopGuideName">
          <template #default="{ row }">
            <TagEllipsis :list="row.shopGuideName" emptyText="-" />
          </template>
        </el-table-column>
        <el-table-column label="门店群活码" align="center" prop="groupCodeName" show-overflow-tooltip>
          <template #default="{ row }">
            <template v-if="row.groupCodeName">
              <div class="mb5">{{ row.groupCodeName }}</div>
              <img style="height: 80px; width: 80px" :src="row.groupCodeUrl" />
            </template>
            <div v-else>-</div>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right">
          <template #default="{ row }">
            <el-button text @click="goRoute('detail', row.id)">详情|统计</el-button>
            <el-button text @click="goRoute('add', row.id)">编辑</el-button>
            <el-button text @click="$refs.rct.remove(remove, row.id)">删除</el-button>
          </template>
        </el-table-column>
      </template>
    </RequestChartTable>
    <import-store v-model:visible="importDialogVisible" @update="$refs.rct.getList(1)"></import-store>
  </div>
</template>
<script>
import { getProCityList } from '@/api/common'
import ImportStore from '../components/ImportStore'
import { getCode, getTableList, deleteStore, updateState, downloadUrl } from '@/api/drainageCode/store'
export default {
  name: 'store-list',
  data() {
    return {
      getList: getTableList,
      remove: deleteStore,
      list: [],
      total: 0,
      ids: [],
      loading: false,
      areaIds: [],
      query: { area: '' },
      cityTree: [],
      props: {
        label: 'name',
        value: 'id',
      },
      importDialogVisible: false,
      storeCode: {
        raidus: '',
        storeCodeConfigUrl: '',
        storeCodeConfigQr: '',
      },
      storeGuide: {
        raidus: '',
        storeCodeConfigUrl: '',
        storeCodeConfigQr: '',
      },
      storeLoading: false,
      guideLoading: false,
    }
  },
  components: {
    ImportStore,
  },
  created() {
    this.$store.setBusininessDesc(
      `
        <div>生成永久二维码，客户扫码后根据定位加入附近门店店主或门店群</div>
      `,
    )
    getProCityList({ isExtName: true }).then(({ data }) => {
      this.cityTree = data
    })
    this.guideLoading = true
    getCode(1).then(({ data }) => {
      this.storeGuide = data
      this.guideLoading = false
    })
    this.storeLoading = true
    getCode(2).then(({ data }) => {
      this.storeCode = data
      this.storeLoading = false
    })
  },
  methods: {
    switchFn(data) {
      if (data.shopGuideName || data.groupCodeName) {
        updateState(data.id, { storeState: data.storeState }).then((res) => {
          this.$refs.rct.getList()
        })
      } else {
        data.storeState = data.storeState == 1 ? 0 : 1
        this.msgError('开启门店必须要求保证导购人员或群活码至少设置一项')
      }
    },
    switchMultFn(type, selectedIds) {
      if (!selectedIds.length) {
        this.msgInfo('请选择要操作项！')
        return
      }
      if (!this.storeCode.storeCodeConfigQr && !this.storeGuide.storeCodeConfigQr) {
        this.msgInfo('门店导购及群活码都未配置, 无法操作！')
        return
      }
      const ids = selectedIds.join(',')
      this.$confirm(`是否确认批量${type}已选门店？${type}后立即生效，请谨慎操作。`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return updateState(ids, { storeState: type === '启用' ? 0 : 1 })
        })
        .then(() => {
          this.$refs.rct.getList()
          this.msgSuccess('操作成功')
        })
        .catch(function () {})
    },
    addNow(type) {
      if (this.$refs.rct.data?.length) {
        this.goRoute(type)
      } else {
        this.$confirm(
          `暂无可用门店，请先创建门店后再尝试创建${type === 'guideCode' ? '门店导购码' : '门店群活码'}。`,
          '提示',
          {
            confirmButtonText: '去新建',
            cancelButtonText: '取消',
            type: 'warning',
          },
        )
          .then(() => {
            return this.goRoute('add')
          })
          .catch(function () {})
      }
    },
    reset() {
      this.areaIds = []
      this.query = { area: '' }
    },
    handleChange(data) {
      let arr = this.$refs.tree.getCheckedNodes()
      if (arr[0]) {
        this.query.area = arr[0].pathLabels.join('')
      }
    },
    goRoute(path, id) {
      this.$router.push({ path: path, query: { id } })
    },
  },
}
</script>
<style lang="scss" scoped>
.tab {
  .unit_content {
    margin-top: 20px;
    height: 80px;
    .empty {
      display: flex;
      align-items: center;
      margin: auto 0;
      height: 100%;
      justify-content: space-around;
    }
    .value {
      display: flex;
      .con {
        width: 100%;
        margin-left: 20px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        .operate {
          display: flex;
          justify-content: space-between;
        }
      }
    }
  }
}
</style>
