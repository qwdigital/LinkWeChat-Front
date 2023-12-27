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
            <el-button type="primary" plain @click="dialogVisibleSelectUser = true">选择员工</el-button>
            <!-- 选择使用员工弹窗 -->
            <SelectUser
              v-model:visible="dialogVisibleSelectUser"
              title="选择员工"
              :defaultValues="form.users"
              @success="(data) => (form.users = data)"></SelectUser>
          </div>

          <TagEllipsis :list="form.users" limit="10" :emptyText="isDetail && '无'"></TagEllipsis>
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
            <FormAutoCreateGroup ref="FormAutoCreateGroup" v-model:form="addGroupCode" :isDetail="isDetail">
              <template #="{ form: _form }">
                <el-form-item
                  label="群活码名称"
                  prop="activityName"
                  :rules="{ activityName: [{ required: true, message: '必填项', trigger: 'blur' }] }">
                  <el-input
                    v-model="_form.activityName"
                    maxlength="15"
                    show-word-limit
                    placeholder="请输入"
                    clearable></el-input>
                </el-form-item>
              </template>
            </FormAutoCreateGroup>
          </el-card>
        </el-form-item>

        <el-form-item label="门店状态">
          <el-switch
            :disabled="isDetail"
            v-model="form.storeState"
            :before-change="switchFn"
            active-text="启用"
            inactive-text="停用"
            :active-value="0"
            :inactive-value="1"></el-switch>
        </el-form-item>
      </div>
    </el-form>
    <div class="g-footer-sticky" v-if="!isDetail">
      <el-button plain @click="cancel">取消</el-button>
      <el-button type="primary" @click="submit">确定</el-button>
    </div>
  </div>
</template>
<script>
import BaiduMap from '@/components/common/BaiduMap'
// import SelectStaffQrCode from '@/components/SelectStaffQrCode'

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
    // SelectStaffQrCode,
    FormAutoCreateGroup: defineAsyncComponent(() => import('@/components/FormAutoCreateGroup.vue')),
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
        addGroupCode: {},
      },
      addGroupCode: {},
      selectedUserList: [],
      dialogVisibleSelectUser: false,
      dialogVisibleSelectGroup: false,
      selectedCodeList: [],
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
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
  },
  created() {
    getProCityList({ isExtName: true }).then(({ data }) => {
      this.cityTree = data
    })
    if (this.$route.query.id) {
      this.$store.loading = true
      storeDetail(this.$route.query.id)
        .then(({ data }) => {
          let userIds = data.addWeUserOrGroupCode?.weQrAddQuery?.qrUserInfos?.[0]?.userIds
          data.users = data.shopGuideName?.split(',')?.map((e, i) => ({
            userId: userIds?.[i],
            name: e,
          }))

          let chatIdList = data.addWeUserOrGroupCode?.addGroupCode?.chatIdList?.split(',')
          this.addGroupCode = {
            ...data.addWeUserOrGroupCode?.addGroupCode,
            groups: data.groupCodeName?.split(',')?.map((e, i) => ({
              chatId: chatIdList?.[i],
              groupName: e,
            })),
          }
          this.form = data
          this.setDetail()
        })
        .finally(() => {
          this.$store.loading = false
        })
    }
  },
  methods: {
    // handleRemove() {
    //   this.form.shopGuideUrl = ''
    //   this.form.shopGuideId = ''
    //   this.form.shopGuideName = ''
    // },
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
    switchFn() {
      if (!this.addGroupCode.groups?.length && !this.form.users?.length) {
        this.msgError('开启门店必须要求导购人员或群活码至少设置一项')
        return false
      }
      return true
    },
    submit() {
      if (this.form.storeState == 0) {
        if (!this.addGroupCode.groups?.length && !this.form.users?.length) {
          this.msgError('门店状态开启时必须要求导购人员或群活码至少设置一项')
          return
        }
      }
      this.$refs['form'].validate((valid) => {
        if (valid) {
          let form = JSON.parse(JSON.stringify(this.form))
          form.shopGuideName = form.users?.map((e) => e.name)?.join(',')
          form.groupCodeName = this.addGroupCode?.groups?.map((e) => e.groupName)?.join(',')
          form.addWeUserOrGroupCode = {
            weQrAddQuery: {
              qrUserInfos: [
                {
                  userIds: form.users?.map((e) => e.userId),
                },
              ],
            },

            addGroupCode: {
              ...this.addGroupCode,
              chatIdList: this.addGroupCode.groups?.map((e) => e.chatId)?.join(','),
            },
          }

          delete form.users

          this.$store.loading = true
          addOrUpdateStore(form)
            .then((res) => {
              this.msgSuccess('操作成功')
              this.$router.back()
            })
            .finally(() => {
              this.$store.loading = false
            })
        }
      })
    },
    cancel() {
      this.$confirm(`是否确认取消${this.$route.query.id ? '编辑' : '新建'}？取消后不可恢复，请谨慎操作。`)
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
