<script>
import { getList, getDetailList, remove } from './api'
export default defineComponent({
  name: '',
  components: { ScrollLoadList: defineAsyncComponent(() => import('@/components/ScrollLoadList')) },
  props: {
    data: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return { getDetailList }
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
      <ul class="list" v-if="data.keyWordGroupSubs">
        <li class="fxbw li" v-for="(item, index) in data.keyWordGroupSubs" :key="index">
          <div class="blod">{{ item.keyword }}</div>
          <div class="g-color cp">加入群聊</div>
        </li>
      </ul>
      <ScrollLoadList
        v-else
        class="list"
        finishedText=""
        :isQuery="!1"
        :params="{ keywordGroupId: data.id }"
        :request="getDetailList">
        <template #item="{ item }">
          <li class="fxbw li">
            <div class="blod">{{ item.keyword }}</div>
            <div class="g-color cp">加入群聊</div>
          </li>
        </template>
      </ScrollLoadList>
    </div>
  </PhoneTemplate>
</template>

<style lang="scss" scoped>
.main {
  background: var(--bg-white);
  height: 100%;
  display: flex;
  flex-direction: column;
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
  border-bottom: 1px solid var(--border-black-8);
  // & + .li {
  //   border-top: 1px solid var(--border-black-8);
  // }
}
</style>
