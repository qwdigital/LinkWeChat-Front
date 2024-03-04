<template>
  <div class="select_content">
    <template v-if="currentType !== 1">
      <div>
        <el-checkbox
          v-model="form.executeCustomerCondit.change"
          @change="selectAttributeChange"
          label="客户属性"></el-checkbox>
        <el-popover placement="top" trigger="hover">
          <template #reference>
            <el-icon-QuestionFilled class="el-icon-QuestionFilled ml5" />
          </template>
          <div>可根据不同属性维度精细化筛选客户。不同的属性自动以“且”关联，相同的属性自动以“或”关联</div>
        </el-popover>
        <div class="select_unit" v-if="form.executeCustomerCondit.change">
          <SelectAttribute
            :init="form.executeCustomerCondit.executeCustomerQUECondits"
            :baseData="base"
            @update="changeFn"
            ref="selectAttribute"></SelectAttribute>
        </div>
      </div>
      <!-- <div>
        <el-checkbox v-model="form.crowdAttribute.change" @change="selectCrowdChange" label="已有人群"></el-checkbox>
        <div class="select_unit" v-if="form.crowdAttribute.change">
          <div v-if="selectedPeopleList.length > 0">
            <el-tag  v-for="(item, index) in selectedPeopleList" :key="index">{{ item.name }}</el-tag>
          </div>
          <el-button icon="el-icon-plus" type="primary" plain  @click="dialogVisibleSelectPeople = true">
            {{ selectedPeopleList.length ? '修改' : '选择' }}人群
          </el-button>
        </div>
      </div> -->
    </template>
    <template v-else>
      <el-radio-group v-model="newCustomerAll" @change="clearChange">
        <el-radio :label="1">全部新客户</el-radio>
        <el-radio :label="2">部分新客户</el-radio>
      </el-radio-group>
      <div class="select_unit" v-if="newCustomerAll === 2">
        客户属性
        <el-popover placement="top" trigger="hover">
          <template #reference>
            <el-icon-QuestionFilled class="el-icon-QuestionFilled ml5" />
          </template>
          <div>可根据不同属性维度精细化筛选客户。不同的属性自动以“且”关联，相同的属性自动以“或”关联</div>
        </el-popover>
        ：
        <SelectAttribute
          v-if="form"
          :baseData="base"
          :init="form.executeCustomerCondit.executeCustomerQUECondits"
          ref="selectAttribute"
          @update="changeFn"></SelectAttribute>
      </div>
    </template>

    <!-- <SelectCrowde
      :selected="selectedPeopleList"
      v-model:visible="dialogVisibleSelectPeople"
      @success="setCrowdeData"
    ></SelectCrowde> -->
  </div>
</template>
<script>
// import SelectCrowde from '@/components/SelectCrowde/index'
import SelectAttribute from './SelectAttribute.vue'
// import { getList } from '@/api/marketStrategy/people'

export default {
  name: 'select-type',
  data() {
    return {
      newCustomerAll: 1, // 新客sop 生效客户
      dialogVisibleSelectPeople: false,
      selectedPeopleList: [],
      form: {
        executeCustomerCondit: {
          change: false,
          executeCustomerQUECondits: [],
        },
        crowdAttribute: {
          change: false,
          crowdIds: [],
        },
      },
    }
  },
  props: {
    currentType: {
      type: Number,
      default: 1,
    },
    base: {
      type: Object,
      default: {},
    },
    initData: {
      type: Object,
      default: {
        executeCustomerCondit: {
          change: false,
          executeCustomerQUECondits: [],
        },
        crowdAttribute: {
          change: false,
          crowdIds: [],
        },
      },
    },
  },
  components: {
    SelectAttribute,
    // SelectCrowde
  },
  methods: {
    setCheck() {
      if (this.form.executeCustomerCondit && this.form.executeCustomerCondit.executeCustomerQUECondits.length) {
        return true
      } else {
        return false
      }
    },
    selectCrowdChange(data) {
      if (!data) {
        this.form.crowdAttribute.crowdIds = []
      }
    },
    selectAttributeChange(data) {
      if (!data) {
        this.form.executeCustomerCondit.executeCustomerQUECondits = []
      }
    },
    validateFn() {
      if (this.currentType === 1) {
        if (this.newCustomerAll === 2) {
          return this.$refs.selectAttribute.validateFn()
        }
        return true
      } else {
        if (!this.form.executeCustomerCondit.change && !this.form.crowdAttribute.change) {
          this.msgError('请选择生效客户！')
          return false
        }
        if (this.form.executeCustomerCondit.change) {
          if (!this.form.executeCustomerCondit.executeCustomerQUECondits.length) {
            this.msgError('请选择客户属性！')
            return false
          } else {
            return this.$refs.selectAttribute.validateFn()
          }
        }
        // if (this.form.crowdAttribute.change) {
        //   if (!this.form.crowdAttribute.crowdIds.length) {
        //     this.msgError('请选择已有人群！')
        //     return false
        //   }
        // }
        return true
      }
    },
    clearChange(type) {
      if (type === 1) {
        this.form = null
      } else {
        this.form = {
          executeCustomerCondit: {
            change: false,
            executeCustomerQUECondits: [],
          },
          crowdAttribute: {
            change: false,
            crowdIds: [],
          },
        }
        // this.$forceUpdate()
      }
    },
    setCrowdeData(data) {
      this.selectedPeopleList = data
      this.form.crowdAttribute.crowdIds = data.map((item) => item.id)
    },
    changeFn(data) {
      this.form.executeCustomerCondit.change = true
      this.form.executeCustomerCondit.executeCustomerQUECondits = data
    },
    submitFn() {
      if (this.newCustomerAll === 1 && this.currentType === 1) {
        this.form = null
      }
      this.$emit('update', this.form)
    },
    // setEditCrowd() {
    //   getList({ pageSize: 10000, pageNum: 1 }).then(({ rows }) => {
    //     if (this.form.crowdAttribute.crowdIds.length) {
    //       this.form.crowdAttribute.crowdIds.forEach((dd) => {
    //         let index = rows.findIndex((item) => item.id === dd)
    //         if (index !== -1) {
    //           this.selectedPeopleList.push(rows[index])
    //         }
    //       })
    //     }
    //   })
    // }
  },
  created() {
    if (this.initData) {
      if (this.initData.executeCustomerCondit.change) {
        this.newCustomerAll = 2
        this.form.executeCustomerCondit = this.initData.executeCustomerCondit
      }
      // if (this.initData.crowdAttribute.change) {
      //   this.form.crowdAttribute = this.initData.crowdAttribute
      //   this.setEditCrowd()
      // }
    }
  },
}
</script>
<style lang="scss" scoped>
.select_content {
  background-color: var(--color-light-10);
  padding: 20px;
  border-radius: 5px;
  .select_unit {
    padding: 10px 25px;
  }
}
</style>
