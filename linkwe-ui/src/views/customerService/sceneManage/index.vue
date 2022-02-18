<template>
  <div class="g-card g-pad20">
    <el-form :inline="true" label-width="80px" label-position="left">
      <el-form-item label="场景名称">
        <el-input v-model="search.name" placeholder="请输入场景名称" clearable @keyup.enter.native="search()" />
      </el-form-item>
      <el-form-item label="所属客服" prop="">
        <el-select v-model="search.openKfId">
          <el-option value="" label="全部"></el-option>
          <el-option :value="unit.openKfId" :label="unit.name" v-for="(unit, key) in customerList" :key="key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="场景类型" prop="">
        <el-select v-model="search.type">
          <el-option value="" label="全部场景"></el-option>
          <el-option :value="unit.key" :label="unit.value" v-for="(unit, key) in typeList" :key="key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" @click="searchFn()">查询</el-button>
        <el-button @click="resetQuery" type="info" plain>清空</el-button>
      </el-form-item>
    </el-form>
    <div class="operation">
      <div class="item">
        <el-button type="primary" size="mini" @click="addFn()">新建场景</el-button>
      </div>
      <div class="item">
        <el-button type="primary" plain size="mini" @click="downloadBatch">批量下载</el-button>
        <el-button type="primary" plain size="mini" @click="deleteFn()">批量删除</el-button>
      </div>
    </div>
    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange" style="margin-top:20px;width: 100%">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="场景名称" align="center" prop="name" min-width="100"></el-table-column>
      <el-table-column label="场景分类" align="center" min-width="100" prop="type" show-overflow-tooltip>
        <template slot-scope="{ row }">
          {{setType(row.type)}}
        </template>
      </el-table-column>
      <el-table-column label="所属客服" align="center" min-width="160" prop="list">
        <template slot-scope="{ row }">
          <show-customer-service :url='row.kfAvatar' :name='row.kfName' showicon></show-customer-service>
        </template>
      </el-table-column>
      <el-table-column label="访问客户数" align="center" min-width="140" prop="accessCnt"></el-table-column>
      <el-table-column label="咨询客户数" align="center" min-width="140" prop="consultCnt"></el-table-column>
      <el-table-column label="接待客户数" align="center" min-width="140" prop="receptionCnt"></el-table-column>
      <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="230" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <el-button type="text" class="copy_btn" :id="'btn' + row.id" :data-clipboard-text="row.url" :data-clipboard-target="'#' + 'btn' + row.id">复制链接</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="downloadSingleFn(row)">下载二维码</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="addFn(row)">编辑</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" @click="deleteFn(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination :total="total" :page.sync="search.pageNum" :limit.sync="search.pageSize" @pagination="getSceneList()" />
    <el-dialog :title="state + '场景'" :visible.sync="showDialog" width="500px">
      <div>
        <el-form ref="form" :rules="formRules" :model="form" label-position="right" label-width="100px">
          <el-form-item label="场景名称" prop="name">
            <el-input v-model="form.name" placeholder="请输入场景名称" show-word-limit clearable maxlength="15" />
          </el-form-item>
          <el-form-item label="场景类型" prop="type">
            <el-select v-model="form.type">
              <el-option :value="unit.key" :label="unit.value" v-for="(unit, key) in typeList" :key="key"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="选择客服" class="my-select" prop="kfId">
            <el-select v-model="form.kfId" @change="setChange">
              <el-option style="height:50px;padding-top: 5px;" :value="unit.id" :label="unit.name" v-for="(unit, key) in customerList" :key="key">
                <div style="height: 40px;">
                  <show-customer-service :url='unit.avatar' :name='unit.name' showicon></show-customer-service>
                </div>
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showDialog = false">取 消</el-button>
        <el-button type="primary" @click="submitFn">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
  import ClipboardJS from 'clipboard'
  import ShowCustomerService from "../components/ShowCustomerSevice.vue"
  import { getList, getSceneList, deleteScene, addScene, editScene, downloadBatch } from '@/api/drainageCode/customerService.js'
  export default {
    name: 'scene-manage',
    components: {
      ShowCustomerService
    },
    data () {
      return {
        loading: false,
        list: [],
        showDialog: false,
        search: {
          pageSize: 10,
          pageNum: 1,
          name: '',
          type: '',
          openKfId: '',
          orderByColumn: 'wks.update_time',
          isAsc: 'desc'
        },
        total: 0,
        state: '新建',
        selectList: [],
        form: {
          type: '',
          name: '',
          kfId: '',
          openKfId: ''
        },
        formRules: {
          name: [{ required: true, message: '请输入场景名称！', trigger: 'blur' }],
          type: [{ required: true, message: '请选择场景类型！', trigger: 'blur' }],
          kfId: [{ required: true, message: '请选择客服！', trigger: 'blur' }]
        },
        customerList: [],
        typeList: [
          //  1-公众号 2-小程序 3-视频号 4-搜一搜 5-微信支付 6-app 7-网页场景类型
          { key: 1, value: '公众号' },
          { key: 2, value: '小程序' },
          { key: 3, value: '视频号' },
          { key: 4, value: '搜一搜' },
          { key: 5, value: '微信支付' },
          { key: 6, value: 'app' },
          { key: 7, value: '网页' },
        ]
      }
    },
    methods: {
      downloadBatch () {
        let ids = this.selectList.map(dd => { return dd.id })
        if (!ids.length) {
          this.msgInfo("请先勾选下载项！")
          return
        }
        this.$confirm('是否确认下载所有二维码吗?', '警告', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            return downloadBatch(ids.join(','))
          })
          .then((res) => {
            if (res != null) {
              let blob = new Blob([res], {
                type: 'application/zip'
              })
              let url = window.URL.createObjectURL(blob)
              const link = document.createElement('a') // 创建a标签
              link.href = url
              link.download = '批量二维码.zip' // 重命名文件
              link.click()
              URL.revokeObjectURL(url) // 释放内存
            }
          })
          .catch(function () { })
      },
      downloadSingleFn (data) {
        let name = data.kfName + '-' + data.name + '.png'
        this.downloadByBlob(data.qrCode, name)
      },
      downloadByBlob (url, name) {
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
      downloadFn (href, name) {
        let eleLink = document.createElement('a')
        eleLink.download = name
        eleLink.href = href
        eleLink.click()
        eleLink.remove()
      },
      setType (type) {
        let str
        this.typeList.forEach(dd => {
          if (type === dd.key) {
            str = dd.value
          }
        })
        return str
      },
      setChange (data) {
        this.customerList.forEach(dd => {
          if (dd.id === data) {
            this.form.openKfId = dd.openKfId
          }
        })
      },
      submitFn () {
        this.$refs['form'].validate(validate => {
          if (validate) {
            if (this.state === '新建') {
              addScene(this.form).then(res => {
                this.$message.success('新建成功！')
                this.showDialog = false
                this.getData()
              })
            } else {
              editScene(this.form).then(res => {
                this.$message.success('编辑成功！')
                this.showDialog = false
                this.getData()
              })
            }
          }
        })
      },
      getData () {
        this.loading = true
        getSceneList(this.search).then(res => {
          this.list = res.rows
          this.total = Number(res.total)
          this.loading = false
        })
        // this.list = [{ id: '11111', "typeName": "nisi eiusmod ea Excepteur dolore", "name": "in aliqua adipisicing sed ut", "type": 71152170.26921538, "kfName": "ad quis dolore", "kfAvatar": "ullamco ex quis", "kfUrl": "labore laboris veniam", "accessCnt": 84703618.49096513, "consultCnt": 89256939.32291824, "receptionCnt": 81229066.2598409, "createTime": "Ut incididunt", "updateTime": "aliqua fugiat deserunt", "createBy": "mollit", "updateBy": "ad officia nisi sunt commodo" }, { "typeName": "do", "name": "irure", "type": 40085324.48885304, "kfName": "Duis sed", "kfAvatar": "sed Lorem velit", "kfUrl": "commodo ut dolor ipsum", "accessCnt": -89463968.4334356, "consultCnt": 63888465.387045145, "receptionCnt": -41534624.394609265, "createTime": "amet velit laboris fugiat", "updateTime": "in sit eiusmod", "createBy": "Ut dolor ea", "updateBy": "incididunt reprehenderit" }, { "typeName": "in sunt et dolore tempor", "name": "quis laboris", "type": -7995649.530553937, "kfName": "amet velit eu", "kfAvatar": "aute dolore anim amet", "kfUrl": "minim", "accessCnt": 99871395.3190921, "consultCnt": 73324612.44769356, "receptionCnt": 64278887.23853704, "createTime": "culpa dolor ut do", "updateTime": "in eu ex", "createBy": "magna tempor dolore dolore amet", "updateBy": "occaecat id Ut qui adipisicing" }]
      },
      searchFn () {
        this.search.pageNum = 1
        this.getData()
      },
      resetQuery () {
        this.search = {
          pageSize: 10,
          pageNum: 1,
          name: '',
          type: '',
          openKfId: '',
          orderByColumn: 'wks.update_time',
          isAsc: 'desc'
        }
        this.getData()
      },
      handleSelectionChange (e) {
        this.selectList = e
        console.log(e)
      },
      addFn (data) {
        this.form = {
          type: '',
          name: '',
          kfId: '',
          openKfId: ''
        }
        if (data) {
          this.form.id = data.id
          this.form.type = data.type
          this.form.name = data.name
          this.form.kfId = data.kfId
          this.form.openKfId = data.openKfId
          this.state = '编辑'
        } else {
          this.state = '新建'
        }
        this.showDialog = true
      },
      deleteFn (data) {
        let ids = data ? data : this.selectList.map(dd => { return dd.id })
        if (ids && ids.length) {
          this.$confirm('是否确定删除当前场景？该操作不可恢复，请谨慎操作', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            console.log(ids)
            return deleteScene(data ? ids : ids.join(','))
          }).then(() => {
            this.getData()
            this.msgSuccess('删除成功')
          })
            .catch(function () { })
        } else {
          this.$message.info('请选择操作项！')
        }
      }
    },
    mounted () {
      var clipboard = new ClipboardJS('.copy_btn')
      clipboard.on('success', (e) => {
        this.$notify({
          title: '成功',
          message: '链接已复制到剪切板，可粘贴。',
          type: 'success'
        })
      })
      clipboard.on('error', (e) => {
        this.$message.error('链接复制失败')
      })
    },
    created () {
      if (this.$route.query.openKfId) {
        this.search.openKfId = this.$route.query.openKfId
      }
      getList().then(res => {
        this.customerList = res.rows
      })
      this.getData()
      this.$store.dispatch(
        'app/setBusininessDesc',
        `
        <div>可将客服链接或二维码可配置到公众号菜单、商城小程序等渠道场景，客服一键咨询</div>
      `
      )
    }
  }
</script>
<style lang="scss" scoped>
  .operation {
    margin-top: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .item {
      display: flex;
      .sub {
        font-size: 12px;
        color: #999;
        margin-left: 10px;
        align-self: flex-end;
      }
    }
  }
</style>
