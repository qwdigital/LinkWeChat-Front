<template>
  <div>
    <el-row>
      <el-col :sm="24" :md="16" :lg="14">
        <el-form :model="form" :rules="rules" ref="form" label-width="140px">
          <el-row>
            <el-col :sm="24" :md="18">
              <el-form-item label="活码名称:" prop="qrName">
                <el-input v-model="form.qrName" placeholder="请输入名称" show-word-limit maxlength="15"></el-input>
              </el-form-item>
              <el-form-item label="拉新方式:" required>
                <div class="function">
                  <!-- <div
                    class="function-item"
                    :class="item.active ? 'active-item' : ''"
                    v-for="(item, index) in functionList"
                    :key="index"
                    @click="boxChange(item)"
                  > -->
                  <el-tooltip
                    effect="dark"
                    content="即将上线,敬请期待"
                    placement="bottom"
                    v-for="(item, index) in functionList"
                    :key="index"
                    :disabled="item.active">
                    <div :class="['function-item', item.active ? 'active-item' : '']">
                      <svg-icon class="icon-style" :icon="item.svg"></svg-icon>
                      <div>
                        <span>{{ item.name }}</span>
                        <div class="item-text">{{ item.content }}</div>
                      </div>
                    </div>
                  </el-tooltip>
                </div>
                <div class="function-tip">
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled mr10"></el-icon-QuestionFilled>
                  <span class="tips">红包拉新需要在管理中心配置微信支付，卡券拉新需要配置公众号</span>
                </div>
              </el-form-item>

              <el-form-item label="添加员工:" required>
                <!-- {{ addWeUser }} -->
                <div class="sub-des">引导新客户扫码时添加以下任意成员为好友</div>
                <SelectMember ref="selectMember" :initData="addWeUser" @update="getExecuteData"></SelectMember>
              </el-form-item>
              <!-- <el-form-item label="添加标签:" prop="tagIds"> -->
              <el-form-item label="添加标签:">
                <div class="sub-des">通过扫描该二维码添加员工好友的新客户会自动打上此处设置的标签</div>
                <template v-for="(item, index) in tagList" :key="index">
                  <el-tag v-if="item.name">{{ item.name }}</el-tag>
                </template>
                <div>
                  <el-button type="primary" icon="el-icon-plus" @click="showSelectTag = true">
                    {{ tagList.length ? '编辑' : '添加' }}标签
                  </el-button>
                </div>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </el-col>
    </el-row>
    <SelectTag v-model:visible="showSelectTag" type="1" :selected="tagList" @success="getSelectTag"></SelectTag>
  </div>
</template>

