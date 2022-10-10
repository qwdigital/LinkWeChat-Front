<template>
  <div style="display:inline;">
    <!-- <el-form :inline="true" label-width="0" label-position="left"> -->
    <el-form-item prop="value">
      <el-select :disabled="detail" @change="setCityList" v-model="selectPro" placeholder="请选择省">
        <el-option v-for="(item, key) in proList" :key="key" :label="item.name" :value="item.id"></el-option>
      </el-select>
    </el-form-item>
    <el-form-item>
      <el-select :disabled="detail" @change="setAreaList" v-model="selectCity" placeholder="请选择市">
        <el-option v-for="(item, index) in cityList" :key="index" :label="item.name" :value="item.id"></el-option>
      </el-select>
    </el-form-item>
    <el-form-item>
      <el-select :disabled="detail" v-model="selectArea" @change="setData" placeholder="请选择区（县）">
        <el-option v-for="(item, index) in areaList" :key="index" :label="item.name" :value="item.id"></el-option>
      </el-select>
    </el-form-item>
    <!-- </el-form> -->
  </div>
</template>
<script>
  import { getProCityList } from '@/api/common'
  export default {
    name: 'select-pro-city',
    data () {
      return {
        proList: [],
        cityList: [],
        areaList: [],
        selectPro: '',
        selectCity: '',
        selectArea: ''
      }
    },
    props: {
      detail: {
        type: Boolean,
        defalut: false
      },
      defaultValue: {
        type: String,
        default: ''
      }
    },
    methods: {
      setCityList (data, state) {
        if (!state) {
          this.selectCity = ''
          this.selectArea = ''
          this.cityList = []
          this.areaList = []
          this.setData()
        }
        this.proList.forEach(dd => {
          if (dd.id === data) {
            this.cityList = dd.children
          }
        })
        // getProCityList({id: data}).then(res => {
        //   if (res.code === 200) {
        //     this.cityList = res.data
        //   }
        // })

      },
      setAreaList (data, state) {
        if (!state) {
          this.selectArea = ''
          this.areaList = []
          this.setData()
        }
        this.cityList.forEach(dd => {
          if (dd.id === data) {
            this.areaList = dd.children
          }
        })
        // getProCityList({id: data}).then(res => {
        //   if (res.code === 200) {
        //     this.areaList = res.data
        //   }
        // })
      },
      setData () {
        let arr = [this.selectPro, this.selectCity, this.selectArea]
        this.$emit('update', arr.join(','))
      },
      initData () {
        if (this.defaultValue) {
          let arr = this.defaultValue.split(',')
          if (arr[0]) {
            this.selectPro = Number(arr[0])
            this.setCityList(this.selectPro, 'first')
          }
          if (arr[1]) {
            this.selectCity = Number(arr[1])
            this.setAreaList(this.selectCity, 'first')
          }
          if (arr[2]) {
            this.selectArea = Number(arr[2])
          }
        }
      }
    },
    mounted () {

    },
    created () {
      getProCityList().then(res => {
        if (res.code === 200) {
          this.proList = res.data
          this.initData()
        }
      })
    },
  }
</script>
<style lang="scss" scoped>
</style>