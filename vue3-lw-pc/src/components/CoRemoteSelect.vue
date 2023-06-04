<!-- 通用远程搜索下拉框 -->
<script>
export default {
  components: {},
  model: {
    event: 'input',
  },
  props: {
    modelValue: {
      type: [Array, String],
      default: undefined,
    },
    remoteMethod: {
      type: Function,
      default: () => () => {},
    },
    queryKeywordsKey: {
      type: String,
      default: '',
    },
    query: {
      type: Object,
      default: () => ({}),
    },
    defaultProps: {
      type: Object,
      default: () => ({ id: 'id', name: 'name' }),
    },
  },
  data() {
    return {
      loading: true,
      list: [],
    }
  },
  watch: {
    query() {
      this.getList()
    },
  },
  computed: {
    valueP: {
      get() {
        return this.modelValue
      },
      set(val) {
        this.$emit('update:modelValue', val)
      },
    },
  },
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    getList(keywords) {
      this.loading = true
      let query = Object.assign(
        { [this.queryKeywordsKey]: keywords },
        {
          pageNum: 1,
          pageSize: 1000,
        },
        this.query,
      )
      this.remoteMethod(query)
        .then(({ data, rows }) => {
          let _data = data || rows
          _data.forEach((e) => {
            e.id = e[this.defaultProps.id]
            e.name = e[this.defaultProps.name]
          })
          this.list = Object.freeze(_data)
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <el-select
    v-model="valueP"
    v-bind="$attrs"
    collapse-tags
    filterable
    remote
    reserve-keyword
    :placeholder="'请选择' + (queryKeywordsKey ? '，支持关键词搜索' : '')"
    :remote-method="getList"
    :loading="loading"
    @change="
      (val) =>
        $emit(
          'change',
          list.filter((e) => val.includes(e.id)),
        )
    ">
    <el-option v-for="(item, index) in list" :key="index" :label="item.name" :value="item.id"></el-option>
  </el-select>
</template>
<style lang="scss" scoped></style>
