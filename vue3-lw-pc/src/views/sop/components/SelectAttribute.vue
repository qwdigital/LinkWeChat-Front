<template>
  <div>
    <el-button icon="el-icon-plus" type="primary" plain @click="addItem">添加属性</el-button>
    <div class="form_inline">
      <div
        class="first_level_left"
        v-if="dataList.length > 1 || (dataList[0] && dataList[0].executeCustomerQUECondits.length > 1)">
        <div
          class="border_dot"
          v-if="!(dataList.length === 2 && dataList[0].executeCustomerQUECondits.length === 0)"></div>
        <div class="word_con" v-if="!(dataList.length === 2 && dataList[0].executeCustomerQUECondits.length === 0)">
          <span>且</span>
        </div>
      </div>
      <div class="first_level_right">
        <template v-for="(unit, key) in dataList" :key="key">
          <div v-if="key === 0">
            <template v-for="(item, index) in unit.executeCustomerQUECondits" :key="index + 1">
              <CustomerAttributes
                :disabled="disableList"
                :enableList="attributesList"
                v-model:currentData="dataList[key].executeCustomerQUECondits[index]"
                :baseData="baseEnum.CustomerAttributesEnum"
                :relationData="baseEnum.RelationEnum"
                :groupChatEnum="baseEnum.GroupChatEnum"
                :weCorpTagEnum="baseEnum.WeCorpTagEnum"
                @change="getChange"
                ref="attributes"
                @updatedata="updateData"
                @remove="setRemoveFn(key, index)"
                :showDelete="index !== 0 || dataList.length > 1"></CustomerAttributes>
            </template>
          </div>
          <div v-if="key > 0">
            <div class="form_inline" style="margin-top: 0; margin-left: 5px">
              <div class="first_level_left">
                <div class="border_dot"></div>
                <div class="word_con">
                  <span>或</span>
                </div>
              </div>
              <div class="first_level_right">
                <template v-for="(item, index) in unit.executeCustomerQUECondits" :key="index + 2">
                  <CustomerAttributes
                    :disabled="disableList"
                    :enableList="attributesList"
                    ref="attributes"
                    :showDelete="index !== 0 || dataList[0].executeCustomerQUECondits.length !== 0"
                    v-model:currentData="dataList[key].executeCustomerQUECondits[index]"
                    :baseData="baseEnum.CustomerAttributesEnum"
                    :relationData="baseEnum.RelationEnum"
                    :groupChatEnum="baseEnum.GroupChatEnum"
                    :weCorpTagEnum="baseEnum.WeCorpTagEnum"
                    @change="getChange"
                    @updatedata="updateData"
                    @remove="setRemoveFn(key, index)"></CustomerAttributes>
                </template>
              </div>
            </div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import { getBaseData } from '@/api/sop/index'
