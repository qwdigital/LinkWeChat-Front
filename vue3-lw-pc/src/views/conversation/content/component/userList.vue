<template>
  <div class="userList" v-loading="loading">
    <ul v-if="personList.length">
      <li
        v-for="(item, index) in personList"
        class="list"
        :class="{ active: index == active }"
        :key="index"
        @click="liClick(item, index)">
        <img v-if="item.avatar" class="fl mr10" :src="item.avatar" />
        <img class="fl mr10" v-else src="../../../../assets/drainageCode/header.png" />
        <div class="name" :title="item.name">
          {{ item.name }}
        </div>
      </li>
    </ul>
    <el-empty v-else :image-size="100"></el-empty>
  </div>
</template>
<script>
export default {
  props: {
    personList: {
      type: Array,
      defluat: () => [],
    },
    loading: {
      type: Boolean,
      defluat: false,
    },
  },

  data() {
    return {
      loadings: true,
      active: undefined,
    }
  },
  methods: {
    liClick(data, index) {
      this.active = index
      this.$emit('chatFn', data)
    },
  },
}
</script>
<style lang="scss" scoped>
.userList {
  overflow-y: auto;
  // height: calc(100vh - 288px);
  height: 100%;

  ::-webkit-scrollbar {
    display: none;
  }

  ::v-deep .el-loading-spinner {
    margin-top: 20px;
  }

  .gray {
    color: var(--font-black-6);
  }
  .list {
    padding: 10px;
    overflow: hidden;
    border-bottom: 1px solid var(--border-black-10);
    cursor: pointer;
    text-align: left;
    .name {
      white-space: nowrap;
      overflow: hidden;
      line-height: 40px;
      text-overflow: ellipsis;
    }
    &:hover {
      background: var(--bg-black-10);
    }
    &.active {
      background: var(--color-light-10);
    }
    img {
      width: 40px;
      height: 40px;
      float: left;
    }
  }
}
</style>
