<template>
  <div>
    <el-form-item label="详细地址" prop="address" v-if="!isOnlyShowMap">
      <el-autocomplete
        :disabled="isDetail"
        @change="setChange"
        v-model="form.address"
        style="width: 500px"
        popper-class="autoAddressClass"
        :fetch-suggestions="querySearchAsync"
        :trigger-on-focus="false"
        placeholder="详细地址"
        clearable
        @select="handleSelect">
        <template #default="{ item }">
          <el-icon-search class="el-icon-search fl mgr10" />
          <div style="overflow: hidden">
            <div class="title">{{ item.title }}</div>
            <span class="address ellipsis">{{ item.address }}</span>
          </div>
        </template>
      </el-autocomplete>
    </el-form-item>
    <el-form-item label="" :label-width="isOnlyShowMap ? 0 : ''" :style="isOnlyShowMap && 'margin-bottom: 0'">
      <div ref="bMap" :style="{ width: mapWidth, height: mapHeight }" />
    </el-form-item>
  </div>
</template>

<script>
/* eslint-disable */
import loadBMap from '@/utils/baiduMap.js'
export default {
  data() {
    return {
      form: {
        province: '',
        city: '',
        area: '',
        address: '', // 详细地址
        addrPoint: {
          // 详细地址经纬度
          lng: 0,
          lat: 0,
        },
      },
      map: '', // 地图实例
      mk: '', // Marker实例
      locationPoint: null,
    }
  },
  props: {
    initData: {
      type: Object,
      default: () => ({
        // area: '', // 省市区
        // address: '', // 详细地址
        // longitude: '', // 经度
        // latitude: '', // 纬度
      }),
    },
    mapWidth: {
      type: String,
      default: '500px',
    },
    mapHeight: {
      type: String,
      default: '300px',
    },
    isDetail: {
      type: Boolean,
      default: false,
    },
    // 是否只显示地图
    isOnlyShowMap: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    initData: {
      handler(value) {
        if (this.initData.area && !this.initData.address) {
          this.form.address = ''
          this.getPoint(this.initData.area)
          this.initMap()
        }
        if (this.initData.address) {
          this.form.address = this.initData.address
          if (this.initData.longitude && this.initData.latitude) {
            this.form.addrPoint.lng = this.initData.longitude
            this.form.addrPoint.lat = this.initData.latitude
          } else {
            let detailAddress = this.initData.area + this.initData.address
            this.getPoint(detailAddress)
          }
          this.initMap()
        }
      },
      deep: true,
    },
  },
  async mounted() {
    // 百度地图AK： GeDsF2XGs01U0bUSpFIUCmvyNoYuGC3P
    await loadBMap() // 加载引入BMap
    if (this.initData.address) {
      this.form.address = this.initData.address
      if (this.initData.longitude && this.initData.latitude) {
        this.form.addrPoint.lng = this.initData.longitude
        this.form.addrPoint.lat = this.initData.latitude
      } else {
        let detailAddress = this.initData.area + this.initData.address
        this.getPoint(detailAddress)
      }
    }
    this.initMap()
  },
  methods: {
    getCity(str) {
      if (str) {
        let area = {}
        let index11 = 0
        let index1 = str.indexOf('省')
        if (index1 == -1) {
          index11 = str.indexOf('自治区')
          if (index11 != -1) {
            area.Province = str.substring(0, index11 + 3)
          } else {
            area.Province = str.substring(0, 0)
          }
        } else {
          area.Province = str.substring(0, index1 + 1)
        }

        let index2 = str.indexOf('市')
        if (index11 == -1) {
          area.City = str.substring(index11 + 1, index2 + 1)
        } else {
          if (index11 == 0) {
            area.City = str.substring(index1 + 1, index2 + 1)
          } else {
            area.City = str.substring(index11 + 3, index2 + 1)
          }
        }

        let index3 = str.indexOf('区')
        if (index3 == -1) {
          index3 = str.indexOf('县')
          if (index3 == -1) {
            index3 = str.indexOf('旗')
            area.Country = str.substring(index2 + 1, index3 + 1)
          } else {
            area.Country = str.substring(index2 + 1, index3 + 1)
          }
        } else {
          area.Country = str.substring(index2 + 1, index3 + 1)
        }
        return area.City
      } else {
        return ''
      }
    },
    getPoint(str) {
      var that = this
      var myGeo = new BMap.Geocoder()
      myGeo.getPoint(
        str,
        function (point) {
          if (point) {
            that.form.addrPoint = point
            that.$emit('point', point)
          } else {
            // alert('您选择的地址没有解析到结果！')
          }
        },
        that.getCity(str),
      )
    },
    // 初始化地图
    initMap() {
      var that = this
      // 1、挂载地图
      this.map = new BMap.Map(this.$refs.bMap, { enableMapClick: false })
      var point = new BMap.Point(
        this.form.addrPoint.lng || 117.2334414073489,
        this.form.addrPoint.lat || 31.826578293886,
      )
      this.map.centerAndZoom(point, 19)
      // 3、设置图像标注并绑定拖拽标注结束后事件
      this.mk = new BMap.Marker(point, { enableDragging: true })
      this.map.addOverlay(this.mk)
      this.mk.addEventListener('dragend', function (e) {
        that.getAddrByPoint(e.point)
      })
      // 4、添加（右上角）平移缩放控件
      this.map.addControl(
        new BMap.NavigationControl({ anchor: BMAP_ANCHOR_TOP_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL }),
      )
      // 5、添加（左下角）定位控件
      var geolocationControl = new BMap.GeolocationControl({ anchor: BMAP_ANCHOR_BOTTOM_LEFT })
      geolocationControl.addEventListener('locationSuccess', function (e) {
        that.getAddrByPoint(e.point)
      })
      geolocationControl.addEventListener('locationError', function (e) {
        alert(e.message)
      })
      this.map.addControl(geolocationControl)
      // 6、浏览器定位
      // this.geolocation()
      // 7、绑定点击地图任意点事件
      this.map.addEventListener('click', function (e) {
        that.getAddrByPoint(e.point)
      })
    },
    // 获取两点间的距离
    getDistancs(pointA, pointB) {
      return this.map.getDistance(pointA, pointB).toFixed(2)
    },
    // 浏览器定位函数
    geolocation() {
      if (!this.isDetail) {
        var that = this
        var geolocation = new BMap.Geolocation()
        geolocation.getCurrentPosition(
          function (res) {
            if (this.getStatus() == BMAP_STATUS_SUCCESS) {
              that.getAddrByPoint(res.point)
              that.locationPoint = res.point
            } else {
              alert('failed' + this.getStatus())
              that.locationPoint = new BMap.Point(117.2334414073489, 31.826578293886)
            }
          },
          { enableHighAccuracy: true },
        )
      }
    },
    // 2、逆地址解析函数
    getAddrByPoint(point) {
      if (!this.isDetail) {
        var that = this
        var geco = new BMap.Geocoder()
        geco.getLocation(point, function (res) {
          that.mk.setPosition(point)
          that.map.panTo(point)
          that.form.address = res.addressComponents.street + res.addressComponents.streetNumber
          that.form.province = res.addressComponents.province
          that.form.city = res.addressComponents.city
          that.form.area = res.addressComponents.district
          that.form.addrPoint = point
          that.onSubmit()
        })
      }
    },
    // 8-1、地址搜索
    querySearchAsync(str, cb) {
      var options = {
        onSearchComplete: function (res) {
          var s = []
          if (local.getStatus() == BMAP_STATUS_SUCCESS) {
            for (var i = 0; i < res.getCurrentNumPois(); i++) {
              s.push(res.getPoi(i))
            }
            cb(s)
          } else {
            cb(s)
          }
        },
      }
      var local = new BMap.LocalSearch(this.map, options)
      local.search(str)
    },
    splitName(str) {
      if (str) {
        let area = {}
        let index11 = 0
        let index1 = str.indexOf('省')
        if (index1 == -1) {
          index11 = str.indexOf('自治区')
          if (index11 != -1) {
            area.Province = str.substring(0, index11 + 3)
          } else {
            area.Province = str.substring(0, 0)
          }
        } else {
          area.Province = str.substring(0, index1 + 1)
        }

        let index2 = str.indexOf('市')
        if (index11 == -1) {
          area.City = str.substring(index11 + 1, index2 + 1)
        } else {
          if (index11 == 0) {
            area.City = str.substring(index1 + 1, index2 + 1)
          } else {
            area.City = str.substring(index11 + 3, index2 + 1)
          }
        }

        let index3 = str.indexOf('区')
        if (index3 == -1) {
          index3 = str.indexOf('县')
          if (index3 == -1) {
            index3 = str.indexOf('旗')
            area.Country = str.substring(index2 + 1, index3 + 1)
          } else {
            area.Country = str.substring(index2 + 1, index3 + 1)
          }
        } else {
          area.Country = str.substring(index2 + 1, index3 + 1)
        }
        let data = area.Province + area.City + area.Country
        if (area.Province) {
          this.form.province = area.Province
        }
        if (area.City) {
          this.form.city = area.City
        }
        this.form.area = area.Country
        return str.substring(data.length)
      } else {
        return ''
      }
    },
    // 8-2、选择地址
    handleSelect(item) {
      this.form.province = item.province
      this.form.city = item.city
      this.form.address = this.splitName(item.address) + item.title
      this.form.addrPoint = item.point
      this.map.clearOverlays()
      this.mk = new BMap.Marker(item.point)
      this.map.addOverlay(this.mk)
      this.map.panTo(item.point)
      this.onSubmit()
    },
    setChange(data) {
      if (!data) {
        this.form = {
          address: '',
          addrPoint: {
            lng: 0,
            lat: 0,
          },
        }
        this.onSubmit()
      }
    },
    onSubmit() {
      this.$emit('update', this.form)
    },
  },
}
</script>

<style lang="scss" scoped>
.autoAddressClass {
  li {
    i.el-icon-search {
      margin-top: 11px;
    }
    .mgr10 {
      margin-right: 10px;
    }
    .title {
      text-overflow: ellipsis;
      overflow: hidden;
    }
    .address {
      line-height: 1;
      font-size: 12px;
      color: var(--font-black-7);
      margin-bottom: 5px;
    }
  }
}
</style>
