<template>
  <div v-loading="loading">
    <div class="label-group">
      <div v-for="item in list" :key="item.groupId" class="label-group-item">
        <div class="label-group-item-title">{{ item.groupName }}</div>
        <div v-if="item.weTags" class="label-group-item-body">
          <span class="label-group-item-body-tag" :style="setTagSelect(tag) ? selectedStyle:''" v-for="tag in item.weTags" :key="tag.tagId" @click="onSelectTag(tag)">{{ tag.name }}</span>
        </div>
      </div>
    </div>
    <div class="buttom">
      <div class="cancel_button" @click="resetFn">
        重置
      </div>
      <div class="submit_button" @click="submitFn">
        确定
      </div>
    </div>
  </div>
</template>
<script>
import { getTagList } from '@/api/group'

export default {
  name: 'tag-select',
  data () {
    return {
      loading:false,
      list: [],
      listOneArray: [],
      selectedList: [],
      selectedStyle: {
        background: '#ECF5FF',
        color: '#0079DE'
      }
    }
  },
  props: {
    type: {
      type: String,
      default: '1'
    },
    selected: {
      type: Array,
      default: () => []
    },
  },
  watch: {
    selected: {
      handler (val = []) {
        this.selectedList = [...val]
      },
      immediate: true
    },
  },
  computed: {
    checkedTagMap () {
      return new Set(this.selectedList.map((i) => i.tagId || (typeof i == 'string' && i)))
    }
  },
  methods: {
    onSelectTag (tag) {
      const existIdx = this.selectedList.findIndex((i) => i.tagId === tag.tagId)
      if (existIdx > -1) {
        this.selectedList.splice(existIdx, 1)
      } else {
        this.selectedList.push(tag)
      }
    },
    getTagFn () {
      this.loading = true
      getTagList({ groupTagType: this.type }).then(({ rows }) => {
        this.list = rows
        // this.list = [{"tenantId":26,"searchValue":null,"createBy":"姜鹏凯","createById":"259","createTime":"2022-06-27 15:02:43","updateBy":"姜鹏凯","updateById":"259","updateTime":"2022-06-27 15:02:43","remark":null,"params":{},"id":"1541316073415118848","groupId":"1541316073415118848","groupName":"测试","gourpName":null,"groupTagType":2,"owner":"admin","weTags":[{"tenantId":null,"searchValue":null,"createBy":null,"createById":null,"createTime":null,"updateBy":null,"updateById":null,"updateTime":null,"remark":null,"params":{},"id":"1541316073419313152","tagId":"1541316073419313152","groupId":"1541316073415118848","name":"11223","tagType":null,"owner":null,"delFlag":null},{"tenantId":null,"searchValue":null,"createBy":null,"createById":null,"createTime":null,"updateBy":null,"updateById":null,"updateTime":null,"remark":null,"params":{},"id":"1541316113281978368","tagId":"1541316113281978368","groupId":"1541316073415118848","name":"11222","tagType":null,"owner":null,"delFlag":null},{"tenantId":null,"searchValue":null,"createBy":null,"createById":null,"createTime":null,"updateBy":null,"updateById":null,"updateTime":null,"remark":null,"params":{},"id":"1541316113281978369","tagId":"1541316113281978369","groupId":"1541316073415118848","name":"222222","tagType":null,"owner":null,"delFlag":null}],"delFlag":0},{"tenantId":26,"searchValue":null,"createBy":"盛锡勇","createById":"248","createTime":"2022-06-27 14:10:16","updateBy":"盛锡勇","updateById":"248","updateTime":"2022-06-27 14:10:16","remark":null,"params":{},"id":"1541302874477301760","groupId":"1541302874477301760","groupName":"客群标签001分组","gourpName":null,"groupTagType":2,"owner":"admin","weTags":[{"tenantId":null,"searchValue":null,"createBy":null,"createById":null,"createTime":null,"updateBy":null,"updateById":null,"updateTime":null,"remark":null,"params":{},"id":"1541302874477301761","tagId":"1541302874477301761","groupId":"1541302874477301760","name":"客群标签001","tagType":null,"owner":null,"delFlag":null},{"tenantId":null,"searchValue":null,"createBy":null,"createById":null,"createTime":null,"updateBy":null,"updateById":null,"updateTime":null,"remark":null,"params":{},"id":"1541302874481496064","tagId":"1541302874481496064","groupId":"1541302874477301760","name":"客群标签002","tagType":null,"owner":null,"delFlag":null}],"delFlag":0}],
        this.listOneArray = []
        this.list.forEach((element) => {
          element.weTags.forEach((d) => {
            this.listOneArray.push({ tagId: d.tagId, name: d.name })
          })
        })
        this.loading = false
      })
    },
    setTagSelect (data) {
      return this.checkedTagMap.has(data.tagId) || this.checkedTagMap.has(data.name)
    },
    resetFn () {
      this.selectedList = []
    },
    submitFn () {
      this.$emit('submit', this.selectedList)
    }
  },
  mounted() {
    
  },
  created() {
    this.getTagFn()
  },
}
</script>
<style lang="less" scoped>
  .label-group {
    max-height: 270px;
    min-height: 270px;
    overflow-x: hidden;
    overflow-y: scroll;
    padding: 20px;
    &-item {
      // margin: 10px;
      // border-bottom: 1px solid #f1f1f1;
      &-title {
        font-size: 16px;
        color: #3D3D3D;
        margin-bottom: 10px;
        margin-top: 10px;
        font-weight: 600;
        font-family: 'PingFang SC-粗体, PingFang SC';
      }
      &-body {
        padding: 10px 0;
        display: flex;
        &-tag {
          font-size: 12px;
          margin-right: 13px;
          margin-bottom: 11px;
          background: #FAFAFA;
          border-radius: 8px;
          padding: 0 10px;
          height: 34px;
          line-height: 34px;
        }
      }
    }
  }
  .buttom {
    padding: 20px;
    display: flex;
    font-size: 16px;
    font-weight: 600px;
    .cancel_button {
      flex:1;
      background: #F8F8F8;
      border-radius: 8px;
      color: #666666;
      text-align: center;
      height: 40px;
      line-height: 40px;
      margin-right: 9px;
    }
    .submit_button {
      flex:1;
      background: #0079DE;
      border-radius: 8px;
      color: #fff;
      text-align: center;
      height: 40px;
      line-height: 40px;
    }
  }
</style>