import CustomerAttributes from './CustomerAttributes.vue'
export default {
  name: 'select-attribute-in-sop',
  components: {
    CustomerAttributes,
  },
  props: {
    init: {
      type: Array,
      default: () => [],
    },
    baseData: {
      type: Object,
      default: {
        businessType: null,
        sendType: 1,
      },
    },
  },
  watch: {
    init: {
      deep: true,
      handler() {
        this.dataList = this.init
        this.setEnableList()
        this.setDisableList()
      },
    },
  },
  data() {
    return {
      attributesList: [],
      disableList: [],
      baseEnum: {
        CustomerAttributesEnum: [],
        RelationEnum: [],
        GroupChatEnum: [],
        WeCorpTagEnum: [],
      },
      realtionData: [],
      dataList: [],
    }
  },
  computed: {},
  methods: {
    setEnableList() {
      if (this.baseData.businessType === 1) {
        this.attributesList = [2, 100, 0]
      } else {
        if (this.baseData.sendType === 1) {
          this.attributesList = [2, 15, 100, 0]
        } else {
          this.attributesList = [2, 3, 5, 7, 12, 15, 100, 0, 102]
        }
      }
      // [2, 3, 5, 7, 12, 15, 100, 0, 102] //base
      // [2, 15, 100, 0] // 企微群发
      // [2, 100, 0] // 新客
    },
    setDisableList() {
      let arr = []
      this.dataList.forEach((dd, index) => {
        if (index > 0) {
          arr.push(dd.executeCustomerQUECondits[0].code)
        }
      })
      this.disableList = arr
    },
    validateFn() {
      if (this.$refs['attributes']) {
        let result = []
        let arr = this.$refs['attributes']
        let channelGo = true
        arr.forEach((dd, index) => {
          if (dd && !dd.handleValidateFn()) {
            channelGo = false
          }
        })
        result.push(channelGo)
        let valid = true
        result.forEach((dd) => {
          if (!dd) {
            valid = false
          }
        })
        return valid
      } else {
        this.msgError('请添加属性！')
        return false
      }
    },
    updateData() {
      this.$emit('update', this.dataList)
    },
    setRemoveFn(key, index) {
      this.dataList[key].executeCustomerQUECondits.splice(index, 1)
      this.getChange()
    },
    async getChange() {
      let arr = []
      this.dataList.forEach((dd) => {
        arr = [...arr, ...dd.executeCustomerQUECondits]
      })
      let data = await this.newArryByCode(arr)
      this.dataList = []
      let newValue = [{ andOr: 1, executeCustomerQUECondits: [] }]
      data.forEach((dd) => {
        if (dd.code && dd.data.length > 1) {
          newValue.push({
            andOr: 2,
            executeCustomerQUECondits: dd.data,
          })
        } else {
          newValue[0].executeCustomerQUECondits.push(...dd.data)
        }
      })
      this.dataList = newValue
      // this.$forceUpdate()
      this.setDisableList()
    },
    newArryByCode(arr) {
      let map = {}
      let dest = []
      for (let i = 0; i < arr.length; i++) {
        let ai = arr[i]
        let current = ai.code.toString()
        if (!map[current]) {
          dest.push({
            code: current,
            data: [ai],
          })
          map[current] = ai
        } else {
          for (let j = 0; j < dest.length; j++) {
            let dj = dest[j]
            if (dj.code == current) {
              dj.data.push(ai)
              break
            }
          }
        }
      }
      return dest
    },
    addItem() {
      if (!this.dataList.length) {
        this.dataList.push({
          andOr: 1,
          executeCustomerQUECondits: [
            {
              swipType: '',
              code: '',
              endTime: '',
              name: '',
              relation: null,
              startTime: '',
              value: '',
            },
          ],
        })
      } else {
        this.dataList[0].executeCustomerQUECondits.push({
          swipType: '',
          code: '',
          endTime: '',
          name: '',
          relation: null,
          startTime: '',
          value: '',
        })
      }
    },
  },
  created() {
    if (this.init && this.init.length) {
      this.dataList = this.init
    }
    this.setEnableList()
    getBaseData(['CustomerAttributesEnum', 'RelationEnum', 'GroupChatEnum', 'WeCorpTagEnum']).then((res) => {
      if (res.code === 200) {
        this.baseEnum = res.data
        let arr = [
          {
            code: 100,
            value: '客户标签',
          },
          {
            code: 0,
            value: '渠道来源',
          },
          {
            code: 102,
            value: '所属群聊',
          },
        ]
        this.baseEnum.CustomerAttributesEnum = [...this.baseEnum.CustomerAttributesEnum, ...arr]
      }
    })
  },
}
</script>

<style scoped lang="scss">
.form_inline {
  margin-top: 20px;
  display: flex;
  justify-items: center;
  .first_level_left {
    margin: 10px 0;
    height: auto;
    position: relative;
    .border_dot {
      border: 1px dotted var(--color);
      border-top-left-radius: 5px;
      border-bottom-left-radius: 5px;
      border-right: transparent;
      width: 30px;
      height: 100%;
    }
    .word_con {
      line-height: normal;
      background-color: #ecf5ff;
      font-size: 12px;
      color: var(--color);
      position: absolute;
      top: 50%;
      left: -5px;
      transform: translateY(-50%);
      display: flex;
      border-radius: 3px;
    }
  }
}
</style>
