<template>
  <div>
    <div v-for="(unit, key) in swipe" :key="key">
      <div class="relation" v-if="key !== 0">
        <span
          v-if="unit.andOr === 1"
          class="relation_button"
          :class="{ relation_active: unit.andOr === 1 }"
          style="margin-right: 16px;"
          >且</span
        >
        <span v-if="unit.andOr === 2" class="relation_button" :class="{ relation_active: unit.andOr === 2 }">或</span>
      </div>
      <el-card>
        <div class="card_header">
          <div>
            <show-people-title :titleType="unit.swipType"></show-people-title>
          </div>
        </div>
        <template v-if="unit.swipType === 1">
          <channel-label :currentData="unit" :detail="true" :baseData="baseEnum.CorpAddStateEnum"></channel-label>
        </template>
        <template v-if="unit.swipType === 2">
          <company-label :currentData="unit" :detail="true" :baseData="baseEnum.WeCorpTagEnum"></company-label>
        </template>
        <template v-if="unit.swipType === 3">
          <customer-attributes
            :currentData="unit"
            :detail="true"
            :baseData="baseEnum.CustomerAttributesEnum"
            :relationData="baseEnum.RelationEnum"
          ></customer-attributes>
        </template>
        <template v-if="unit.swipType === 4">
          <customer-behavior
            :currentData="unit"
            :detail="true"
            :baseData="baseEnum.CustomerBehaviorTimeEnum"
            :happenList="baseEnum.CustomerBehaviorTypeEnum"
            :behaviorList="baseEnum.CustomerBehaviorEnum"
          ></customer-behavior>
        </template>
        <template v-if="unit.swipType === 5">
          <strategic-crowd :currentData="unit" :detail="true" :baseData="baseEnum.StrategicCrowdEnum"></strategic-crowd>
        </template>
      </el-card>
    </div>
  </div>
</template>
<script>
  import ShowPeopleTitle from '../components/ShowPeopleTitle'
  import ChannelLabel from '../components/ChannelLabel'
  import CompanyLabel from '../components/CompanyLabel'
  import CustomerAttributes from '../components/CustomerAttributes'
  import CustomerBehavior from '../components/CustomerBehavior'
  import StrategicCrowd from '../components/StrategicCrowd'
  import { getBaseData } from '@/api/marketStrategy/people'

  export default {
    name: 'people-filter',
    data() {
      return {
        baseEnum: {
          CorpAddStateEnum: [],
          CustomerBehaviorTypeEnum: [],
          CustomerAttributesEnum: [],
          CustomerBehaviorEnum: [],
          CustomerBehaviorTimeEnum: [],
          RelationEnum: [],
          StrategicCrowdEnum: [],
          WeCorpTagEnum: []
        }
      }
    },
    props: {
      swipe: {
        type: Array,
        default: () => []
      }
    },
    components: {
      ShowPeopleTitle,
      ChannelLabel,
      CompanyLabel,
      CustomerAttributes,
      CustomerBehavior,
      StrategicCrowd
    },
    methods: {
      getInitData() {
        // CorpAddStateEnum //渠道标签
        // WeCorpTagEnum //企业标签
        // CustomerAttributesEnum //客户属性
        // CustomerBehaviorEnum //客户行为
        // CustomerBehaviorTimeEnum //客户行为时间
        // RelationEnum, StrategicCrowdEnum //策略人群
        // CustomerBehaviorTypeEnum // 客户行为发生类型
        getBaseData([
          'CorpAddStateEnum',
          'WeCorpTagEnum',
          'CustomerAttributesEnum',
          'CustomerBehaviorEnum',
          'CustomerBehaviorTimeEnum',
          'RelationEnum',
          'StrategicCrowdEnum',
          'CustomerBehaviorTypeEnum'
        ]).then((res) => {
          if (res.code === 200) {
            this.baseEnum = res.data
          }
        })
      }
    },
    created() {
      this.getInitData()
    }
  }
</script>
<style lang="scss" scoped>
  .card_header {
    padding-bottom: 15px;
    border-bottom: 1px solid #f1f1f1;
    font-size: 14px;
    font-weight: 500;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .delete {
      color: #0079de;
      font-size: 16px;
      cursor: pointer;
      &:hover {
        opacity: 0.7;
      }
    }
  }
  .relation {
    display: flex;
    justify-content: center;
    padding: 10px;
  }
  .relation_button {
    height: 32px;
    line-height: 32px;
    border-radius: 3px 3px 3px 3px;
    border: 1px solid #0079de;
    color: #0079de;
    font-size: 16px;
    padding: 0 24px;
    cursor: pointer;
    &:hover {
      opacity: 0.7;
    }
  }
  .relation_active {
    background-color: #0079de;
    color: #fff;
  }
</style>
