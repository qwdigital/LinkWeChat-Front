<template>
  <div>
    <el-form label-width="120px" label-position="right" ref="form" :rules="rule" :model="form">
      <div class="g-card">
        <div class="card-title" style="display: inline-block">基础信息</div>
        <div style="float: right" v-if="isDetail">
          <el-button
            type="primary"
            @click="
              $router.push({
                path: 'add',
                query: {
                  id: $route.query.id,
                  obj: encodeURIComponent(JSON.stringify(form)),
                },
              })
            ">
            编辑
          </el-button>
        </div>
        <el-form-item label="门店名称" prop="storeName">
          <el-input
            :disabled="isDetail"
            v-model="form.storeName"
            placeholder="请输入门店名称"
            style="width: 400px"
            show-word-limit
            maxlength="30" />
        </el-form-item>
        <el-form-item label="所属地区" prop="area">
          <el-cascader
            :disabled="isDetail"
            v-model="areaArray"
            :props="props"
            :options="cityTree"
            ref="tree"
            @change="handleTree"></el-cascader>
        </el-form-item>
        <BaiduMap @update="handleChange" @point="getPoint" :isDetail="isDetail" :initData="form"></BaiduMap>
      </div>

      <div class="g-card">
        <div class="card-title">门店设置</div>
        <el-form-item label="门店导购">
          <div v-if="!isDetail">
            <el-button type="primary" plain @click="dialogVisibleQr = true">选择员工</el-button>
            <!-- 选择使用员工弹窗 -->
            <SelectUser
              v-model:visible="dialogVisibleSelectUser"
              title="选择使用员工"
              :defaultValues="form.users"
              @success="(data) => ((form.users = data), $refs.form.validateField('users'))"></SelectUser>
          </div>

          <TagEllipsis :list="form.users" limit="10" emptyText></TagEllipsis>
          <!-- <div style="margin-top: 10px" v-if="form.shopGuideUrl">
            <ul class="el-upload-list el-upload-list--picture-card">
              <li class="el-upload-list__item is-success">
                <img style="width: 100%; height: 100%" :src="form.shopGuideUrl" />
                <span class="el-upload-list__item-actions">
                  <span class="el-upload-list__item-delete">
                    <el-icon-delete class="el-icon-delete" @click="handleRemove"></el-icon-delete>
                  </span>
                </span>
              </li>
            </ul>
          </div> -->
        </el-form-item>

        <el-form-item label="门店客群">
          <el-card shadow="always" style="width: 600px" :body-style="{ padding: '20px' }">
            <el-form-item label="群活码名称" prop="codeName">
              <el-input
                v-model="form.codeName"
                maxlength="30"
                show-word-limit
                placeholder="请输入"
                clearable></el-input>
            </el-form-item>
            <el-form-item label="活码客群:" prop="groups">
              <template v-if="!isDetail">
                <el-button type="primary" @click="dialogVisibleSelectGroup = true">选择客群</el-button>
                <div class="g-tip">最多选择五个客群</div>
                <SelectGroup
                  v-model:visible="dialogVisibleSelectGroup"
                  :defaults="form.groups"
                  @submit="(data) => ((form.groups = data), $refs.form.validateField('groups'))"></SelectGroup>
              </template>
              <TagEllipsis :list="form.groups" limit="5" defaultProps="groupName"></TagEllipsis>
            </el-form-item>

            <el-form-item label="群满自动建群:">
              <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
              <div class="g-tip">默认以第一个群的群主作为新建群的群主</div>
            </el-form-item>
            <template v-if="form.autoCreateRoom">
              <el-form-item label="群名前缀:" prop="roomBaseName">
                <el-input
                  show-word-limit
                  maxlength="20"
                  v-model="form.roomBaseName"
                  placeholder="请输入群名前缀"></el-input>
              </el-form-item>
              <el-form-item label="群起始序号:" prop="roomBaseId">
                <el-input-number v-model="form.roomBaseId" controls-position="right" :min="1"></el-input-number>
              </el-form-item>
            </template>
          </el-card>
        </el-form-item>

        <el-form-item label="门店状态">
          <template v-if="!isDetail">
            <el-switch
              :disabled="!form.groupCodeUrl && !form.shopGuideId"
              v-model="form.storeState"
              active-text="启用"
              inactive-text="停用"
              :active-value="0"
              :inactive-value="1"></el-switch>
          </template>
          <template v-else>
            <el-switch
              disabled
              v-model="form.storeState"
              active-text="启用"
              inactive-text="停用"
              :active-value="0"
              :inactive-value="1"></el-switch>
          </template>
        </el-form-item>
      </div>
    </el-form>
    <div class="g-footer-sticky" v-if="!isDetail">
      <el-button plain @click="cancelFn">取消</el-button>
      <el-button type="primary" @click="submitFn" :loading="submitLoading" :disabled="submitLoading">确定</el-button>
    </div>
    <!-- <SelectUser
      key="123"
       v-model:visible="dialogVisibleSelectUser"
      title="选择导购"
      :isOnlyLeaf="true"
      :defaultValues="selectedUserList"
      @success="selectedUser"
    ></SelectUser> -->
    <SelectStaffQrCode v-model:visible="dialogVisibleQr" @success="selectedQr"></SelectStaffQrCode>
  </div>
</template>
<script>
import BaiduMap from '@/components/common/BaiduMap'
import SelectStaffQrCode from '@/components/SelectStaffQrCode'

