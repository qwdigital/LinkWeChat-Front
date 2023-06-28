<template>
  <div>
    <!-- 话术素材 -->
    <el-row type="flex" justify="space-between" v-if="isedit">
      <el-col :span="16" class="left" style="padding-right: 10px; border-radius: 4px">
        <div class="g-card">
          <div style="display: flex; justify-content: space-between; margin-bottom: 10px">
            <div style="display: flex">
              <div class="title">{{ form.talkTitle }}</div>
              <div class="group">
                {{ form.categoryId === '1' ? '默认分组' : form.categoryName }}
              </div>
            </div>
            <el-button text @click="isedit = false">编辑</el-button>
          </div>
        </div>
        <div class="mt20 g-card pad20">
          <TalkList :dataList="form.weMaterialList" />
        </div>
      </el-col>
      <el-col :span="8" class="g-card pad20" style="margin-top: 0px">
        <PreviewInPhone :list="form.weMaterialList" />
      </el-col>
    </el-row>
    <div v-else>
      <AddMaterial talkType="1" :talkId="talkId" :moduleType="2" />
    </div>
  </div>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { lexicalDetail } from '@/api/contentCenter/scriptCenter'
import AddMaterial from '@/components/ContentCenter/AddMaterial.vue'
import TalkList from '@/views/contentCenter/components/TalkList.vue'
export default {
  components: {
    PreviewInPhone,
    AddMaterial,
    TalkList,
  },
  data() {
    return {
      mobForm: {
        welcomeMsg: '',
        materialMsgList: [],
        userIds: '',
        userNames: '',
      },
      form: {}, // 素材表单
      loading: false,
      talkId: '',
      isedit: true,
    }
  },
  methods: {
    // 获取详情
    getDeatil() {
      this.loading = true
      lexicalDetail(this.talkId)
        .then((res) => {
          this.form = res.data
          // 此处需要后端返回详情的值
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
  },
  created() {
    this.talkId = this.$route.query.talkId
    this.getDeatil()
  },
}
</script>

<style lang="scss" scoped>
.group {
  font-size: 12px;
  background: var(--color);
  color: var(--font-white, #fff);
  display: block;
  padding: 0 5px;
  height: 24px;
  line-height: 24px;
  border-radius: 5px;
  text-align: center;
  margin-left: 20px;
}
::v-deep.card-group-index {
  .card-index-li {
    background: var(--bg-black-11);
    margin-top: 20px;
  }
}

.total-list {
  .item {
    padding: 10px;
    background: var(--bg-white);
  }
}

.data-content {
  margin-top: 10px;
  .chart-content {
    margin-top: 10px;
    .my_button {
      float: right;
    }
    .column {
      display: flex;
      .column-item {
        flex: 1;
      }
    }
  }
  .search-content {
    display: flex;
    justify-content: space-between;
  }
  .table-content {
    margin-top: 10px;
  }
}
</style>
