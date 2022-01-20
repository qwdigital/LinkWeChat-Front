<script>
export default {
  // 指标卡片组
  name: 'CardGroupIndex',
  components: {},
  props: {
    // 数据列表
    data: {
      type: Array,
      default: () => []
    },
    // isArrow: {
    //   type: Boolean,
    //   default: false
    // },
    defaultProps: {
      type: Object,
      default: () => ({
        title: 'title',
        tips: 'tips',
        value: 'value',
        title1: 'title1',
        value1: 'value1',
        noArrow: 'noArrow'
      })
    }
  },
  data() {
    return {}
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    getClass(value) {
      let val = Number(value)
      if (val > 0) {
        return 'ascend'
      } else if (val < 0) {
        return 'descend'
      }
    },
    getArrow(value) {
      let val = Number(value)
      if (val > 0) {
        return '↑'
      } else if (val < 0) {
        return '↓'
      } else {
        return '-'
      }
    }
  }
}
</script>

<template>
  <ul class="card-group-index flex">
    <li v-for="(row, index) in data" :key="index" class="card-index-li">
      <div class="mb5 label">
        <span>{{ row[defaultProps.title] }}</span>
        <div v-if="row[defaultProps.tips] !== undefined" class="fr">
          <el-popover trigger="hover" :content="row[defaultProps.tips]" placement="top-start">
            <i slot="reference" class="el-icon-question"></i>
          </el-popover>
        </div>
      </div>
      <div class="mb15 value">{{ row[defaultProps.value] || 0 }}</div>
      <div v-if="row[defaultProps.title1] !== undefined || row[defaultProps.value1] !== undefined">
        {{ row[defaultProps.title1] }}
        <span class="fr" :class="row[defaultProps.noArrow] || getClass(row[defaultProps.value1])">
          {{ row[defaultProps.noArrow] ? '' : getArrow(row[defaultProps.value1]) }}
          {{ Math.abs(row[defaultProps.value1]) }}
        </span>
      </div>
    </li>
  </ul>
</template>

<style lang="scss" scoped>
// 指标卡片
.card-index-li {
  position: relative;
  width: 200px;
  // height: 108px;
  // background: linear-gradient(90deg, #f7f8fb 0%, #f1f3f8 100%);
  background: #fff;
  border-radius: $border-radius;
  margin: 0 10px 20px 0;
  line-height: 1;
  padding: 22px 20px;
  .card-icon {
    position: absolute;
    top: 0;
    right: 0;
  }
  .label {
    position: relative;
    font-size: $font-size;
  }
  .value,
  .value2 {
    font-size: 20px;
    font-weight: bold;
  }
  .value2 {
    font-size: $font-size-keydata;
    line-height: 1.15;
  }
  .icon-arrow {
    position: absolute;
  }

  .el-radio,
  .el-checkbox {
    position: relative;
    float: right;
    margin-right: 0;
    top: -8px;
  }

  .descend {
    color: #ff0000;
  }

  .ascend {
    color: green;
  }
}
</style>