import { getProCityList } from '@/api/common'
import { addOrUpdateStore, storeDetail } from '@/api/drainageCode/store'
export default {
  name: 'store-add',
  props: {
    isDetail: {
      type: Boolean,
      default: false,
    },
  },
  components: {
    BaiduMap,
    SelectStaffQrCode,
    SelectGroup: defineAsyncComponent(() => import('@/components/SelectGroup.vue')),
  },
  data() {
    return {
      areaArray: [],
      current: {
        province: '',
        city: '',
        area: '',
      },
      form: {
        storeState: 1,
        storeName: '',
        area: '',
        provinceId: '',
        cityId: '',
        areaId: '',
        longitude: '',
        latitude: '',
        shopGuideId: '',
        shopGuideName: '',
        address: '',
        groupCodeUrl: '',
        groupCodeName: '',
        groupCodeId: '',
        shopGuideUrl: '',
      },
      selectedUserList: [],
      dialogVisibleSelectUser: false,
      dialogVisibleSelectGroup: false,
      selectedCodeList: [],
      submitLoading: false,
      cityTree: [],
      props: {
        label: 'name',
        value: 'name',
      },
      rule: {
        storeName: [{ required: true, message: '请输入门店名称', trigger: 'blur' }],
        area: [{ required: true, message: '请选择所属地区', trigger: 'blur' }],
        address: [{ required: true, message: '请选择详细地址', trigger: 'blur' }],
      },
      dialogVisibleQr: false,
    }
  },
  created() {
    getProCityList({ isExtName: true }).then((res) => {
      if (res.code === 200) {
        this.cityTree = res.data
      }
    })
    if (this.$route.query.id) {
      storeDetail(this.$route.query.id).then((res) => {
        if (res.code === 200) {
          this.form = res.data
          this.setDetail()
        }
      })
    }
  },
  methods: {
    handleRemove() {
      this.form.shopGuideUrl = ''
      this.form.shopGuideId = ''
      this.form.shopGuideName = ''
    },
    selectedQr(data) {
      let arr = []
      if (data.qrUserInfos.length) {
        data.qrUserInfos.forEach((dd) => {
          arr = [...arr, ...dd.weQrUserList]
        })
      }
      let ids = []
      let names = []
      arr.forEach((dd) => {
        ids.push(dd.userId)
        names.push(dd.userName)
      })
      this.form.shopGuideId = ids.join(',')
      this.form.shopGuideName = names.join(',')

      this.form.shopGuideUrl = data.qrCode
      this.dialogVisibleQr = false
    },
    getPoint(addrPoint) {
      this.form.longitude = addrPoint.lng.toString()
      this.form.latitude = addrPoint.lat.toString()
    },
    handleChange(data) {
      if (data.address) {
        this.form.address = data.address
        this.form.area = data.province + data.city + data.area
        if (data.province) {
          this.areaArray = [data.province, data.city, data.area]
        }
        this.form.longitude = data.addrPoint.lng.toString()
        this.form.latitude = data.addrPoint.lat.toString()
      }
    },
    handleTree(data) {
      this.form.area = this.areaArray.join('')
      this.form.address = ''
      this.form.longitude = ''
      this.form.latitude = ''
    },
    selectedUser(data) {
      this.selectedUserList = data
      let ids = []
      let names = []
      data.forEach((dd) => {
        ids.push(dd.userId)
        names.push(dd.name)
      })
      this.form.shopGuideId = ids.join(',')
      this.form.shopGuideName = names.join(',')
    },
    onSelectUser() {
      // this.dialogVisibleSelectUser = true
      this.dialogVisibleQr = true
    },
    selectedQrCode(data) {
      if (data) {
        this.selectedCodeList[0] = data
        this.form.groupCodeUrl = data.codeUrl
        this.form.groupCodeName = data.activityName
        this.form.groupCodeId = data.id
      }
    },
    submitFn() {
      this.$refs['form'].validate((valitate) => {
        if (valitate) {
          this.submitLoading = true
          addOrUpdateStore(this.form).then((res) => {
            if (res.code === 200) {
              this.msgSuccess('操作成功')
              this.$router.back()
              this.submitLoading = false
            } else {
              this.submitLoading = false
              this.msgInfo(res.msg)
            }
          })
        }
      })
    },
    cancelFn() {
      this.$confirm(`是否确认取消${this.$route.query.id ? '编辑' : '新建'}？取消后不可恢复，请谨慎操作。`, '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.$router.back()
        })
        .catch(function () {})
    },
    setDetail() {
      if (this.form.groupCodeId) {
        this.selectedCodeList[0] = { id: this.form.groupCodeId }
      }
      if (this.form.area) {
        let reg = /.+?(省|市|自治区|自治州|县|区|旗)/g
        let arr = this.form.area.match(reg)
        this.areaArray = arr
      }
      if (this.form.shopGuideId) {
        this.selectedUserList = []
        let idList = this.form.shopGuideId.split(',')
        let nameList = this.form.shopGuideName.split(',')
        let arr = []
        idList.forEach((dd, index) => {
          arr.push({ name: nameList[index], userId: dd })
        })
        this.selectedUserList = [...arr]
        // this.$forceUpdate()
      }
    },
  },
}
</script>
<style lang="scss" scoped>
.card-title {
  font-size: 16px;

  font-weight: 500;
  color: var(--font-black);
  margin-bottom: 20px;
}
</style>
