<template>
  <div>
    <el-form label-width="120px" label-position="right" ref="form" :rules="rule" :model="form">
      <div class="g-card g-pad20">
        <div class="card-title" style="display: inline-block;">基础信息</div>
        <div style="float: right;" v-if="isDetail">
          <el-button
            type="primary"
            size="mini"
            @click="
              $router.push({
                path: 'add',
                query: {
                  id: $route.query.id,
                  obj: encodeURIComponent(JSON.stringify(form))
                }
              })
            "
            >编辑</el-button
          >
        </div>
        <el-form-item label="门店名称" prop="storeName">
          <el-input
            :disabled="isDetail"
            v-model="form.storeName"
            placeholder="请输入门店名称"
            style="width: 400px;"
            show-word-limit
            maxlength="30"
          />
        </el-form-item>
        <el-form-item label="所属地区" prop="area">
          <el-cascader
            :disabled="isDetail"
            v-model="areaArray"
            :props="props"
            :options="cityTree"
            ref="tree"
            @change="handleTree"
          ></el-cascader>
        </el-form-item>
        <baidu-map @update="handleChange" @point="getPoint" :isDetail="isDetail" :initData="form"></baidu-map>
      </div>
      <div class="g-card g-pad20">
        <div class="card-title">
          门店设置
        </div>
        <el-form-item label="门店导购">
          <div v-if="selectedUserList.length > 0">
            <el-tag size="medium" v-for="(item, index) in selectedUserList" :key="index">{{ item.name }}</el-tag>
          </div>
          <el-button v-if="!isDetail" icon="el-icon-plus" type="primary" plain size="mini" @click="onSelectUser"
            >{{ selectedUserList.length ? '编辑' : '选择' }}导购</el-button
          >
        </el-form-item>
        <el-form-item label="门店群活码">
          <template>
            <div v-if="form.groupCodeUrl">
              <div>{{ form.groupCodeName }}</div>
              <img style="height: 80px; width: 80px; margin-top: 5px;" :src="form.groupCodeUrl" />
            </div>
          </template>
          <template>
            <el-button
              v-if="!isDetail"
              icon="el-icon-plus"
              type="primary"
              plain
              size="mini"
              @click="dialogVisibleSelectQrCode = true"
              >{{ form.groupCodeUrl ? '编辑' : '选择' }}群活码</el-button
            >
          </template>
        </el-form-item>
        <el-form-item label="门店状态">
          <template v-if="!isDetail">
            <el-switch
              size="mini"
              :disabled="!form.groupCodeUrl && !form.shopGuideId"
              v-model="form.storeState"
              active-text="启用"
              inactive-text="停用"
              :active-value="0"
              :inactive-value="1"
            ></el-switch>
          </template>
          <template v-else>
            <el-switch
              size="mini"
              disabled
              v-model="form.storeState"
              active-text="启用"
              inactive-text="停用"
              :active-value="0"
              :inactive-value="1"
            ></el-switch>
          </template>
        </el-form-item>
      </div>
      <el-form-item style="text-align: right;" v-if="!isDetail">
        <el-button plain @click="cancelFn">取消</el-button>
        <el-button type="primary" @click="submitFn" :loading="submitLoading" :disabled="submitLoading">确定</el-button>
      </el-form-item>
    </el-form>
    <SelectWeUser
      key="123"
      :visible.sync="dialogVisibleSelectUser"
      title="选择导购"
      :isOnlyLeaf="true"
      :defaultValues="selectedUserList"
      @success="selectedUser"
    ></SelectWeUser>
    <SelectQrCode
      :visible.sync="dialogVisibleSelectQrCode"
      @success="selectedQrCode"
      :selected="selectedCodeList"
    ></SelectQrCode>
  </div>
</template>
<script>
  import BaiduMap from '@/components/common/BaiduMap'
  import SelectQrCode from '@/components/SelectQrCode'
  import SelectWeUser from '@/components/SelectWeUser'

  import { getProCityList } from '@/api/common'
  import { addOrUpdateStore, storeDetail } from '@/api/drainageCode/store'
  export default {
    name: 'store-add',
    data() {
      return {
        areaArray: [],
        current: {
          province: '',
          city: '',
          area: ''
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
          groupCodeId: ''
        },
        selectedUserList: [],
        dialogVisibleSelectUser: false,
        dialogVisibleSelectQrCode: false,
        selectedCodeList: [],
        submitLoading: false,
        cityTree: [],
        props: {
          label: 'name',
          value: 'name'
        },
        rule: {
          storeName: [{ required: true, message: '请输入门店名称', trigger: 'blur' }],
          area: [{ required: true, message: '请选择所属地区', trigger: 'blur' }],
          address: [{ required: true, message: '请选择详细地址', trigger: 'blur' }]
        }
      }
    },
    props: {
      isDetail: {
        type: Boolean,
        default: false
      }
    },
    components: {
      BaiduMap,
      SelectQrCode,
      SelectWeUser
    },
    methods: {
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
        this.dialogVisibleSelectUser = true
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
          type: 'warning'
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
          this.$forceUpdate()
        }
      }
    },
    created() {
      getProCityList().then((res) => {
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
    }
  }
</script>
<style lang="scss" scoped>
  .card-title {
    font-size: 16px;
    font-family: PingFangSC-Medium, PingFang SC;
    font-weight: 500;
    color: #333333;
    margin-bottom: 20px;
  }
</style>
