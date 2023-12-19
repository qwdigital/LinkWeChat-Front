<script>
export default {
  name: '',
  components: {},
  props: {
    title: '',
    data: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {}
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>

<template>
  <PhoneTemplate class="Preview" :title="title">
    <div class="main">
      <el-input class="search" placeholder="搜索关键词"></el-input>
      <div class="desc">
        这是链接描述 这是链接描述 这是链接描述 这是链接描述这是链接描述 这是链接描述这是链接描述
        这是链接描述这是链接描述 这是链接描述
      </div>
      <ul class="list">
        <li class="fxbw li" v-for="(item, index) in 3" :key="index">
          <div class="blod">关键词1</div>
          <div class="g-color cp">加入群聊</div>
        </li>
      </ul>
    </div>
  </PhoneTemplate>
</template>

<style lang="scss" scoped>
.main {
  background: var(--bg-white);
  height: 100%;
}
.search {
  padding: 15px 10px 10px;
}
.desc {
  margin: 10px;
  padding: 10px;
  background: var(--bg-black-8);
}
.list {
  border-top: 10px solid var(--border-black-10);
  margin-top: 10px;
  padding: 0 10px;
}
.li {
  padding: 10px 0;
  & + .li {
    border-top: 1px solid var(--border-black-8);
  }
}
</style>
