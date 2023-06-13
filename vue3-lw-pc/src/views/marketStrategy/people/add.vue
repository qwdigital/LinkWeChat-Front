<template>
  <div>
    <div class="g-card">
      <el-steps align-center finish-status="success" :active="currentActive">
        <el-step title="基础信息"></el-step>
        <el-step title="人群筛选"></el-step>
      </el-steps>
    </div>
    <div class="g-card" v-if="currentActive === 1">
      <el-row>
        <div>
          <div class="title_head">基础信息</div>
          <el-col>
            <el-form ref="baseForm" :rules="baseRules" :model="baseForm" label-position="right" label-width="100px">
              <el-form-item label="人群名称" prop="name">
                <el-input
                  v-model="baseForm.name"
                  style="width: 400px;"
                  maxlength="30"
                  show-word-limit
                  clearable
                ></el-input>
              </el-form-item>
              <el-form-item label="人群分组" prop="groupId">
                <el-select style="width: 400px;" v-model="baseForm.groupId">
                  <el-option v-for="item in groupList" :key="item.id" :label="item.name" :value="item.id"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="更新方式" prop="type">
                <el-radio-group v-model="baseForm.type">
                  <el-radio :label="1">手动更新</el-radio>
                  <el-radio :label="2">自动更新</el-radio>
                </el-radio-group>
                <div class="sub-des">选择自动更新后，系统会在每日0点开始陆续自动更新</div>
              </el-form-item>
            </el-form>
          </el-col>
        </div>
      </el-row>
    </div>
    <div v-if="currentActive === 2" style="margin-top: 10px;">
      <el-row type="flex" justify="space-between">
        <el-col :span="5" class="left g-card">
          <div class="title">标签筛选</div>
          <div class="unit active" @click="addSwipe(1)">
            <img style="margin-right: 12px;" src="../../../assets/marketstrategy/ways.svg" alt="" />
            渠道标签
            <div style="margin-left: auto;">
              <el-popover placement="top" trigger="hover">
                <div slot="reference" style="display: flex; flex-direction: column; justify-content: center;">
                  <img src="../../../assets/marketstrategy/help.svg" alt="" />
                </div>
                <div>按照客户渠道标签进行筛选</div>
              </el-popover>
            </div>
          </div>
          <div class="unit active" @click="addSwipe(2)">
            <img style="margin-right: 12px;" src="../../../assets/marketstrategy/company.svg" alt="" />
            企业标签
            <div style="margin-left: auto;">
              <el-popover placement="top" trigger="hover">
                <div slot="reference" style="display: flex; flex-direction: column; justify-content: center;">
                  <img src="../../../assets/marketstrategy/help.svg" alt="" />
                </div>
                <div>按照客户企业标签进行筛选</div>
              </el-popover>
            </div>
          </div>
          <div class="unit disabled">
            <img style="margin-right: 12px;" src="../../../assets/marketstrategy/business.svg" alt="" />
            业务标签(敬请期待)
          </div>
          <div class="title" style="margin-top: 25px;">画像筛选</div>
          <div class="unit active" @click="addSwipe(3)">
            <img style="margin-right: 12px;" src="../../../assets/marketstrategy/customer.svg" alt="" />
            客户属性
            <div style="margin-left: auto;">
              <el-popover placement="top" trigger="hover">
                <div slot="reference" style="display: flex; flex-direction: column; justify-content: center;">
                  <img src="../../../assets/marketstrategy/help.svg" alt="" />
                </div>
                <div>按照客户多维属性进行筛选</div>
              </el-popover>
            </div>
          </div>
          <div class="unit active" @click="addSwipe(4)">
            <img style="margin-right: 12px;" src="../../../assets/marketstrategy/behavior.svg" alt="" />
            客户行为
            <div style="margin-left: auto;">
              <el-popover placement="top" trigger="hover">
                <div slot="reference" style="display: flex; flex-direction: column; justify-content: center;">
                  <img src="../../../assets/marketstrategy/help.svg" alt="" />
                </div>
                <div>按照客户行为事件进行筛选</div>
              </el-popover>
            </div>
          </div>
          <div class="title" style="margin-top: 25px;">其他筛选</div>
          <div class="unit active" @click="addSwipe(5)">
            <img style="margin-right: 12px;" src="../../../assets/marketstrategy/haved.svg" alt="" />
            已有人群
            <div style="margin-left: auto;">
              <el-popover placement="top" trigger="hover">
                <div slot="reference" style="display: flex; flex-direction: column; justify-content: center;">
                  <img src="../../../assets/marketstrategy/help.svg" alt="" />
                </div>
                <div>直接选择已有人群</div>
              </el-popover>
            </div>
          </div>
        </el-col>
        <el-col :span="19" style="padding-left: 10px;">
          <div class="empty_content" v-if="!swipe.length">
            <div>
              <div class="empty">
                <img
                  style="margin-left: 16px; margin-right: 10px;"
                  src="../../../assets/marketstrategy/tag.svg"
                  alt=""
                />
                筛选选项
                <img class="img_ab" src="../../../assets/marketstrategy/click.svg" alt="" />
              </div>
              <div class="text">点击左侧筛选选项进行策略人群筛选</div>
            </div>
          </div>
          <template v-else>
            <div v-for="(unit, key) in swipe" :key="key">
              <div class="relation" v-if="key !== 0">
                <span
                  class="relation_button"
                  :class="{ relation_active: unit.andOr === 1 }"
                  style="margin-right: 16px;"
                  @click="setRelationFn(key, 1)"
                >
                  且
                </span>
                <span
                  class="relation_button"
                  :class="{ relation_active: unit.andOr === 2 }"
                  @click="setRelationFn(key, 2)"
                >
                  或
                </span>
              </div>
              <div class="g-card" style="margin-top: 0;">
                <div class="card_header">
                  <div>
                    <show-people-title :titleType="unit.swipType"></show-people-title>
                  </div>
                  <div class="delete" @click="deleteSwipe(key)">
                    <img src="../../../assets/marketstrategy/delete.svg" alt="" />
                  </div>
                </div>
                <template v-if="unit.swipType === 1">
                  <channel-label
                    ref="channel"
                    :currentData="unit"
                    :baseData="baseEnum.CorpAddStateEnum"
                  ></channel-label>
                </template>
                <template v-if="unit.swipType === 2">
                  <company-label ref="company" :currentData="unit" :baseData="baseEnum.WeCorpTagEnum"></company-label>
                </template>
                <template v-if="unit.swipType === 3">
                  <customer-attributes
                    ref="attributes"
                    :currentData="unit"
                    :baseData="baseEnum.CustomerAttributesEnum"
                    :relationData="baseEnum.RelationEnum"
                  ></customer-attributes>
                </template>
                <template v-if="unit.swipType === 4">
                  <customer-behavior
                    ref="behavior"
                    :currentData="unit"
                    :baseData="baseEnum.CustomerBehaviorTimeEnum"
                    :happenList="baseEnum.CustomerBehaviorTypeEnum"
                    :behaviorList="baseEnum.CustomerBehaviorEnum"
                  ></customer-behavior>
                </template>
                <template v-if="unit.swipType === 5">
                  <strategic-crowd
                    ref="crowd"
                    :currentData="unit"
                    :baseData="baseEnum.StrategicCrowdEnum"
                  ></strategic-crowd>
                </template>
              </div>
            </div>
          </template>
        </el-col>
      </el-row>
    </div>
    <div class="g-footer-sticky" v-if="currentActive === 1">
      <el-button plain @click="cancelFn">取消</el-button>
      <el-button type="primary" @click="nextStep">下一步</el-button>
    </div>
    <div class="g-footer-sticky" v-if="currentActive === 2">
      <el-button plain @click="currentActive = 1">上一步</el-button>
      <el-button type="primary" @click="submitFn" :loading="submitLoading" :disabled="submitLoading || !swipe.length">
        确定
      </el-button>
    </div>
  </div>
