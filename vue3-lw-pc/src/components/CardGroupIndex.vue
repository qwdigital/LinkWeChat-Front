<script>
export default {
  // 指标卡片组
  name: 'CardGroupIndex',
  components: {},
  props: {
    // 数据列表
    data: {
      type: Array,
      default: () => [],
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
        noArrow: 'noArrow',
      }),
    },
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
        return ''
      }
    },
  },
}
</script>

<template>
  <ul class="card-group-index flex">
    <li v-for="(row, index) in data" :key="index" class="card-index-li">
      <div class="label">
        <span>{{ row[defaultProps.title] }}</span>
        <div v-if="row[defaultProps.tips] !== undefined" class="fr">
          <el-popover trigger="hover" :content="row[defaultProps.tips]" placement="top-start">
            <template #reference>
              <el-icon-warning class="el-icon-warning"></el-icon-warning>
            </template>
          </el-popover>
        </div>
      </div>
      <div class="mt10 value">{{ row[defaultProps.value] || 0 }}</div>
      <div class="mt15" v-if="row[defaultProps.title1] !== undefined || row[defaultProps.value1] !== undefined">
        {{ row[defaultProps.title1] }}
        <span class="fr" :class="row[defaultProps.noArrow] || getClass(row[defaultProps.value1])">
          {{ row[defaultProps.noArrow] ? '' : getArrow(row[defaultProps.value1]) }}
          {{ Math.abs(row[defaultProps.value1]) || 0 }}
        </span>
      </div>
    </li>
  </ul>
</template>

<style lang="scss" scoped>
// 指标卡片
.card-index-li {
  position: relative;
  flex: auto;
  // min-width: 200px;
  max-width: 240px;
  background: var(--bg-white);
  border-radius: var(--border-radius-big);
  border: 1px solid var(--border-black-10);
  line-height: 1;
  padding: 22px 20px;
  margin-right: 10px;
  margin-bottom: var(--card-margin);
  // // 6个以上的换行 需定宽并使用 media query
  // &:nth-child(n + 8) {
  //   margin-top: var(--card-margin);ç
  // }
  &:last-child {
    margin-right: 0;
  }
  .card-icon {
    position: absolute;
    top: 0;
    right: 0;
  }
  .label {
    position: relative;
    font-size: 14px;
  }
  .value,
  .value2 {
    font-size: 20px;
    font-weight: bold;
  }
  .value2 {
    font-size: 24px;
    line-height: 1.15;
  }
  .el-icon-warning {
    color: var(--font-black-6);
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
    color: green;
  }

  .ascend {
    color: red;
  }
}
</style>