<script>
// import { add, update, getDetail } from '@/api/drainageCode/group'
import SelectMember from '../components/SelectMember.vue'
export default {
  props: {
    // 实际群活码
    // groupCodeId: {
    //   type: String,
    //   default: '',
    // },
    query: {
      type: Object,
      default: {},
    },
  },
  components: {
    SelectMember,
  },
  watch: {
    query: {
      handler(val) {
        if (val.qrUserInfos) {
          this.form = Object.assign(this.form, val)
          // console.log(106,this.form);
          this.form['qrName'] = val.name
          this.addWeUser = this.dealVal(val.qrUserInfos)
        }
        if (val.qrType) {
          this.functionList.forEach((obj, i) => {
            obj['active'] = false
            if (i + 1 === val.qrType) {
              obj['active'] = true
            }
          })
        }
        if (val.tags && val.qrTags) {
          let arr = []
          let names = val.tags ? val.tags : []
          let ids = val.qrTags ? val.qrTags : []
          ids.forEach((dd, index) => {
            let obj = {
              name: names[index],
              tagId: dd,
            }
            arr.push(obj)
          })
          this.tagList = arr
        }
      },
      immediate: true,
    },
  },
  data() {
    return {
      functionList: [
        {
          svg: 'redBox',
          name: '红包拉新',
          content: '给新客户发送红包',
          active: true,
          type: 1,
        },
        {
          svg: 'card',
          name: '卡券拉新',
          content: '给新客户发送微信卡券',
          active: false,
          type: 2,
        },
      ],
      addWeUser: {
        executeUserCondit: {
          change: false,
          weUserIds: [],
        },
        executeDeptCondit: {
          change: false,
          deptIds: [],
          posts: [],
        },
      },
      showSelectTag: false,
      form: {
        qrName: '',
        qrTags: [],
        qrType: 1, // 1红包拉新 0卡券拉新
        qrUserInfos: [],
      },
      a: '',
      rules: {
        qrName: [{ required: true, message: '请输入拉新活码名称', trigger: 'blur' }],
        // qrTags: [{ required: true, message: '请添加拉新活码标签', trigger: 'blur' }],
      },
      tagList: [],
    }
  },
  mounted() {
    // this.groupCodeId = this.$route.query.groupCodeId
    // if (this.$route.query.groupCodeId) {
    //   console.log(178, this.query)
    // }
  },
  methods: {
    dealPartys(list) {
      if (list) {
        list = list.map((item) => {
          return item.toString()
        })
        return list
      }
    },
    dealVal(data) {
      let obj = {
        executeUserCondit: {
          change: false,
          weUserIds: [],
        },
        executeDeptCondit: {
          change: false,
          deptIds: [],
          posts: [],
        },
      }
      obj.executeUserCondit.weUserIds = data[0] ? data[0].userIds : []
      obj.executeDeptCondit.deptIds = data[1] ? this.dealPartys(data[1].partys) : []
      obj.executeDeptCondit.posts = data[2] ? data[2].positions : []
      obj.executeDeptCondit.change =
        (data[1] && data[1].partys && data[1].partys.length) ||
        (data[2] && data[2].positions && data[2].positions.length)
          ? true
          : false
      // console.log(data[0].userIds)
      obj.executeUserCondit.change = data[0] && data[0].userIds && data[0].userIds.length ? true : false
      return obj
    },
    getExecuteData(data) {
      // console.log(data.executeDeptCondit.deptIds) // 范围
      // console.log(data.executeDeptCondit.posts) // 岗位
      // console.log(data.executeUserCondit.weUserIds) // 成员
      this.addWeUser = data
      let list = [
        { scopeType: 1, userIds: data.executeUserCondit.weUserIds },
        { scopeType: 2, partys: data.executeDeptCondit.deptIds },
        { scopeType: 3, positions: data.executeDeptCondit.posts },
      ]
      this.form.qrUserInfos = list
    },
    boxChange(item) {
      this.functionList.forEach((obj) => (obj['active'] = false))
      item.active = true
      this.form['qrType'] = item.type
    },
    async handleValidateFn() {
      await this.$refs['form'].validate()
      this.$emit('nextBaseInfo', this.form)
      if (!this.$refs.selectMember.validateFn()) {
        return Promise.reject()
      }
    },
    getSelectTag(list) {
      console.log('tagList', list)
      this.tagList = list
      this.form.qrTags = this.tagList.map((dd) => {
        return dd.tagId
      })
      // .join(',')
      this.form.tags = this.tagList
        .map((dd) => {
          return dd.name
        })
        .join(',')
    },
    // 新增群活码
    // add() {
    //   this.$refs.form.validate((valid) => {
    //     if (!valid) return
    //     // 新增群活码数据至数据库
    //     add(this.form).then((res) => {
    //       if (res.code === 200) {
    //         this.$emit('next', res.data.id, res.data)
    //       } else if (res.code === 433) {
    //         this.$refs['form'].fields[0].validateMessage = res.msg
    //         this.$refs['form'].fields[0].validateState = 'error'
    //         this.$emit('next')
    //       } else {
    //         this.$emit('next')
    //       }
    //     })
    //   })
    // },
    // 更新群活码
    // update() {
    //   this.$refs.form.validate((valid) => {
    //     if (!valid) return
    //     update(this.form).then((res) => {
    //       if (res.code === 200) {
    //         this.$emit('next', this.groupCodeId, res.data)
    //       } else if (res.code === 433) {
    //         this.$refs['form'].fields[0].validateMessage = res.msg
    //         this.$refs['form'].fields[0].validateState = 'error'
    //         this.$emit('next')
    //       } else {
    //         this.$emit('next')
    //       }
    //     })
    //   })
    // },
    // 获取群活码信息
    getGroupDetail() {
      if (!this.groupCodeId) return
      // 编辑回显
      let arr = []
      let names = this.form.tags ? this.form.tags.split(',') : []
      let ids = this.form.qrTags ? this.form.qrTags.split(',') : []
      ids.forEach((dd, index) => {
        let obj = {
          name: names[index],
          tagId: dd,
        }
        arr.push(obj)
      })
      this.tagList = arr
      // let arr2 = []
      // let groupNames = this.form.groupNames ? this.form.groupNames.split(',') : []
      // let groupIds = this.form.chatIdList ? this.form.chatIdList.split(',') : []
      // groupIds.forEach((dd, index) => {
      //   let obj = {
      //     groupName: groupNames[index],
      //     chatId: dd,
      //   }
      //   arr2.push(obj)
      // })
      // this.groupList = arr2
      // this.$forceUpdate()
    },
    // 提交
    // submit() {
    //   if (!this.groupCodeId) return this.add()
    //   this.update()
    // },
  },
}
</script>

<style scoped lang="scss">
.function {
  display: flex;
  width: 540px;
  justify-content: space-between;
  .function-item {
    width: 260px;
    height: 76px;
    border-width: 1px;
    border-style: solid;
    border-color: rgba(242, 242, 242, 1);
    border-radius: 5px;
    display: flex;
    padding: 10px;
    padding-top: 6px;
    cursor: pointer;
    .icon-style {
      margin-right: 10px;
      margin-top: 8px;
      font-size: 22px;
    }
    .item-text {
      font-size: 12px;
      color: var(--font-black-7);
      line-height: 24px;
    }
  }
  .active-item {
    border: 1px solid rgba(7, 193, 96, 1);
    background-color: rgba(7, 193, 96, 0.09019607843137255);
  }
}
.function-tip {
  width: 400px;
}
.sub-des {
  font-size: 10px;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: var(--font-black-7);
}
::v-deep .image-uploader {
  .uploader-icon {
    width: 80px;
    height: 80px;
    line-height: 80px;
  }

  .upload-img {
    width: 80px;
    height: 80px;
  }
}

::v-deep .image-uploader2 {
  .uploader-icon {
    width: 120px;
    height: 120px;
    line-height: 120px;
  }
  .upload-img {
    width: 120px;
    height: 120px;
  }
}

.el-form-item {
  margin-bottom: 30px;
}
.tips,
.el-icon-QuestionFilled {
  color: var(--font-black-8);
  font-size: 12px;
  margin-top: 20px;
}
</style>