</template>
<script>
  import { getBaseData, add, detail, update } from '@/api/marketStrategy/people'
  import { getCodeCategoryList } from '@/api/drainageCode/staff'
  import ShowPeopleTitle from '../components/ShowPeopleTitle'
  import ChannelLabel from '../components/ChannelLabel'
  import CompanyLabel from '../components/CompanyLabel'
  import CustomerAttributes from '../components/CustomerAttributes'
  import CustomerBehavior from '../components/CustomerBehavior'
  import StrategicCrowd from '../components/StrategicCrowd'
  export default {
    name: 'add-or-edit',
    data() {
      return {
        currentActive: 1,
        baseForm: {
          name: '',
          groupId: '',
          type: 1
        },
        groupList: [],
        baseRules: {
          name: [
            {
              required: true,
              message: '请输入人群名称',
              trigger: 'blur'
            }
          ],
          groupId: [
            {
              required: true,
              message: '请选择分组',
              trigger: 'blur'
            }
          ],
          type: [
            {
              required: true,
              message: '请选择更新方式',
              trigger: 'blur'
            }
          ]
        },
        swipe: [],
        baseEnum: {
          CorpAddStateEnum: [],
          CustomerBehaviorTypeEnum: [],
          CustomerAttributesEnum: [],
          CustomerBehaviorEnum: [],
          CustomerBehaviorTimeEnum: [],
          RelationEnum: [],
          StrategicCrowdEnum: [],
          WeCorpTagEnum: []
        },
        submitLoading: false
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
      addSwipe(type) {
        let obj = {
          andOr: 1,
          behavior: '',
          code: '',
          endTime: '',
          happenType: '',
          relation: '',
          startTime: '',
          value: '',
          name: '',
          swipType: type
        }
        this.swipe.push(obj)
      },
      deleteSwipe(index) {
        this.swipe.splice(index, 1)
      },
      setRelationFn(index, type) {
        this.swipe[index].andOr = type
      },
      cancelFn() {
        this.$router.back()
      },
      nextStep() {
        this.$refs['baseForm'].validate((validate) => {
          if (validate) {
            this.currentActive = 2
          }
        })
      },
      getCodeCategoryList() {
        getCodeCategoryList({ mediaType: 7 }).then((res) => {
          this.groupList = res.data
        })
      },
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
      },
      checkData() {
        let result = []
        if (this.$refs['channel']) {
          let arr = this.$refs['channel']
          let channelGo = true
          arr.forEach((dd, index) => {
            if (dd && !dd.handleValidateFn()) {
              channelGo = false
            }
          })
          result.push(channelGo)
        }
        if (this.$refs['company']) {
          let arr = this.$refs['company']
          let channelGo = true
          arr.forEach((dd, index) => {
            if (dd && !dd.handleValidateFn()) {
              channelGo = false
            }
          })
          result.push(channelGo)
        }
        if (this.$refs['attributes']) {
          let arr = this.$refs['attributes']
          let channelGo = true
          arr.forEach((dd, index) => {
            if (dd && !dd.handleValidateFn()) {
              channelGo = false
            }
          })
          result.push(channelGo)
        }
        if (this.$refs['behavior']) {
          let arr = this.$refs['behavior']
          let channelGo = true
          arr.forEach((dd, index) => {
            if (dd && !dd.handleValidateFn()) {
              channelGo = false
            }
          })
          result.push(channelGo)
        }
        if (this.$refs['crowd']) {
          let arr = this.$refs['crowd']
          let channelGo = true
          arr.forEach((dd, index) => {
            if (dd && !dd.handleValidateFn()) {
              channelGo = false
            }
          })
          result.push(channelGo)
        }
        let valid = true
        result.forEach((dd) => {
          if (!dd) {
            valid = false
          }
        })
        return valid
      },
      submitFn() {
        if (this.checkData()) {
          let obj = {
            ...this.baseForm,
            swipe: this.swipe
          }
          this.submitLoading = true

          if (this.$route.query.id) {
            obj.id = this.$route.query.id
            update(obj).then((res) => {
              if (res.code === 200) {
                this.msgSuccess('操作成功')
                this.$router.back()
              } else {
                this.msgError(res.msg)
              }
              this.submitLoading = false
            })
          } else {
            add(obj).then((res) => {
              if (res.code === 200) {
                this.msgSuccess('操作成功')
                this.$router.back()
              } else {
                this.msgError(res.msg)
              }
              this.submitLoading = false
            })
          }
        } else {
          this.msgError('请填写完整数据')
        }
      },
      getDetailFn(id) {
        detail(id).then((res) => {
          if (res.code === 200) {
            this.baseForm = res.data
            this.swipe = res.data.swipe
          }
        })
      }
    },
    created() {
      this.getInitData()
      let id = this.$route.query.id
      let groupId = this.$route.query.groupId
      if (groupId) {
        this.baseForm.groupId = groupId
      }
      this.getCodeCategoryList()
      if (id) {
        // this.title = '编辑'
        this.getDetailFn(id)
      }
    }
  }
