<script>
export default defineComponent({
  name: '',
  components: {},
  props: {
    data: {
      type: Object,
      default: () => ({}),
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
})
</script>

<template>
  <PhoneTemplate class="Preview" :title="data.title">
    <div class="main">
      <el-input class="search" placeholder="搜索关键词"></el-input>
      <div class="desc">
        {{ data.descrition }}
      </div>
      <ul class="list">
        <li class="fxbw li" v-for="(item, index) in data.keyWordGroupSubs" :key="index">
          <div class="blod">{{ item.keyword }}</div>
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
