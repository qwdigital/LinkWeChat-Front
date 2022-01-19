<template>
  <div class="search">
    <div class="item">
      <el-button-group>
        <el-button size="mini" @click="setType(1)" :type="active === 1 ? 'primary': ''">近一周</el-button>
        <el-button size="mini" @click="setType(2)" :type="active === 2 ? 'primary': ''">近一月</el-button>
        <el-button size="mini" @click="setType(3)" :type="active === 3 ? 'primary': ''">自定义</el-button>
      </el-button-group>
    </div>
    <div class="item" v-if="active === 3">
      <el-date-picker style="width: 250px;" size="mini" v-model="value" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期">
      </el-date-picker>
    </div>
    <div class="item" v-if="showScene">
      <el-select size="mini" v-model="value2" placeholder="请选择场景">
        <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
        </el-option>
      </el-select>
    </div>
    <div class="item" v-if="showMember">
      <el-select size="mini" v-model="value2" placeholder="请选择客服">
        <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
        </el-option>
      </el-select>
    </div>
    <div class="item" v-if="showMember">
      <el-select size="mini" v-model="value2" placeholder="请选择接待员工">
        <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
        </el-option>
      </el-select>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'search-title',
    props: {
      showScene:{
        type: Boolean,
        default: false
      },
      showMember: {
        type: Boolean,
        default:false
      }
    },
    data () {
      return {
        active: 1,
        value: [],
        options: [{ value: 10, label: '1123' }],
        value2: ''
      }
    },
    methods: {
      setType (type) {
        this.active = type
      }
    }
  }
</script>
<style lang="scss" scoped>
  .search {
    display: flex;
    align-items: center;
    .item {
      margin-right: 20px;
    }
  }
</style>