</script>
<style lang="scss" scoped>
  .relation_button {
    height: 32px;
    line-height: 32px;
    border-radius: 3px 3px 3px 3px;
    border: 1px solid var(--color);
    color: var(--color);
    font-size: 16px;
    padding: 0 24px;
    cursor: pointer;
    &:hover {
      opacity: 0.7;
    }
  }
  .relation_active {
    background-color: var(--color);
    color: #fff;
  }
  .title_head {
    font-size: 16px;
    font-family: PingFang SC-粗体, PingFang SC;
    font-weight: 600;
    color: rgba(0, 0, 0, 0.9);
    margin-bottom: 25px;
  }
  .tab {
    height: 78px;
    background: #fff;
    border-top: 1px solid #f1f1f1;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
  }
  .sub-des {
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #999999;
  }
  .left {
    border-right: 1px solid #f1f1f1;
  }
  .title {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 20px;
  }
  .unit {
    display: flex;
    align-items: center;
    height: 40px;
    line-height: 40px;
    background: #fafafa;
    color: rgba(0, 0, 0, 0.6);
    border-radius: 2px;
    font-size: 14px;
    cursor: pointer;
    padding: 0 16px;
    margin-bottom: 12px;
  }
  .active {
    &:hover {
      font-weight: 500;
      color: rgba(0, 0, 0, 0.9);
      background: #ecf5ff;
    }
  }
  .disabled {
    color: #999;
    cursor: not-allowed;
  }
  .card_header {
    padding-bottom: 15px;
    // border-bottom: 1px solid #f1f1f1;
    font-size: 14px;
    font-weight: 500;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .delete {
      color: var(--color);
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
  .empty_content {
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    height: 90%;
    text-align: center;
    .empty {
      margin: 0 auto;
      display: flex;
      align-items: center;
      font-size: 14px;
      position: relative;
      width: 200px;
      height: 40px;
      background: rgba(0, 0, 0, 0.2);
      border-radius: 2px 2px 2px 2px;
      opacity: 0.4;
      .img_ab {
        position: absolute;
        right: 4px;
        top: 25px;
      }
    }
    .text {
      font-size: 14px;
      color: rgba(0, 0, 0, 0.4);
      margin-top: 26px;
    }
  }
</style>
