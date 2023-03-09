<template>
  <div>
    <div class="tab flex">
      <div class="g-card mr20 flex1">
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
                  <el-button type="primary" size="mini" @click="downloadUrlFn(1, '门店导购码.jpg')">下载活码</el-button>
                  <el-button type="primary" plain size="mini" @click="handleCopy(storeGuide.storeCodeConfigUrl)">
                    复制链接
                  </el-button>
                </div>
                <el-button type="text" @click="goRoute('guideDetail')">详情>></el-button>
              </div>
            </div>
          </div>
          <div class="empty" v-else>
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="addNow('guideCode')">立即新建</el-button>
          </div>
        </div>
      </div>
      <div class="g-card mt0 flex1">
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
                  <el-button type="primary" size="mini" @click="downloadUrlFn(2, '门店群活码.jpg')">下载活码</el-button>
                  <el-button type="primary" plain size="mini" @click="handleCopy(storeCode.storeCodeConfigUrl)">
                    复制链接
                  </el-button>
                </div>
                <el-button type="text" @click="goRoute('storeDetail')">详情>></el-button>
              </div>
            </div>
          </div>
          <div class="empty" v-else>
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="addNow('storeCode')">立即新建</el-button>
          </div>
        </div>
      </div>
    </div>
    <el-form :inline="true" label-width="80px" label-position="left" class="top-search mt20">
      <el-form-item label="门店名称">
        <el-input v-model="query.storeName" placeholder="请输入门店名称" clearable @keyup.enter.native="search()" />
      </el-form-item>
      <el-form-item label="所属地区">
        <el-cascader
          v-model="areaIds"
          :props="props"
          :options="cityTree"
          ref="tree"
          @change="handleChange"></el-cascader>
      </el-form-item>
      <el-form-item label="状态" label-width="40px">
        <el-select v-model="query.storeState" :popper-append-to-body="false">
          <el-option label="全部状态" value=""></el-option>
          <el-option label="启用" value="0"></el-option>
          <el-option label="停用" value="1"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" @click="search">查询</el-button>
        <el-button @click="resetFn">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <div>
          <el-button type="primary" size="mini" @click="goRoute('add')">新建</el-button>
          <el-button type="primary" plain size="mini" @click="importDialogVisible = true">批量导入</el-button>
        </div>
        <div>
          <el-button type="primary" plain size="mini" @click="switchMultFn('启用')">批量启用</el-button>
          <el-button type="primary" plain size="mini" @click="switchMultFn('停用')">批量停用</el-button>
          <el-button type="primary" plain size="mini" @click="removeFn('mult')">批量删除</el-button>
        </div>
      </div>
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange" style="width: 100%">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="门店名称" align="center" min-width="100" prop="storeName" show-overflow-tooltip />
        <el-table-column label="所属地区" align="center" min-width="120" prop="area" show-overflow-tooltip />
        <el-table-column label="详细地址" align="center" prop="address" width="180"></el-table-column>
        <el-table-column label="门店状态" align="center" min-width="100" prop="storeState" show-overflow-tooltip>
          <template slot="header">
            <el-popover placement="top" trigger="hover">
              <div slot="reference">
                门店状态
                <i class="el-icon-question"></i>
              </div>
              <div>启用后，范围内的客户扫码可正常添加门店导购或群活码；停用后，扫码无法就近添加</div>
            </el-popover>
          </template>
          <template slot-scope="{ row }">
            <el-switch
              size="mini"
              :disabled="!row.shopGuideId && !row.groupCodeId"
              @change="switchFn(row)"
              v-model="row.storeState"
              :active-value="0"
              :inactive-value="1"></el-switch>
          </template>
        </el-table-column>
        <el-table-column label="门店导购" align="center" prop="shopGuideName" min-width="160px">
          <template slot-scope="{ row }">
            <div v-if="row.shopGuideName">
              <TagEllipsis :list="row.shopGuideName.split(',')" />
            </div>
            <div v-else>-</div>
          </template>
        </el-table-column>
        <el-table-column label="门店群活码" align="center" min-width="100" prop="groupCodeName" show-overflow-tooltip>
          <template slot-scope="{ row }">
            <div v-if="row.groupCodeName">
              {{ row.groupCodeName }}
            </div>
            <div v-else>-</div>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180" class-name="small-padding fixed-width">
          <template slot-scope="{ row }">
            <el-button
              type="text"
              @click="
                $router.push({
                  path: 'detail',
                  query: {
                    id: row.id,
                  },
                })
              ">
              详情|统计
            </el-button>

            <el-button
              type="text"
              @click="
                $router.push({
                  path: 'add',
                  query: {
                    id: row.id,
                  },
                })
              ">
              编辑
            </el-button>

            <el-button type="text" @click="removeFn('single', row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
    </div>
    <import-store :visible.sync="importDialogVisible" @update="search"></import-store>
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
      list: [],
      total: 0,
      ids: [],
      loading: false,
      areaIds: [],
      query: {
        storeName: '',
        area: '',
        storeState: null,
        pageNum: 1,
        pageSize: 10,
        orderByColumn: 'update_time',
        isAsc: 'desc',
      },
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
  methods: {
    downloadUrlFn(type, name) {
      downloadUrl({ storeCodeType: type }).then((res) => {
        if (res != null) {
          let blob = new Blob([res], {
            type: 'application/image',
          })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = name // 重命名文件
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
    handleCopy(text) {
      const input = document.createElement('input')
      input.style.cssText = 'opacity: 0;'
      input.type = 'text'
      input.value = text // 修改文本框的内容
      document.body.appendChild(input)
      input.select() // 选中文本
      document.execCommand('copy') // 执行浏览器复制命令
      this.$message({ message: '复制成功', type: 'success' })
    },
    switchFn(data) {
      updateState(data.id, { storeState: data.storeState }).then((res) => {
        if (res.code === 200) {
          this.getList()
        }
      })
    },
    switchMultFn(type) {
      if (!this.ids.length) {
        this.msgInfo('请选择要操作项！')
        return
      }
      if (!this.storeCode.storeCodeConfigQr && !this.storeGuide.storeCodeConfigQr) {
        this.msgInfo('门店导购及群活码都未配置, 无法操作！')
        return
      }
      const ids = this.ids.join(',')
      this.$confirm(`是否确认批量${type}已选门店？${type}后立即生效，请谨慎操作。`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return updateState(ids, { storeState: type === '启用' ? 0 : 1 })
        })
        .then(() => {
          this.getList()
          this.msgSuccess('操作成功')
        })
        .catch(function () {})
    },
    addNow(type) {
      if (this.list.length) {
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
    resetFn() {
      this.areaIds = []
      ;(this.query = {
        storeName: '',
        area: '',
        storeState: '',
        pageNum: 1,
        pageSize: 10,
      }),
        this.getList()
    },
    handleChange(data) {
      let arr = this.$refs.tree.getCheckedNodes()
      if (arr[0]) {
        this.query.area = arr[0].pathLabels.join('')
      }
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    getList() {
      this.loading = true
      getTableList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = Number(total)
          this.loading = false
          this.ids = []
        })
        .catch(() => {
          this.loading = false
        })
    },
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    goRoute(path, id) {
      this.$router.push({ path: path, query: { id } })
    },
    removeFn(type, id) {
      if (type === 'mult' && !this.ids.length) {
        this.msgInfo('请选择要删除项！')
        return
      }
      const ids = id || this.ids.join(',')
      this.$confirm('是否确认删除当前门店？删除后不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deleteStore(ids)
        })
        .then(() => {
          this.search()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
  },
  created() {
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>生成永久二维码，客户扫码后根据定位加入附近门店店主或门店群</div>
      `,
    )
    getProCityList({ isExtName: true }).then((res) => {
      if (res.code === 200) {
        this.cityTree = res.data
      }
    })
    this.guideLoading = true
    getCode(1).then((res) => {
      if (res.code === 200 && res.data) {
        this.storeGuide = res.data
      }
      this.guideLoading = false
    })
    this.storeLoading = true
    getCode(2).then((res) => {
      if (res.code === 200 && res.data) {
        this.storeCode = res.data
      }
      this.storeLoading = false
    })
    this.getList()
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
